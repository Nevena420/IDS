-- BRRIEF    : IDS project
-- AUTHORS   : Vesovic Nevena & Maros Orsak
-- DATE_START: 17.4.2018
-- DATE_END  : **.*.2018
            
            
             
                                           --- Normal entities ---

DROP TABLE OSOBA CASCADE CONSTRAINTS;
DROP TABLE LEKAR CASCADE CONSTRAINTS;
DROP TABLE SESTRA CASCADE CONSTRAINTS;
DROP TABLE PACIENT CASCADE CONSTRAINTS;
DROP TABLE ODDELENI CASCADE CONSTRAINTS;
DROP TABLE HOSPITALIZACE CASCADE CONSTRAINTS;
DROP TABLE LEK CASCADE CONSTRAINTS;
DROP TABLE VYSETRENI CASCADE CONSTRAINTS;

                                                --- Relationship entities ---

DROP TABLE byl_predepsan CASCADE CONSTRAINTS;
DROP TABLE ma_uvazek CASCADE CONSTRAINTS;
DROP TABLE provedl_lekar_vysetreni CASCADE CONSTRAINTS;

                                                ---   Sequence  ----
                                                
DROP SEQUENCE counterID;
                                                --- CREATING TABLES ---
                                            


CREATE TABLE OSOBA
(   
    id_osoba        INTEGER NOT NULL,
    jmeno           VARCHAR2(50) NOT NULL,
    prijmeni        VARCHAR2(50) NOT NULL,
    datum_narozenin DATE NOT NULL,
    adresa          VARCHAR2(50) NOT NULL
);

CREATE TABLE LEKAR
(
    id_lekar INTEGER NOT NULL,
    id_osoba INTEGER NOT NULL
);

CREATE TABLE SESTRA
(
    id_sestra INTEGER NOT NULL,
    id_oddeleni INTEGER NOT NULL,
    id_osoba INTEGER NOT NULL
);

CREATE TABLE PACIENT
(
    rodne_cislo VARCHAR(11) NOT NULL,  
    telefoni_cislo VARCHAR2(30) NOT NULL,
    id_lekar INTEGER NOT NULL,
    id_osoba INTEGER NOT NULL
);
--ALTER TABLE PACIENT ADD CONSTRAINT kontrola_rodne_cislo_pacient CHECK ( rodne_cislo>99999999 AND (rodne_cislo<1000000000 OR (MOD(rodne_cislo, 11)=0 AND rodne_cislo<10000000000)) );

CREATE TABLE ODDELENI
(
    id_oddeleni INTEGER NOT NULL,
    nazev VARCHAR2(20) NOT NULL,
    umisteni VARCHAR2(20) NOT NULL,
    kapacita INTEGER NOT NULL,
    id_lekar INTEGER NOT NULL,
    id_vysetreni INTEGER NOT NULL,
    id_hospitalizace INTEGER NOT NULL
);

ALTER TABLE ODDELENI ADD CONSTRAINT kontrola_kapacita_oddeleni CHECK (kapacita > 0);


CREATE TABLE HOSPITALIZACE
(
    id_hospitalizace INTEGER NOT NULL,  
    datum_zahajeni DATE NOT NULL,
    rodne_cislo VARCHAR(11) NOT NUll,
    id_oddeleni INTEGER NOT NULL,
    id_lekar INTEGER NOT NULL
);
--ALTER TABLE HOSPITALIZACE ADD CONSTRAINT kontrola_rodne_cislo_hospitalizace CHECK ( rodne_cislo>99999999 AND (rodne_cislo<1000000000 OR (MOD(rodne_cislo, 11)=0 AND rodne_cislo<10000000000)) );


CREATE TABLE LEK
(
    id_lek INTEGER NOT NULL,
    nazev VARCHAR2(30) NOT NULL,
    ucinna_latka VARCHAR2(30) NOT NULL CHECK (ucinna_latka IN('FORTE','BIFORTE' ,'MITTE')),
    sila_leku VARCHAR2(20) NOT NULL CHECK (sila_leku IN('STRONG','MEDIUM' ,'WEAK')), 
    kontranindikace VARCHAR2(40) NOT NULL
);


