-- BRRIEF    : IDS project
-- AUTHORS   : Vesovic Nevena & Maros Orsak
-- DATE_START: 12.3.2018
-- DATE_END  : 30.3.2018
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

                                                --- CREATING TABLES ---

CREATE TABLE OSOBA

(   id_osoba        INTEGER NOT NULL,
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
    rodne_cislo INTEGER  NOT NULL,  
    telefoni_cislo VARCHAR2(30) NOT NULL,
    id_lekar INTEGER NOT NULL,
    id_osoba INTEGER NOT NULL
);
ALTER TABLE PACIENT ADD CONSTRAINT kontrola_rodne_cislo_pacient CHECK ( rodne_cislo>99999999 AND (rodne_cislo<1000000000 OR (MOD(rodne_cislo, 11)=0 AND rodne_cislo<10000000000)) );

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
    rodne_cislo INTEGER NOT NUll,
    id_oddeleni INTEGER NOT NULL,
    id_lekar INTEGER NOT NULL
);
ALTER TABLE HOSPITALIZACE ADD CONSTRAINT kontrola_rodne_cislo_hospitalizace CHECK ( rodne_cislo>99999999 AND (rodne_cislo<1000000000 OR (MOD(rodne_cislo, 11)=0 AND rodne_cislo<10000000000)) );


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
                                         
ALTER TABLE LEKAR ADD CONSTRAINT FK_lekar_info FOREIGN KEY(id_osoba) REFERENCES OSOBA(id_osoba);
ALTER TABLE SESTRA ADD CONSTRAINT FK_sestra_info FOREIGN KEY(id_osoba) REFERENCES OSOBA(id_osoba);
ALTER TABLE PACIENT ADD CONSTRAINT FK_pacient_info FOREIGN KEY(id_osoba) REFERENCES OSOBA(id_osoba);
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

INSERT INTO LEKAR (id_lekar , id_osoba) VALUES(1,1);
INSERT INTO LEKAR (id_lekar , id_osoba) VALUES(2,2); 
INSERT INTO LEKAR (id_lekar , id_osoba) VALUES(3,3); 
INSERT INTO LEKAR (id_lekar , id_osoba) VALUES(4,4);

INSERT INTO ODDELENI(id_oddeleni,nazev,umisteni,kapacita,id_lekar,id_vysetreni,id_hospitalizace) VALUES(1,'Cardiology','Pavilon B4',100,1,3,4);         
INSERT INTO ODDELENI(id_oddeleni,nazev,umisteni,kapacita,id_lekar,id_vysetreni,id_hospitalizace) VALUES(2,'Endocrinology','Pavilon A4',75,4,3,2);
INSERT INTO ODDELENI(id_oddeleni,nazev,umisteni,kapacita,id_lekar,id_vysetreni,id_hospitalizace) VALUES(3,'Hematology','Pavilon D1',50,4,2,3);
INSERT INTO ODDELENI(id_oddeleni,nazev,umisteni,kapacita,id_lekar,id_vysetreni,id_hospitalizace) VALUES(4,'Cardiology','Pavilon C3',50,4,1,2);

INSERT INTO SESTRA (id_sestra, id_oddeleni , id_osoba) VALUES(1,4,9);
INSERT INTO SESTRA (id_sestra, id_oddeleni , id_osoba) VALUES(2,2,10); 
INSERT INTO SESTRA (id_sestra, id_oddeleni , id_osoba) VALUES(3,1,11); 
INSERT INTO SESTRA (id_sestra, id_oddeleni , id_osoba) VALUES(4,3,12);

INSERT INTO PACIENT (rodne_cislo , telefoni_cislo, id_lekar , id_osoba) VALUES(9610219168,'202-555-0183',3,5);
INSERT INTO PACIENT (rodne_cislo , telefoni_cislo, id_lekar , id_osoba) VALUES(9709241729,'202-555-0198',2,6); 
INSERT INTO PACIENT (rodne_cislo , telefoni_cislo, id_lekar , id_osoba) VALUES(9755128790,'202-555-0174',1,7); 
INSERT INTO PACIENT (rodne_cislo , telefoni_cislo, id_lekar , id_osoba) VALUES(9859040466,'202-555-0179',4,8);


INSERT INTO HOSPITALIZACE (id_hospitalizace , datum_zahajeni, rodne_cislo, id_oddeleni, id_lekar  ) VALUES(1,TO_DATE('11/23/2018','MM-DD-YYYY'), 9859040466, 1, 1);
INSERT INTO HOSPITALIZACE (id_hospitalizace , datum_zahajeni, rodne_cislo, id_oddeleni, id_lekar  ) VALUES(2,TO_DATE('05/11/2018','MM-DD-YYYY'), 9755128790, 4, 2);
INSERT INTO HOSPITALIZACE (id_hospitalizace , datum_zahajeni, rodne_cislo, id_oddeleni, id_lekar  ) VALUES(3,TO_DATE('03/25/2018','MM-DD-YYYY'), 9859040466, 3, 3);
INSERT INTO HOSPITALIZACE (id_hospitalizace , datum_zahajeni, rodne_cislo, id_oddeleni, id_lekar  ) VALUES(4,TO_DATE('07/05/2018','MM-DD-YYYY'), 9755128790, 2, 3);

