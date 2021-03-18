#####-PROJEKT BENZINSKA-POSTAJA-########
DROP DATABASE IF EXISTS benza;
CREATE DATABASE benza;
USE benza;

CREATE TABLE info (
	id INTEGER NOT NULL,
    ime VARCHAR(25),
    broj_telefona VARCHAR(30) NOT NULL,
    adresa VARCHAR(35),
    grad CHAR(25),
    poštanski_broj INTEGER NOT NULL,
    PRIMARY KEY(id)
);

CREATE TABLE voditelj (
	id INTEGER NOT NULL UNIQUE,
    sifra_m VARCHAR(11) NOT NULL UNIQUE,
	OIB VARCHAR(11) NOT NULL UNIQUE,
    ime CHAR(30),
    prezime CHAR(30),
	datum_zaposlenja DATETIME DEFAULT NOW(),
    placa INTEGER DEFAULT 6500,
    PRIMARY KEY(id),
    CONSTRAINT CHK_placa_voditelj CHECK (placa >= 6000)
);

CREATE TABLE blagajnik (
	id INTEGER NOT NULL UNIQUE,
    sifra_t VARCHAR(11) NOT NULL UNIQUE,
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
    CONSTRAINT CHK_vrsta_artikla CHECK (vrsta = 'GRICKALICE' OR vrsta = 'PIĆA' OR vrsta = 'ALKOHOL' OR vrsta = 'SLATKO' OR vrsta = 'OSTALO' OR vrsta = 'CIGARETE' OR vrsta = 'KAVA'),
    PRIMARY KEY (id)
);

CREATE TABLE gorivo (
	id INTEGER NOT NULL UNIQUE PRIMARY KEY,
    vrsta VARCHAR(20),
    ime VARCHAR(50),
    cijena NUMERIC (10,2) NOT NULL,
    preostalo_litara NUMERIC(10,2),
    CONSTRAINT CHK_cijena_goriva CHECK (cijena > 0),
    CONSTRAINT CHK_vrsta_goriva CHECK (vrsta = 'BENZIN' OR vrsta = 'DIZEL' OR vrsta = 'PLIN' OR vrsta = 'LOŽ ULJE'),
	CONSTRAINT CHK_preostalo_litara CHECK (preostalo_litara>=0)
);
drop table gorivo;

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
    FOREIGN KEY (id_blagajnik) REFERENCES blagajnik(id),
    CONSTRAINT CHK_osnovica CHECK (osnovica >= 0),
    CONSTRAINT CHK_PDV CHECK (PDV >= 0),
    CONSTRAINT CHK_ukupno CHECK (ukupno >= 0)
);

######################-INSERTI-##############################

INSERT INTO info VALUES (1, 'CRObenz', '052/000-111', 'Rovinjska 14', 'Pula' , 52220);


INSERT INTO voditelj VALUES (1, '12345', '12345678910', 'Marko', 'Marić', STR_TO_DATE('1.2.2021', '%d.%m.%Y'), 6700);



INSERT INTO blagajnik VALUES 	(10, '11', '12345432110', 'Boris', 'Mileta', STR_TO_DATE('2.2.2021', '%d.%m.%Y'), 4550),
								(11, '22', '58490584322', 'Darko', 'Filipović', STR_TO_DATE('2.2.2021', '%d.%m.%Y'), 4550),
                                (12s, '33', '94384938938', 'Dario', 'Marković', NOW(), DEFAULT);
					
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


 # (vrsta = 'GRICKALICE' OR vrsta = 'PIĆA' OR vrsta = 'ALKOHOL' OR vrsta = 'SLATKO' OR vrsta = 'OSTALO' OR vrsta = 'CIGARETE'),
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
                            (20, 'PIĆA' , 'Prirodna Voda 0.5', 9.99),
                            (22, 'PIĆA' , 'Voda sa okusom limuna', 14.99),
                            (23, 'PIĆA' , 'Coca-Cola 2L', 18.99),
                            (24, 'PIĆA' , 'Fanta 2L', 16.99),
                            (25, 'PIĆA' , 'Sprite 2L', 14.99),
                            (26, 'PIĆA' , 'Pašareta', 13.99),
                            (27, 'PIĆA' , 'Gusti sok', 13.59),
                            (28, 'PIĆA' , 'Voda sa okusom limuna', 14.99),
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

