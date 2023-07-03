
-- Delete rows from the Prodaje table where IdKat < 30
DELETE FROM PRODAJE WHERE IdKat < 30;

-- Delete rows from the Recenzije table where IdKat < 30
DELETE FROM RECENZIJE WHERE IdArt > 0;

-- Delete rows from the punjenja table where id < 30
DELETE FROM PUNJENJA WHERE id < 30;

-- Delete rows from the ARTIKAL table where IdArt < 30
DELETE FROM ARTIKAL WHERE IdArt < 30;

-- Delete rows from the KORISNIK table where IdKor < 30
DELETE FROM KORISNIK WHERE IdKor < 30;

-- Delete rows from the MESTO table where IdMes < 30
DELETE FROM MESTO WHERE IdMes < 30;

-- Delete rows from the KATEGORIJA table where IdKat < 30
DELETE FROM KATEGORIJA WHERE IdKat < 30;

-- Delete rows from the Vreme table where IdKat < 30
DELETE FROM Vreme WHERE IdVre > 0;

ALTER TABLE Vreme AUTO_INCREMENT = 1;



INSERT INTO Prodaje (IdKat, IdVre, IdKupca, IdMestoKupca, IdMestoProdavca, Kolicina, Iznos)
SELECT artikal.IdKat, (select IdVre from vreme where vreme.VremeDatum = CAST(CONCAT(narudzbina.Datum, ' ', narudzbina.Vreme) AS DATETIME)) as IdVre,
KORISNIK_PRODAVAC.IdKor as IdKupca, KORISNIK_KUPAC.IdM as MestoKupac, KORISNIK_PRODAVAC.IdM as MestoProdavac, stavka.Kolicina, stavka.Iznos
FROM stavka
inner join artikal on artikal.IdArt = stavka.IdArt
inner join narudzbina on narudzbina.IdNar = stavka.IdNar
inner join korisnik as KORISNIK_KUPAC on KORISNIK_KUPAC.IdKor = narudzbina.IdKor
inner join korisnik as KORISNIK_PRODAVAC on KORISNIK_PRODAVAC.IdKor = artikal.IdKor
where stavka.VremeUnosa > COALESCE((select max(poslednje_punjenje) from punjenja),'1900-01-01 00:00:00');

INSERT INTO Recenzije (IdVre, IdArt, IdKat, IdKupca, IdMestoKupca, IdProdavca, IdMestoProdavca, Ocena)
select (select IdVre from vreme where vreme.VremeDatum = CAST(CONCAT(recenzija.Datum, ' ', recenzija.Vreme) AS DATETIME)) as IdVre,
recenzija.IdArt, artikal.IdKat as IdKat, KUPAC.IdKor as IdKupca, KUPAC.IdM as IdMestoKupca, PRODAVAC.IdKor as IdProdavca, PRODAVAC.IdM as IdMestoProdavca, recenzija.Ocena
from recenzija
inner join korisnik as KUPAC on KUPAC.IdKor = recenzija.IdKor
inner join artikal on artikal.IdArt = recenzija.IdArt
inner join korisnik as PRODAVAC on PRODAVAC.IdKor = artikal.IdKor 
where CAST(CONCAT(recenzija.Datum, ' ', recenzija.Vreme) AS DATETIME) > COALESCE((select max(poslednje_punjenje) from punjenja),'1900-01-01 00:00:00');

-- VremeDatum
SELECT VremeDatum FROM vreme
where VremeDatum > COALESCE((select max(poslednje_punjenje) from punjenja),'1900-01-01 00:00:00')