/* 
Nom du joueur en majuscule 
*/

CREATE OR REPLACE TRIGGER NomJoueurMajuscule
BEFORE INSERT ON Village
FOR EACH ROW
SET NEW.nomJoueur = UPPER(NEW.nomJoueur);

CREATE OR REPLACE TRIGGER SupprimerJoueurClan
AFTER DELETE ON Village
FOR EACH ROW 
UPDATE clan 
SET membresMax = membresMax - 1
WHERE Clan.idVillage = old.idVillage;

CREATE OR REPLACE TRIGGER AjoutVillage
AFTER INSERT
ON Village
FOR EACH ROW 
UPDATE capaciteeCampMax
SET capaciteeCampMax = capaciteeCampMax + 50;

CREATE OR REPLACE TRIGGER nouveauVillage
BEFORE INSERT ON Village 
FOR EACH ROW
WHEN (new.no_line > 0)
DECLARE
  evol_exemple number;
BEGIN
  evol_exemple := :new.exemple  - :old.exemple;
  DBMS_OUTPUT.PUT_LINE('  evolution : ' || evol_exemple);
END;

/*
[trigger pour créer une troupe en vérifiant qu'on a la place et les sous]
[trigger pour ajouter l'argent gagné après une attaque et l'enlever au défenseur]
*/