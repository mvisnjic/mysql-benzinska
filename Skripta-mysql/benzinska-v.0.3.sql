#####-PROJEKT BENZINSKA-POSTAJA-########
#####-Matej-Višnjić-Baze-II-############
#####-Sveučilište Jurja Dobrile Pula-###

DROP DATABASE IF EXISTS benza;
CREATE DATABASE benza;
USE benza;

CREATE TABLE benzinska (
	id INTEGER NOT NULL,
    ime VARCHAR(25),
    broj_telefona VARCHAR(30) NOT NULL,
    adresa VARCHAR(35),
    grad CHAR(25),
    poštanski_broj INTEGER NOT NULL,
    PRIMARY KEY(id)
);

CREATE TABLE voditelj (
	id INTEGER AUTO_INCREMENT NOT NULL UNIQUE,
    sifra_v VARCHAR(11) NOT NULL UNIQUE,
	OIB VARCHAR(11) NOT NULL UNIQUE,
    ime CHAR(30),
    prezime CHAR(30),
	datum_zaposlenja DATETIME DEFAULT NOW(),
    placa INTEGER DEFAULT 6500,
    PRIMARY KEY(id),
    CONSTRAINT CHK_placa_voditelj CHECK (placa >= 6000)
);

CREATE TABLE blagajnik (
	id INTEGER AUTO_INCREMENT NOT NULL UNIQUE,
    sifra_b VARCHAR(11) NOT NULL UNIQUE,
	OIB VARCHAR(11) NOT NULL UNIQUE,
    ime CHAR(30),
    prezime CHAR(30),
	datum_zaposlenja DATETIME DEFAULT NOW(),
    placa INTEGER DEFAULT 4500,
    PRIMARY KEY(id),
    CONSTRAINT CHK_placa_blagajnik CHECK (placa >= 4450)
);

CREATE TABLE artikl (
	id INTEGER NOT NULL UNIQUE,
    vrsta VARCHAR(20),
    naziv VARCHAR(50),
    cijena NUMERIC (10,2) NOT NULL,
    CONSTRAINT CHK_cijena_artikla CHECK (cijena > 0),
    CONSTRAINT CHK_vrsta_artikla CHECK (vrsta = 'GRICKALICE' OR vrsta = 'BEZALKOHOLNO' OR vrsta = 'ALKOHOL' OR vrsta = 'SLATKO' OR vrsta = 'OSTALO' OR vrsta = 'CIGARETE' OR vrsta = 'KAVA'),
    PRIMARY KEY (id)
);

CREATE TABLE gorivo (
	id INTEGER NOT NULL UNIQUE PRIMARY KEY,
    vrsta VARCHAR(20),
    ime VARCHAR(50),
    cijena NUMERIC (10,2) NOT NULL,
    CONSTRAINT CHK_cijena_goriva CHECK (cijena > 0),
    CONSTRAINT CHK_vrsta_goriva CHECK (vrsta = 'BENZIN' OR vrsta = 'DIZEL' OR vrsta = 'PLIN' OR vrsta = 'LOŽ ULJE')
);


CREATE TABLE pumpa (
	id INTEGER NOT NULL UNIQUE PRIMARY KEY,
    CONSTRAINT CHK_id_pumpe CHECK (id>=0)
   
);

CREATE TABLE kupnja (
	id INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
    id_pumpa INTEGER,
    id_proizvod INTEGER,
    kolicina NUMERIC (8,2) NOT NULL,
    CONSTRAINT CHK_kolicina CHECK (kolicina > 0),
    CONSTRAINT CHK_broj_pumpe CHECK (id_pumpa >= 0),
    FOREIGN KEY (id_pumpa) REFERENCES pumpa(id)
);

CREATE TABLE prodani_proizvodi (
	id INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
    id_pumpa INTEGER,
    id_proizvod INTEGER,
    kolicina NUMERIC (8,2) NOT NULL,
    CONSTRAINT CHK_kolicina_prodanih CHECK (kolicina > 0),
    CONSTRAINT CHK_broj_pumpe_2 CHECK (id_pumpa >= 0),
    FOREIGN KEY (id_pumpa) REFERENCES pumpa(id)
);