CREATE TABLE VYSETRENI
(
    id_vysetreni INTEGER NOT NULL, 
    vysledek VARCHAR2(50) NOT NULL, 
    datum DATE NOT NULL,   
    id_lekar INTEGER NOT NULL,
    id_oddeleni INTEGER NOT NULL,
    id_hospitalizace INTEGER NOT NULL
);


CREATE TABLE byl_predepsan
(
    cas_podavani    DATE NOT NULL,
    mnozstvi        INTEGER NOT NULL, --kolik celkem leku
    davkovanie      VARCHAR2(50) NOT NULL  CHECK (davkovanie like '% per day'), --jak casto denne
    datum_zahajenia DATE NOT NULL,
    datum_ukoncenia DATE NOT NULL,
    id_lek          INTEGER NOT NULL,
    id_hospitalizace INTEGER NOT NULL
);

CREATE TABLE ma_uvazek
(
    typ_uvazku      VARCHAR2(50) NOT NULL CHECK (typ_uvazku IN('full-time', 'part-time')),
    pozice          VARCHAR2(50) NOT NULL,   
    telefonni_cislo VARCHAR2(50) NOT NULL,
    id_oddeleni INTEGER NOT NULL,
    id_lekar INTEGER NOT NULL
);

CREATE TABLE provedl_lekar_vysetreni 
(
    id_lekar NUMBER NOT NULL,
    id_vysetreni NUMBER NOT NULL
);

                            ---- TRIGGERS ----
--SET SERVEROUTPUT ON
                     
--DROP SEQUENCE counterID;
--
--CREATE SEQUENCE counterID 
--    START WITH 1 INCREMENT BY 1 CACHE 20;
--CREATE OR REPLACE TRIGGER incrementingID
--  BEFORE INSERT ON OSOBA
--  FOR EACH ROW
--BEGIN
--  :new.id_osoba := counterID.nextval; --dame do idcka hodnotu z sequencie +1
--END incrementingID;
--/




--
--CREATE OR REPLACE TRIGGER checkBirthNumber
--	BEFORE INSERT OR UPDATE OF rodne_cislo ON PACIENT
--	FOR EACH ROW
--	DECLARE
--		rodneCislo PACIENT.rodne_cislo%TYPE;
--		lomitko VARCHAR2(1);
--		poradie NUMBER(4);
--		sucet NUMBER;
--		rok NUMBER(2);
--		mesiac NUMBER(2);
--		den NUMBER(2);
--		
--	BEGIN
--		rodneCislo := :NEW.rodne_cislo;
--		lomitko := SUBSTR(rodneCislo, 7, 1);
--		poradie := SUBSTR(rodneCislo, 8, 4);-- kolky je to novorodenec v danom dni
--		sucet := (rok + mesiac + den + poradie); -- sucet musi byt delitelny 11
--		rok := SUBSTR(rodneCislo, 1, 2);	-- ziskanie roku z rodneho cisla
--		mesiac := SUBSTR(rodneCislo, 3, 2);	-- ziskanie mesiaca
--		den := SUBSTR(rodneCislo, 5, 2);	-- ziskanie dna
--	IF MOD(sucet, 11) != 0 THEN 
--        Raise_Application_Error(-20322, 'Birth number has wrong format');
--    END IF;
--    IF (LENGTH(rodneCislo) != 11) THEN
--        Raise_Application_Error(-20323, 'Birth number has wrong length');
--    END IF;
--    IF (lomitko != '/') THEN
--        Raise_Application_Error(-20324, 'Dash is not in the current Birth number');
--    END IF;
--    IF NOT (rok > -1 and rok < 100) THEN
--        Raise_Application_Error(-20325, 'Not valid year number');
--    END IF;
--   IF mesiac < 1 OR (mesiac > 12 AND mesiac < 51) OR mesiac > 62 THEN
--		Raise_Application_Error(-20101, 'Rodne cislo ma chybne uvedeni mesiac');
--	END IF;
--    IF NOT (den > 0 and den < 32) THEN
--        Raise_Application_Error(-20327, 'Not valid day number');
--    END IF;
----    IF NOT (poradi > 0 and poradi < 1000) THEN
----        Raise_Application_Error(-20328, 'Not valid order number');
----    END IF;
--END checkBirthNumber;
--/

                                        --- CREATING PRIMARY KEYS ---
            
