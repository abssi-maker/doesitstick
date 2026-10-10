# Did It Stick

**Calm math homework for parents.** Snap tonight's worksheet and Did It Stick tells you what to
say, the way the class teaches it, and when to stop. Then it checks, days later, that it stuck.

**Try it:** [doesitstick.serverpod.space](https://doesitstick.serverpod.space). Tap *Get started*;
no account needed.

Built with **Flutter** and **Serverpod** for *Build Something Real: The Serverpod Hackathon*.

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

1. **Snap the worksheet.** Gemini reads the topic and the problems. The photo is deleted right after.
2. **Work through it together**, on the child's *own* problems:
   - **How the class does it**: the method in one line.
   - **Say:** the exact words to use.
   - **Hints that never give the answer away**, then a bigger hint.
   - **A kind ending** when it isn't clicking: "Great one to ask your teacher about tomorrow!"
   - **Listen for:** what a good "why" sounds like.
3. **Mark how it went**: Not yet / With a hint / Got the answer / Explained why. No red, anywhere.
   A praise line tells you what to say next.
4. **Your partner sees it live** on their phone.
5. **Did it stick?** A 1-minute re-check on day 2 and day 7, with new numbers, and a weekly
   "what stuck" summary.

Grades 3–5: 3-digit addition and subtraction, 2-digit multiplication, dividing by one digit,
equivalent fractions.

## How Serverpod makes it work

Every Serverpod feature answers a parent need.

| Parent need | Serverpod feature |
|---|---|
| Don't make me wait at the table | A **future call** reads the photo in the background; the result arrives over the live stream. |
| Never give my child a wrong answer | **Server-side checking.** Gemini only names the topic and copies the problems. Dart code on the server builds every question and recomputes every answer with an independent checker (`math/concepts.dart`). A misread problem is dropped, not trusted. |
| My partner should see tonight live | **Streaming endpoints** + `session.messages` on a per-family channel. |
| Check it stuck without me remembering | **Scheduled future calls** on day 2 and day 7. `Recheck` rows are the source of truth, and a recurring 15-minute sweep catches anything missed, so restarts and deploys lose nothing. |
| My child's homework photo is private | **Private file storage** with upload descriptions; deleted right after reading, and the sweep removes anything older than an hour. |
| No sign-up at the kitchen table | **Serverpod auth** with a one-tap anonymous identity provider; email sign-in is optional. |
| Wi-Fi drops at home | An offline outbox on the phone and **idempotent** marks (`clientMarkId`); the latest mark wins. |
| Setup must never get stuck | Idempotent `family.create` and `join`: retrying after a lost reply is safe. |
| Keys stay secret | **Serverpod Cloud passwords** (`geminiApiKey`); never in the app or this repo. |
| It has to be trustworthy | Tests with `serverpod_test` on an embedded Postgres, plus opt-in tests that send real worksheet photos to Gemini. |

One Dart codebase: the Flutter app (Android and web) and the server share generated models.

## Try it as a judge

- **Two parents:** open the app in two browsers (or a normal and a private window). Start a family in
  one, then join with the code from the *Family* tab in the other. Marks appear live in both.
- **A worksheet:** sample photos are in
  [`doesitstick_server/test/fixtures/worksheets`](doesitstick_server/test/fixtures/worksheets).
  Download one and use *Choose a photo*.
- **Day 7 without waiting a week:** on *Re-checks*, use **For judges: jump ahead in time**.

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
- `doesitstick_flutter/lib/` — the app (screens, live state, offline outbox, design tokens)
