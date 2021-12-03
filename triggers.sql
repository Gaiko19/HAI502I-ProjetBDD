prompt -Lancement des Triggers

/* [Trigger Nom du joueur en majuscule] */
CREATE OR REPLACE TRIGGER NomJoueurMajuscule
BEFORE INSERT ON Village
FOR EACH ROW
SET :new.nomJoueur = UPPER(:new.nomJoueur);
END;
/

/* [Trigger Nom de la troupe en majuscule] */
CREATE OR REPLACE TRIGGER NomTroupeMajuscule
BEFORE INSERT ON Troupe
FOR EACH ROW
SET :new.nomTroupe = UPPER(:new.nomTroupe);
END;
/

/* [trigger pour actualiser le nombre de joueurs dans un clan lors de la suppression d'un joueur] */
CREATE OR REPLACE TRIGGER SupprimerJoueurClan
AFTER DELETE ON Village
FOR EACH ROW 
UPDATE clan SET membresMax = (membresMax - 1) WHERE Clan.idVillage = :old.idVillage;
END;
/

/*[Trigger pour ajouter un nouveau village avec uniquement le nom du joueur]*/

/*
INSERT INTO Village VALUES (idVillage, nomJoueur, niveauJoueur, capaciteeCampMax, trophees, idClan);
*/

CREATE OR REPLACE TRIGGER nouveauVillage
BEFORE INSERT ON Village 
DECLARE
  id_vil number;
BEGIN
  IF :new.niveauJoueur IS NULL THEN :new.niveauJoueur := 1;
  ENF IF;

  :new.capaciteeCampMax := calculCapaMax(:new.niveauJoueur);
  
  IF :new.idVillage IS NULL THEN SELECT MAX(idVillage) INTO id_vil FROM Village;
  ENF IF;
END;
/

prompt -Triggers lancés



/*
à faire :

[trigger pour créer une troupe en vérifiant qu'on a la place et les sous]
[trigger pour ajouter l'argent gagné après une attaque et l'enlever au défenseur]
[trigger pour ajouter les trophés gagnés après une attaque et les enlever au défenseur]
[trigger pour voir si il reste une place dans le clan qd un mec rejoins (max 50) et si il a le nombre de trophées requis]
*/