ALTER TABLE OSOBA ADD PRIMARY KEY(id_osoba);
ALTER TABLE LEKAR ADD PRIMARY KEY(id_lekar);
ALTER TABLE SESTRA ADD PRIMARY KEY(id_sestra);
ALTER TABLE PACIENT ADD PRIMARY KEY(rodne_cislo);
ALTER TABLE ODDELENI ADD PRIMARY KEY(id_oddeleni);
ALTER TABLE HOSPITALIZACE ADD PRIMARY KEY(id_hospitalizace);
ALTER TABLE VYSETRENI ADD PRIMARY KEY(id_vysetreni);
ALTER TABLE LEK ADD PRIMARY KEY(id_lek);
ALTER TABLE byl_predepsan ADD CONSTRAINT PK_byl_predepsan PRIMARY KEY(id_hospitalizace, id_lek);
ALTER TABLE ma_uvazek ADD CONSTRAINT PK_uvazek PRIMARY KEY(id_lekar, id_oddeleni);
ALTER TABLE provedl_lekar_vysetreni ADD CONSTRAINT PK_provedl PRIMARY KEY (id_lekar, id_vysetreni);

                                         
                                         --- CREATING FOREIGN KEYS ---
                                         
                                         
ALTER TABLE HOSPITALIZACE ADD CONSTRAINT FK_pacient_hospitalizovan FOREIGN KEY(rodne_cislo) REFERENCES PACIENT(rodne_cislo);
ALTER TABLE HOSPITALIZACE ADD CONSTRAINT FK_hospi_na_oddeleni FOREIGN KEY(id_oddeleni) REFERENCES ODDELENI(id_oddeleni);
ALTER TABLE HOSPITALIZACE ADD CONSTRAINT FK_provedl_lekar_hospit FOREIGN KEY(id_lekar) REFERENCES LEKAR(id_lekar);
ALTER TABLE SESTRA ADD CONSTRAINT FK_pracuje_na_oddeleni FOREIGN KEY(id_oddeleni) REFERENCES ODDELENI(id_oddeleni);
ALTER TABLE PACIENT ADD CONSTRAINT FK_lekar_pacient FOREIGN KEY(id_lekar) REFERENCES LEKAR(id_lekar);
ALTER TABLE VYSETRENI ADD CONSTRAINT FK_vyzaduje_hospi FOREIGN KEY(id_hospitalizace) REFERENCES HOSPITALIZACE(id_hospitalizace);
ALTER TABLE VYSETRENI ADD CONSTRAINT FK_vyset_na_oddeleni FOREIGN KEY(id_oddeleni) REFERENCES ODDELENI(id_oddeleni);

ALTER TABLE byl_predepsan ADD CONSTRAINT FK_pri_hospitalizace FOREIGN KEY(id_hospitalizace) REFERENCES HOSPITALIZACE(id_hospitalizace);
ALTER TABLE byl_predepsan ADD CONSTRAINT FK_lek FOREIGN KEY(id_lek) REFERENCES LEK(id_lek);

ALTER TABLE ma_uvazek ADD CONSTRAINT FK_lekar_pracuje_na FOREIGN KEY(id_oddeleni) REFERENCES ODDELENI(id_oddeleni);
ALTER TABLE ma_uvazek ADD CONSTRAINT FK_oddeleni_lekar FOREIGN KEY(id_lekar) REFERENCES LEKAR(id_lekar);

ALTER TABLE provedl_lekar_vysetreni ADD CONSTRAINT FK_provedl_lekar FOREIGN KEY(id_lekar) REFERENCES LEKAR(id_lekar);
ALTER TABLE provedl_lekar_vysetreni ADD CONSTRAINT FK_provedl_vysetreni FOREIGN KEY(id_vysetreni) REFERENCES VYSETRENI(id_vysetreni);


                                               --- INSERTING DATA INTO TABLES ---