CREATE TABLE racun (
	id INTEGER NOT NULL UNIQUE AUTO_INCREMENT,
    id_blagajnik INTEGER NOT NULL,
	datum_izdavanja DATETIME DEFAULT NOW(),
    osnovica NUMERIC (8,2),
    PDV NUMERIC(8,2),
    ukupno NUMERIC(8,2),
    FOREIGN KEY (id_blagajnik) REFERENCES blagajnik(id) ON DELETE CASCADE,
    CONSTRAINT CHK_osnovica CHECK (osnovica >= 0),
    CONSTRAINT CHK_PDV CHECK (PDV >= 0),
    CONSTRAINT CHK_ukupno CHECK (ukupno >= 0)
);

######################-INSERTI-##############################

INSERT INTO benzinska VALUES (1, 'IstraBenz', '052/000-111', 'Rovinjska 14', 'Pula' , 52220);

INSERT INTO voditelj VALUES (1, '12345', '12345678910', 'Marko', 'Marić', STR_TO_DATE('1.2.2021', '%d.%m.%Y'), 6700);



INSERT INTO blagajnik VALUES 	(NULL, '11', '12345432110', 'Boris', 'Mileta', STR_TO_DATE('2.2.2021', '%d.%m.%Y'), 4550),
								(NULL, '22', '58490584322', 'Darko', 'Filipović', STR_TO_DATE('2.2.2021', '%d.%m.%Y'), 4550),
                                (NULL, '33', '94384938938', 'Dario', 'Marković', NOW(), DEFAULT);
					
INSERT INTO pumpa VALUES 	(0), #služi kada nešto se proda, a nije natankao gorivo. 
							(1),
                            (2),
                            (3),
                            (4),
                            (5),
                            (6);

 ####-TRIGGER AKO UPIŠEŠ VRSTU ARTIKLA MALIM SLOVIMA DA PREBACI U VELIKA-####
DELIMITER //
CREATE TRIGGER bi_artikl
BEFORE INSERT ON artikl
FOR EACH ROW
BEGIN 
IF NEW.vrsta = LOWER(NEW.vrsta) THEN
SET NEW.vrsta = UPPER(NEW.vrsta);
END IF;
END//
DELIMITER ;


INSERT INTO artikl VALUES 	(1, 'KAVA' , 'Veliki Machiatto/capucccino', 10.00),
							(2, 'KAVA' , 'Mali Machiatto/capuccino', 8.00),
                            (3, 'KAVA' , 'Kakao', 11.00),
                            (4, 'KAVA' , 'Bijela Kava', 14.00),
                            (5, 'KAVA' , 'Espresso', 7.00),
                            (6, 'GRICKALICE' , 'Čips', 17.99),
                            (7, 'GRICKALICE' , 'Kroki', 14.99),
                            (8, 'GRICKALICE' , 'Štapići', 12.99),
                            (9, 'GRICKALICE' , 'Ribice', 7.99),
                            (10, 'GRICKALICE' , 'Indijski orah', 24.99),
                            (20, 'BEZALKOHOLNO' , 'Prirodna Voda 0.5', 9.99),
                            (22, 'BEZALKOHOLNO' , 'Voda sa okusom limuna', 14.99),
                            (23, 'BEZALKOHOLNO' , 'Coca-Cola 2L', 18.99),
                            (24, 'BEZALKOHOLNO' , 'Fanta 2L', 16.99),
                            (25, 'BEZALKOHOLNO' , 'Sprite 2L', 14.99),
                            (26, 'BEZALKOHOLNO' , 'Pašareta', 13.99),
                            (27, 'BEZALKOHOLNO' , 'Gusti sok', 13.59),
                            (28, 'BEZALKOHOLNO' , 'Voda sa okusom limuna', 14.99),
                            (29, 'ALKOHOL' , 'Vodka 0.75', 72.99),
                            (30, 'ALKOHOL' , 'Badel 0.75', 80.99),
                            (31, 'ALKOHOL' , 'Badel 0.75', 80.99),
                            (32, 'ALKOHOL' , 'JackDaniels 0.75', 223.79),
                            (33, 'ALKOHOL' , 'Johnie Walker 0.75', 195.99),
                            (34, 'ALKOHOL' , 'Vino Plavac', 65.99),
                            (35, 'ALKOHOL' , 'Pivo limenka 0.5', 17.99),
                            (36, 'ALKOHOL' , 'Pivo radler 0.5', 16.99),
                            (37, 'ALKOHOL' , 'Vino Ribar', 27.49),
                            (38, 'ALKOHOL' , 'Pjenušac 0.75', 112.99),
                            (40, 'SLATKO' , 'Milka Čokolada', 11.99),
                            (41, 'SLATKO' , 'Čokoladni krugovi', 8.99),
                            (42, 'SLATKO' , 'Snikers', 8.99),
                            (43, 'SLATKO' , 'Mars', 7.99),
                            (44, 'SLATKO' , 'Kinder jaje', 12.99),
                            (45, 'SLATKO' , 'Ferrero Rocher', 17.99),
                            (46, 'SLATKO' , 'Raffaello', 21.99),
                            (47, 'SLATKO' , 'Kinder bueno', 25.99),
                            (48, 'SLATKO' , 'Bananko', 4.99),
                            (50, 'CIGARETE' , 'Marlboro', 32.00),
                            (51, 'CIGARETE' , 'LuckyStrike', 30.00),
                            (52, 'CIGARETE' , 'Chesterfield', 27.00),
                            (53, 'CIGARETE' , 'Pall mall', 26.00),
                            (54, 'CIGARETE' , 'York', 25.00),
                            (55, 'CIGARETE' , 'Dunhill', 33.00),
                            (60, 'OSTALO' , 'Vrećica leda 5kg', 34.99),
                            (61, 'OSTALO' , 'Ulje motorno 5w30 1L', 76.99),
                            (62, 'OSTALO' , 'Ulje za pilu 0.2', 61.99),
                            (63, 'OSTALO' , 'Univerzalni osigurači', 40.99),
                            (64, 'OSTALO' , 'Toalet papir', 27.99),
                            (65, 'OSTALO' , 'Tuna u konzervi', 19.99),
                            (66, 'OSTALO' , 'Tost sendvič', 23.99),
                            (67, 'OSTALO' , 'Prašak za pranje rublja', 35.99);

