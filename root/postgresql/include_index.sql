--standard
CREATE INDEX idx
    ON sales
        ( subsidiary_id, eur_value );

SELECT SUM(eur_value)
FROM sales
WHERE subsidiary_id = ?;

--include
CREATE INDEX idx
    ON sales ( subsidiary_id )
    INCLUDE ( eur_value );

--having more columns in index
SELECT *
FROM sales
WHERE subsidiary_id = ?
  AND notes LIKE '%search term%';

--old
CREATE INDEX idx
    ON sales ( subsidiary_id, ts )
    INCLUDE ( eur_value );

--new
CREATE INDEX idx
    ON sales ( subsidiary_id, ts )
    INCLUDE ( eur_value, notes );

------
CREATE UNIQUE INDEX …
    ON … ( id )
    INCLUDE ( payload );


SELECT payload
FROM …
         WHERE id = ?;