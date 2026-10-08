BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "wellness_check" ADD COLUMN "ringCount" bigint NOT NULL DEFAULT 0;
ALTER TABLE "wellness_check" ADD COLUMN "snoozeCount" bigint NOT NULL DEFAULT 0;

--
-- MIGRATION VERSION FOR dhatri
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('dhatri', '20261008074806539-wellness-ring-snooze-counts', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261008074806539-wellness-ring-snooze-counts', "timestamp" = now();

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
    VALUES ('serverpod_auth_idp', '20260924105404509', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260924105404509', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20260924105232991', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260924105232991', "timestamp" = now();


COMMIT;