INSERT INTO OSOBA (id_osoba , jmeno , prijmeni , datum_narozenin , adresa) VALUES(1,'Michel','Reedman',TO_DATE('10/10/1965','MM/DD/YYYY'),'Leen Street');
INSERT INTO OSOBA (id_osoba , jmeno , prijmeni , datum_narozenin , adresa) VALUES(2,'John','Smith',TO_DATE('03/10/1975','MM/DD/YYYY'),'Ride Street');
INSERT INTO OSOBA (id_osoba , jmeno , prijmeni , datum_narozenin , adresa) VALUES(3,'April','Chapman',TO_DATE('08/02/1958','MM/DD/YYYY'),'High Street');
INSERT INTO OSOBA (id_osoba , jmeno , prijmeni , datum_narozenin , adresa) VALUES(4,'Sam','Avery',TO_DATE('09/29/1980','MM/DD/YYYY'),'Hugh Street');
INSERT INTO OSOBA (id_osoba , jmeno , prijmeni , datum_narozenin , adresa) VALUES(5,'Samantha','Johnson',TO_DATE('09/29/1980','MM/DD/YYYY'),'Sixth Street');
INSERT INTO OSOBA (id_osoba , jmeno , prijmeni , datum_narozenin , adresa) VALUES(6,'Jessica','Johns',TO_DATE('09/29/1980','MM/DD/YYYY'),'Sane Lane');
INSERT INTO OSOBA (id_osoba , jmeno , prijmeni , datum_narozenin , adresa) VALUES(7,'Michael','Keene',TO_DATE('09/29/1980','MM/DD/YYYY'),'Low Street');
INSERT INTO OSOBA (id_osoba , jmeno , prijmeni , datum_narozenin , adresa) VALUES(8,'Brad','Summer',TO_DATE('04/05/1965','MM/DD/YYYY'),'Burkes Street');
INSERT INTO OSOBA (id_osoba , jmeno , prijmeni , datum_narozenin , adresa) VALUES(9,'Martha','Gouuve',TO_DATE('09/20/1980','MM/DD/YYYY'),'Prinston Street');
INSERT INTO OSOBA (id_osoba , jmeno , prijmeni , datum_narozenin , adresa) VALUES(10,'Amy','Flavour',TO_DATE('12/12/1912','MM/DD/YYYY'),'Cray Street');
INSERT INTO OSOBA (id_osoba , jmeno , prijmeni , datum_narozenin , adresa) VALUES(11,'Lisa','Voubalis',TO_DATE('01/01/1980','MM/DD/YYYY'),'Bay Street');
INSERT INTO OSOBA (id_osoba , jmeno , prijmeni , datum_narozenin , adresa) VALUES(12,'Samantha','Wicket',TO_DATE('09/07/1970','MM/DD/YYYY'),'Lane Street');
INSERT INTO OSOBA (id_osoba , jmeno , prijmeni , datum_narozenin , adresa) VALUES(13,'Leeejla','Wicket',TO_DATE('08/02/1992','MM/DD/YYYY'),'Eane Street');

INSERT INTO LEKAR (id_lekar , id_osoba) VALUES(1,1);
INSERT INTO LEKAR (id_lekar , id_osoba) VALUES(2,2); 
INSERT INTO LEKAR (id_lekar , id_osoba) VALUES(3,3); 
INSERT INTO LEKAR (id_lekar , id_osoba) VALUES(4,4);

INSERT INTO ODDELENI(id_oddeleni,nazev,umisteni,kapacita,id_lekar,id_vysetreni,id_hospitalizace) VALUES(1,'Cardiology','Pavilon B4',100,1,2,4);         
INSERT INTO ODDELENI(id_oddeleni,nazev,umisteni,kapacita,id_lekar,id_vysetreni,id_hospitalizace) VALUES(2,'Endocrinology','Pavilon A4',75,2,2,3);
INSERT INTO ODDELENI(id_oddeleni,nazev,umisteni,kapacita,id_lekar,id_vysetreni,id_hospitalizace) VALUES(3,'Hematology','Pavilon D1',50,2,1,3);
INSERT INTO ODDELENI(id_oddeleni,nazev,umisteni,kapacita,id_lekar,id_vysetreni,id_hospitalizace) VALUES(4,'Cardiology','Pavilon C3',50,4,4,1);


