--DLS projekt
--Vesovic Nevena
--

-- normalne entity

DROP TABLE LEKAR CASCADE CONSTRAINTS;
DROP TABLE SESTRA CASCADE CONSTRAINTS;
DROP TABLE PACIENT CASCADE CONSTRAINTS;
DROP TABLE ODDELENI CASCADE CONSTRAINTS;
DROP TABLE HOSPITALIZACE CASCADE CONSTRAINTS;
DROP TABLE LEK CASCADE CONSTRAINTS;
DROP TABLE VYSETRENI CASCADE CONSTRAINTS;
DROP TABLE OSOBA CASCADE CONSTRAINTS;

-- vztahove entity
DROP TABLE byl_predepsan CASCADE CONSTRAINTS;
DROP TABLE ma_uvazek CASCADE CONSTRAINTS;



    -- Vytvarannie tabuliek --

CREATE TABLE LEKAR
(
	id_lekare INTEGER NOT NULL
);


CREATE TABLE SESTRA
(
	id_sestry INTEGER NOT NULL,
    id_oddeleni INTEGER NOT NULL
);

CREATE TABLE PACIENT
(
    rodne_cislo INTEGER  NOT NULL,  --nebo jako PRIMARNI KLIC muzeme dat rodni cislo
    telefoni_cislo VARCHAR2(30) NOT NULL,
    id_lekare INTEGER NOT NULL
);


CREATE TABLE ODDELENI
(
    id_oddeleni INTEGER NOT NULL,
    nazev VARCHAR2(20) NOT NULL,
    umisteni VARCHAR2(20) NOT NULL,
    kapacita INTEGER DEFAULT 0, -- ak tam nic nezadame tak to bude 0
    id_lekare INTEGER NOT NULL,
    id_vysetreni INTEGER NOT NULL,
    id_hospitalizace INTEGER NOT NULL
);


CREATE TABLE HOSPITALIZACE
(
    id_hospitalizace INTEGER NOT NULL,  
    datum_zahajeni DATE NOT NULL,
    rodne_cislo INTEGER NOT NUll,
    id_oddeleni INTEGER NOT NULL,
    id_lekare INTEGER NOT NULL
);

CREATE TABLE LEK
(
	id_lek INTEGER NOT NULL,
	nazev VARCHAR2(30) NOT NULL,
	ucinna_latka VARCHAR2(30) NOT NULL, -- ked to budes insertovat tak 1.FORTE(silny) 2.BIFORTE 3.MITTE(slaby)
	sila_leku VARCHAR2(20) NOT NULL, 
    kontranindikace VARCHAR2(40) NOT NULL
);


CREATE TABLE VYSETRENI
(
	id_vysetreni INTEGER NOT NULL,
	vysledek VARCHAR2(50) NOT NULL,
	datum DATE NOT NULL,   -- ex. 27.2.2018 : 12:23
    id_lekare INTEGER NOT NULL,
    id_oddeleni INTEGER NOT NULL,
    id_hospitalizace INTEGER NOT NULL
);

CREATE TABLE OSOBA
( 
    jmeno           VARCHAR2(50) NOT NULL,
    prijmeni        VARCHAR2(50) NOT NULL,
    datum_narozenin DATE NOT NULL,
    adresa          VARCHAR2(50) NOT NULL
);
-- doplnil som vztahove mnoziny

CREATE TABLE byl_predepsan
(
    cas_podavani    TIMESTAMP NOT NULL,
    mnozstvi        INTEGER NOT NULL,       -- ratanie krabiciek...liekov
    davkovanie      VARCHAR2(50) NOT NULL,  -- toto neviem ci string alebo int ??
    datum_zahajenia TIMESTAMP NOT NULL,
    datum_ukoncenia TIMESTAMP NOT NULL,
    id_lek          INTEGER NOT NULL,
    id_hospitalizace INTEGER NOT NULL
);

CREATE TABLE ma_uvazek
(
    typ_uvazku      VARCHAR2(50) NOT NULL,   -- full-time , part-time
    pozice          VARCHAR2(50) NOT NULL,   -- neurolog, kardioolog....
    telefonni_cislo VARCHAR2(50) NOT NULL,
    id_oddeleni INTEGER NOT NULL,
    id_lekare INTEGER NOT NULL
);


            --- CREATING PRIMARY KEYS ---
            
