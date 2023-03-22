-- STRUCTURI DE CONTROL SI CURSORI

-- Actualizarea comisionului medicului citit de la tastatura in functie de numarul de vizite efectuate
-- se afiseaza comisionul medicului citit de la tastatura
-- se afiseaza numarul vizitelor efectuate
-- se modifica comisionul astfel:
-- daca medicul a efectuat
-- intre 1-3 vizite => + 0.1 adaugat la comision
-- cel putin 4 vizite => + 0.2 adaugat la comision
-- altfel nu are loc nicio modificare la comision

SET SERVEROUTPUT ON

DECLARE
    --variabile pentru medic: id, nume, comision
    v_id_med medici.id_med%TYPE := &id_med;
    v_nume_med medici.nume_med%TYPE;
    v_comision medici.comision%TYPE;
    --variabila ce va tine nr vizitelor efectuate
    v_nrvizite NUMBER;

BEGIN
    --afisare comision
    SELECT nume_med, comision INTO v_nume_med, v_comision FROM medici
    WHERE id_med = v_id_med;
    DBMS_OUTPUT.PUT_LINE('Medicul ' || v_nume_med || ' are un comision de ' || v_comision);

    --afisare nr vizite
    SELECT COUNT(id_med) INTO v_nrvizite FROM vizite 
    WHERE id_med = v_id_med;
    DBMS_OUTPUT.PUT_LINE('A efectuat un numar de ' || v_nrvizite || ' vizite');

    --actualizarea comisionului
    IF v_nrvizite >= 1 AND v_nrvizite <= 3 THEN
        v_comision := v_comision + 0.1;
    ELSIF v_nrvizite > 3 THEN
        v_comision := v_comision + 0.2;
    END IF; 

    UPDATE medici
    SET comision = v_comision
    WHERE id_med = v_id_med;

    DBMS_OUTPUT.PUT_LINE('Noul comision al medicului este de ' || v_comision);
END;
/

-- Afisarea tuturor vizitelor folosind o structura FOR
-- se va afisa id-ul vizitei, data si pretul acesteia

DECLARE
    --variabile ce vor tine datele despre vizita
    v_data_vizita vizite.data_vizita%TYPE;
    v_pret vizite.pret%TYPE;
    --variabile pentru FOR
    v_idmin vizite.id_vizita%TYPE;
    v_idmax vizite.id_vizita%TYPE;

BEGIN
    SELECT MIN(id_vizita), MAX(id_vizita) INTO v_idmin, v_idmax FROM vizite;
    FOR v_id_vizita IN v_idmin..v_idmax LOOP
        SELECT data_vizita, pret INTO v_data_vizita, v_pret FROM vizite
        WHERE id_vizita = v_id_vizita;
        DBMS_OUTPUT.PUT_LINE('Vizita de pe data de ' || v_data_vizita || ' cu ID ' || v_id_vizita || ' a fost in valoare de ' || v_pret);
    END LOOP;
END;
/

-- Folosind un cursor, afisati toate randurile din tabela stapani
-- se vor afisa id-ul stapanului, numele, prenumele si adresa

DECLARE
    CURSOR cur_stapani IS
        SELECT id_stapan, nume_stapan, prenume_stapan, adresa_stapan FROM stapani;
    v_id_stapan stapani.id_stapan%TYPE;
    v_nume_stapan stapani.nume_stapan%TYPE;
    v_prenume_stapan stapani.prenume_stapan%TYPE;
    v_adresa_stapan stapani.adresa_stapan%TYPE;

BEGIN
    OPEN cur_stapani;
    LOOP
        FETCH cur_stapani INTO v_id_stapan, v_nume_stapan, v_prenume_stapan, v_adresa_stapan;
        EXIT WHEN cur_stapani%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Clientul ' || v_id_stapan || ' cu numele ' || v_nume_stapan || ' ' || v_prenume_stapan || ' locuieste la adresa ' || v_adresa_stapan);
    END LOOP;
    CLOSE cur_stapani;
END;
/

-- Afisarea animalelor paciente cu id-ul intre 2 si 12 printr-un WHILE LOOP
-- se vor afisa numele si greutatea animalutului

DECLARE
    --variabile ce tin datele animalului
    v_id_animal animale.id_animal%TYPE := 2;
    v_nume_animal animale.nume_animal%TYPE;
    v_greutate_kg animale.greutate_kg%TYPE;

BEGIN
    WHILE v_id_animal < 13 LOOP
    SELECT nume_animal, greutate_kg INTO v_nume_animal, v_greutate_kg FROM animale
    WHERE id_animal = v_id_animal;
    DBMS_OUTPUT.PUT_LINE('Animalutul ' || v_nume_animal || ' are ' || v_greutate_kg || ' kg');
    v_id_animal := v_id_animal + 1;
    END LOOP;
END;
/

-- Listarea fiecarei specializari
-- urmata de listarea fiecarui medic cu respectiva specializare

DECLARE
    --cursor pentru specializari
    CURSOR cur_spec IS
        SELECT id_specializare, nume_specializare
        FROM specializari
        ORDER BY nume_specializare;
    --cursor pentru medici
    --va avea ca parametru id-ul specializarii
    CURSOR cur_med (p_id_specializare NUMBER) IS
        SELECT nume_med
        FROM medici
        WHERE id_specializare = p_id_specializare
        ORDER BY nume_med;
    v_specrec cur_spec%ROWTYPE;
    v_medrec cur_med%ROWTYPE;

BEGIN  
    OPEN cur_spec;
    LOOP
        FETCH cur_spec INTO v_specrec;
        EXIT WHEN cur_spec%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Specializarea ' || v_specrec.nume_specializare);

        OPEN cur_med (v_specrec.id_specializare);
        LOOP
            FETCH cur_med INTO v_medrec;
            EXIT WHEN cur_med%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE('- Medic ' || v_medrec.nume_med);
        END LOOP;
        CLOSE cur_med;
    END LOOP;
    CLOSE cur_spec;
END;
/

-- Afisarea medicilor cu specializarea Faramcologie (id = 5) care au un salariu mai mic de 4500 lei

DECLARE
    CURSOR cur_med (p_id_specializare NUMBER, p_salariul NUMBER) IS SELECT id_med, nume_med, prenume_med
    FROM medici
    WHERE id_specializare = p_id_specializare
    AND salariul < p_salariul;

BEGIN
    FOR v_medrec IN cur_med(5, 4500) LOOP
        DBMS_OUTPUT.PUT_LINE('Medicul farmacolog cu salariul mai mic de 4500 lei are ID ' || v_medrec.id_med || ' si numele ' || v_medrec.nume_med || ' ' || v_medrec.prenume_med);
    END LOOP;
END;