INSERT INTO SESTRA (id_sestra, id_oddeleni , id_osoba) VALUES(1,4,9);
INSERT INTO SESTRA (id_sestra, id_oddeleni , id_osoba) VALUES(2,2,10); 
INSERT INTO SESTRA (id_sestra, id_oddeleni , id_osoba) VALUES(3,1,11); 
INSERT INTO SESTRA (id_sestra, id_oddeleni , id_osoba) VALUES(4,3,12);
INSERT INTO SESTRA (id_sestra, id_oddeleni , id_osoba) VALUES(5,3,13);


INSERT INTO PACIENT (rodne_cislo , telefoni_cislo, id_lekar , id_osoba) VALUES('970110/4270','202-555-0183',3,5);
INSERT INTO PACIENT (rodne_cislo , telefoni_cislo, id_lekar , id_osoba) VALUES('955615/9701','202-555-0198',2,6); 
INSERT INTO PACIENT (rodne_cislo , telefoni_cislo, id_lekar , id_osoba) VALUES('915115/9701','202-555-0174',1,7); 
INSERT INTO PACIENT (rodne_cislo , telefoni_cislo, id_lekar , id_osoba) VALUES('955215/9701','202-555-0179',4,8);

INSERT INTO HOSPITALIZACE (id_hospitalizace , datum_zahajeni, rodne_cislo, id_oddeleni, id_lekar  ) VALUES(1,TO_DATE('11/23/2018','MM-DD-YYYY'), '970110/4270', 1, 1);
INSERT INTO HOSPITALIZACE (id_hospitalizace , datum_zahajeni, rodne_cislo, id_oddeleni, id_lekar  ) VALUES(2,TO_DATE('05/11/2018','MM-DD-YYYY'), '955615/9701', 4, 2);
INSERT INTO HOSPITALIZACE (id_hospitalizace , datum_zahajeni, rodne_cislo, id_oddeleni, id_lekar  ) VALUES(3,TO_DATE('03/25/2018','MM-DD-YYYY'), '970110/4270', 3, 3);
INSERT INTO HOSPITALIZACE (id_hospitalizace , datum_zahajeni, rodne_cislo, id_oddeleni, id_lekar  ) VALUES(4,TO_DATE('07/05/2018','MM-DD-YYYY'), '955215/9701', 2, 3);




INSERT INTO LEK (id_lek , nazev , ucinna_latka, sila_leku, kontranindikace) VALUES(1,'Acebutolol','FORTE','STRONG','Persistently severe bradycardia');
INSERT INTO LEK (id_lek , nazev , ucinna_latka, sila_leku, kontranindikace) VALUES(2,'Allernaze','MITTE','WEAK','Pregnancy');
INSERT INTO LEK (id_lek , nazev , ucinna_latka, sila_leku, kontranindikace) VALUES(3,'Arzerra','BIFORTE','MEDIUM','Lactation schedules');
INSERT INTO LEK (id_lek , nazev , ucinna_latka, sila_leku, kontranindikace) VALUES(4,'Azithromycin','BIFORTE','MEDIUM','Hearing loss');                    

INSERT INTO VYSETRENI (id_vysetreni , vysledek , datum, id_hospitalizace , id_oddeleni , id_lekar ) VALUES(1,'healthy',TO_DATE('11/23/2018','MM-DD-YYYY'), 1 , 2 , 3);
INSERT INTO VYSETRENI (id_vysetreni , vysledek , datum, id_hospitalizace , id_oddeleni , id_lekar ) VALUES(2,'cold',TO_DATE('05/11/2018','MM-DD-YYYY'), 4, 4, 2);
INSERT INTO VYSETRENI (id_vysetreni , vysledek , datum, id_hospitalizace , id_oddeleni , id_lekar ) VALUES(3,'cancer',TO_DATE('03/25/2018','MM-DD-YYYY'), 3, 1, 3);
INSERT INTO VYSETRENI (id_vysetreni , vysledek , datum, id_hospitalizace , id_oddeleni , id_lekar ) VALUES(4,'healthy',TO_DATE('07/05/2018','MM-DD-YYYY'), 1, 2, 1);

