-- skladiste

CREATE TABLE punjenja (
    id INT AUTO_INCREMENT PRIMARY KEY,
    poslednje_punjenje DATETIME
);

CREATE TABLE `Vreme` (
  IdVre INT AUTO_INCREMENT,
  VremeDatum DATETIME UNIQUE,
  Dan INT,
  Mesec INT,
  Godina INT,
  PRIMARY KEY (IdVre)
);

-- Kreiranje tabele KATEGORIJA
CREATE TABLE KATEGORIJA (
    IdKat INT NOT NULL,
    Naziv VARCHAR(255),
    PRIMARY KEY(IdKat)
);

-- Kreiranje tabele MESTO
CREATE TABLE MESTO (
    IdMes INT NOT NULL,
    Mesto VARCHAR(255),
    PRIMARY KEY(IdMes)
);

-- Kreiranje tabele KORISNIK
CREATE TABLE KORISNIK (
    IdKor INT NOT NULL,
    Ime VARCHAR(255),
    Prezime VARCHAR(255),
    Mobilni VARCHAR(20),
    Email VARCHAR(255),
    Godiste INT,
    Pol VARCHAR(10),
    IdM INT,
    FOREIGN KEY (IdM) REFERENCES MESTO(IdMes),
    PRIMARY KEY(IdKor)
);

-- Kreiranje tabele ARTIKAL
CREATE TABLE ARTIKAL (
    IdArt INT NOT NULL,
    Naziv VARCHAR(255),
    Opis TEXT,
    Cena DECIMAL(10, 2),
    Popust DECIMAL(10, 2),
    Kolicina INT,
    IdKor INT,
    IdKat INT,
    FOREIGN KEY (IdKor) REFERENCES KORISNIK(IdKor),
    FOREIGN KEY (IdKat) REFERENCES KATEGORIJA(IdKat),
    PRIMARY KEY(IdArt)
);

CREATE TABLE `Prodaje` (
  IdKat INT,
  IdVre INT,
  IdKupca INT,
  IdMestoKupca INT,
  IdMestoProdavca INT,
  Kolicina INT,
  Iznos DECIMAL(10, 2),
  FOREIGN KEY (IdKat) REFERENCES KATEGORIJA(IdKat),
  FOREIGN KEY (IdVre) REFERENCES VREME(IdVre),
  FOREIGN KEY (IdKupca) REFERENCES KORISNIK(IdKor),
  FOREIGN KEY (IdMestoKupca) REFERENCES MESTO(IdMes),
  FOREIGN KEY (IdMestoProdavca) REFERENCES MESTO(IdMes)
);

CREATE TABLE `Recenzije` (
  IdVre INT,
  IdArt INT,
  IdKat INT,
  IdKupca INT,
  IdMestoKupca INT,
  IdProdavca INT,
  IdMestoProdavca INT,
  Ocena DECIMAL(5, 2),
  FOREIGN KEY (IdVre) REFERENCES VREME(IdVre),
  FOREIGN KEY (IdArt) REFERENCES ARTIKAL(IdArt),
  FOREIGN KEY (IdKat) REFERENCES KATEGORIJA(IdKat),
  FOREIGN KEY (IdKupca) REFERENCES KORISNIK(IdKor),
  FOREIGN KEY (IdMestoKupca) REFERENCES MESTO(IdMes),
  FOREIGN KEY (IdMestoProdavca) REFERENCES MESTO(IdMes),
  FOREIGN KEY (IdProdavca) REFERENCES KORISNIK(IdKor)
);

-- Trigger VREME
DELIMITER $$
CREATE TRIGGER trg_insert_VREME
BEFORE INSERT ON VREME
FOR EACH ROW
BEGIN
    SET NEW.Dan = DATE_FORMAT(NEW.VremeDatum, '%d');
    SET NEW.Mesec = DATE_FORMAT(NEW.VremeDatum, '%m');
    SET NEW.Godina = DATE_FORMAT(NEW.VremeDatum, '%Y');
END$$
DELIMITER ;