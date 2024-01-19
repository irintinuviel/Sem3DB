-- usuwa wygasłe ubezpieczenia 
DELIMITER //  
CREATE PROCEDURE UsunWygasle()
   BEGIN
    DECLARE currentDate DATE;
    -- Pobierz aktualną datę
    SET currentDate = CURDATE();
    -- Usuń wygasłe ubezpieczenia
    DELETE FROM ubezpieczenia
    WHERE DataKon < currentDate;
   END //
DELIMITER ;

-- sprzedaż nowemu klientowi
DELIMITER // 
CREATE PROCEDURE SprzedajNowemu( 
DataSp DATE, 
Kwota DECIMAL(12,2), 
Prowizja DECIMAL(4,2),
IdSprzedawcy INT,
IdDziela INT,
Imie VARCHAR(100),
Nazwisko VARCHAR(100),
Ulica VARCHAR(100), 
NrBudynku VARCHAR(10), 
NrLokalu VARCHAR(100), 
KodPoczt VARCHAR(6), 
Miejscowosc VARCHAR(100) 
)
   BEGIN
    DECLARE Idk INT;
    INSERT INTO kontrahenci(Typ, Imie, Nazwisko, Ulica, NrBudynku, NrLokalu, KodPoczt, Miejscowosc)
    VALUES ('Klient',Imie, Nazwisko, Ulica, NrBudynku, NrLokalu, KodPoczt, Miejscowosc);

    SELECT MAX(Id) into Idk FROM kontrahenci;
	 INSERT INTO sprzedaz(DataSp, Kwota, Prowizja, IdKupujacego, IdSprzedawcy, IdDziela)
    VALUES (DataSp, Kwota, Prowizja, Idk, IdSprzedawcy, IdDziela);
   END //
DELIMITER ;

-- sprzedaż klientowi już zapisanemu w bazie danych
DELIMITER //
CREATE PROCEDURE Sprzedaj(
DataSp DATE, 
Kwota DECIMAL(12,2), 
Prowizja DECIMAL(4,2),
IdKupujacego INT,
IdSprzedawcy INT,
IdDziela INT)
	BEGIN
		INSERT INTO sprzedaz(DataSp, Kwota, Prowizja, IdKupujacego, IdSprzedawcy, IdDziela)
	   VALUES (DataSp, Kwota, Prowizja, IdKupujacego, IdSprzedawcy, IdDziela);
	END //
   
DELIMITER ;

-- nabycie nowego dzieła
DELIMITER //
CREATE PROCEDURE NoweNabycie(
Tytul VARCHAR(1000),
Cena DECIMAL (12,2),
Rozmiar VARCHAR(100),
IdKategorii INT,
IdAutora INT,
DataNab DATE, 
KwotaZakupu DECIMAL(12,2), 
ProcentProwizji DECIMAL(4,2),
IdSprzedajacego INT
)
	BEGIN
		DECLARE Idk INT;    	
		INSERT INTO dziela(Tytul,Cena,Rozmiar,IdKategorii,IdAutora)
	   VALUES (Tytul,Cena,Rozmiar,IdKategorii,IdAutora);
	   
	   SELECT MAX(NrInw) into Idk FROM dziela;
	   INSERT INTO nabycie(DataNab, KwotaZakupu, ProcentProwizji,IdSprzedajacego,IdDziela)
	   VALUES (DataNab, KwotaZakupu, ProcentProwizji,IdSprzedajacego,Idk);
	END //

DELIMITER ;


-- z IF- obniżka ceny o 100 przy zakupie dla klienta który zakupił więcej niż 3 dzieła lub o 50 dla klienta który zakupił więcej niż 2
DELIMITER //
	CREATE FUNCTION obnizkaceny(ilesprzedano INT) RETURNS INT
	BEGIN
	   DECLARE obnizka INT;
	    IF ilesprzedano > 3 THEN
	    	SET obnizka = 100;
	    ELSEIF ilesprzedano > 2 THEN
	    	SET obnizka = 50;
	    END IF;
	    
	   RETURN obnizka;
	END  //
	
DELIMITER ;

-- WYZWALACZ Wykorzystujący tą funkcję- przy każdym nowym zakupie:
DELIMITER //
 CREATE TRIGGER dodaj_obnizke
 BEFORE INSERT ON sprzedaz
 FOR EACH ROW
 BEGIN
 	DECLARE obnizka INT;
 	SET obnizka = (SELECT obnizkaceny(COUNT(*)) FROM sprzedaz WHERE IdKupujacego = NEW.IdKupujacego);
   IF obnizka IS NULL THEN
      SET obnizka = 0;
   END IF;
	SET NEW.Kwota = NEW.Kwota - obnizka;
 END;
 //
DELIMITER ;


-- WYZWALACZE

-- sprawdza przed sprzedażą czy dzieło już zostało sprzedane
DELIMITER // 

CREATE TRIGGER before_insert_sprzedaz
BEFORE INSERT ON sprzedaz
FOR EACH ROW
BEGIN
    DECLARE dzielo_count INT;
    SET dzielo_count = (SELECT COUNT(*) FROM sprzedaz WHERE IdDziela = NEW.IdDziela);
    IF dzielo_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Dzieło o podanym ID zostało już sprzedane';
    END IF;
END;
//

DELIMITER ;

-- sprawdza czy dzieło można wystawić czy zostało już sprzedane
DELIMITER // 

CREATE TRIGGER before_insert_dzielo_wystawa
BEFORE INSERT ON dzielo_wystawa
FOR EACH ROW
BEGIN
    DECLARE dzielo_count INT;
    SET dzielo_count = (SELECT COUNT(*) FROM sprzedaz WHERE IdDziela = NEW.IdDziela);
    IF dzielo_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Dzieło o podanym ID zostało sprzedane, nie można go wystawić';
    END IF;
END;
//

DELIMITER ;


