BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "family" (
    "id" bigserial PRIMARY KEY,
    "childName" text NOT NULL,
    "inviteCode" text NOT NULL,
    "shareToken" text,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "family_invite_idx" ON "family" USING btree ("inviteCode");
CREATE UNIQUE INDEX "family_share_idx" ON "family" USING btree ("shareToken");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "family_member" (
    "id" bigserial PRIMARY KEY,
    "familyId" bigint NOT NULL,
    "authUserId" uuid,
    "displayName" text NOT NULL,
    "joinedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "family_member_user_idx" ON "family_member" USING btree ("authUserId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "mark" (
    "id" bigserial PRIMARY KEY,
    "questionId" bigint NOT NULL,
    "cardId" bigint NOT NULL,
    "familyId" bigint NOT NULL,
    "outcome" text NOT NULL,
    "parentName" text NOT NULL,
    "authUserId" uuid,
    "clientMarkId" text NOT NULL,
    "markedAt" timestamp without time zone NOT NULL,
    "receivedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "mark_client_idx" ON "mark" USING btree ("clientMarkId");
CREATE INDEX "mark_question_idx" ON "mark" USING btree ("questionId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "question" (
    "id" bigserial PRIMARY KEY,
    "cardId" bigint NOT NULL,
    "familyId" bigint NOT NULL,
    "position" bigint NOT NULL,
    "conceptId" text NOT NULL,
    "style" text NOT NULL,
    "seed" bigint NOT NULL,
    "operands" json NOT NULL,
    "prompt" text NOT NULL,
    "expectedAnswer" text NOT NULL,
    "answerValue" bigint NOT NULL,
    "shownWrong" bigint,
    "methodNote" text NOT NULL,
    "listenFor" text NOT NULL,
    "hint" text NOT NULL,
    "checkedByCode" boolean NOT NULL,
    "variantOfQuestionId" bigint
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "question_card" (
    "id" bigserial PRIMARY KEY,
    "familyId" bigint NOT NULL,
    "conceptId" text NOT NULL,
    "kind" text NOT NULL,
    "recheckDay" bigint NOT NULL,
    "sourceCardId" bigint,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "completedAt" timestamp without time zone
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "recheck" (
    "id" bigserial PRIMARY KEY,
    "familyId" bigint NOT NULL,
    "sourceCardId" bigint NOT NULL,
    "conceptId" text NOT NULL,
    "dayOffset" bigint NOT NULL,
    "dueAt" timestamp without time zone NOT NULL,
    "status" text NOT NULL,
    "cardId" bigint,
    "fastForwarded" boolean NOT NULL DEFAULT false
);

-- Indexes
CREATE UNIQUE INDEX "recheck_source_day_idx" ON "recheck" USING btree ("sourceCardId", "dayOffset");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "worksheet" (
    "id" bigserial PRIMARY KEY,
    "familyId" bigint NOT NULL,
    "uploadedByName" text NOT NULL,
    "photoPath" text,
    "status" text NOT NULL,
    "conceptId" text,
    "detectedProblems" json,
    "note" text,
    "cardId" bigint,
    "photoDeletedAt" timestamp without time zone,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "family_member"
    ADD CONSTRAINT "family_member_fk_0"
    FOREIGN KEY("familyId")
    REFERENCES "family"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "mark"
    ADD CONSTRAINT "mark_fk_0"
    FOREIGN KEY("questionId")
    REFERENCES "question"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "question"
    ADD CONSTRAINT "question_fk_0"
    FOREIGN KEY("cardId")
    REFERENCES "question_card"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "question_card"
    ADD CONSTRAINT "question_card_fk_0"
    FOREIGN KEY("familyId")
    REFERENCES "family"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "recheck"
    ADD CONSTRAINT "recheck_fk_0"
    FOREIGN KEY("familyId")
    REFERENCES "family"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "worksheet"
    ADD CONSTRAINT "worksheet_fk_0"
    FOREIGN KEY("familyId")
    REFERENCES "family"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR doesitstick
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('doesitstick', '20261009151313646', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261009151313646', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260824182259319', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260824182259319', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20260910193913364-string-rate-limit-keys', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260910193913364-string-rate-limit-keys', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20260824182354731', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260824182354731', "timestamp" = now();


COMMIT;
