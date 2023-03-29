--Operații de actualizare

--1. Sa se adauge o nouă coloana in tabela medici care listeaza salariul acestora.
-- se va inițializa salariul cu 4000.
ALTER TABLE medici
ADD salariul NUMBER(8,2);
UPDATE medici SET salariul = 4000;

--2. Sa se adauge o nouă intrare în tabela medici.
INSERT INTO medici
VALUES(12, 'Gheorghe', 'Patricia', '8876543222', TO_DATE('23-02-2014', 'DD-MM-YYYY'),
TO_DATE('10-11-2020', 'DD-MM-YYYY'), 05, 5000);

--3. Sa se șteargă prescriptiile unde id-ul animalului este 2.
DELETE from prescriptii
WHERE id_animal = 002;
ROLLBACK;

--4. Sa se modifice data angajării a medicului al cărui id este 1.
UPDATE medici
SET data_angajarii = TO_DATE('17-07-2016', 'DD-MM-YYYY')
WHERE id_med = 01;

--5. Sa se modifice salariul la 6000 pentru medicii ce au fost angajați la clinica
-- înainte de 2018
UPDATE medici
SET salariul = 6000
WHERE EXTRACT(YEAR FROM data_angajarii) < 2018;

--6. Sa se creeze o copie a tabelei medicamente.
--7. Sa se stearga datele din copia tabelei medicamente.
TRUNCATE TABLE copie_medicamente;

--8. Sa se stearga complet copia tabelei medicamente.
DROP TABLE copie_medicamente;

--9. Sa se adauge o noua coloana in tabela medici care listeaza comisionul acestora.
-- acesta va fi initializat cu null.
ALTER TABLE medici
ADD comision NUMBER(2,2);

--10. Sa se adauge o noua coloana in tabela vizite care listeaza pretul vizitei.
ALTER TABLE vizite
ADD pret NUMBER(8,2);

--11. Sa se adauge un comision de 0.3 pentru medicii cu vechime mai mare sau egala de 2
--ani,
-- si un comision de 0.4 pentru medicii cu vechime mai mare sau egala de 5 ani.
UPDATE medici
SET comision = 0.3
WHERE (ROUND((SYSDATE - data_angajarii)/365) >= 2);
UPDATE medici
SET comision = 0.5
WHERE (ROUND((SYSDATE - data_angajarii)/365) >= 5);

--Interogări

--1. Sa se afiseze numele complet al medicului, salariul cu simbol monetar, data angajarii,
-- si vechimea in ani.
SELECT nume_med || ' ' || prenume_med AS "Nume medic", salariul || '$' AS "Salariul",
data_angajarii AS "Data Angajare",
ROUND((SYSDATE - data_angajarii)/365) AS "Vechime in munca"
FROM medici;

--2. Sa se afiseze numarul de animale care au varsta mai mare sau egala de 5 ani.
SELECT COUNT(id_animal)
FROM animale
WHERE (ROUND((SYSDATE - data_nastere)/365) >= 5);

--3. Sa se afiseze numarul de animale detinute de fiecare stapan.
-- sa se ordoneze crescator lista rezultata.
SELECT id_stapan, COUNT(id_animal) AS "Numar animale"
FROM animale
GROUP BY id_stapan
ORDER BY 1 ASC;

--4. Sa se afiseze numarul medicilor pe specializari.
SELECT id_specializare, COUNT(id_med) AS "Numar medici"
FROM medici
GROUP BY id_specializare
ORDER BY 1 ASC;

--5. Sa se afiseze salariul maxim si salariul minim din tabela medici.
SELECT MAX(salariul) AS "Salariul maxim", MIN(salariul) AS "Salariul minim"
FROM medici;

--6. Sa se afiseze cate specializari distincte sunt alocate medicilor.
SELECT COUNT(DISTINCT id_specializare) AS "Specializari"
FROM medici;

--7. Sa se afiseze numele complet al medicului si numele specializarii pe care o detine.
SELECT m.nume_med || ' ' || m.prenume_med AS "Nume medic", s.nume_specializare AS
"Specializare"
FROM medici m, specializari s
WHERE m.id_specializare = s.id_specializare;