ALTER TABLE LEKAR ADD PRIMARY KEY(id_lekare);
ALTER TABLE SESTRA ADD PRIMARY KEY(id_sestry);
ALTER TABLE PACIENT ADD PRIMARY KEY(rodne_cislo);
ALTER TABLE ODDELENI ADD PRIMARY KEY(id_oddeleni);
ALTER TABLE HOSPITALIZACE ADD PRIMARY KEY(id_hospitalizace);
ALTER TABLE VYSETRENI ADD PRIMARY KEY(id_vysetreni);
ALTER TABLE LEK ADD PRIMARY KEY(id_lek);


            --- CREATING FOREIGN KEYS ---
        
 
ALTER TABLE HOSPITALIZACE ADD CONSTRAINT FK_pacient_hospitalizovan FOREIGN KEY(rodne_cislo) REFERENCES PACIENT(rodne_cislo);
ALTER TABLE HOSPITALIZACE ADD CONSTRAINT FK_hospi_na_oddeleni FOREIGN KEY(id_oddeleni) REFERENCES ODDELENI(id_oddeleni);
ALTER TABLE HOSPITALIZACE ADD CONSTRAINT FK_provedl_lekar FOREIGN KEY(id_lekare) REFERENCES LEKAR(id_lekare);
ALTER TABLE SESTRA ADD CONSTRAINT FK_pracuje_na_oddeleni FOREIGN KEY(id_oddeleni) REFERENCES ODDELENI(id_oddeleni);
ALTER TABLE PACIENT ADD CONSTRAINT FK_lekar_pacient FOREIGN KEY(id_lekare) REFERENCES LEKAR(id_lekare);
ALTER TABLE VYSETRENI ADD CONSTRAINT FK_vyzaduje_hospi FOREIGN KEY(id_hospitalizace) REFERENCES HOSPITALIZACE(id_hospitalizace);
ALTER TABLE VYSETRENI ADD CONSTRAINT FK_vyset_na_oddeleni FOREIGN KEY(id_oddeleni) REFERENCES ODDELENI(id_oddeleni);
ALTER TABLE VYSETRENI ADD CONSTRAINT FK_provedl FOREIGN KEY(id_lekare) REFERENCES LEKAR(id_lekare);
ALTER TABLE ma_uvazek ADD CONSTRAINT FK_lekar_pracuje_na FOREIGN KEY(id_oddeleni) REFERENCES ODDELENI(id_oddeleni);
ALTER TABLE ma_uvazek ADD CONSTRAINT FK_oddeleni_lekar FOREIGN KEY(id_lekare) REFERENCES LEKAR(id_lekare);
ALTER TABLE byl_predepsan ADD CONSTRAINT FK_pri_hospitalizace FOREIGN KEY(id_hospitalizace) REFERENCES HOSPITALIZACE(id_hospitalizace);
ALTER TABLE byl_predepsan ADD CONSTRAINT FK_lek FOREIGN KEY(id_lek) REFERENCES LEK(id_lek);


            --- INSERTING DATA INTO TABLES ---

INSERT INTO OSOBA (jmeno , prijmeni , datum_narozenin , adresa) VALUES('Michel','Reedman',TO_DATE('10/10/1965','MM/DD/YYYY'),'Leen Street');
INSERT INTO OSOBA (jmeno , prijmeni , datum_narozenin , adresa) VALUES('John','Smith',TO_DATE('03/10/1975','MM/DD/YYYY'),'Ride Street');
INSERT INTO OSOBA (jmeno , prijmeni , datum_narozenin , adresa) VALUES('April','Chapman',TO_DATE('08/02/1958','MM/DD/YYYY'),'High Street');
INSERT INTO OSOBA (jmeno , prijmeni , datum_narozenin , adresa) VALUES('Sam','Avery',TO_DATE('09/29/1980','MM/DD/YYYY'),'Hugh Street');
INSERT INTO OSOBA (jmeno , prijmeni , datum_narozenin , adresa) VALUES('Samantha','Johnson',TO_DATE('09/29/1980','MM/DD/YYYY'),'Sixth Street');
INSERT INTO OSOBA (jmeno , prijmeni , datum_narozenin , adresa) VALUES('Jessica','Johns',TO_DATE('09/29/1980','MM/DD/YYYY'),'Sane Lane');
INSERT INTO OSOBA (jmeno , prijmeni , datum_narozenin , adresa) VALUES('Michael','Keene',TO_DATE('09/29/1980','MM/DD/YYYY'),'Low Street');
-- dorobit inserty....

