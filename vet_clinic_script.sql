DROP TABLE prescriptii CASCADE CONSTRAINTS;
DROP TABLE vizite CASCADE CONSTRAINTS;
DROP TABLE animale CASCADE CONSTRAINTS;
DROP TABLE medici CASCADE CONSTRAINTS;
DROP TABLE stapani CASCADE CONSTRAINTS;
DROP TABLE medicamente CASCADE CONSTRAINTS;
DROP TABLE specializari CASCADE CONSTRAINTS;
DROP TABLE specii CASCADE CONSTRAINTS;

prompt
prompt Creating table SPECII 
prompt =====================
prompt
CREATE TABLE specii (
id_specie NUMBER(2),
nume_specie VARCHAR2(30),
CONSTRAINT pk_specie PRIMARY KEY (id_specie)
);

prompt
prompt Creating table SPECIALIZARI 
prompt ===========================
prompt
CREATE TABLE specializari (
id_specializare NUMBER(2),
nume_specializare VARCHAR2(30),
CONSTRAINT pk_specializare PRIMARY KEY (id_specializare)
);

prompt
prompt Creating table MEDICAMENTE 
prompt ==========================
prompt
CREATE TABLE medicamente (
id_medicament NUMBER(2),
nume_medicament VARCHAR(30),
brand VARCHAR(30),
CONSTRAINT pk_medicamente PRIMARY KEY (id_medicament)
);

prompt
prompt Creating table STAPANI 
prompt ======================
prompt
CREATE TABLE stapani (
id_stapan NUMBER(3),
nume_stapan VARCHAR2(20) NOT NULL,
prenume_stapan VARCHAR(20) NOT NULL,
cnp_stapan CHAR(13) UNIQUE NOT NULL,
adresa_stapan VARCHAR2(50),
telefon_stapan VARCHAR2(10) UNIQUE,
email_stapan VARCHAR2(30) UNIQUE,
CONSTRAINT pk_stapan PRIMARY KEY (id_stapan),
CONSTRAINT lungime_telefon_stapan CHECK (LENGTH(telefon_stapan)=10),
CONSTRAINT format_email CHECK (email_stapan LIKE '%@%.%')
);

prompt
prompt Creating table MEDICI 
prompt =====================
prompt
CREATE TABLE medici (
id_med NUMBER(2),
nume_med VARCHAR2(20) NOT NULL,
prenume_med VARCHAR(20) NOT NULL,
telefon_med VARCHAR2(10) UNIQUE,
data_absolvire DATE NOT NULL,
data_angajarii DATE NOT NULL,
id_specializare NUMBER(2),
CONSTRAINT pk_med PRIMARY KEY (id_med),
CONSTRAINT lungime_telefon_med CHECK (LENGTH(telefon_med)=10),
CONSTRAINT fk_specializare FOREIGN KEY (id_specializare) REFERENCES specializari
(id_specializare)
);

prompt
prompt Creating table ANIMALE 
prompt ======================
prompt
CREATE TABLE animale (
id_animal NUMBER(3),
nume_animal VARCHAR2(20),
data_nastere DATE,
greutate_kg NUMBER(3),
id_stapan NUMBER(3),
id_specie NUMBER(2),
CONSTRAINT pk_animal PRIMARY KEY (id_animal),
CONSTRAINT fk_stapan FOREIGN KEY (id_stapan) REFERENCES stapani (id_stapan),
CONSTRAINT fk_specie FOREIGN KEY (id_specie) REFERENCES specii (id_specie)
);

prompt
prompt Creating table VIZITE 
prompt =====================
prompt
CREATE TABLE vizite (
id_vizita NUMBER(3),
id_animal NUMBER(3),
id_med NUMBER(2),
data_vizita DATE NOT NULL,
CONSTRAINT pk_vizita PRIMARY KEY (id_vizita),
CONSTRAINT fk_animal FOREIGN KEY (id_animal) REFERENCES animale (id_animal),
CONSTRAINT fk_med FOREIGN KEY (id_med) REFERENCES medici (id_med)
);

prompt
prompt Creating table PRESCRIPTII 
prompt ==========================
prompt
CREATE TABLE prescriptii (
id_prescriptie NUMBER(3),
id_medicament NUMBER(2),
id_animal NUMBER(3),
id_med NUMBER(2),
CONSTRAINT fk_medicament FOREIGN KEY (id_medicament) REFERENCES
medicamente (id_medicament),
CONSTRAINT fk_animalp FOREIGN KEY (id_animal) REFERENCES animale (id_animal),
CONSTRAINT fk_medp FOREIGN KEY (id_med) REFERENCES medici (id_med)
);