####-TRIGGER AKO UPIŠEŠ VRSTU GORIVA MALIM SLOVIMA DA PREBACI U VELIKA-####
DELIMITER //
CREATE TRIGGER bi_gorivo
BEFORE INSERT ON gorivo
FOR EACH ROW
BEGIN 
IF NEW.vrsta = LOWER(NEW.vrsta) THEN
SET NEW.vrsta = UPPER(NEW.vrsta);
END IF;
END//
DELIMITER ;

INSERT INTO gorivo VALUES 	(100, 'BENZIN', 'Eurosuper 90s', 10.34),
							(101, 'BENZIN', 'Eurosuper 95s', 10.74),
                            (102, 'BENZIN', 'Eurosuper 100s', 11.32),
                            (105, 'DIZEL', 'Eurodiesel ', 9.28),
                            (106, 'DIZEL', 'Eurodiesel + ', 9.88),
                            (107, 'DIZEL', 'Eurodiesel kamioni', 8.28),
                            (108, 'DIZEL', 'Eurodiesel plavi ', 4.58),
							(110, 'PLIN', 'Boca plina', 102.00),
                            (111, 'PLIN', 'Autoplin LPG', 4.70),
                            (120, 'lož ulje', 'Lož ulje', 4.40);
                            
#### -VIEW ZA SVE PRIKAZATI SVE ARTIKLE+GORIVO- ####
CREATE VIEW proizvodi AS 
SELECT * from artikl
UNION
SELECT * FROM gorivo;

####- VIEW ZA PRIKAZATI SVE ZAPOSLENIKE, BEZ OIBA I PLACE
CREATE VIEW zaposlenici AS 
SELECT id,ime,prezime,datum_zaposlenja FROM voditelj v
UNION
SELECT id,ime,prezime,datum_zaposlenja FROM blagajnik;

##-VIEWI ZA PRIKAZATI VRSTE GORIVA-##
CREATE VIEW dizel AS 
SELECT * FROM gorivo
WHERE vrsta = 'dizel';

CREATE VIEW benzin AS 
SELECT * FROM gorivo
WHERE vrsta = 'benzin';

CREATE VIEW loz_ulje AS 
SELECT * FROM gorivo
WHERE vrsta = 'lož ulje';

CREATE VIEW plin AS 
SELECT * FROM gorivo
WHERE vrsta = 'plin';

##-VIEWI ZA PRIKAZATI VRSTE ARTIKALA-##

CREATE VIEW kava AS
SELECT * FROM artikl
WHERE vrsta = 'kava';

CREATE VIEW grickalice AS
SELECT * FROM artikl
WHERE vrsta = 'grickalice';

CREATE VIEW bezalkoholno AS
SELECT * FROM artikl
WHERE vrsta = 'bezalkoholno';

CREATE VIEW alkohol AS
SELECT * FROM artikl
WHERE vrsta = 'alkohol';

CREATE VIEW slatko AS
SELECT * FROM artikl
WHERE vrsta = 'slatko';