-- kapacita bude pocet luzkov... cize cislo ako napriklad 100 = means 100 luzkov
INSERT INTO ODDELENI(id_oddeleni,nazev,umisteni,kapacita,id_lekare,id_vysetreni,id_hospitalizace) VALUES(1,'Cardiology','Pavilon B4',100,1,1,1);         
INSERT INTO ODDELENI(id_oddeleni,nazev,umisteni,kapacita,id_lekare,id_vysetreni,id_hospitalizace) VALUES(2,'Endocrinology','Pavilon A4',75,2,2,2);
INSERT INTO ODDELENI(id_oddeleni,nazev,umisteni,kapacita,id_lekare,id_vysetreni,id_hospitalizace) VALUES(3,'Hematology','Pavilon D1',50,3,3,3);
INSERT INTO ODDELENI(id_oddeleni,nazev,umisteni,kapacita,id_lekare,id_vysetreni,id_hospitalizace) VALUES(4,'Cardiology','Pavilon C3',50,4,4,4);

INSERT INTO LEKAR (id_lekare) VALUES(1);
INSERT INTO LEKAR (id_lekare) VALUES(2); 
INSERT INTO LEKAR (id_lekare) VALUES(3); 
INSERT INTO LEKAR (id_lekare) VALUES(4);

INSERT INTO PACIENT (rodne_cislo , telefoni_cislo, id_lekare) VALUES(24343542,'202-555-0183',1);
INSERT INTO PACIENT (rodne_cislo , telefoni_cislo, id_lekare) VALUES(45621345,'202-555-0198',2); 
INSERT INTO PACIENT (rodne_cislo , telefoni_cislo, id_lekare) VALUES(23123423,'202-555-0174',3); 
INSERT INTO PACIENT (rodne_cislo , telefoni_cislo, id_lekare) VALUES(46423212,'202-555-0179',4);

INSERT INTO HOSPITALIZACE (id_hospitalizace , datum_zahajeni, rodne_cislo, id_oddeleni, id_lekare  ) VALUES(1,TO_DATE('11/23/2018','MM-DD-YYYY'), 24343542, 1, 1);
INSERT INTO HOSPITALIZACE (id_hospitalizace , datum_zahajeni, rodne_cislo, id_oddeleni, id_lekare  ) VALUES(2,TO_DATE('05/11/2018','MM-DD-YYYY'), 45621345, 2, 2);
INSERT INTO HOSPITALIZACE (id_hospitalizace , datum_zahajeni, rodne_cislo, id_oddeleni, id_lekare  ) VALUES(3,TO_DATE('03/25/2018','MM-DD-YYYY'), 23123423, 3, 3);
INSERT INTO HOSPITALIZACE (id_hospitalizace , datum_zahajeni, rodne_cislo, id_oddeleni, id_lekare  ) VALUES(4,TO_DATE('07/05/2018','MM-DD-YYYY'), 46423212, 4, 4);

INSERT INTO SESTRA (id_sestry, id_oddeleni) VALUES(1,1);
INSERT INTO SESTRA (id_sestry, id_oddeleni) VALUES(2,2); 
INSERT INTO SESTRA (id_sestry, id_oddeleni) VALUES(3,3); 
INSERT INTO SESTRA (id_sestry, id_oddeleni) VALUES(4,4);



INSERT INTO LEK (id_lek , nazev , ucinna_latka, sila_leku, kontranindikace) VALUES(1,'Acebutolol','FORTE','STRONG','Persistently severe bradycardia');
INSERT INTO LEK (id_lek , nazev , ucinna_latka, sila_leku, kontranindikace) VALUES(2,'Allernaze','MITTE','WEAK','Pregnancy');
INSERT INTO LEK (id_lek , nazev , ucinna_latka, sila_leku, kontranindikace) VALUES(3,'Arzerra','BIFORTE','MEDIUM','Lactation schedules');
INSERT INTO LEK (id_lek , nazev , ucinna_latka, sila_leku, kontranindikace) VALUES(4,'Azithromycin','BIFORTE','MEDIUM','Hearing loss');                    



-- inserty upravene spolu s alter tables 