prompt Loading MEDICAMENTE...
INSERT INTO medicamente
VALUES (01, 'Antibiotic injectabil', 'Tetravet');
INSERT INTO medicamente
VALUES (02, 'Antibiotic tableta', 'Synulox');
INSERT INTO medicamente
VALUES (03, 'Antiinflamatoriu', 'Dexafort');
INSERT INTO medicamente
VALUES (04, 'Antihistaminic', 'Ancesol');
INSERT INTO medicamente
VALUES (05, 'Antiparazitar injectabil', 'Eprecis');
INSERT INTO medicamente
VALUES (06, 'Anestezic injectabil', 'Antisedan');
INSERT INTO medicamente
VALUES (07, 'Anestezic oral', 'Tranquiline');
INSERT INTO medicamente
VALUES (08, 'Antiseptic', 'Iodomed');
INSERT INTO medicamente
VALUES (09, 'Probiotic', 'Suiferm');
INSERT INTO medicamente
VALUES (10, 'Antibiotic premix', 'Rhemox');
INSERT INTO medicamente
VALUES (11, 'Antiinflamator uz extern', 'Ecomint');
INSERT INTO medicamente
VALUES (12, 'Ser', 'Canglob');

prompt Loading SPECII...
INSERT INTO specii
VALUES (01, 'Caine de talie mica');
INSERT INTO specii
VALUES (02, 'Caine de talie medie');
INSERT INTO specii
VALUES (03, 'Caine de talie mare');
INSERT INTO specii
VALUES (04, 'Pisica');
INSERT INTO specii
VALUES (05, 'Dihor domestic');
INSERT INTO specii
VALUES (06, 'Iepure domestic');
INSERT INTO specii
VALUES (07, 'Peste tropical');
INSERT INTO specii
VALUES (08, 'Amfibien');
INSERT INTO specii
VALUES (09, 'Reptila');
INSERT INTO specii
VALUES (10, 'Pasare domestica');

prompt Loading SPECIALIZARI...
INSERT INTO specializari
VALUES (01, 'Chirurgie');
INSERT INTO specializari
VALUES (02, 'Anesteziologie');
INSERT INTO specializari
VALUES (03, 'Parazitologie');
INSERT INTO specializari
VALUES (04, 'Radiologie');
INSERT INTO specializari
VALUES (05, 'Farmacologie');
INSERT INTO specializari
VALUES (06, 'Dermatologie');
INSERT INTO specializari
VALUES (07, 'Imagistica diagnostic');
INSERT INTO specializari
VALUES (08, 'Medicina de laborator');
INSERT INTO specializari
VALUES (09, 'Rezidenta');

prompt Loading STAPANI...
INSERT INTO stapani
VALUES (001, 'Carter', 'Mihaela', '6000119090658', 'Aleea Cascadei 40, Bucuresti',
'1234567891', 'mihaelac@gmail.com');
INSERT INTO stapani
VALUES (002, 'Stephens', 'Liliana', '6002319090658', 'Valea Oltului 12, Bucuresti',
'1234567892', 'lilisteph@gmail.com');
INSERT INTO stapani
VALUES (003, 'Cross', 'Damian', '5000119040658', 'Strada Timisoarei 90, Domnesti',
'1234567893', 'damiancross@gmail.com');
INSERT INTO stapani
VALUES (004, 'Lawson', 'Kiley', '6000119880658', 'Aleea Parva 55, Bucuresti', '1234567894',
'lawsonk@gmail.com');
INSERT INTO stapani
VALUES (005, 'Smith', 'Andrei', '5500119090658', 'Strada Veghea 60, Straulesti',
'1234567895', 'andreismith@gmail.com');
INSERT INTO stapani
VALUES (006, 'Simon', 'Elena', '6000155090658', 'Bulevardul Aviatiei 22, Bucuresti',
'1234567896', 'elenas@gmail.com');
INSERT INTO stapani
VALUES (007, 'Bell', 'Roman', '5430119090658', 'Bulevardul Unirii 78, Bucuresti',
'1234567897', 'romanbell@gmail.com');
INSERT INTO stapani
VALUES (008, 'Arias', 'Carina', '6000189090658', 'Drumul Furcii 8, Domnesti', '1234567898',
'ariascarina@gmail.com');
INSERT INTO stapani
VALUES (009, 'Nolan', 'Antonio', '5000619090658', 'Strada Eminescu 50, Bucuresti',
'1234567899', 'toninolan@gmail.com');
INSERT INTO stapani
VALUES (010, 'Hill', 'Karen', '6000177090658', 'Aleea Frumoasa 3, Bucuresti', '1234567811',
'karenhill@gmail.com');
INSERT INTO stapani
VALUES (011, 'Esposito', 'Gia', '6033119090658', 'Strada Rosetti, Bucuresti', '1234567822',
'giaesposito@gmail.com');
INSERT INTO stapani
VALUES (012, 'Lupu', 'Nicoleta', '6000119055558', 'Drumul Doftanei 34, Domnesti',
'1234567833', 'lupunicoleta@gmail.com');