INSERT INTO LEK (id_lek , nazev , ucinna_latka, sila_leku, kontranindikace) VALUES(1,'Acebutolol','FORTE','STRONG','Persistently severe bradycardia');
INSERT INTO LEK (id_lek , nazev , ucinna_latka, sila_leku, kontranindikace) VALUES(2,'Allernaze','MITTE','WEAK','Pregnancy');
INSERT INTO LEK (id_lek , nazev , ucinna_latka, sila_leku, kontranindikace) VALUES(3,'Arzerra','BIFORTE','MEDIUM','Lactation schedules');
INSERT INTO LEK (id_lek , nazev , ucinna_latka, sila_leku, kontranindikace) VALUES(4,'Azithromycin','BIFORTE','MEDIUM','Hearing loss');                    

INSERT INTO VYSETRENI (id_vysetreni , vysledek , datum, id_hospitalizace , id_oddeleni , id_lekar ) VALUES(1,'healthy',TO_DATE('11/23/2018','MM-DD-YYYY'), 1 , 2 , 3);
INSERT INTO VYSETRENI (id_vysetreni , vysledek , datum, id_hospitalizace , id_oddeleni , id_lekar ) VALUES(2,'cold',TO_DATE('05/11/2018','MM-DD-YYYY'), 4, 4, 2);
INSERT INTO VYSETRENI (id_vysetreni , vysledek , datum, id_hospitalizace , id_oddeleni , id_lekar ) VALUES(3,'cancer',TO_DATE('03/25/2018','MM-DD-YYYY'), 3, 1, 3);
INSERT INTO VYSETRENI (id_vysetreni , vysledek , datum, id_hospitalizace , id_oddeleni , id_lekar ) VALUES(4,'healthy',TO_DATE('07/05/2018','MM-DD-YYYY'), 1, 2, 1);

INSERT INTO byl_predepsan (cas_podavani , mnozstvi , davkovanie, datum_zahajenia, datum_ukoncenia , id_hospitalizace , id_lek ) VALUES(CURRENT_TIMESTAMP,4,'2 per day',TO_DATE('2018-11-23','YYYY-MM-DD'),TO_DATE('2018-11-29','YYYY-MM-DD'), 1, 4);
INSERT INTO byl_predepsan (cas_podavani , mnozstvi , davkovanie, datum_zahajenia, datum_ukoncenia , id_hospitalizace , id_lek ) VALUES(CURRENT_TIMESTAMP,10,'4 per day',TO_DATE('2018-12-23','YYYY-MM-DD'),TO_DATE('2019-01-23','YYYY-MM-DD'), 1, 1);
INSERT INTO byl_predepsan (cas_podavani , mnozstvi , davkovanie, datum_zahajenia, datum_ukoncenia , id_hospitalizace , id_lek ) VALUES(CURRENT_TIMESTAMP,2,'1 per day',TO_DATE('2018-03-14','YYYY-MM-DD'),TO_DATE('2018-03-24','YYYY-MM-DD'), 4, 3);
INSERT INTO byl_predepsan (cas_podavani , mnozstvi , davkovanie, datum_zahajenia, datum_ukoncenia , id_hospitalizace , id_lek ) VALUES(CURRENT_TIMESTAMP,1,'1/2 per day',TO_DATE('2018-11-03','YYYY-MM-DD'),TO_DATE('2018-11-23','YYYY-MM-DD'), 2, 4);

INSERT INTO ma_uvazek (typ_uvazku , pozice , telefonni_cislo , id_oddeleni , id_lekar) VALUES('full-time','Cardiologist','462-535-0183', 2, 4);
INSERT INTO ma_uvazek (typ_uvazku , pozice , telefonni_cislo , id_oddeleni , id_lekar) VALUES('part-time','Endocrinologists','752-555-0223', 1, 2);
INSERT INTO ma_uvazek (typ_uvazku , pozice , telefonni_cislo , id_oddeleni , id_lekar) VALUES('full-time','Gastroenterologists','902-155-2183', 4, 1);
INSERT INTO ma_uvazek (typ_uvazku , pozice , telefonni_cislo , id_oddeleni , id_lekar) VALUES('part-time','Hematologists','721-545-0283', 4, 2);

INSERT INTO provedl_lekar_vysetreni (id_lekar , id_vysetreni ) VALUES(2, 3);
INSERT INTO provedl_lekar_vysetreni (id_lekar , id_vysetreni ) VALUES(1, 4);
INSERT INTO provedl_lekar_vysetreni (id_lekar , id_vysetreni ) VALUES(4, 2);
INSERT INTO provedl_lekar_vysetreni (id_lekar , id_vysetreni ) VALUES(2, 1);

                                                                  --- END OF INSERTING --- 





