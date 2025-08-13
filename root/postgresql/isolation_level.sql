BEGIN ISOLATION LEVEL REPEATABLE READ;

-- Now we're in snapshot isolation


/*
*/
BEGIN;

SELECT *
FROM player
WHERE id = 42
    FOR UPDATE;

-- some kind of game logic here

UPDATE player
SET score = 853
WHERE id = 42;

COMMIT;