prompt Loading MEDICI...
INSERT INTO medici
VALUES (01, 'Nicu', 'Luisa', '9876543210', TO_DATE('15-06-2007', 'DD-MM-YYYY'),
TO_DATE('30-04-2018', 'DD-MM-YYYY'), 02);
INSERT INTO medici
VALUES (02, 'Miguel', 'Marian', '9876543211', TO_DATE('25-06-2021', 'DD-MM-YYYY'),
TO_DATE('01-12-2021', 'DD-MM-YYYY'), 09);
INSERT INTO medici
VALUES (03, 'Matei', 'Irina', '9876543212', TO_DATE('17-07-2010', 'DD-MM-YYYY'),
TO_DATE('15-10-2018', 'DD-MM-YYYY'), 06);
INSERT INTO medici
VALUES (04, 'Hernandez', 'Livia', '9876543213', TO_DATE('20-07-2008', 'DD-MM-YYYY'),
TO_DATE('11-05-2018', 'DD-MM-YYYY'), 01);
INSERT INTO medici
VALUES (05, 'Roberts', 'Saul', '9876543214', TO_DATE('28-06-2008', 'DD-MM-YYYY'),
TO_DATE('31-03-2016', 'DD-MM-YYYY'), 04);
INSERT INTO medici
VALUES (06, 'Jordan', 'Elizabeta', '9876543215', TO_DATE('16-06-2017', 'DD-MM-YYYY'),
TO_DATE('29-08-2018', 'DD-MM-YYYY'), 07);
INSERT INTO medici
VALUES (07, 'Morgan', 'Harry', '9876543216', TO_DATE('05-12-2019', 'DD-MM-YYYY'),
TO_DATE('13-08-2020', 'DD-MM-YYYY'), 05);
INSERT INTO medici
VALUES (08, 'Constantine', 'Farrah', '9876543217', TO_DATE('29-07-2014',
'DD-MM-YYYY'), TO_DATE('12-05-2017', 'DD-MM-YYYY'), 03);
INSERT INTO medici
VALUES (09, 'George', 'Carmen', '9876543218', TO_DATE('23-06-2020', 'DD-MM-YYYY'),
TO_DATE('23-06-2022', 'DD-MM-YYYY'), 09);
INSERT INTO medici
VALUES (10, 'Dumitrescu', 'Iulia', '9876543219', TO_DATE('30-08-2014', 'DD-MM-YYYY'),
TO_DATE('14-11-2021', 'DD-MM-YYYY'), 01);
INSERT INTO medici
VALUES (11, 'Milton', 'Alex', '9876543222', TO_DATE('30-06-2015', 'DD-MM-YYYY'),
TO_DATE('30-09-2019', 'DD-MM-YYYY'), 08);

prompt Loading ANIMALE...
INSERT INTO animale
VALUES (001, 'Cookie', TO_DATE('22-06-2019', 'DD-MM-YYYY'), 7, 001, 04);
INSERT INTO animale
VALUES (002, 'Spot', TO_DATE('13-05-2016', 'DD-MM-YYYY'), 25, 012, 02);
INSERT INTO animale
VALUES (003, 'Fluffy', TO_DATE('15-08-2013', 'DD-MM-YYYY'), 45, 009, 03);
INSERT INTO animale
VALUES (004, 'Gigel', TO_DATE('26-12-2020', 'DD-MM-YYYY'), 2, 007, 08);
INSERT INTO animale
VALUES (005, 'Chico', TO_DATE('12-10-2019', 'DD-MM-YYYY'), 24, 005, 02);
INSERT INTO animale
VALUES (006, 'Jimmy', TO_DATE('17-06-2018', 'DD-MM-YYYY'), 4, 001, 09);
INSERT INTO animale
VALUES (007, 'Spike', TO_DATE('27-10-2010', 'DD-MM-YYYY'), 55, 003, 03);
INSERT INTO animale
VALUES (008, 'Mabel', TO_DATE('18-06-2020', 'DD-MM-YYYY'), 8, 002, 04);
INSERT INTO animale
VALUES (009, 'Costel', TO_DATE('02-04-2017', 'DD-MM-YYYY'), 53, 004, 03);
INSERT INTO animale
VALUES (010, 'Misty', TO_DATE('23-07-2015', 'DD-MM-YYYY'), 26, 006, 02);
INSERT INTO animale
VALUES (011, 'Brownie', TO_DATE('11-02-2021', 'DD-MM-YYYY'), 3, 008, 06);
INSERT INTO animale
VALUES (012, 'Regele', TO_DATE('19-04-2009', 'DD-MM-YYYY'), 8, 010, 01);
INSERT INTO animale
VALUES (013, 'Coco', TO_DATE('27-08-2019', 'DD-MM-YYYY'), 2, 011, 10);
INSERT INTO animale
VALUES (014, 'Jerry', TO_DATE('24-02-2020', 'DD-MM-YYYY'), 3, 005, 05);
INSERT INTO animale
VALUES (015, 'Colt', TO_DATE('08-06-2013', 'DD-MM-YYYY'), 49, 009, 03);
INSERT INTO animale
VALUES (016, 'Tom', TO_DATE('23-05-2017', 'DD-MM-YYYY'), 7, 012, 04);