--8. Sa se afiseze id-ul specializarii, numele specializarii, si numarul de medici din fiecare
--specializare.
-- rezultatul se va ordona alfabetic dupa numele specializarii.
SELECT s.id_specializare, s.nume_specializare, COUNT(m.id_med) AS "Numar medici"
FROM specializari s, medici m
WHERE s.id_specializare = m.id_specializare
GROUP BY s.id_specializare, s.nume_specializare
ORDER BY 2 ASC;

--9. Sa se afiseze numele stapanului, id-ul acestuia, adresa si numarul de animale
-- pentru stapanii care locuiesc in Bucuresti.
-- rezultatul va fi ordonat alfabetic dupa numele stapanilor.
SELECT st.id_stapan, st.nume_stapan, st.adresa_stapan, COUNT(a.id_animal) AS "Numar
animale"
FROM stapani st, animale a
WHERE st.id_stapan = a.id_stapan
AND st.adresa_stapan LIKE '%Bucuresti%'
GROUP BY st.id_stapan, st.nume_stapan, st.adresa_stapan
ORDER BY 2 ASC;

--10. Sa se realizeze o jonctiune interna de egalitate intre tabela vizite si tabela medici,
SELECT *
FROM vizite v, medici m
WHERE v.id_med = m.id_med;

--11. Sa se realizeze o jonctiune externa la stanga intre tabela vizite si tabela medici,
SELECT *
FROM vizite v, medici m
WHERE v.id_med = m.id_med (+);

--12. Sa se modifice salariul medicilor astfel:
-- daca id specializare = 1, salariul creste cu 10%
-- daca id specializare = 2, salariul creste cu 5%
-- daca id specializare = 5, salariul creste cu 3%
-- altfel ramane nemodificat
UPDATE medici
SET salariul =
CASE
WHEN id_specializare = 1
THEN salariul * 1.1
WHEN id_specializare = 2
THEN salariul * 1.05
WHEN id_specializare = 5
THEN salariul * 1.03
ELSE salariul
END;

--13. Sa se afiseze numele medicilor si a specializarilor corespondente folosind DECODE.
SELECT nume_med || ' ' || prenume_med AS "Nume medic",
DECODE(id_specializare,
1, 'Chirurgie',
2, 'Anesteziologie',
3, 'Parazitologie',
4, 'Radiologie',
'Alta specializare')
AS "Specializare"
FROM medici
ORDER BY 1 ASC;

--14. Sa se afiseze id-ul medicilor care au avut cel putin o consultatie.
SELECT id_med
FROM medici
INTERSECT
SELECT id_med
FROM vizite;

--15. Sa se afiseze stapanii fara cei care traiesc in Bucuresti.
SELECT * FROM stapani
MINUS
SELECT * FROM stapani WHERE adresa_stapan LIKE '%Bucuresti%';

--16. Sa se afiseze stapanii care traiesc in Bucuresti si in Domnesti.
SELECT * FROM stapani WHERE adresa_stapan LIKE '%Domnesti%'
UNION ALL
SELECT * FROM stapani WHERE adresa_stapan LIKE '%Bucuresti%';

--17. Sa se afiseze numele medicilor cu salariul mai mare decat salariul mediu al tuturor
medicilor.
SELECT nume_med || ' ' || prenume_med AS "Nume medic", salariul
FROM medici
WHERE salariul > (SELECT ROUND(AVG(salariul), 2) FROM medici);

--18. Sa se creeze o tabela virtuala numai cu medicii care au absolvit inainte de 2015
(exclusiv).
CREATE OR REPLACE VIEW medici_inainte_2015
AS
SELECT id_med, nume_med
FROM medici
WHERE EXTRACT(YEAR FROM data_absolvire) < 2015;
SELECT *
FROM medici_inainte_2015;

--19. Sa se creeze un index pe tabela stapani pe coloana nume_stapan.
CREATE INDEX idx_nume ON stapani(UPPER(nume_stapan));
DROP INDEX idx_upper_nume;

--20. Sa se creeze un sinonim pentru tabela medicamente.
CREATE SYNONYM medicam FOR medicamente;

--21. Sa se creeze o secventa pentru tabela Specializari.
CREATE SEQUENCE s_specializari START WITH 1 INCREMENT BY 1 MAXVALUE 30;

--22. Sa se afiseze legatura dintre medici si salariul.
SELECT id_med, salariul, LEVEL
FROM medici
CONNECT BY PRIOR id_med = salariul;