CREATE VIEW cigarete AS
SELECT * FROM artikl
WHERE vrsta = 'cigarete';

CREATE VIEW ostalo AS
SELECT * FROM artikl
WHERE vrsta = 'ostalo';

#### -FUNCKIJA ZA ISPIS UKUPNOG BROJA PROIZVODA NA BENZINSKOJ- ####
DELIMITER //
CREATE FUNCTION ukupan_broj_proizvoda() RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
DECLARE broj INTEGER;

SELECT COUNT(*) INTO broj 
FROM proizvodi;

RETURN broj;
END//
DELIMITER ;

SELECT ukupan_broj_proizvoda();

#### -FUNCKIJA KOJA PROSJEK CIJENE GORIVA OVISNO O VRSTI KOJU UPIŠEMO- ####
DELIMITER //
CREATE FUNCTION prosjecna_cijena_goriva(p_vrsta VARCHAR(20)) RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
DECLARE prosjek NUMERIC(6,3);
 
SELECT AVG(cijena) INTO prosjek
FROM gorivo
WHERE vrsta = p_vrsta;

IF prosjek IS NULL THEN
RETURN CONCAT ('Ne postoji ta vrsta!');
ELSE
RETURN prosjek;
END IF;


END//
DELIMITER ;

SELECT prosjecna_cijena_goriva('LOŽ ulje');

DELIMITER //

###-PROCEDURA ZA UVEĆATI/UMANJITI CIJENE GORIVA (prema vrsti)-###
CREATE PROCEDURE cijena_goriva(p_cijene VARCHAR(6), p_vrsta VARCHAR(20), p_iznos NUMERIC(5,2))
BEGIN 

SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
START TRANSACTION;

IF p_cijene != 'uvecaj' AND p_cijene != 'umanji'
THEN ROLLBACK;
SELECT CONCAT('Moraš koristiti ključnu riječ: uvecaj ili umanji!') AS GREŠKA;
ELSEIF p_vrsta NOT IN (SELECT vrsta FROM gorivo)
THEN ROLLBACK;
SELECT CONCAT('Nepoznata vrsta goriva!') AS GREŠKA;
ELSEIF p_iznos < 0
THEN ROLLBACK;
SELECT CONCAT('Iznos je manji od nule!') AS GREŠKA;

ELSEIF p_cijene = 'uvecaj' THEN
UPDATE gorivo 
SET cijena = cijena + p_iznos
WHERE vrsta = p_vrsta;
SELECT CONCAT ('Vrsta: ', p_vrsta, ' je uvećana za ', p_iznos, ' kn') AS USPJEŠNO;
COMMIT;

ELSEIF p_cijene = 'umanji' THEN
UPDATE gorivo 
SET cijena = cijena - p_iznos
WHERE vrsta = p_vrsta;
SELECT CONCAT ('Vrsta: ', p_vrsta, ' je umanjena za ', p_iznos, ' kn') AS USPJEŠNO;
COMMIT;
END IF;



END//
DELIMITER ;
				#uvecaj/umanji, vrsta_gorivo, iznos
CALL cijena_goriva ('uvecaj', 'benzin', 3.36);
CALL cijena_goriva ('umanji', 'benzin', 3.36);

DELIMITER //

##-PROCEDURA ZA UVECATI/UMANJITI CIJENE ARTIKLA PREMA IMENU--##
CREATE PROCEDURE cijena_artikla(p_cijene VARCHAR(6), p_naziv_artikla VARCHAR(50), p_iznos NUMERIC(5,2))
BEGIN 

SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
START TRANSACTION;

IF p_cijene != 'uvecaj' AND p_cijene != 'umanji'
THEN ROLLBACK;
SELECT CONCAT('Moraš koristiti ključnu riječ: uvecaj ili umanji!') AS GREŠKA;
ELSEIF p_naziv_artikla NOT IN (SELECT naziv FROM artikl)
THEN ROLLBACK;
SELECT CONCAT('Nepoznat naziv artikla!') AS GREŠKA;
ELSEIF p_iznos < 0
THEN ROLLBACK;
SELECT CONCAT('Iznos je manji od nule!') AS GREŠKA;

ELSEIF p_cijene = 'uvecaj' THEN
UPDATE artikl 
SET cijena = cijena + p_iznos
WHERE naziv = p_naziv_artikla;
SELECT CONCAT ('Artikl: ', p_naziv_artikla, ' je uvećan za ', p_iznos, ' kn') AS USPJEŠNO;
COMMIT;