INSERT INTO byl_predepsan (cas_podavani , mnozstvi , davkovanie, datum_zahajenia, datum_ukoncenia , id_hospitalizace , id_lek ) VALUES(CURRENT_TIMESTAMP,4,'2 per day',TO_DATE('2018-11-23','YYYY-MM-DD'),TO_DATE('2018-11-29','YYYY-MM-DD'), 1, 4);
INSERT INTO byl_predepsan (cas_podavani , mnozstvi , davkovanie, datum_zahajenia, datum_ukoncenia , id_hospitalizace , id_lek ) VALUES(CURRENT_TIMESTAMP,10,'4 per day',TO_DATE('2018-12-23','YYYY-MM-DD'),TO_DATE('2019-01-23','YYYY-MM-DD'),4, 1);
INSERT INTO byl_predepsan (cas_podavani , mnozstvi , davkovanie, datum_zahajenia, datum_ukoncenia , id_hospitalizace , id_lek ) VALUES(CURRENT_TIMESTAMP,2,'1 per day',TO_DATE('2018-03-14','YYYY-MM-DD'),TO_DATE('2018-03-24','YYYY-MM-DD'),3, 3);
INSERT INTO byl_predepsan (cas_podavani , mnozstvi , davkovanie, datum_zahajenia, datum_ukoncenia , id_hospitalizace , id_lek ) VALUES(CURRENT_TIMESTAMP,1,'1/2 per day',TO_DATE('2018-11-03','YYYY-MM-DD'),TO_DATE('2018-11-23','YYYY-MM-DD'), 2, 4);

INSERT INTO ma_uvazek (typ_uvazku , pozice , telefonni_cislo , id_oddeleni , id_lekar) VALUES('full-time','Cardiologist','462-535-0183', 2, 4);
INSERT INTO ma_uvazek (typ_uvazku , pozice , telefonni_cislo , id_oddeleni , id_lekar) VALUES('part-time','Endocrinologists','752-555-0223', 1, 2);
INSERT INTO ma_uvazek (typ_uvazku , pozice , telefonni_cislo , id_oddeleni , id_lekar) VALUES('full-time','Gastroenterologists','902-155-2183', 4, 1);
INSERT INTO ma_uvazek (typ_uvazku , pozice , telefonni_cislo , id_oddeleni , id_lekar) VALUES('part-time','Hematologists','721-545-0283', 4, 2);

INSERT INTO provedl_lekar_vysetreni (id_lekar , id_vysetreni ) VALUES(2, 3);
INSERT INTO provedl_lekar_vysetreni (id_lekar , id_vysetreni ) VALUES(1, 4);
INSERT INTO provedl_lekar_vysetreni (id_lekar , id_vysetreni ) VALUES(4, 2);
INSERT INTO provedl_lekar_vysetreni (id_lekar , id_vysetreni ) VALUES(2, 1); 


-- first procedure 
SET SERVEROUTPUT ON

CREATE OR REPLACE PROCEDURE vypis_perceto_zastupenie_lekar_v_databaze
IS
    CURSOR cursor_osoba IS SELECT * FROM OSOBA LEFT JOIN LEKAR ON OSOBA.ID_OSOBA = LEKAR.ID_OSOBA;
    riadok_tabulky cursor_osoba%ROWTYPE;
    pocet_osob NUMBER;
    pocet_lekarov NUMBER;
    BEGIN
        pocet_osob := 0;
        pocet_lekarov := 0;
        OPEN
            cursor_osoba;
            LOOP
                FETCH
                cursor_osoba INTO riadok_tabulky;
                EXIT WHEN cursor_osoba%NOTFOUND;
                IF(riadok_tabulky.id_lekar IS NOT NULL) THEN
                    pocet_lekarov := pocet_lekarov + 1;
                END IF; 
                pocet_osob := pocet_osob + 1;
            END LOOP;
        CLOSE cursor_osoba;
        dbms_output.put_line('Percetage division persons to doctors is ' || pocet_lekarov * 100 / pocet_osob);
        EXCEPTION
        WHEN ZERO_DIVIDE THEN
            dbms_output.put_line('Error -> Zero division');
END;
/

-- second procedure


