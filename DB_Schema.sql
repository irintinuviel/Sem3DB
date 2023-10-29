-- DROP DATABASE Galeria ;
CREATE DATABASE Galeria DEFAULT CHARACTER SET utf8;
USE Galeria;

CREATE TABLE Kategorie (
Id INT auto_increment, 
Nazwa VARCHAR(100) NOT null,
PRIMARY KEY (Id)
);

CREATE TABLE Kontrahenci (
Id INT auto_increment, 
Typ VARCHAR(20) NOT null,
Imie VARCHAR(100) NOT null, 
Nazwisko VARCHAR(100) NOT null, 
Ulica VARCHAR(100), 
NrBudynku VARCHAR(10), 
NrLokalu VARCHAR(100), 
KodPoczt VARCHAR(6), 
Miejscowosc VARCHAR(100),
Biografia VARCHAR(1000),
NrZezwolenia VARCHAR(100),
PRIMARY KEY (Id),
CONSTRAINT Typ_Chck CHECK (Typ IN ('Klient','Artysta','Ubezpieczyciel'))
);

CREATE TABLE Dziela (
	NrInw INT auto_increment,
	Tytul VARCHAR(1000) NOT null,
	Cena DECIMAL (12,2) NOT null,
	Rozmiar VARCHAR(100),
	IdKategorii INT NOT null,
	IdAutora INT NOT null,
	PRIMARY KEY (NrInw),
	FOREIGN KEY (IdKategorii) REFERENCES Kategorie(Id),
	FOREIGN KEY (IdAutora) REFERENCES Kontrahenci(Id)
);

CREATE TABLE Rzeczoznawcy (
Id INT auto_increment, 
Imie VARCHAR(100) NOT null, 
Nazwisko VARCHAR(100) NOT null, 
NrTel VARCHAR(15),
PRIMARY KEY (Id)
);

CREATE TABLE Certyfikaty (
Sygnatura VARCHAR(20), 
DataWyst DATE NOT null,
IdRzeczoznawcy INT NOT null,
IdDziela INT NOT null,
PRIMARY KEY (Sygnatura),
FOREIGN KEY (IdRzeczoznawcy) REFERENCES Rzeczoznawcy(Id),
FOREIGN KEY (IdDziela) REFERENCES Dziela(NrInw) ON DELETE CASCADE
);


CREATE TABLE Wystawy (
Id INT auto_increment, 
Tytul VARCHAR(1000) NOT null, 
DataPocz date, 
DataKon DATE,
PRIMARY KEY (Id)
);

CREATE TABLE Dzielo_Wystawa(
IdDziela INT,
IdWystawy INT,
FOREIGN KEY (IdDziela) REFERENCES Dziela(NrInw),
FOREIGN KEY (IdWystawy) REFERENCES Wystawy(Id)
);

CREATE TABLE Tagi (
Wartosc VARCHAR(100) NOT null,
NrInw INT NOT null,
FOREIGN KEY (NrInw) REFERENCES Dziela(NrInw) ON DELETE CASCADE
);



CREATE TABLE Ubezpieczenia (
NrPolisy VARCHAR(10), 
DataPocz date, 
DataKon date, 
KwotaUbezp DECIMAL(12,2) NOT null, 
Koszt DECIMAL(12,2) NOT null,
IdUbezpieczyciela INT NOT null,
IdDziela INT NOT NULL,
PRIMARY KEY (NrPolisy),
FOREIGN KEY (IdUbezpieczyciela) REFERENCES Kontrahenci(Id),
FOREIGN KEY (IdDziela) REFERENCES Dziela(NrInw) ON DELETE CASCADE
);



CREATE TABLE Nabycie (
Id INT auto_increment,
DataNab DATE NOT null, 
KwotaZakupu DECIMAL(12,2), 
ProcentProwizji DECIMAL(4,2),
IdSprzedajacego INT NOT null,
IdDziela INT NOT NULL,
PRIMARY KEY (Id),
FOREIGN KEY (IdSprzedajacego) REFERENCES Kontrahenci(Id),
FOREIGN KEY (IdDziela) REFERENCES Dziela(NrInw) ON DELETE CASCADE,
CONSTRAINT TypChck CHECK ((KwotaZakupu IS NOT NULL) + (ProcentProwizji IS NOT NULL) = 1)
);

CREATE TABLE Sprzedawcy (
NrPracownika INT auto_increment, 
Imie VARCHAR(100) NOT null, 
Nazwisko VARCHAR(100) NOT null,
NrPrzelozonego INT,
PRIMARY KEY (NrPracownika),
FOREIGN KEY (NrPrzelozonego) REFERENCES Sprzedawcy(NrPracownika)
);

CREATE TABLE Sprzedaz (
Id INT auto_increment,
DataSp DATE NOT null, 
Kwota DECIMAL(12,2) NOT null, 
Prowizja DECIMAL(4,2),
IdKupujacego INT NOT null,
IdSprzedawcy INT NOT null,
IdDziela INT NOT NULL,
PRIMARY KEY (Id),
FOREIGN KEY (IdKupujacego) REFERENCES Kontrahenci(Id),
FOREIGN KEY (IdSprzedawcy) REFERENCES Sprzedawcy(NrPracownika),
FOREIGN KEY (IdDziela) REFERENCES Dziela(NrInw) 
);