ELSEIF p_cijene = 'umanji' THEN
UPDATE artikl 
SET cijena = cijena - p_iznos
WHERE naziv = p_naziv_artikla;
SELECT CONCAT ('Artikl: ', p_naziv_artikla, ' je umanjen za ', p_iznos, ' kn') AS USPJEŠNO;
COMMIT;
END IF;


END//
DELIMITER ;
				#uvecaj/umanji, naziv artikla, iznos
CALL cijena_artikla('uvecaj', 'espresso', 3.5);

# -PROCEDURA ZA OBAVITI KUPNJU-#
DELIMITER //
CREATE PROCEDURE kupi (p_id_pumpa INTEGER, p_id_proizvod INTEGER, p_kolicina NUMERIC(6,2))
BEGIN 

DECLARE EXIT HANDLER FOR SQLEXCEPTION 
BEGIN
SELECT CONCAT('Došlo je do greške!') AS GREŠKA;
ROLLBACK;
END;
DECLARE utijeku INTEGER;
SELECT id_pumpa INTO utijeku FROM kupnja
WHERE id_pumpa!=p_id_pumpa
LIMIT 1;


SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
START TRANSACTION;

INSERT INTO kupnja VALUES (NULL, p_id_pumpa, p_id_proizvod, p_kolicina);



IF p_id_pumpa NOT IN (SELECT id FROM pumpa) THEN
ROLLBACK;
SELECT CONCAT('Krivi ID pumpe!') AS GREŠKA;
ELSEIF utijeku != p_id_pumpa THEN
ROLLBACK;
SELECT concat('Kupnja u tijeku! Isprintajte račun ili obrišite narudžbu!') AS GREŠKA;
ELSEIF p_kolicina < 0 THEN
ROLLBACK;
SELECT CONCAT('Količina ne smije biti manja od 0!') AS GREŠKA;
ELSEIF p_id_proizvod NOT IN (SELECT id FROM proizvodi) THEN
ROLLBACK;
SELECT CONCAT('Krivi ID proizvoda!') AS GREŠKA;
ELSE SELECT CONCAT('Uspješna narudžba!') AS USPJEŠNO;
COMMIT;
END IF;



END//
DELIMITER ;
	#id_pumpa, id_proizvod, kolicina
CALL kupi (1, 50, 10);

##- PROCEDURA ZA PREGLED STAVKI NA RACUNU-##
DELIMITER //
CREATE PROCEDURE pregled_stavki (p_id_pumpa INTEGER) 
BEGIN 

SELECT id_pumpa,p.id AS sifra_artikla,naziv,kolicina,cijena,SUM(cijena*kolicina) AS iznos FROM proizvodi p
INNER JOIN kupnja k ON k.id_proizvod=p.id
WHERE id_pumpa = p_id_pumpa
GROUP BY k.id;


END//
DELIMITER ;
				#broj_pumpe	
CALL pregled_stavki (1);

## -PROCEDURA ZA BRISANJE PROIZVODA SA TREUNTNE KUPNJE- ##
DELIMITER //
CREATE PROCEDURE brisanje_stavki_kupnje (p_id_proizvod INTEGER) 
BEGIN 

SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
START TRANSACTION;
IF p_id_proizvod NOT IN (SELECT id_proizvod FROM kupnja)
THEN ROLLBACK;
SELECT CONCAT('Ne postoji taj ID proizvoda!') AS GREŠKA;
ELSE 
DELETE FROM kupnja
WHERE id_proizvod=p_id_proizvod;
COMMIT;
END IF;

END//
DELIMITER ;

 					    #id_proizvoda
CALL brisanje_stavki_kupnje (44);

## -PROCEDURA ZA DODAVANJE/MICANJE KOLICINE PROIZVODA SA TRENUTNE KUPNJE- ##
DELIMITER //
CREATE PROCEDURE brisanje_kolicine_stavki (p_id_proizvod INTEGER, p_kol NUMERIC(8,2), p VARCHAR(4)) 
BEGIN 



SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
START TRANSACTION;
IF p_id_proizvod NOT IN (SELECT id_proizvod FROM kupnja)
THEN ROLLBACK;
SELECT CONCAT('Ne postoji taj ID proizvoda!') AS GREŠKA;
ELSEIF p = 'dodaj' THEN
UPDATE kupnja
SET kolicina = kolicina+p_kol
WHERE id_proizvod=p_id_proizvod;
COMMIT;
ELSEIF p = 'oduzmi' THEN
UPDATE kupnja
SET kolicina = kolicina-p_kol
WHERE id_proizvod=p_id_proizvod;
COMMIT;
END IF;

