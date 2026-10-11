# Did It Stick

**Calm math homework for parents, and proof it stuck.** Snap tonight's worksheet and Did It Stick
tells you what to say for your child's *actual* problems, the way the class teaches it, and when to
stop. Then it checks, on day 2 and day 7, that it stuck.

**Try it:** [doesitstick.serverpod.space](https://doesitstick.serverpod.space). Tap *Get started*;
no account needed.

Built with **Flutter** and **Serverpod 4** in **Serverpod App Studio** with an AI coding agent, for
*Build Something Real: The Serverpod Hackathon*.

## The problem

Helping with math homework often ends in a fight. Most parents were never taught how to *teach*
math, and the classroom methods (area models, partial quotients, number lines) are new to them.

- Children of math-anxious parents learned less math over a school year, and became more anxious
  themselves, **only when those parents helped often**. Parents' math knowledge didn't matter; their
  anxiety did. ([Maloney et al., *Psychological Science*, 2015](https://news.uchicago.edu/article/2015/08/10/parents-math-anxiety-can-undermine-children-s-math-achievement))
- Parents feel more negative during homework than during other math with their kids, and that
  irritation predicted lower motivation and achievement a year later.
  ([Wu, Pomerantz et al., *Child Development*, 2022](https://news.illinois.edu/parents-reactions-while-helping-with-math-shape-young-childrens-achievement/))
- The most common homework conflict is a *knowledge* conflict: the parent's way against the child's
  new way. ([Gao et al., "The Homework Wars", 2025](https://arxiv.org/abs/2502.01325))

## The solution

Did It Stick coaches the **parent**, not the child.

1. **Snap the worksheet.** Google Gemini reads the topic and the problems. Both parents can look at the photo
   again; it stays private to the family and is deleted after 7 days.
2. **Work through it together**, one of the child's *own* problems at a time: the class method in one
   line, then **Say:** the exact words. Then one of two things happens:
   - **Got it** → *"Now ask: how do you know?"*, with what a good answer sounds like. A right answer
     might be a guess; the "why" is what sticks.
   - **Not quite** → the moment the yelling usually starts. *"What did Mia say?"* Type it in:
     - **282** for 46 × 7 → *"A common slip: the 4 tens from 6 × 7 = 42 got lost. Ask: 'What is
       6 × 7? Where did the 40 go?'"*
     - anything else → *"Ask: 'How did you get that? Show me.'"*
     - then help one step at a time (a nudge, the first step together, the full walk-through), never
       the answer, ending kindly: *"Great one to ask your teacher about tomorrow!"*
3. **The app notes how it went** from what you tapped: Not yet / With a hint / Got the answer /
   Explained why. No red, anywhere. A praise line tells you what to say next.
4. **Your partner is there, even from work.** Their phone shows *"Live now: Alex is with Mia,
   problem 2 of 3, working through it with a hint"*, and they can send a cheer that pops up big at the
   table: *"Sam sent a cheer: Proud of you for sticking with it, Mia! Read it out."* Invite them with
   a link; it opens the app with the code filled in.
5. **Did it stick?** A quick re-check on day 2 and day 7, with new numbers, and a weekly
   "what stuck" summary.

Grades 3–5: 3-digit addition and subtraction, 2-digit multiplication, dividing by one digit,
equivalent fractions.

## How Serverpod makes it work

Every Serverpod feature answers a parent need.

| Parent need | Serverpod feature |
|---|---|
| Don't make me wait at the table | A **future call** reads the photo in the background; the result arrives over the live stream. |
| Never give my child a wrong answer | **Server-side checking.** Gemini only names the topic and copies the problems. Dart code on the server builds every question and recomputes every answer with an independent checker (`math/concepts.dart`). A misread problem is dropped, not trusted. |
| Tell me what to say to *this* wrong answer | **Server-side coaching.** For each problem the server works out the usual slips for its exact numbers (forgotten carry, skipped box, flipped subtraction…) with a question to ask, plus a next step. The checker recomputes every slip on its own and rejects any help that states the answer. Stored with the question, so it works offline. |
| My partner should be there, even from work | **Streaming endpoints** + `session.messages` on a per-family channel: live presence (which problem, stuck or not; streamed, never stored), preset cheers to the table, and every mark the moment it lands. |
| Check it stuck without me remembering | **Scheduled future calls** on day 2 and day 7. `Recheck` rows are the source of truth, and a recurring 15-minute sweep catches anything missed, so restarts and deploys lose nothing. |
| My child's homework photo is private | **Private file storage** with upload descriptions; only family members can fetch it through an endpoint, a parent can delete it, and the sweep removes it after 7 days. |
| No sign-up at the kitchen table | **Serverpod auth** with a one-tap anonymous identity provider; email sign-in is optional. |
| Wi-Fi drops at home | **Serverpod 4 offline sync** (`database: sync`): each phone keeps its family's marks in local SQLite (also in the browser, via `sqlite3.wasm`), writes offline, and syncs continuously into a shared **family space**; conflicts merge, latest mark wins. |
| Setup must never get stuck | Idempotent `family.create` and `join`: retrying after a lost reply is safe. |
| Keys stay secret | **Serverpod Cloud passwords** (`geminiApiKey`); never in the app or this repo. |
| It has to be trustworthy | Tests with `serverpod_test` on an embedded Postgres, plus opt-in tests that send real worksheet photos to Gemini. |

One Dart codebase: the Flutter app (Android and web) and the server share generated models.

### Offline sync, end to end

Marks are a `database: sync` model in a shared space per family (created with the family; the partner
is granted on join). A small `familySync` endpoint wraps the module's sync with `onMergeSuccess`, so
when a phone's marks land the server completes the card, schedules re-checks and tells the other
parent. Verified with:

- `doesitstick_client/tool/two_parents_sync.dart`: two accounts, two local databases; a mark
  reaches the other phone, offline marks sync later, conflicting edits converge, live sync in ~2 s.
- `doesitstick_flutter/tool/web_sync_check.dart`: the same in Chrome (SQLite in WebAssembly).
- A real Android phone: marked with no connection ("Saved on this phone"), synced 3 s after
  reconnecting; the app also opens offline from its cached family.

What we learned along the way is in [SERVERPOD_FEEDBACK.md](SERVERPOD_FEEDBACK.md).

## Try it as a judge (about a minute)

1. Open [doesitstick.serverpod.space](https://doesitstick.serverpod.space), tap **Get started**, enter a
   child's name and yours, and skip the invite.
2. On *Tonight*, tap **No worksheet at hand? Try a sample one**. It goes through the real path:
   upload → Gemini → server-built, re-checked questions on the sheet's own problems (46 × 7, …).
3. **Work through it together**: tap **Not quite**, type **282** for 46 × 7 and see the slip it names.
   Then try **Give a nudge** → *Still stuck?* down to the kind ending.
4. **How it works, under the hood** (welcome page or *Family* tab) maps each step to the Serverpod
   feature behind it.

More:

- **Two parents:** open the app in two browsers (or a normal and a private window). Start a family in
  one, then join with the code from the *Family* tab in the other. Open tonight's card in the first:
  the second shows *Live now* with the problem, and its cheers pop up in the first.
- **A worksheet:** sample photos are in
  [`doesitstick_server/test/fixtures/worksheets`](doesitstick_server/test/fixtures/worksheets).
  Download one and use *Choose a photo instead*.
- **Day 7 without waiting a week, or no Wi-Fi:** *Family* → **Try it out**: skip to day 2 or 7, or
  switch the connection off.

## Run it locally

Requirements: Flutter 3.44+ and the Serverpod CLI 4.

```bash
cd doesitstick_server
serverpod start          # starts the server, the database and the Flutter app
```

Photo reading needs a Gemini key in `doesitstick_server/config/passwords.yaml`
(`geminiApiKey: ...` under `development:`). Without it, parents pick the topic themselves.

Tests (no Docker needed; Serverpod runs an embedded Postgres):

```bash
cd doesitstick_server
dart test                                          # all server tests
RUN_E2E=1 GEMINI_API_KEY=... dart test test/e2e    # real worksheet photos through Gemini
```

## Project layout

- `doesitstick_server/lib/src/math/` — question builder and independent checker
- `doesitstick_server/lib/src/worksheets/` — photo upload, Gemini reader, background reading
- `doesitstick_server/lib/src/rechecks/` — day-2 and day-7 re-checks
- `doesitstick_flutter/lib/` — the app (screens, live state, offline sync of marks, design tokens)
