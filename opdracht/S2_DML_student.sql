-- ------------------------------------------------------------------------
-- Data & Persistency
-- Opdracht S2: Data Manipulation Language
--
-- (c) 2020 Hogeschool Utrecht
-- Tijmen Muller (tijmen.muller@hu.nl)
-- André Donk (andre.donk@hu.nl)
--
--
-- Opdracht: schrijf SQL-queries om onderstaande resultaten op te vragen,
-- aan te maken, verwijderen of aan te passen in de database van de
-- bedrijfscasus.
--
-- Codeer je uitwerking onder de regel 'DROP VIEW ...' (bij een SELECT)
-- of boven de regel 'ON CONFLICT DO NOTHING;' (bij een INSERT)
-- Je kunt deze eigen query selecteren en los uitvoeren, en wijzigen tot
-- je tevreden bent.
--
-- Vervolgens kun je je uitwerkingen testen door de testregels
-- (met [TEST] erachter) te activeren (haal hiervoor de commentaartekens
-- weg) en vervolgens het hele bestand uit te voeren. Hiervoor moet je de
-- testsuite in de database hebben geladen (bedrijf_postgresql_test.sql).
-- NB: niet alle opdrachten hebben testregels.
--
-- Lever je werk pas in op Canvas als alle tests slagen. Draai daarna
-- alle wijzigingen in de database terug met de queries helemaal onderaan.
-- ------------------------------------------------------------------------


-- S2.1. Vier-daagse cursussen
--
-- Geef code en omschrijving van alle cursussen die precies vier dagen duren.
DROP VIEW IF EXISTS s2_1; CREATE OR REPLACE VIEW s2_1 AS                                                     -- [TEST]

SELECT code, omschrijving FROM cursussen
WHERE lengte = 4;

-- S2.2. Medewerkersoverzicht
--
-- Geef alle informatie van alle medewerkers, gesorteerd op functie,
-- en per functie op leeftijd (van jong naar oud).
DROP VIEW IF EXISTS s2_2; CREATE OR REPLACE VIEW s2_2 AS                                                     -- [TEST]

SELECT * FROM medewerkers
ORDER BY functie, gbdatum;

-- S2.3. Door het land
--
-- Welke cursussen zijn in Utrecht en/of in Maastricht uitgevoerd? Geef
-- code en begindatum.
DROP VIEW IF EXISTS s2_3; CREATE OR REPLACE VIEW s2_3 AS                                                     -- [TEST]

SELECT cursus, begindatum from uitvoeringen
WHERE locatie = 'UTRECHT' or locatie = 'MAASTRICHT';

-- S2.4. Namen
--
-- Geef de naam en voorletters van alle medewerkers, behalve van R. Jansen.
DROP VIEW IF EXISTS s2_4; CREATE OR REPLACE VIEW s2_4 AS                                                     -- [TEST]

SELECT naam, voorl FROM medewerkers
WHERE naam != 'Jansen' and voorl != 'R';

-- S2.5. Nieuwe SQL-cursus
--
-- Er wordt een nieuwe uitvoering gepland voor cursus S02, en wel op de
-- komende 2 maart. De cursus wordt gegeven in Leerdam door Nick Smit.
-- Voeg deze gegevens toe.
INSERT INTO uitvoeringen(cursus, begindatum, docent, locatie)
VALUES('S02', '2023-03-02', 7369, 'LEERDAM')
ON CONFLICT DO NOTHING;                                                                                         -- [TEST]


-- S2.6. Stagiairs
--
-- Neem één van je collega-studenten aan als stagiair ('STAGIAIR') en
-- voer zijn of haar gegevens in. Kies een personeelnummer boven de 8000.
INSERT INTO medewerkers(mnr, naam, voorl, functie, chef, gbdatum, maandsal, comm, afd)
VALUES(8420, 'Meijer', 'T', 'STAGAIRE', 7839, '2002-05-06', 1400.00, null, 30)
ON CONFLICT DO NOTHING;                                                                                         -- [TEST]


-- S2.7. Nieuwe schaal
--
-- We breiden het salarissysteem uit naar zes schalen. Voer een extra schaal in voor mensen die
-- tussen de 3001 en 4000 euro verdienen. Zij krijgen een toelage van 500 euro.
UPDATE schalen
set bovengrens = 4000
WHERE snr = 5;

INSERT INTO schalen(snr, ondergrens, bovengrens, toelage)
VALUES(6, 4001, 9999, 500)
ON CONFLICT DO NOTHING;                                                                                         -- [TEST]


