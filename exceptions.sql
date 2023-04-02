-- LUCRUL CU EXCEPTII

-- Exceptii predefinite

-- Afisati numele, greutatea si data nasterii pentru animalele al caror id al speciei este citit de la tastatura (test: id_specie = 8)

-- Tratati cazul in care nu exista niciun animal apartinand speciei (test: id_specie = 7)
-- Sa se afiseze mesajul 'Nu este inregistrat niciun animal apartinand speciei cu ID ...'

-- Tratati cazul in care exista mai multe animale apartinand speciei (test: id_specie = 3)
-- Sa se afiseze mesajul 'Sunt inregistrate multiple animale apartinand speciei cu ID ...'

-- Tratati alte erori care ar putea sa apara


SET SERVEROUTPUT ON

DECLARE
    --variabile pentru animale
    v_nume_animal animale.nume_animal%TYPE;
    v_greutate_kg animale.greutate_kg%TYPE;
    v_data_nastere animale.data_nastere%TYPE;
    --variabila pentru id_specie citit de la tastatura
    v_id_specie animale.id_specie%TYPE := &id_dat;

BEGIN
    SELECT nume_animal, greutate_kg, data_nastere INTO v_nume_animal, v_greutate_kg, v_data_nastere FROM animale
    WHERE id_specie = v_id_specie;
    DBMS_OUTPUT.PUT_LINE('Nume animal: ' || v_nume_animal || ' ; Greutate (kg): ' || v_greutate_kg || ' ; Data nasterii: ' || v_data_nastere || ' ; ID Specie: ' || v_id_specie);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Nu este inregistrat niciun animal apartinand speciei cu ID ' || v_id_specie);
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('Sunt inregistrate multiple animale apartinand speciei cu ID ' || v_id_specie);
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Un alt tip de eroare s-a generat');
END;
/

-- Exceptii non-predefinite

-- Adaugati un nou client in tabela stapani cu urmatoarele date:
-- INSERT INTO stapani VALUES (100, 'Ion', 'John','1000119090658', NULL, '123456789', NULL);

-- Se va genera urmatorul mesaj de eroare
--Error report - ORA-02290: check constraint(TINTAREANUP_61.LUNGIME_TELEFON_STAPAN) violated
-- deoarece restrictia de integritate privind lungime numarului de telefon (= 10) a fost incalcata

-- Tratati aceasta situatie afisand mesajul corespunzator

DECLARE
    telefon_excep EXCEPTION;
    PRAGMA EXCEPTION_INIT(telefon_excep, -02290);

BEGIN
    INSERT INTO stapani (id_stapan, nume_stapan, prenume_stapan, cnp_stapan, adresa_stapan, telefon_stapan, email_stapan)
    VALUES (100, 'Ion', 'John','1000119090658', NULL, '123456789', NULL);

EXCEPTION
    WHEN telefon_excep THEN
        DBMS_OUTPUT.PUT_LINE('Informatia data nu este acceptata. Numarul de telefon nu a fost introdus corect');
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/

-- Exceptii definite de programator

-- Tratati situatia in care user-ul modifica denumirea unei specializari al carei id nu exista (test: set numele specializari 'Nefrologie' pentru id_specializare 99)

DECLARE
    e_specializare_invalida EXCEPTION;
    v_nume_specializare specializari.nume_specializare%TYPE := 'Nefrologie';
    v_id_specializare specializari.id_specializare%TYPE := 99;

BEGIN
    UPDATE specializari
    SET nume_specializare = v_nume_specializare
    WHERE id_specializare = v_id_specializare;
    IF SQL%NOTFOUND THEN
        RAISE e_specializare_invalida;
    END IF;

EXCEPTION
    WHEN e_specializare_invalida THEN
        DBMS_OUTPUT.PUT_LINE('Nu exista acest ID pentru specializari');
END;
/

-- Creati un bloc PL/SQL pentru a sterge un client din tabela stapani.
-- Tratati cazul in care numele introdus de la tastatura este invalid (nu exista)
-- Daca acest caz se aplica, se va afisa o lista de nume valide din care user-ul poate alege

DECLARE
    e_nume EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_nume, -20999);
    v_nume_stapan stapani.nume_stapan%TYPE := '&nume_stapan';

BEGIN
    DELETE FROM stapani
    WHERE nume_stapan = v_nume_stapan;

    IF SQL%ROWCOUNT = 0 THEN
        RAISE_APPLICATION_ERROR(-20999, 'Numele este invalid');
    ELSE 
        DBMS_OUTPUT.PUT_LINE(v_nume_stapan || ' a fost sters');
    END IF;

EXCEPTION
    WHEN e_nume THEN
        DBMS_OUTPUT.PUT_LINE('Numele valide sunt urmatoarele: ');
        FOR c IN (SELECT DISTINCT nume_stapan FROM stapani) LOOP
            DBMS_OUTPUT.PUT_LINE(c.nume_stapan);
        END LOOP;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Un alt tip de eroare s-a generat');
        --obs: deoarece toate inregistrarile din tabela stapani au dependente in alte tabele, aceasta eroare se va afisa si cand introducem un nume valid
END;
/