END//
DELIMITER ;
					#id_proizvod,kolicina, dodaj/oduzmi
CALL brisanje_kolicine_stavki (100, 46, 'oduzmi');

DELIMITER //
CREATE FUNCTION ukupan_iznos (p_id_pumpa INTEGER) RETURNS NUMERIC(8,2) 
DETERMINISTIC
BEGIN 
DECLARE ukupan_iznos NUMERIC (8,2);
SELECT SUM(cijena*kolicina) INTO ukupan_iznos FROM kupnja k
INNER JOIN proizvodi p ON k.id_proizvod = p.id
WHERE id_pumpa = p_id_pumpa;

RETURN ukupan_iznos;
END//
DELIMITER ;

SELECT ukupan_iznos(2) AS ukupno_sa_pdv;

DELIMITER //
CREATE PROCEDURE ispis_racuna (p_id_blagajnik INTEGER, p_id_pumpa INTEGER) 
BEGIN 

DECLARE ukupno NUMERIC (8,2);
DECLARE pdv NUMERIC(8,2);
DECLARE osnovica NUMERIC(8,2);
DECLARE kol NUMERIC(8,2);
DECLARE p_id_proizvod INT;
DECLARE EXIT HANDLER FOR SQLEXCEPTION 
BEGIN
SELECT CONCAT('Došlo je do greške,pokušajte ponovno!') AS GREŠKA;
ROLLBACK;
END;

SELECT ukupan_iznos(p_id_pumpa) INTO ukupno;

SELECT ukupno*0.25 INTO pdv;

SELECT ukupno-pdv INTO osnovica;

SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
START TRANSACTION;


INSERT INTO racun VALUES (NULL, p_id_blagajnik, NOW(), osnovica, pdv, ukupno);


IF p_id_pumpa NOT IN (SELECT id_pumpa FROM kupnja) THEN
ROLLBACK;
SELECT CONCAT('Nema stavki!') AS GREŠKA;
ELSE 
INSERT INTO prodani_proizvodi (id_pumpa,id_proizvod,kolicina)(SELECT id_pumpa,id_proizvod,kolicina INTO kol FROM kupnja);
TRUNCATE kupnja;
COMMIT;
END IF;

END//
DELIMITER ;
		#id_blagajnik, id_pumpa
CALL ispis_racuna(1,2);

#--FUNKCIJA ZA VIDJETI KOLIKO JE LITARA ODREĐENE VRSTE GORIVA PRODANO!--#
DELIMITER //
CREATE FUNCTION kolicina_prodanog_goriva (p_id_gorivo INTEGER) RETURNS NUMERIC(10,2)
DETERMINISTIC
BEGIN
DECLARE br NUMERIC(10,2);
 
SELECT SUM(kolicina) INTO br FROM prodani_proizvodi pp 
INNER JOIN gorivo g ON pp.id_proizvod = g.id
WHERE g.id = p_id_gorivo;


IF p_id_gorivo NOT IN (SELECT id FROM gorivo)THEN
RETURN NULL;
ELSE
RETURN br;
END IF;

END//
DELIMITER ;
							 #id goriva
SELECT kolicina_prodanog_goriva (100);

#--FUNKCIJA ZA VIDJETI KOLIKO JE ARTIKALA PRODANO!--#
DELIMITER //
CREATE FUNCTION kolicina_prodanog_artikl (p_id_artikl INTEGER) RETURNS NUMERIC(10,2)
DETERMINISTIC
BEGIN
DECLARE br NUMERIC(10,2);
 
SELECT SUM(kolicina) INTO br FROM prodani_proizvodi pp 
INNER JOIN artikl a ON pp.id_proizvod = a.id
WHERE a.id = p_id_artikl;


IF p_id_artikl NOT IN (SELECT id FROM artikl)THEN
RETURN NULL;
ELSE
RETURN br;
END IF;

END//
DELIMITER ;
	     				   #id artikla
SELECT kolicina_prodanog_artikl(50);


#--PROCEDURA ZA DODAVANJE NOVOG BLAGAJNIKA--#
DELIMITER //
CREATE PROCEDURE dodaj_blagajnika (p_sifra VARCHAR(11), p_OIB VARCHAR(11), p_ime CHAR(30), p_prezime CHAR(30), p_placa INTEGER) 
BEGIN 


SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
START TRANSACTION;
INSERT INTO blagajnik VALUES (NULL, p_sifra, p_OIB, p_ime, p_prezime, NOW(), p_placa);
SELECT CONCAT ('Uspjesno dodan zaposlenik!') AS USPJEŠNO;
COMMIT;

END//
DELIMITER ;

CALL dodaj_blagajnika (44, '56437483921', 'Test', 'Test', 6540);

#--PROCEDURA ZA UKLANJANJE BLAGAJNIKA--#
DELIMITER //
CREATE PROCEDURE dodaj_blagajnika (p_id INTEGER, p_sifra VARCHAR(11), p_OIB VARCHAR(11), p_ime CHAR(30), p_prezime CHAR(30), p_placa INTEGER) 
BEGIN 


SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
START TRANSACTION;
INSERT INTO blagajnik VALUES (p_id, p_sifra, p_OIB, p_ime, p_prezime, NOW(), p_placa);
SELECT CONCAT ('Uspjesno dodan zaposlenik!') AS USPJEŠNO;
COMMIT;

END//
DELIMITER ;

DELIMITER //
CREATE FUNCTION ukupno_racuna () RETURNS INTEGER
DETERMINISTIC
BEGIN
declare br INTEGER;
 
SELECT COUNT(id) INTO br FROM racun;

RETURN br;

END//
DELIMITER ;

SELECT ukupno_racuna() AS broj_izdanih_racuna;


DELIMITER //
CREATE PROCEDURE pregled_istipkanih_racuna () 
BEGIN 

SELECT r.id AS racun_broj, r.id_blagajnik, b.ime,b.prezime,r.datum_izdavanja,r.osnovica,r.PDV,r.ukupno
FROM racun r 
INNER JOIN blagajnik b ON r.id_blagajnik = b.id;

END//
DELIMITER ;

DELIMITER //

CREATE PROCEDURE pregled_istipkanih_racuna_blagajnika (p_id_blagajnik INTEGER) 
BEGIN 

SELECT r.id AS racun_broj, r.id_blagajnik, b.ime,b.prezime,r.datum_izdavanja,r.osnovica,r.PDV,r.ukupno 
FROM racun r 
INNER JOIN blagajnik b ON r.id_blagajnik = b.id
WHERE b.id=p_id_blagajnik;

END//
DELIMITER ;
									#id_blagajnik
CALL pregled_istipkanih_racuna_blagajnika(1);

DELIMITER //
CREATE PROCEDURE dodaj_artikl (p_id INTEGER, p_vrsta VARCHAR(20), p_naziv VARCHAR(50), p_cijena NUMERIC(10,2)) 
BEGIN 

SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
START TRANSACTION;
INSERT INTO artikl VALUES (p_id,p_vrsta, p_naziv, p_cijena);
SELECT CONCAT ('Uspjesno dodan artikl!') AS USPJEŠNO;
COMMIT;

END//
DELIMITER ;

CALL dodaj_artikl(69, 'ostalo', 'test', 50.45);

DELIMITER //
CREATE PROCEDURE dodaj_gorivo (p_id INTEGER, p_vrsta VARCHAR(20), p_naziv VARCHAR(50), p_cijena NUMERIC(10,2)) 
BEGIN 

SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
START TRANSACTION;
INSERT INTO gorivo VALUES (p_id,p_vrsta, p_naziv, p_cijena);
SELECT CONCAT ('Uspjesno dodan artikl!') AS USPJEŠNO;
COMMIT;

END//
DELIMITER ;

CALL dodaj_gorivo(104, 'benzin', 'eurosuper 200', 11.44);

DELIMITER //
CREATE PROCEDURE brisanje_blagajnika (p_id INTEGER) 
BEGIN 
DECLARE v_ime CHAR(30);
DECLARE v_prezime CHAR(30);

SELECT ime INTO v_ime FROM blagajnik
WHERE id = p_id;
SELECT prezime INTO v_prezime FROM blagajnik
WHERE id = p_id;
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
START TRANSACTION;
IF p_id NOT IN (SELECT id FROM blagajnik)
THEN ROLLBACK;
SELECT CONCAT('Ne postoji taj zaposlenik!') AS GREŠKA;
ELSE 
SELECT CONCAT ('Zaposlenik ',v_ime, ' ',v_prezime,' ID: ', p_id, ' je uspješno obrisan') AS USPJEŠNO;
DELETE FROM blagajnik
WHERE id=p_id;
COMMIT;
END IF;

END//
DELIMITER ;

CALL brisanje_blagajnika(13);

DELIMITER //