INSERT INTO gorivo VALUES 	(100, 'BENZIN', 'Eurosuper 90s', 10.34, 20000),
							(101, 'BENZIN', 'Eurosuper 95s', 10.74, 19000),
                            (102, 'BENZIN', 'Eurosuper 100s', 11.32, 15000),
                            (105, 'DIZEL', 'Eurodiesel ', 9.28, 25000),
                            (106, 'DIZEL', 'Eurodiesel + ', 9.88, 15000),
                            (107, 'DIZEL', 'Eurodiesel kamioni', 8.28, 50000),
                            (108, 'DIZEL', 'Eurodiesel plavi ', 4.58, 12000),
							(110, 'PLIN', 'Boca plina', 102.00, 15),
                            (111, 'PLIN', 'Autoplin LPG', 4.70, 30000),
                            (120, 'lož ulje', 'Lož ulje', 4.40, 14000);
                            
#### -VIEW ZA SVE PRIKAZATI SVE ARTIKLE+GORIVO- ####
CREATE VIEW proizvodi AS 
SELECT * from artikl
UNION
SELECT id,vrsta,ime,cijena FROM gorivo;

SELECT * from proizvodi;


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

ELSEIF p_cijene = 'umanji' THEN
UPDATE gorivo 
SET cijena = cijena - p_iznos
WHERE vrsta = p_vrsta;
SELECT CONCAT ('Vrsta: ', p_vrsta, ' je umanjena za ', p_iznos, ' kn') AS USPJEŠNO;
END IF;

COMMIT;

END//
DELIMITER ;
#				uvecaj/umanji, vrsta_gorivo, iznos
CALL cijena_goriva ('uvecaj', 'benzin', 3.36);
CALL cijena_goriva ('umanji', 'benzin', 3.36);


# -PROCEDURA ZA OBAVITI KUPNJU-#
DELIMITER //
CREATE PROCEDURE kupi (p_id_pumpa INTEGER, p_id_proizvod INTEGER, p_kolicina NUMERIC(6,2))
BEGIN 

/*DECLARE EXIT HANDLER FOR SQLEXCEPTION 
BEGIN
SELECT CONCAT('Došlo je do greške!') AS GREŠKA;
ROLLBACK;
END;*/
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

DROP PROCEDURE kupi;

select * from kupnja;
CALL kupi (1, 50, 2);
select *,count(id_pumpa) from kupnja
group by id_pumpa;
select id_pumpa from kupnja
where id_pumpa != 0;
truncate kupnja;
select * from kupnja;
##- PROCEDURA ZA PREGLED STAVKI NA RACUNU-##
DELIMITER //
CREATE PROCEDURE pregled_stavki (p_id_pumpa INTEGER) 
BEGIN 

SELECT k.id AS id_stavke,id_pumpa,p.id AS sifra_artikla,vrsta,naziv,cijena,kolicina,SUM(cijena*kolicina) AS iznos FROM proizvodi p
INNER JOIN kupnja k ON k.id_proizvod=p.id
WHERE id_pumpa = p_id_pumpa
GROUP BY k.id;


END//
DELIMITER ;
#				broj_pumpe	
CALL pregled_stavki (1);

## -PROCEDURA ZA BRISANJE STAVKI- ##
DELIMITER //
CREATE PROCEDURE brisanje_stavki (p_id_stavka INTEGER) 
BEGIN 
DECLARE v_id_proizvod INTEGER;

