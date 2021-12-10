/*  ==============================
    |  Suppression des triggers |
    ==============================
*/

prompt "Suppression des Triggers"

BEGIN
EXECUTE IMMEDIATE 'DROP TRIGGER NomTroupeMajuscule ';
EXCEPTION
 WHEN OTHERS THEN
  IF SQLCODE != -4080 THEN
  RAISE;
  END IF;
END;
/

BEGIN
EXECUTE IMMEDIATE 'DROP TRIGGER nouveauVillage ';
EXCEPTION
 WHEN OTHERS THEN
  IF SQLCODE != -4080 THEN
  RAISE;
  END IF;
END;
/

BEGIN
EXECUTE IMMEDIATE 'DROP TRIGGER nouvelleReserve ';
EXCEPTION
 WHEN OTHERS THEN
  IF SQLCODE != -4080 THEN
  RAISE;
  END IF;
END;
/

BEGIN
EXECUTE IMMEDIATE 'DROP TRIGGER changementChefDeClan ';
EXCEPTION
 WHEN OTHERS THEN
  IF SQLCODE != -4080 THEN
  RAISE;
  END IF;
END;
/

BEGIN
EXECUTE IMMEDIATE 'DROP TRIGGER calculAttaque ';
EXCEPTION
 WHEN OTHERS THEN
  IF SQLCODE != -4080 THEN
  RAISE;
  END IF;
END;
/

BEGIN
EXECUTE IMMEDIATE 'DROP TRIGGER nouvelleTroupe ';
EXCEPTION
 WHEN OTHERS THEN
  IF SQLCODE != -4080 THEN
  RAISE;
  END IF;
END;
/

BEGIN
EXECUTE IMMEDIATE 'DROP TRIGGER RejoindreChefClan ';
EXCEPTION
 WHEN OTHERS THEN
  IF SQLCODE != -4080 THEN
  RAISE;
  END IF;
END;
/

BEGIN
EXECUTE IMMEDIATE 'DROP TRIGGER RejoindrePlaceClan ';
EXCEPTION
 WHEN OTHERS THEN
  IF SQLCODE != -4080 THEN
  RAISE;
  END IF;
END;
/

BEGIN
EXECUTE IMMEDIATE 'DROP TRIGGER SupprimerClanVide';
EXCEPTION
 WHEN OTHERS THEN
  IF SQLCODE != -4080 THEN
  RAISE;
  END IF;
END;
/

BEGIN
EXECUTE IMMEDIATE 'DROP TRIGGER calculReservesNegatives';
EXCEPTION
 WHEN OTHERS THEN
  IF SQLCODE != -4080 THEN
  RAISE;
  END IF;
END;
/

/*  ===========================
    |  Création des triggers |
    ===========================
*/  

prompt -Lancement des Triggers 

prompt "Trigger NomTroupeMajuscule"

--[Trigger Nom de la troupe en majuscule]
CREATE OR REPLACE TRIGGER NomTroupeMajuscule
BEFORE INSERT ON Troupe
FOR EACH ROW
BEGIN
  :new.nomTroupe := UPPER(:new.nomTroupe);
END;
/

prompt "Trigger nouveauVillage"

--[Trigger pour créer un nouveau village et calculer sa capcitée Max]
CREATE OR REPLACE TRIGGER nouveauVillage
BEFORE INSERT ON Village
FOR EACH ROW
BEGIN
  :new.nomJoueur := UPPER(:new.nomJoueur);
  IF (:new.niveauJoueur IS NULL) THEN :new.niveauJoueur := 1;
  END IF;
  calculCapaMax(:new.niveauJoueur,:new.capaciteeCampMax);
END;
/

prompt "Trigger nouvelleReserve"