CREATE OR REPLACE PROCEDURE vypis_perceto_zastupenie_sestricka_v_databaze
IS
    CURSOR cursor_osoba IS SELECT * FROM OSOBA LEFT JOIN SESTRA ON OSOBA.ID_OSOBA = SESTRA.ID_OSOBA;
    riadok_tabulky cursor_osoba%ROWTYPE;
    pocet_osob NUMBER;
    pocet_sestier NUMBER;
    BEGIN
        pocet_osob := 0;
        pocet_sestier := 0;
        OPEN
            cursor_osoba;
            LOOP
                FETCH
                cursor_osoba INTO riadok_tabulky;
                EXIT WHEN cursor_osoba%NOTFOUND;
                IF(riadok_tabulky.id_sestra IS NOT NULL) THEN
                    pocet_sestier := pocet_sestier + 1;
                END IF; 
                pocet_osob := pocet_osob + 1;
            END LOOP;
        CLOSE cursor_osoba;
        dbms_output.put_line('Percetage division persons to nurses is ' || pocet_sestier * 100 / pocet_osob);
        EXCEPTION
        WHEN ZERO_DIVIDE THEN
            dbms_output.put_line('Error -> Zero division');
END;
/


--SELECT LEKAR.id_lekar FROM OSOBA LEFT JOIN LEKAR ON OSOBA.id_osoba = LEKAR.id_osoba;



                                                                  --- SELECT QUERIES ---
                                                                  
                                                                
---- 2x  spojenie dvoch tabuliek
--vypise Sestricku ktorej prijmeni je Flavour ----> cize ID_SESTRA = 2 && ID_ODDELENI = 2 && ID_OSOBA = 10

SELECT * FROM SESTRA WHERE id_osoba=(SELECT id_osoba FROM OSOBA WHERE prijmeni='Flavour');

----vypise vsetko z Oddelenia na ktorom sa nachadza sestricka, ktora ma ID 3

SELECT * FROM ODDELENI WHERE id_oddeleni=(SELECT id_oddeleni FROM SESTRA WHERE id_sestra='3');

-- 1x EXIST
--vypise vsetky oddelenia ktore maju sestricky

SELECT * FROM ODDELENI WHERE EXISTS( SELECT * FROM SESTRA WHERE SESTRA.id_oddeleni = ODDELENI.id_oddeleni);


--1. PRVA 
-- 2x s klauzulí GROUP BY a agregaèní funkcí

-- vypise pocet lekarov na danom oddeleni

SELECT id_lekar, COUNT(id_lekar) FROM ODDELENI GROUP BY id_lekar;

-- 2.DRUHA
--vypise maximalnu nazov a kapacitu jednotlivych oddeleni 
SELECT nazev,id_oddeleni, MAX(kapacita) FROM ODDELENI GROUP BY nazev,id_oddeleni;
      
      
-- 1x IN
--vypise vsetky osoby s menami Samantha a Jessica a Michael
SELECT * FROM Osoba WHERE jmeno IN('Samantha', 'Jessica','Michael');

-- 1x s WHERE
-- vypise vsetkych lekarov ktory maju full-time job...
SELECT * FROM ma_uvazek WHERE typ_uvazku='full-time';

-- 1x so spojenim 3 tabuliek
-- vypise  vsetky informacie o osobe , ktora je lekar a ma cislo 462-535-0183

SELECT * FROM OSOBA WHERE id_osoba=(SELECT id_lekar FROM LEKAR WHERE id_lekar=(SELECT id_lekar FROM ma_uvazek WHERE telefonni_cislo= '462-535-0183')); 


                            -- CALLING THE PROCEDURES --
                            
exec vypis_perceto_zastupenie_lekar_v_databaze;
exec vypis_perceto_zastupenie_sestricka_v_databaze;




--Kteri lekar osetril ktereho pacienta.(Spojeni 2x tabulky)
SELECT  PACIENT.rodne_cislo,
        LEKAR.id_lekar
FROM  PACIENT, LEKAR
WHERE LEKAR.id_lekar = PACIENT.id_lekar;

--V kolik hodin byl pacient hospitalizovan. Vypise v poradi podle datumu.(Spojeni 2x tabulky)
SELECT  PACIENT.rodne_cislo,
        HOSPITALIZACE.datum_zahajeni
FROM PACIENT, HOSPITALIZACE
WHERE PACIENT.rodne_cislo = HOSPITALIZACE.rodne_cislo
ORDER BY datum_zahajeni;

--Podrobnejsi info o lekarech kteri osetrili urcite pacienty.(Spojeni 3x tabulky)
SELECT  PACIENT.rodne_cislo,
        LEKAR.id_lekar,
        OSOBA.*
