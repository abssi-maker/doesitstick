# Feedback for the Serverpod team

From building *Did It Stick* with Serverpod 4.0.4, `serverpod_offline_sync` 0.0.10 and Flutter 3.44,
in Serverpod App Studio with an AI coding agent. We moved a real feature (parents' marks, shared by two
parents) onto offline sync and tested it on the server, with two simulated phones, in Chrome and on an
Android phone. It works, and it's a strong feature. Below is what slowed us down, each with a repro, the
workaround we used, and a suggestion.

## What worked well

- `database: sync` on a model, `serverpod generate`, `create-migration`: right the first time,
  including the **client** SQLite migration. `createSyncSession` generated on the client is a great touch.
- Shared **spaces** map cleanly to a real domain concept (a family).
- Continuous sync is fast: ~60–190 ms per round locally; a mark reached another device in about 2 s,
  and an offline mark reached the server 3 s after the phone reconnected.
- Conflicting edits on two devices converged to the same latest mark every time.
- The web path works once the assets are in place: SQLite in WebAssembly saved a mark that reached the
  server in 1.4 s.

## Issues, in the order we hit them

### 1. `withServerpod` doesn't start the offline sync engine

**Repro:** any test that touches a synced table or `session.offlineSync` fails with
`Bad state: The OfflineSyncEngine has not been initialized for this Serverpod instance.`
The generated test tools build a plain `Serverpod(args, Protocol(), Endpoints())`, not the generated
subclass that calls `initializeOfflineSync`.

**Workaround:** a `withSyncedServerpod` wrapper that calls
`sessionBuilder.build().serverpod.initializeOfflineSync(syncTables: syncTables)` in `setUpAll`
([`test/integration/synced_serverpod.dart`](doesitstick_server/test/integration/synced_serverpod.dart)).

**Suggestion:** have the generated test tools construct the generated `Serverpod` subclass (or call
`initializeOfflineSync` when sync tables exist).

### 2. The test session's rollback proxy hides the sync database

**Repro:** inside `withServerpod`, `session.offlineSyncDb` throws
`This database session is not wrapped with OfflineSyncDatabaseSession`, because the session's `db` is
a `TestDatabaseProxy`, not an `OfflineSyncDatabase`. Passing `offlineSyncDatabaseInterceptor` as
`databaseInterceptor` doesn't help: the proxy wraps the intercepted database and hides it.

**Workaround:** wrap the proxy ourselves when needed:
`db is OfflineSyncDatabase ? db : offlineSyncDatabaseInterceptor(session, db)`, and write synced rows
through that database (`db.insertRow<Mark>(…, transaction: tx)` inside `transactionForUser`).

**Suggestion:** let `TestDatabaseProxy` forward to an `OfflineSyncDatabase`, or make `offlineSyncDb`
unwrap known proxies.

### 3. Cached sync-table ids break under per-test rollback

**Repro:** after issue 2's workaround, the first test passes and later ones fail with
`insert or update on table "crdt_data_rows" violates foreign key constraint "crdt_data_rows_fk_1" …
Key (tblId)=(1) is not present in table "crdt_schema_tables"`. The engine registers its tables inside
the first test's transaction, caches the ids, and the rollback deletes the rows.

**Workaround:** register the tables once, outside any test, in a committed session:
`await syncDatabase(await pod.createSession()).initialize()` in `setUpAll`.

**Suggestion:** register sync tables at engine start (or in the migration), or re-validate the cache
after a rollback.

### 4. No server hook in the built-in sync endpoint

`session.offlineSync.sync(…, onMergeSuccess: …)` exists, but the module's own `OfflineSyncEndpoint`
doesn't expose it, and there's no write-validation hook. Our server must react when marks arrive
(complete a card, schedule re-checks, notify the other parent), so we wrote our own endpoint and
pointed the client at it with `OfflineSyncClient(({changes, once}) => client.familySync.sync(…))`.
The module's endpoint stays exposed next to it, so a client could bypass our hook.

**Suggestion:** an `onMergeSuccess` (and ideally a per-row validation hook) in
`initializeOfflineSync`, plus a way to turn off the default endpoint when you provide your own.

### 5. Web setup isn't documented

The web client needs `sqlite3.wasm` and `db_worker.js` in `web/`, matching the resolved `sqlite3` and
`sqlite_async` versions (3.7.0 and 0.14.5 for us), from two different GitHub release pages. We found
this in `sqlite_async`'s README, not in the offline sync docs.

**Suggestion:** a "Web" section in the offline sync docs with the exact files and versions, or a
`serverpod` command that fetches them.

Related: on first open in a browser, the console shows
`Error in worker: SqliteException(1): … no such table: serverpod_migrations`. It's harmless (the
migration check runs before the table exists) but alarming. Checking for the table first would avoid
it.

### 6. Smaller docs gaps

- How to **write into a shared space from the client** (`offlineSyncDb.transactionForUser(user,
  …, spaceId: space)`) and that a phone must sync once before it can act in a shared space (its
  membership cache starts empty).
- How to write synced rows **on the server** (same API, via `session.offlineSyncDb`).
- That `serverpod_offline_sync` 0.0.10 needs Serverpod **exactly** `>=4.0.4 <4.1.0`: worth stating
  on the main docs page, since App Studio projects start on 4.0.0.
- Synced models can't keep a relation to a non-synced parent (our `Mark → Question` foreign key had to
  go). It's in the limitations list, but an example of the recommended pattern would help.

## Outside offline sync

- **Debug-only crash:** `setState(() => _future = client.x())` throws
  "setState() callback argument returned a Future" in debug builds and the screen never rebuilds. Our
  own family gate (written with an AI agent) had it, and release builds hide it. A lint in
  `serverpod_lints` for setState arrows that return a Future would catch it, and help agents too.
- **App Studio's web app uses the production URL:** the dev Flutter web app reads `apiUrl` from
  `assets/config.json`, which Serverpod Cloud set to production. During development our web app
  talked to the live server, not the local one, which surprised us. Defaulting to the local server
  in development would be safer.
- **`withServerpod` + `serverpod_test`**: passing `databaseInterceptor` is documented, but a sentence
  on how it composes with rollback would have saved time (see issues 1–3).
