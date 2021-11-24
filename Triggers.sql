/* 
Nom du joueur en majuscule 
*/

CREATE TRIGGER NomJoueurMajuscule
BEFORE INSERT ON Village
FOR EACH ROW
SET NEW.nomJoueur = UPPER(NEW.nomJoueur);

CREATE TRIGGER SupprimerJoueurClan
AFTER DELETE ON Village
FOR EACH ROW 
UPDATE clan 
SET membresMax = membresMax - 1
WHERE Clan.idVillage = old.idVillage;

CREATE TRIGGER AjoutVillage
AFTER INSERT
ON Village
FOR EACH ROW 
UPDATE capaciteeCampMax
SET capaciteeCampMax = capaciteeCampMax + 50;