SELECT id_proizvod INTO v_id_proizvod FROM kupnja
WHERE id = p_id_stavka;
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
START TRANSACTION;
IF p_id_stavka NOT IN (SELECT id FROM kupnja)
THEN ROLLBACK;
SELECT CONCAT('Ne postoji taj ID stavke!') AS GREŠKA;
ELSE 
DELETE FROM kupnja
WHERE id=p_id_stavka;
COMMIT;
END IF;




END//
DELIMITER ;

# 					id_stavke
CALL brisanje_stavki (9);
select * from kupnja
WHERE id = 1;
select * from kupnja;


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

SELECT ukupan_iznos(1) AS ukupno_sa_pdv;


/*
CREATE TABLE racun (
	id INTEGER NOT NULL UNIQUE AUTO_INCREMENT,
    id_zaposlenik INTEGER NOT NULL,
	datum_izdavanja DATETIME DEFAULT NOW(),
    osnovica NUMERIC (8,2),
    PDV NUMERIC(8,2),
    ukupno NUMERIC(8,2),
    FOREIGN KEY (id_zaposlenik) REFERENCES zaposlenik(id),
    CONSTRAINT CHK_osnovica CHECK (osnovica >= 0),
    CONSTRAINT CHK_PDV CHECK (PDV >= 0),
    CONSTRAINT CHK_ukupno CHECK (ukupno >= 0)
);
*/
DELIMITER //
CREATE PROCEDURE ispis_racuna (p_id_blagajnik INTEGER, p_id_pumpa INTEGER) 
BEGIN 

DECLARE ukupno NUMERIC (8,2);
DECLARE pdv NUMERIC(8,2);
DECLARE osnovica NUMERIC(8,2);
DECLARE kol NUMERIC(8,2);
DECLARE pre NUMERIC(10,2);

/*DECLARE EXIT HANDLER FOR SQLEXCEPTION 
BEGIN
SELECT CONCAT('Došlo je do greške!') AS GREŠKA;
ROLLBACK;
END;*/

SELECT ukupan_iznos(p_id_pumpa) INTO ukupno;

SELECT ukupno*0.25 INTO pdv;

SELECT ukupno-pdv INTO osnovica;

SELECT kolicina INTO kol FROM kupnja k
INNER JOIN gorivo g ON k.id_proizvod = g.id;

SELECT preostalo_litara INTO pre FROM kupnja k
INNER JOIN gorivo g ON k.id_proizvod = g.id;
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
START TRANSACTION;


INSERT INTO racun VALUES (NULL, p_id_blagajnik, NOW(), osnovica, pdv, ukupno);


IF p_id_pumpa NOT IN (SELECT id_pumpa FROM kupnja) THEN
ROLLBACK;
SELECT CONCAT('Nema stavki!') AS GREŠKA;
ELSE 
INSERT INTO prodani_proizvodi (id_pumpa,id_proizvod,kolicina)(SELECT id_pumpa,id_proizvod,kolicina FROM kupnja);
TRUNCATE kupnja;
UPDATE gorivo
SET preostalo_litara=pre - kol
WHERE id=p_id_proizvod; ## dovršiti ovo za oduzimanje litara!
COMMIT;
END IF;

END//
DELIMITER ;
drop procedure ispis_racuna;

CALL ispis_racuna(1,1);
SELECT * FROM kupnja;
CALL kupi(0, 100, 47.56);

TRUNCATE kupnja;
call kupi(1, 101, 5);
select ukupan_iznos(1);
select kolicina,preostalo_litara from kupnja k
INNER JOIN gorivo g ON k.id_proizvod = g.id;

truncate racun;
select * from racun;
select * from prodani_proizvodi;
TRUNCATE prodani_proizvodi;

truncate racun;

select * from prodani_proizvodi;
/*
IF p_id_proizvod IN (SELECT id FROM gorivo) THEN 
UPDATE gorivo
SET preostalo_litara=preostalo_litara - p_kolicina
WHERE id=p_id_proizvod;
END IF;*/ #OVO TREBAM STAVTI DA KAD OTIPKAS RACUN DA SE LITRE ODUZMU!