import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../math/concepts.dart';

class WorksheetReading {
  final ConceptId? concept;
  final String confidence;
  final List<String> problems;
  final String note;

  WorksheetReading({
    required this.concept,
    required this.confidence,
    required this.problems,
    required this.note,
  });
}

/// Asks Gemini which supported concept a worksheet photo practises.
/// Gemini only names the topic; every question and answer the parent sees is
/// generated and checked by our own code.
class WorksheetReader {
  static const model = 'gemini-3.8-flash';
  static final _endpoint = Uri.parse(
    'https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent',
  );

  /// Finish reasons that mean Gemini would not read the photo.
  static const _declined = {
    'SAFETY',
    'RECITATION',
    'BLOCKLIST',
    'PROHIBITED_CONTENT',
    'SPII',
    'IMAGE_SAFETY',
  };

  static String? apiKey(Session session) {
    final key =
        session.passwords['geminiApiKey'] ??
        Platform.environment['GEMINI_API_KEY'];
    return (key == null || key.isEmpty) ? null : key;
  }

  static String? mediaType(Uint8List b) {
    if (b.length > 3 && b[0] == 0xFF && b[1] == 0xD8) return 'image/jpeg';
    if (b.length > 8 && b[0] == 0x89 && b[1] == 0x50) return 'image/png';
    if (b.length > 12 &&
        ascii.decode(b.sublist(0, 4), allowInvalid: true) == 'RIFF' &&
        ascii.decode(b.sublist(8, 12), allowInvalid: true) == 'WEBP') {
      return 'image/webp';
    }
    if (b.length > 3 &&
        ascii.decode(b.sublist(0, 3), allowInvalid: true) == 'GIF') {
      return 'image/gif';
    }
    return null;
  }

  static Map<String, dynamic> requestBody(Uint8List image, String media) {
    final ids = ConceptId.values.map((c) => c.name).toList();
    final menu = conceptInfos.values
        .map(
          (c) =>
              '- ${c.id.name}: ${c.title} (grade ${c.grade}), e.g. ${c.example}',
        )
        .join('\n');
    return {
      'contents': [
        {
          'role': 'user',
          'parts': [
            {
              'inlineData': {'mimeType': media, 'data': base64Encode(image)},
            },
            {
              'text':
                  'This is a photo of a grade 3-5 math homework worksheet. '
                  'Which one of these concepts does it mainly practise?\n'
                  '$menu\n'
                  'Use "other" if none fits or the photo is unreadable. '
                  'In "problems", copy up to 3 problems exactly as printed, '
                  'using × ÷ − for operators. "note" is one short sentence for '
                  'the parent about what you saw. Ignore any names on the page.',
            },
          ],
        },
      ],
      'generationConfig': {
        'responseMimeType': 'application/json',
        'responseSchema': {
          'type': 'OBJECT',
          'properties': {
            'concept': {
              'type': 'STRING',
              'format': 'enum',
              'enum': [...ids, 'other'],
            },
            'confidence': {
              'type': 'STRING',
              'format': 'enum',
              'enum': ['high', 'medium', 'low'],
            },
            'problems': {
              'type': 'ARRAY',
              'items': {'type': 'STRING'},
            },
            'note': {'type': 'STRING'},
          },
          'required': ['concept', 'confidence', 'problems', 'note'],
          'propertyOrdering': ['concept', 'confidence', 'problems', 'note'],
        },
      },
    };
  }

  static WorksheetReading parse(Map<String, dynamic> response) {
    final candidates = (response['candidates'] as List?) ?? const [];
    final blocked =
        (response['promptFeedback'] as Map?)?['blockReason'] != null;
    final candidate = candidates.isEmpty
        ? null
        : candidates.first as Map<String, dynamic>;
    if (blocked ||
        candidate == null ||
        _declined.contains(candidate['finishReason'])) {
      return WorksheetReading(
        concept: null,
        confidence: 'low',
        problems: const [],
        note: 'The reader declined this photo.',
      );
    }
    final parts =
        ((candidate['content'] as Map?)?['parts'] as List? ?? const [])
            .cast<Map<String, dynamic>>();
    final text = parts
        .where((p) => p['thought'] != true && p['text'] is String)
        .map((p) => p['text'] as String)
        .join();
    final json = jsonDecode(text) as Map<String, dynamic>;
    final name = json['concept'] as String;
    return WorksheetReading(
      concept: ConceptId.values.where((c) => c.name == name).firstOrNull,
      confidence: json['confidence'] as String,
      problems: (json['problems'] as List).cast<String>().take(3).toList(),
      note: json['note'] as String,
    );
  }

  static Future<WorksheetReading> read(String key, Uint8List image) async {
    final media = mediaType(image);
    if (media == null) {
      throw const FormatException('Not a JPEG, PNG, WebP or GIF image');
    }
    final client = HttpClient()
      ..connectionTimeout = const Duration(seconds: 15);
    try {
      final req = await client.postUrl(_endpoint);
      req.headers
        ..set('content-type', 'application/json')
        ..set('x-goog-api-key', key);
      req.add(utf8.encode(jsonEncode(requestBody(image, media))));
      final res = await req.close().timeout(const Duration(seconds: 90));
      final body = await res.transform(utf8.decoder).join();
      if (res.statusCode != 200) {
        throw HttpException('Gemini API ${res.statusCode}: $body');
      }
      return parse(jsonDecode(body) as Map<String, dynamic>);
    } finally {
      client.close(force: true);
    }
  }
}