FROM  PACIENT, LEKAR , OSOBA
WHERE LEKAR.id_lekar = PACIENT.id_lekar AND OSOBA.id_osoba = LEKAR.id_osoba;

--Kolik lekare je na kterem oddeleni(1. GROUP BY a agregační funkcí)
SELECT nazev,COUNT(id_lekar) AS "Pocet lekare"
FROM ODDELENI
GROUP BY nazev;

--Jak moc tablety bylo predepsano od jednotlivych leku.(2. GROUP BY a agregační funkcí) 
SELECT id_lek, SUM(mnozstvi) AS "Mnozstvi predepsaneho leku"
FROM byl_predepsan
GROUP BY id_lek;

--Dostavame podrobnejsi info o sestre ktera pracuje na oddeleni 'Hematology'(IN s vnorenim selektem)
SELECT * FROM OSOBA 
    WHERE id_osoba IN
    (SELECT id_osoba FROM SESTRA
    WHERE id_oddeleni IN
    (SELECT id_oddeleni FROM ODDELENI WHERE nazev = 'Hematology'));
--    
----Vypise nazev leku ci mnozstvi bylo predepsano na 10 tablety pri hospitalizace.(SELECT s prediktem EXISTS) ----
SELECT nazev FROM LEK
WHERE EXISTS (SELECT id_lek FROM byl_predepsan WHERE id_lek = LEK.id_lek AND mnozstvi = 10);

/* --------------------- INDEX -------------------------- */

DROP INDEX index1;
    -- Kolik lekare je na kterem oddeleni
EXPLAIN PLAN FOR 
SELECT PACIENT.rodne_cislo, COUNT(*) pocet
      FROM HOSPITALIZACE JOIN Pacient on(Pacient.rodne_cislo=HOSPITALIZACE.rodne_cislo)
      GROUP BY Pacient.rodne_cislo;

	SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY());  
    
CREATE INDEX index1 ON HOSPITALIZACE (rodne_cislo);
EXPLAIN PLAN FOR 
SELECT PACIENT.rodne_cislo, COUNT(*) pocet
      FROM HOSPITALIZACE JOIN Pacient on(Pacient.rodne_cislo=HOSPITALIZACE.rodne_cislo)
      GROUP BY Pacient.rodne_cislo;

	SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY());



                                    ----------    5 -->  RIGHTS     -----------  

GRANT ALL ON OSOBA TO xvesov00;
GRANT ALL ON ODDELENI TO xvesov00;
GRANT ALL ON LEKAR TO xvesov00;
GRANT ALL ON PACIENT TO xvesov00;
GRANT ALL ON SESTRA TO xvesov00;
GRANT ALL ON VYSETRENI TO xvesov00;
GRANT ALL ON LEK TO xvesov00;
GRANT ALL ON HOSPITALIZACE TO xvesov00;


            --- Relationship entities ---
GRANT ALL ON byl_predepsan TO xvesov00;
GRANT ALL ON ma_uvazek TO xvesov00;
GRANT ALL ON provedl_lekar_vysetreni TO xvesov00;

COMMIT;

DROP MATERIALIZED VIEW pocetV;

CREATE MATERIALIZED VIEW LOG ON VYSETRENI WITH PRIMARY KEY,ROWID(id_lekar) INCLUDING NEW VALUES;

CREATE MATERIALIZED VIEW pocetV 
CACHE --postupne optimalizuje citanie z pohladu
BUILD IMMEDIATE --naplni pohlad hned po jeho vytvoreni
REFRESH FAST ON COMMIT --postupne optimalizuje citanie z pohladu
ENABLE QUERY REWRITE --bude pouzivany optimalizatorom
AS 
SELECT V.id_lekar, count(V.id_vysetreni) as pocetVysetreni
FROM VYSETRENI V
GROUP BY V.id_lekar;

GRANT ALL ON pocetV TO xvesov00;

SELECT * from pocetV;
INSERT INTO VYSETRENI (id_vysetreni , vysledek , datum, id_hospitalizace , id_oddeleni , id_lekar ) VALUES(5,'healthy',TO_DATE('07/05/2018','MM-DD-YYYY'), 1, 2, 1);
COMMIT;
SELECT * from pocetV;