--[trigger qui ajoute une reserve à chaque création d'un village]
CREATE OR REPLACE TRIGGER nouvelleReserve
AFTER INSERT ON Village
FOR EACH ROW
DECLARE
  qMax;
BEGIN
  qMax := calculQuantiteMax(:new.idVillage);
  INSERT INTO Reserves(typeReserve, quantiteMax, idVillage) VALUES('OR', qMax, :new.idVillage);
  INSERT INTO Reserves(typeReserve, quantiteMax, idVillage) VALUES('ELIXIR', qMax, :new.idVillage);
  INSERT INTO Reserves(typeReserve, quantiteMax, idVillage) VALUES('ELIXIRNOIR', qMax, :new.idVillage);
END;
/

prompt "Trigger changementChefDeClan"

--[trigger chef de clan défini aléatoirement si le chef quitte]
CREATE OR REPLACE TRIGGER changementChefDeClan
AFTER UPDATE ON Village
FOR EACH ROW
DECLARE
  idChef;
  nbMembres;
  nouveauChef;
BEGIN
  IF (:old.idClan != :new.idClan) THEN BEGIN
    SELECT COUNT(*) INTO nbMembres FROM Village WHERE Village.idClan = :old.idClan;
    SELECT idChefDeClan INTO idChef FROM Clan WHERE idClan = :old.idClan;

    IF nbMembres <= 0 THEN DELETE FROM Clan WHERE idClan = :new.idChefDeClan
    ELSIF (:new.idVillage == idChef) THEN BEGIN
      SELECT idVillage INTO nouveauChef FROM Village WHERE idClan = :old.idClan FETCH FIRST 1 ROWS ONLY;
      UPDATE Clan SET idChefDeClan = nouveauChef WHERE idClan = :old.idClan
      END;
    END IF;
    END;
  END IF;
END;
/

prompt "Trigger calculAttaque"

--[trigger pour ajouter à l'attaquant les ressources gagnées et les trophées après une attaque et les enlever au défenseur]
CREATE OR REPLACE TRIGGER calculAttaque
AFTER INSERT ON Attaque
FOR EACH ROW
BEGIN
  UPDATE Village SET (trophees += :new.tropheesPris) WHERE (idVillage=idAttaquant);
  UPDATE Reserves SET (quantite += :new.orRecolte) WHERE (idVillage=idAttaquant AND typeReserve='OR');
  UPDATE Reserves SET (quantite += :new.elixirRecolte) WHERE (idVillage=idAttaquant AND typeReserve='ELIXIR');
  UPDATE Reserves SET (quantite += :new.elixirNoirRecolte) WHERE (idVillage=idAttaquant AND typeReserve='ELIXIRNOIR');
  UPDATE Village SET (trophees -= :new.tropheesPris) WHERE (idVillage=idDefenseur);
  UPDATE Reserves SET (quantite -= :new.orRecolte) WHERE (idVillage=idDefenseur AND typeReserve='OR');
  UPDATE Reserves SET (quantite -= :new.elixirRecolte) WHERE (idVillage=idDefenseur AND typeReserve='ELIXIR');
  UPDATE Reserves SET (quantite -= :new.elixirNoirRecolte) WHERE (idVillage=idDefenseur AND typeReserve='ELIXIRNOIR');
END;
/

prompt "Trigger nouvelleTroupe"

--[trigger pour créer une troupe en vérifiant qu'on a la place et les ressources nécessaires]
CREATE OR REPLACE TRIGGER nouvelleTroupe
BEFORE INSERT ON Camp
DECLARE
  var1 number;
  var2 number;
  var3 number;
BEGIN
  (SELECT SUM(placeOccupee * nbrTroupe) INTO var1 FROM Camp, Troupe
  WHERE Camp.typeTroupe = Troupe.idTroupe AND Camp.idVillage = :new.idVillage);

  (SELECT quantite INTO var2 FROM Reserves 
  WHERE Reserves.idVillage == :new.idVillage AND typeReserve == 'ELIXIR');

  (SELECT quantite INTO var3 FROM Reserves 
  WHERE Reserves.idVillage == :new.idVillage AND typeReserve == 'ELIXIRNOIR');

  IF ((:new.idVillage.capaciteeCampMax >= var1 + :new.typeTroupe.) 
  AND (var2 >= :new.typeTroupe.prixElixir) 
  AND (var3 >= :new.typeTroupe.prixElixirNoir)) THEN BEGIN
    UPDATE Reserves SET (quantite -= var2) WHERE (idVillage=:new.idVillage AND typeReserve='ELIXIR');
    UPDATE Reserves SET (quantite -= var3) WHERE (idVillage=:new.idVillage AND typeReserve='ELIXIRNOIR');
  END;
  ELSE THEN RAISE_APPLICATION_ERROR (-20500, 'Vous n avez pas assez de ressource pour créer la troupe.');
  END IF;
END;
/

prompt "Trigger RejoindreChefClan"

--[trigger pour ajouter l'id d'un clan à un Village qui en est le chef]
CREATE OR REPLACE TRIGGER RejoindreChefClan
AFTER CREATE ON Clan
FOR EACH ROW
BEGIN
  UPDATE Village SET (idClan = :new.idClan) WHERE idVillage = :new.idChefDeClan;
END;
/

prompt "Trigger RejoindrePlaceClan"

--[trigger pour voir si il reste une place dans le clan quand qqn rejoins (max 50)]
CREATE OR REPLACE TRIGGER RejoindrePlaceClan
BEFORE UPDATE ON Clan
FOR EACH ROW
DECLARE
  nbMembres;
BEGIN
  SELECT COUNT(*) INTO nbMembres FROM Village
  WHERE Village.idClan = :new.idClan;
  IF nbMembres >= 50 THEN RAISE_APPLICATION_ERROR (-20600, 'Le clan est plein.');
  END IF;
END;
/

prompt "Trigger SupprimerClanVide"

--[trigger pour supprimer un clan s'il est vide]
CREATE OR REPLACE TRIGGER SupprimerClanVide
AFTER UPDATE ON Clan
FOR EACH ROW
DECLARE
  nbMembres;
BEGIN
  SELECT COUNT(*) INTO nbMembres FROM Village
  WHERE Village.idClan = :new.idClan;
  IF nbMembres <= 0 THEN DELETE FROM Clan WHERE idClan = :new.idChefDeClan
  END IF;
END;
/

prompt "Trigger calculReservesNegatives"

--[trigger si les réserves sont en négatif, elles passent à 0]
CREATE OR REPLACE TRIGGER calculReservesNegatives
BEFORE UPDATE ON Reserves
FOR EACH ROW
BEGIN
  IF :new.quantite < 0 THEN :new.quantite := 0
  END IF;
END;
/


prompt -Triggers lancés