-- S2.8. Nieuwe cursus
--
-- Er wordt een nieuwe 6-daagse cursus 'Data & Persistency' in het programma opgenomen.
-- Voeg deze cursus met code 'D&P' toe, maak twee uitvoeringen in Leerdam en schrijf drie
-- mensen in.
INSERT INTO cursussen(code, omschrijving, type, lengte)
VALUES('D&P', 'Een cursus voor Data & Persistency', 'DSG', 6)
ON CONFLICT DO NOTHING;                                                                                         -- [TEST]
INSERT INTO uitvoeringen(cursus, begindatum, docent, locatie)
VALUES('D&P', '2023-03-06', 7369, 'LEERDAM')
ON CONFLICT DO NOTHING;                                                                                         -- [TEST]
INSERT INTO uitvoeringen(cursus, begindatum, docent, locatie)
VALUES('D&P', '2023-05-06', 7369, 'LEERDAM')
ON CONFLICT DO NOTHING;                                                                                         -- [TEST]
INSERT INTO inschrijvingen(cursist, cursus, begindatum, evaluatie)
VALUES(7369, 'D&P', '2023-05-06', 4)
ON CONFLICT DO NOTHING;                                                                                         -- [TEST]
INSERT INTO inschrijvingen(cursist, cursus, begindatum, evaluatie)
VALUES(7369, 'D&P', '2023-03-06', 4)
ON CONFLICT DO NOTHING;                                                                                         -- [TEST]
INSERT INTO inschrijvingen(cursist, cursus, begindatum, evaluatie)
VALUES(7369, 'D&P', '2023-03-06', 4)
ON CONFLICT DO NOTHING;                                                                                         -- [TEST]


-- S2.9. Salarisverhoging
--
-- De medewerkers van de afdeling VERKOOP krijgen een salarisverhoging
-- van 5.5%, behalve de manager van de afdeling, deze krijgt namelijk meer: 7%.
-- Voer deze verhogingen door.

UPDATE medewerkers
SET maandsal = CASE
    when mnr = 7698 then maandsal * 1.07
    WHEN functie = 'VERKOPER' then maandsal * 1.055
    ELSE maandsal
    END;


-- S2.10. Concurrent
--
-- Martens heeft als verkoper succes en wordt door de concurrent
-- weggekocht. Verwijder zijn gegevens.

-- Zijn collega Alders heeft ook plannen om te vertrekken. Verwijder ook zijn gegevens.
-- Waarom lukt dit (niet)?

DELETE FROM medewerkers
WHERE mnr = 7654;

-- DELETE FROM medewerkers
-- WHERE mnr = 7499;
-- Deze query lukt niet, omdat Alders nog steeds ingeschreven staat bij een cursus.

-- S2.11. Nieuwe afdeling
--
-- Je wordt hoofd van de nieuwe afdeling 'FINANCIEN' te Leerdam,
-- onder de hoede van De Koning. Kies een personeelnummer boven de 8000.
-- Zorg voor de juiste invoer van deze gegevens.

INSERT INTO medewerkers(mnr, naam, voorl, functie, chef, gbdatum, maandsal, comm)
VALUES(8069, 'Griffioen', 'J', 'MANAGER', 7839, '2001-09-13', 9999, null)
ON CONFLICT DO NOTHING;                                                                                         -- [TEST]

INSERT INTO afdelingen(anr, naam, locatie, hoofd)
VALUES(50, 'FINANCIEN', 'LEERDAM', 8069)
ON CONFLICT DO NOTHING;                                                                                         -- [TEST]



-- -------------------------[ HU TESTRAAMWERK ]--------------------------------
-- Met onderstaande query kun je je code testen. Zie bovenaan dit bestand
-- voor uitleg.

SELECT * FROM test_select('S2.1') AS resultaat
UNION
SELECT 'S2.2 wordt niet getest: geen test mogelijk.' AS resultaat
UNION
SELECT * FROM test_select('S2.3') AS resultaat
UNION
SELECT * FROM test_select('S2.4') AS resultaat
UNION
SELECT * FROM test_exists('S2.5', 1) AS resultaat
UNION
SELECT * FROM test_exists('S2.6', 1) AS resultaat
UNION
SELECT * FROM test_exists('S2.7', 6) AS resultaat
ORDER BY resultaat;


-- Draai alle wijzigingen terug om conflicten in komende opdrachten te voorkomen.
UPDATE medewerkers SET afd = NULL WHERE mnr < 7369 OR mnr > 7934;
UPDATE afdelingen SET hoofd = NULL WHERE anr > 40;
DELETE FROM afdelingen WHERE anr > 40;
DELETE FROM medewerkers WHERE mnr < 7369 OR mnr > 7934;
DELETE FROM inschrijvingen WHERE cursus = 'D&P';
DELETE FROM uitvoeringen WHERE cursus = 'D&P';
DELETE FROM cursussen WHERE code = 'D&P';
DELETE FROM uitvoeringen WHERE locatie = 'LEERDAM';
INSERT INTO medewerkers (mnr, naam, voorl, functie, chef, gbdatum, maandsal, comm, afd)
VALUES (7654, 'MARTENS', 'P', 'VERKOPER', 7698, '1976-09-28', 1250, 1400, 30);
UPDATE medewerkers SET maandsal = 1600 WHERE mnr = 7499;
UPDATE medewerkers SET maandsal = 1250 WHERE mnr = 7521;
UPDATE medewerkers SET maandsal = 2850 WHERE mnr = 7698;
UPDATE medewerkers SET maandsal = 1500 WHERE mnr = 7844;
UPDATE medewerkers SET maandsal = 800 WHERE mnr = 7900;