prompt Loading VIZITE...
INSERT INTO vizite
VALUES(001, 008, 01, TO_DATE('02-02-2022', 'DD-MM-YYYY'));
INSERT INTO vizite
VALUES(002, 012, 08, TO_DATE('02-02-2022', 'DD-MM-YYYY'));
INSERT INTO vizite
VALUES(003, 016, 04, TO_DATE('03-02-2022', 'DD-MM-YYYY'));
INSERT INTO vizite
VALUES(004, 002, 09, TO_DATE('06-02-2022', 'DD-MM-YYYY'));
INSERT INTO vizite
VALUES(005, 014, 05, TO_DATE('09-02-2022', 'DD-MM-YYYY'));
INSERT INTO vizite
VALUES(006, 014, 10, TO_DATE('13-02-2022', 'DD-MM-YYYY'));
INSERT INTO vizite
VALUES(007, 002, 01, TO_DATE('04-02-2022', 'DD-MM-YYYY'));

prompt Loading PRESCRIPTII...
INSERT INTO prescriptii
VALUES(001, 09, 008, 01);
INSERT INTO prescriptii
VALUES(002, 07, 008, 01);
INSERT INTO prescriptii
VALUES(003, 01, 012, 08);
INSERT INTO prescriptii
VALUES(004, 03, 016, 04);
INSERT INTO prescriptii
VALUES(005, 06, 002, 09);
INSERT INTO prescriptii
VALUES(006, 07, 014, 05);
INSERT INTO prescriptii
VALUES(007, 02, 002, 01);
INSERT INTO prescriptii
VALUES(008, 03, 002, 01);

prompt
prompt Modifying table MEDICI
prompt=======================
prompt
ALTER TABLE medici
ADD salariul NUMBER(8,2);
UPDATE medici SET salariul = 4000;

INSERT INTO medici
VALUES(12, 'Gheorghe', 'Patricia', '8876543222', TO_DATE('23-02-2014', 'DD-MM-YYYY'),
TO_DATE('10-11-2020', 'DD-MM-YYYY'), 05, 5000);

ALTER TABLE medici
ADD comision NUMBER(2,2);

UPDATE medici
SET comision = 0.3
WHERE (ROUND((SYSDATE - data_angajarii)/365) >= 2);
UPDATE medici
SET comision = 0.5
WHERE (ROUND((SYSDATE - data_angajarii)/365) >= 5);

prompt
prompt Modifying table VIZITE
prompt=======================
prompt
ALTER TABLE vizite
ADD pret NUMBER(8,2);

UPDATE vizite
SET pret = 100;
UPDATE vizite
SET pret = 300
WHERE id_med BETWEEN 1 AND 5;

prompt
prompt Modifying table PRESCRIPTII
prompt============================
prompt
ALTER TABLE prescriptii
ADD doza_mg NUMBER(8,2);

UPDATE prescriptii
SET doza_mg = 200;
UPDATE prescriptii
SET doza_mg = 300
WHERE id_medicament BETWEEN 1 AND 3; 
UPDATE prescriptii
SET doza_mg = 500
WHERE id_medicament BETWEEN 7 AND 12;

COMMIT;

INSERT INTO vizite
VALUES(008, 008, 01, TO_DATE('02-03-2022', 'DD-MM-YYYY'), 400);
INSERT INTO vizite
VALUES(009, 016, 08, TO_DATE('04-03-2022', 'DD-MM-YYYY'), 300);
INSERT INTO vizite
VALUES(010, 001, 03, TO_DATE('10-03-2022', 'DD-MM-YYYY'), 250);
INSERT INTO vizite
VALUES(011, 009, 09, TO_DATE('16-03-2022', 'DD-MM-YYYY'), 450);
INSERT INTO vizite
VALUES(012, 015, 05, TO_DATE('17-03-2022', 'DD-MM-YYYY'), 100);
INSERT INTO vizite
VALUES(013, 015, 01, TO_DATE('17-03-2022', 'DD-MM-YYYY'), 70);
INSERT INTO vizite
VALUES(014, 002, 01, TO_DATE('20-03-2022', 'DD-MM-YYYY'), 500);

COMMIT;