#-PROCEDURA ZA BRISANJE ARTIKLA/GORIVA PREKO IMENA
CREATE PROCEDURE brisanje_proizvoda (p_naziv VARCHAR(50))  
BEGIN 
DECLARE p_id INTEGER;


SELECT id INTO p_id FROM proizvodi  
where naziv=p_naziv;

SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
START TRANSACTION;
IF p_naziv NOT IN (SELECT naziv FROM proizvodi)
THEN ROLLBACK;
SELECT CONCAT('Ne postoji taj proizvod!') AS GREŠKA;
ELSEIF p_id IN (SELECT id FROM artikl) THEN
SELECT CONCAT ('Proizvod ID: ',p_id,' Naziv: ',p_naziv,' je uspješno obrisan') AS USPJEŠNO;
DELETE FROM artikl
WHERE id=p_id;
COMMIT;
ELSE 
SELECT CONCAT ('Proizvod ID: ',p_id,' Naziv: ',p_naziv,' je uspješno obrisan') AS USPJEŠNO;
DELETE FROM gorivo
WHERE id=p_id;
COMMIT;
END IF;

END//
DELIMITER ;
CALL brisanje_proizvoda('boca plina');


######-SVE FUNKCIJE I PROCEDURE-######

#funckija za vidjeti kolicinu prodanog artikla
							#id_artikl
SELECT kolicina_prodanog_artikl(50);

#funkcija za ukupan iznos racuna 
				#id_pumpa
SELECT ukupan_iznos(1) AS ukupno_sa_pdv;

#funkcija za vidjeti kolicinu prodanog goriva
							  #id_goriva
SELECT kolicina_prodanog_goriva (100);

#funkcija za izracunati prosjecnu cijenu goriva
							  #vrsta goriva
SELECT prosjecna_cijena_goriva('LOŽ ulje');

#funkcija koja zbraja sve proizvode koje imaju na benzinskoj
SELECT ukupan_broj_proizvoda();

#funkcija koja vraća ukupan broj istipkanih racuna
SELECT ukupno_racuna() AS broj_izdanih_racuna;



#### --OBAVLJANJE KUPNJE -- ####
#procedura za obavljati kupnju(blagajnik prodaje kupcu)
#id_blagajnika, id_proizvoda, kolicina
CALL kupi (1, 50, 10);

#procedura za pregled stavki u trenutnoj kupnji			
				#id_pumpa
CALL pregled_stavki (1);

#procedura za brisanje kolicine proizvoda u trenutnoj kupnji
							#id_proizvoda, kolicina, oduzimi/dodaj
CALL brisanje_kolicine_stavki (100, 46, 'oduzmi');

#procedura za brisanje proizvoda sa kupnje
					#id_proizvoda
CALL brisanje_stavki_kupnje (44);
#procedura za ispisati racun
		#id_blagajnik, id_pumpa
CALL ispis_racuna(1,1);


##### -- MIJENJANJE CIJENE GORIVA ILI ARTIKALA -- #####
#procedura za uvecati/umanjiti cijene goriva
				#uvecaj/umanji, vrsta, iznos za koliko se uveca/umanji
CALL cijena_goriva ('uvecaj', 'benzin', 3.36);

#procedura za uvecati/umanjiti cijene artikla
				#uvecaj/umanji, naziv artikla, iznos
CALL cijena_artikla('uvecaj', 'espresso', 3.5);


#### -- 'STATISTIKA' -- ####
#procedura za pregled svih istipkanih racuna(sa imenima i prezimenima blagajnika)
CALL pregled_istipkanih_racuna;

#procedura za pregled istipkanih racuna za odredenog blagajnika
									#id_blagajnik
CALL pregled_istipkanih_racuna_blagajnika(1);


#### -- 'POSTAVKE' -- ####
#procedura za dodavati blagajnika 
					  #sifra     oib       ime    prezime  placa
CALL dodaj_blagajnika (44, '56437483921', 'Zoran', 'Tratin', 6540);

#procedura za dodavati nove artikle
				#id    vrsta    naziv   cijena
CALL dodaj_artikl(69, 'ostalo', 'test', 50.45);

#procedura za dodavati novo gorivo
				#  id   vrsta        naziv        cijena
CALL dodaj_gorivo(104, 'benzin', 'eurosuper 200', 11.44);

#procedura za brisanje blagajnika
						#id
CALL brisanje_blagajnika(13);

#procedura za brisanje proizvoda preko naziva
						#   naziv
CALL brisanje_proizvoda('boca plina');