INSERT INTO VYSETRENI (id_vysetreni , vysledek , datum, id_hospitalizace , id_oddeleni , id_lekare ) VALUES(1,'healthy',TO_DATE('11/23/2018','MM-DD-YYYY'), 1 , 1 , 1);
INSERT INTO VYSETRENI (id_vysetreni , vysledek , datum, id_hospitalizace , id_oddeleni , id_lekare ) VALUES(2,'cold',TO_DATE('05/11/2018','MM-DD-YYYY'), 2, 2, 2);
INSERT INTO VYSETRENI (id_vysetreni , vysledek , datum, id_hospitalizace , id_oddeleni , id_lekare ) VALUES(3,'cancer',TO_DATE('03/25/2018','MM-DD-YYYY'), 3, 3, 3);
INSERT INTO VYSETRENI (id_vysetreni , vysledek , datum, id_hospitalizace , id_oddeleni , id_lekare ) VALUES(4,'healthy',TO_DATE('07/05/2018','MM-DD-YYYY'), 4, 4, 4);


INSERT INTO ma_uvazek (typ_uvazku , pozice , telefonni_cislo , id_oddeleni , id_lekare) VALUES('full-time','Cardiologist','462-535-0183', 1, 1);
INSERT INTO ma_uvazek (typ_uvazku , pozice , telefonni_cislo , id_oddeleni , id_lekare) VALUES('part-time','Endocrinologists','752-555-0223', 2, 2);
INSERT INTO ma_uvazek (typ_uvazku , pozice , telefonni_cislo , id_oddeleni , id_lekare) VALUES('full-time','Gastroenterologists','902-155-2183', 3, 3);
INSERT INTO ma_uvazek (typ_uvazku , pozice , telefonni_cislo , id_oddeleni , id_lekare) VALUES('part-time','Hematologists','721-545-0283', 4, 4);

INSERT INTO byl_predepsan (cas_podavani , mnozstvi , davkovanie, datum_zahajenia, datum_ukoncenia , id_hospitalizace , id_lek ) VALUES(TO_DATE('2018-11-14 11:22','YYYY-MM-DD HH24:MI'),4,'2 per day',TO_DATE('2018-11-23 11:22','YYYY-MM-DD HH24:MI'),TO_DATE('2018-11-23 11:22','YYYY-MM-DD HH24:MI'), 1, 1);
INSERT INTO byl_predepsan (cas_podavani , mnozstvi , davkovanie, datum_zahajenia, datum_ukoncenia , id_hospitalizace , id_lek ) VALUES(TO_DATE('2018-02-12 11:22','YYYY-MM-DD HH24:MI'),10,'4 per day',TO_DATE('2018-11-23 11:22','YYYY-MM-DD HH24:MI'),TO_DATE('2018-11-23 11:22','YYYY-MM-DD HH24:MI'), 2, 2);
INSERT INTO byl_predepsan (cas_podavani , mnozstvi , davkovanie, datum_zahajenia, datum_ukoncenia , id_hospitalizace , id_lek ) VALUES(TO_DATE('2018-04-28 11:22','YYYY-MM-DD HH24:MI'),2,'1 per day',TO_DATE('2018-11-23 11:22','YYYY-MM-DD HH24:MI'),TO_DATE('2018-11-23 11:22','YYYY-MM-DD HH24:MI'), 3, 3);
INSERT INTO byl_predepsan (cas_podavani , mnozstvi , davkovanie, datum_zahajenia, datum_ukoncenia , id_hospitalizace , id_lek ) VALUES(TO_DATE('2018-06-21 11:22','YYYY-MM-DD HH24:MI'),1,'1/2 per day',TO_DATE('2018-11-23 11:22','YYYY-MM-DD HH24:MI'),TO_DATE('2018-11-23 11:22','YYYY-MM-DD HH24:MI'), 4, 4);


            --- END OF INSERTING --- 


ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MON-YYYY';
select * from OSOBA;    -- spytaj sa ratka...s tymi nulami
ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MON-YYYY HH:MI:SS ';
select * from VYSETRENI;

/*
 skusanie
ALTER TABLE vysetreni_pacient ADD(FOREIGN KEY(jmeno_pacientu) references PACIENT(jmeno));
ALTER TABLE vysetreni_pacient ADD(FOREIGN KEY(vysledek_vysetreni) references PACIENT(vysledek));
*/
