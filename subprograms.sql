-- LUCRUL CU SUBPROGRAME

-- Sa se realizeze o procedura prin care sa se mareasca salariul unui medic primit ca parametru cu un procent primit ca parametru (procentul trebuie sa se afle in intervalul (1, 50))
-- Sa se trateze exceptiile pentru cazul in care id-ul dat ca parametru nu este gasit, sau procentul dat ca parametru nu respecta restrictia

CREATE OR REPLACE PROCEDURE mareste_sal
    (p_id_med IN medici.id_med%TYPE,
    p_procent IN NUMBER)
IS
    procent_gresit EXCEPTION;
BEGIN
    UPDATE medici
    SET salariul = salariul * (1 + p_procent/100)
    WHERE id_med = p_id_med;
    IF p_procent <= 1 OR p_procent >= 50 THEN
        RAISE procent_gresit;
    END IF;
EXCEPTION
    WHEN procent_gresit THEN
    DBMS_OUTPUT.PUT_LINE('Procentul introdus este invalid.');
    WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Nu s-a gasit medicul cu id ' || p_id_med);
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Un alt tip de eroare s-a generat');
END mareste_sal;
/

SET SERVEROUTPUT ON

BEGIN
    mareste_sal(1, 10);
    mareste_sal(2, 5);
    mareste_sal(5, 20);
    mareste_sal(7, 9);
    mareste_sal(3, 30);
END;
/

-- Sa se realizeze o procedura prin care sa se actualizeze salariul tuturor medicilor cu o marire de 15% folosind un apel al subprogramului mareste_sal creat anterior

CREATE OR REPLACE PROCEDURE actualizare_sal_med
IS
    CURSOR c_med IS
        SELECT id_med 
        FROM medici;
BEGIN
    FOR v_med_rec IN c_med
    LOOP
        mareste_sal(v_med_rec.id_med, 15);
    END LOOP;
END actualizare_sal_med;
/

BEGIN
    actualizare_sal_med;
END;
/

-- Sa se realizeze un subprogram prin care se adauga un nou medicament in tabela medicamente
-- Procedura va primi ca parametru id-ul medicamentului, numele, si denumirea brandului. Sa se dea valori default 'N/A' pentru cei doi parametri

CREATE SEQUENCE medicamente_seq
START WITH 13
INCREMENT BY 1
NOCACHE
NOCYCLE;
/

CREATE OR REPLACE PROCEDURE add_medicament
    (p_nume_medicament medicamente.nume_medicament%TYPE := 'N/A',
    p_brand medicamente.brand%TYPE DEFAULT 'N/A'
    )
IS
BEGIN
    INSERT INTO medicamente(id_medicament, nume_medicament, brand) 
    VALUES (medicamente_seq.NEXTVAL, p_nume_medicament, p_brand);
END add_medicament;
/

BEGIN
    add_medicament('Tratament preventiv', 'Advantix');
    add_medicament;
END;
/

-- Sa se realizeze o functie care verifica daca un id al unui client stapan este valid (luat)

CREATE OR REPLACE FUNCTION id_s_valid
    (p_id_stapan IN NUMBER)
RETURN BOOLEAN
AS
v_id_exist NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_id_exist
    FROM stapani
    WHERE id_stapan = p_id_stapan;
RETURN 1 = v_id_exist;
EXCEPTION   
    WHEN OTHERS THEN
    RETURN FALSE;
END id_s_valid;
/

DECLARE
    v_id_s NUMBER;
BEGIN
    v_id_s := &id;
    IF id_s_valid(v_id_s)
    THEN
        DBMS_OUTPUT.PUT_LINE('ID ' || v_id_s || ' este valid.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('ID ' || v_id_s || ' nu este valid.');
    END IF;
END;

-- Sa se realizeze o functie care returneaza un mesaj in functie de id-ul medicului transmis ca parametru
-- afiseaza 'Comision mare' pentru comision > 0.5
-- aifseaza 'Comision mediu' pentru comision >= 0.1 si <= 0.5
-- afiseaza 'Comision inexistent' in rest

CREATE OR REPLACE FUNCTION ce_comision(p_id_med medici.id_med%TYPE)
RETURN VARCHAR2
IS
    v_comision medici.comision%TYPE;
BEGIN
    SELECT comision INTO v_comision FROM medici
    WHERE id_med = p_id_med;
    IF v_comision > 0.5 THEN
        RETURN 'Comision mare';
    ELSIF v_comision BETWEEN 0.1 AND 0.5 THEN
        RETURN 'Comision mediu';
    ELSE
        RETURN 'Comision inexistent';
    END IF;
EXCEPTION   
    WHEN NO_DATA_FOUND THEN
        RETURN 'ID-ul cautat nu este asociat cu niciun medic';
END;
/

BEGIN   
    DBMS_OUTPUT.PUT_LINE(ce_comision(&id));
END;
/