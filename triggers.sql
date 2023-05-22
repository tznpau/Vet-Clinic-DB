-- Sa se creeze un trigger care asigura securitatea datelor din tabela medici.
-- Acest trigger trebuie sa previna inserarea unei noi intrari in tabela
-- in afara intervalului orar de munca Luni - Sambata ; 08:00 - 20:00

CREATE OR REPLACE TRIGGER securitate_med
BEFORE INSERT ON medici
BEGIN
    IF (TO_CHAR(SYSDATE, 'DY') IN ('SUN')) OR (TO_CHAR(SYSDATE, 'HH24:MI') NOT BETWEEN '08:00' AND '20:00') THEN
        RAISE_APPLICATION_ERROR(-20500, 'Atentie! Nu se pot adauga medici in afara orelor de program.');
    END IF;
END;
/

-- test in afara programului stabilit
INSERT INTO medici
VALUES (22, 'Maricica', 'Maria', '9876533310', TO_DATE('15-06-2007', 'DD-MM-YYYY'),
TO_DATE('30-04-2018', 'DD-MM-YYYY'), 02, 4000, 0.5);


-- Sa se creeze un trigger care sa poata fi declansat pentru diferite tipuri de comenzi (INSERT, UPDATE [OF coloana] OR DELETE),
-- folosind 3 functii booleene prin care sa se indice tipul operatiei executate

CREATE TABLE clinic_log
(tip CHAR(1),
username VARCHAR2(100),
data DATE DEFAULT SYSDATE);

CREATE OR REPLACE TRIGGER trig_log
BEFORE INSERT OR UPDATE OR DELETE ON stapani
DECLARE
    v_tip clinic_log.tip%TYPE;
BEGIN
    CASE
    WHEN INSERTING THEN
        v_tip := 'I';
    WHEN UPDATING THEN
        v_tip := 'U';
    ELSE
        v_tip := 'D';
    END CASE;

    INSERT INTO clinic_log(tip, username, data) 
    VALUES(v_tip, user, SYSDATE);
END;
/

-- test
UPDATE stapani
SET adresa_stapan = 'Aleea Masa Tacerii 14, Bucuresti'
WHERE id_stapan = 8;

SELECT * FROM clinic_log;


-- Sa se creeze un trigger care sa previna stergerea obiectelor din schema
-- Sa se dezactiveze acest trigger dupa testare

CREATE OR REPLACE TRIGGER trig_preventie_stergere
BEFORE DROP ON SCHEMA 
BEGIN
    RAISE_APPLICATION_ERROR(-20203, 'Incercare esuata de stergere a obiectului');
END;
/

-- test
DROP TABLE vizite;

-- dezactivare trigger
ALTER TRIGGER trig_preventie_stergere DISABLE;
-- stergere trigger
DROP TRIGGER trig_preventie_stergere;


-- Sa se creeze un INSTEAD OF trigger astfel:

-- Sa se creeze un view care selecteaza medicii din camera de garda: chirurgi, anesteziologi si rezidenti
-- (id-uri: 1, 2, respectiv 9)

CREATE OR REPLACE VIEW view_er
AS
    SELECT m.id_med, m.nume_med, m.prenume_med, m.telefon_med, m.data_absolvire, m.data_angajarii, m.id_specializare, m.salariul, m.comision,
    s.nume_specializare
    FROM medici m, specializari s
    WHERE m.id_specializare = s.id_specializare
    AND m.id_specializare IN (1, 2, 9);
    
SELECT * FROM view_er;
    
-- Dorim sa facem o inserare in view-ul creat, un medic cu o specializare noua, Cardiologie
INSERT INTO view_er
VALUES (20, 'Gheorghe', 'Gheorghescu', '1116543222', TO_DATE('30-06-2016', 'DD-MM-YYYY'),
TO_DATE('30-09-2020', 'DD-MM-YYYY'), 10, 4000, 0.5, 'Cardiologie');

-- Sa se creeze un trigger trig_er cu optiunea INSTEAD OF care sa permita operatia de INSERT pe view

CREATE OR REPLACE TRIGGER trig_er
INSTEAD OF INSERT OR UPDATE OR DELETE ON view_er
FOR EACH ROW
BEGIN
    IF inserting THEN
        INSERT INTO specializari (id_specializare, nume_specializare)
        VALUES (:new.id_specializare, :new.nume_specializare);
        INSERT INTO medici (id_med, nume_med, prenume_med, telefon_med, data_absolvire, data_angajarii, id_specializare, salariul, comision)
        VALUES (:new.id_med, :new.nume_med, :new.prenume_med, :new.telefon_med, :new.data_absolvire, :new.data_angajarii, :new.id_specializare, :new.salariul, :new.comision);
    
    ELSIF deleting THEN
        DELETE FROM medici WHERE id_specializare = :old.id_specializare;
    
    ELSIF updating('nume_med') THEN
        UPDATE medici
        SET nume_med = :new.nume_med
        WHERE id_med = :old.id_med;
    
    ELSIF updating('nume_specializare') THEN
        UPDATE specializari
        SET nume_specializare = :new.nume_specializare
        WHERE id_specializare = :old.id_specializare;
    END IF;
END;
        
-- a fost nevoie de dezactivarea unui trigger creat anterior    
 ALTER TRIGGER securitate_med DISABLE;  

