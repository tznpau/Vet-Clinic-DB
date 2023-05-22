-- Sa se realizeze un pachet pentru gestiunea tabelei medici, care sa contina urmatoarele subprograme:

-- o procedura prin care sa se mareasca salariul unui medic primit ca parametru cu un procent primit ca parametru (procentul trebuie sa se afle in intervalul (1, 50))
-- Sa se trateze exceptiile pentru cazul in care id-ul dat ca parametru nu este gasit, sau procentul dat ca parametru nu respecta restrictia

-- o procedura prin care sa se actualizeze salariul tuturor medicilor cu o marire de 15% folosind un apel al subprogramului mareste_sal creat anterior

-- o functie care returneaza un mesaj in functie de id-ul medicului transmis ca parametru
-- afiseaza 'Comision mare' pentru comision > 0.5
-- aifseaza 'Comision mediu' pentru comision >= 0.1 si <= 0.5
-- afiseaza 'Comision inexistent' in rest

CREATE OR REPLACE PACKAGE pac_medici
AS  
    PROCEDURE mareste_sal
    (p_id_med IN medici.id_med%TYPE,
    p_procent IN NUMBER);
    PROCEDURE actualizare_sal_med;
    FUNCTION ce_comision(p_id_med medici.id_med%TYPE) RETURN VARCHAR2;
END;
/    

CREATE OR REPLACE PACKAGE BODY pac_medici
AS  
    PROCEDURE mareste_sal (p_id_med IN medici.id_med%TYPE,
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

    PROCEDURE actualizare_sal_med
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

    FUNCTION ce_comision(p_id_med medici.id_med%TYPE)
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
    END ce_comision;
END;
/

BEGIN   
    pac_medici.actualizare_sal_med;
END;
/

-- Sa se realizeze un pachet pentru gestiunea tabelei animale, care sa contina urmatoarele subprograme:

-- o functie care verifica daca id-ul unui animal este valid

-- o functie care returneaza numele si stapanul unui animal dat ca parametru prirn id

-- o procedura care afiseaza animalele nascute dupa 04-FEB-2013

CREATE OR REPLACE PACKAGE pac_animale
AS  
    FUNCTION id_a_valid(p_id_animal IN animale.id_animal%TYPE) RETURN BOOLEAN;
    FUNCTION info_animal(p_id_animal IN animale.id_animal%TYPE) RETURN VARCHAR2;
    PROCEDURE afiseaza_animale;
END pac_animale;
/

CREATE OR REPLACE PACKAGE BODY pac_animale 
AS
    FUNCTION id_a_valid(p_id_animal IN animale.id_animal%TYPE)
    RETURN BOOLEAN
    IS
        v_id_exist NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO v_id_exist
        FROM animale
        WHERE id_animal = p_id_animal;
    RETURN 1 = v_id_exist;
    EXCEPTION   
        WHEN OTHERS THEN
        RETURN FALSE;
    END id_a_valid;

    FUNCTION info_animal(p_id_animal IN animale.id_animal%TYPE) 
    RETURN VARCHAR2
    IS
        v_info VARCHAR(100);
    BEGIN
        SELECT a.nume_animal || ' -> ' || s.nume_stapan || ' ' || s.prenume_stapan INTO v_info FROM animale a, stapani s
        WHERE id_animal = p_id_animal AND a.id_stapan = s.id_stapan;

        RETURN v_info;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN 'Nu exista animalul cautat';
    END info_animal;

    PROCEDURE afiseaza_animale
    IS
        CURSOR c IS SELECT nume_animal, data_nastere FROM animale;
    BEGIN
        FOR rec IN c LOOP
            IF rec.data_nastere > TO_DATE('04-02-2013', 'DD-MM-YYYY') THEN
                DBMS_OUTPUT.PUT_LINE(rec.nume_animal);
            END IF;
        END LOOP;
    END afiseaza_animale;
END;
/

BEGIN
    DBMS_OUTPUT.PUT_LINE(pac_animale.info_animal(&id));
END;
/







    




