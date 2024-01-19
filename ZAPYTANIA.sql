-- Dzieła z jakich kategorii zostały wystawione więcej niż 10 razy
SELECT IdKategorii,Nazwa, COUNT(*) Ile FROM kategorie k, dziela d, dzielo_wystawa dw WHERE k.Id=d.IdKategorii AND d.NrInw=dw.IdDziela 
GROUP BY IdKategorii HAVING COUNT(*)>10 ORDER BY Ile DESC;

-- Pełne zestawienie dat nabycia i sprzedaży każdego dzieła i ile dni spędziło w galerii
SELECT NrInw, Tytul, DataNab, DataSp, IF (DataSp IS NOT NULL, DATEDIFF(DataSp,DataNab),DATEDIFF(CURDATE(),DataNab)) Dni
FROM (SELECT * FROM dziela d, nabycie n WHERE d.NrInw = n.IdDziela) ds LEFT JOIN sprzedaz s ON ds.NrInw= s.IdDziela; 

-- Którzy klienci sprzedawali dzieła sztuki galerii ale sami nie kupili żadnego 
SELECT * FROM kontrahenci WHERE Typ = 'Klient' AND Id NOT IN (SELECT IdKupujacego FROM sprzedaz);

-- Ile galeria zakupiła dzieł w 2019?
SELECT COUNT(*) Ile FROM nabycie n WHERE DataNab LIKE '2019%';

-- Najdroższe dzieło
SELECT NrInw, Tytul, Cena FROM dziela WHERE Cena IN (SELECT MAX(Cena) FROM dziela);

-- Dzieła bez certyfikatów które udało się sprzedać
SELECT NrInw, Tytul FROM dziela d, sprzedaz s WHERE d.NrInw = s.IdDziela AND NOT EXISTS
(SELECT IdDziela FROM certyfikaty c WHERE d.NrInw = IdDziela);

-- Dziela których cenę ustalono na wyższą niż kwotę ich zakupu
SELECT NrInw, Tytul FROM dziela WHERE Cena > ALL (SELECT KwotaZakupu FROM nabycie WHERE NrInw = IdDziela);

-- Dziela sprzedane bez prowizji
SELECT NrInw, Tytul FROM dziela WHERE NrInw = ANY(SELECT IdDziela FROM sprzedaz WHERE Prowizja IS NULL);

-- Zestawienie ilości sprzedanych dzieł przez pracowników podległych każdemu z szefów
SELECT Imie, Nazwisko, ss.Ile 
FROM sprzedawcy, 
(SELECT NrPrzelozonego, COUNT(*) Ile FROM sprzedawcy s, sprzedaz sp WHERE s.NrPracownika = sp.IdSprzedawcy AND s.NrPrzelozonego IS NOT NULL GROUP BY s.NrPrzelozonego) ss
WHERE NrPracownika = ss.NrPrzelozonego ORDER BY ss.Ile DESC; 

-- Najpopularniejsze tagi (dzieła kupione 5)
SELECT Wartosc, COUNT(*) Ile FROM tagi t, sprzedaz s WHERE t.NrInw = s.IdDziela GROUP BY Wartosc HAVING COUNT(*) >=5 ORDER BY Ile DESC;

-- Wykaz łącznych kwot na jakie ubezpieczono dzieła dla każdego ubezpieczyciela
SELECT Id, Imie, Nazwisko, SUM(KwotaUbezp) Kwota FROM ubezpieczenia u, kontrahenci k WHERE u.IdUbezpieczyciela= k.Id GROUP BY Id;

-- Artyści od których nigdy nie kupowano bezpośrednio dzieł
SELECT Id, Imie, Nazwisko FROM kontrahenci WHERE Typ= 'Artysta' AND Id NOT IN (SELECT IdSprzedajacego FROM nabycie);

-- Wystawy posortowane wg średniej wartości dzieł wystawionych na nich
SELECT IdWystawy, w.Tytul, ROUND(AVG(Cena),2) SredniaWartosc FROM dzielo_wystawa dw, dziela d, wystawy w 
WHERE dw.IdDziela = d.NrInw AND dw.IdWystawy = w.Id GROUP BY IdWystawy ORDER BY SredniaWartosc DESC;

-- Najpopularniejsze kategorie w galerii (w galerii było 5 lub więcej dzieł z tej kategorii)
SELECT Id, Nazwa, COUNT(*) Ile FROM kategorie k, dziela d WHERE d.IdKategorii = k.Id GROUP BY Id HAVING Ile >=5;

-- Który klient kupił najwięcej
SELECT k.Id,k.Imie, k.Nazwisko, COUNT(*) Ile FROM kontrahenci k, sprzedaz s WHERE k.Id = s.IdKupujacego GROUP BY k.Id ORDER BY Ile DESC LIMIT 1;

-- Dzieła mające więcej niż jeden certyfikat
SELECT * FROM dziela d WHERE EXISTS (SELECT IdDziela FROM certyfikaty WHERE IdDziela = d.NrInw GROUP BY IdDziela HAVING COUNT(*)>1);

-- Wydatki na zakup dzieł w każdym roku
SELECT SUBSTRING(DataNab, 1, 4) Rok, SUM(KwotaZakupu) Wydatki FROM nabycie GROUP BY Rok;

-- Artyści którzy tworzyli dzieła w więcej niż 5 kategoriach
SELECT Id, Imie, Nazwisko FROM kontrahenci k, dziela d WHERE k.Id = d.IdAutora GROUP BY Id HAVING COUNT(DISTINCT IdKategorii) > 5;

