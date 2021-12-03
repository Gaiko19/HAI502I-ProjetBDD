/*  ===========================
    |  Création des fonctions |
    ===========================
*/  

prompt "Création des fonctions"

/*  ===========================
    |  Création calculCapaMax |
    ===========================
*/  
-- Renvoie la capacité max du village en fonction du niveau du village

CREATE OR REPLACE FUNCTION calculCapaMax (num IN INTEGER) 
RETURN INTEGER IS nb INTEGER;
BEGIN 
  IF num < 20 THEN nb := 100;
  ELSIF num < 50 THEN nb := 140;
  ELSIF num < 80 THEN nb := 180;
  ELSIF num < 120 THEN nb := 220;
  ELSIF num < 175 THEN nb := 260;
  ELSE nb := 300;
  END IF;
  RETURN (nb);
END; 

prompt "calculCapaMax créée"

/*  ===============================
    |  Création calculQuantiteMax |
    ===============================
*/  
-- Renvoie la quantité de ressource maximale du village en fonction du niveau du village


CREATE OR REPLACE FUNCTION calculQuantiteMax (id IN INTEGER) 
RETURN INTEGER IS nb INTEGER;
num INTEGER;
BEGIN
  SELECT niveauJoueur INTO num FROM Village WHERE idVillage=id;
  IF num < 20 THEN nb := 100;
  ELSIF num < 50 THEN nb := 140;
  ELSIF num < 80 THEN nb := 180;
  ELSIF num < 120 THEN nb := 220;
  ELSIF num < 175 THEN nb := 260;
  ELSE nb := 300;
  END IF;
  RETURN (nb);
END; 

prompt Fonction créée
