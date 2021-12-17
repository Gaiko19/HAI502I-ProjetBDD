/*  ===========================
    |  Création des triggers |
    ===========================
*/  

prompt "Lancement des Triggers" 

prompt "Trigger nouveauVillage"

--[Trigger pour créer un nouveau village et calculer sa capcitée Max]
CREATE OR REPLACE TRIGGER nouveauVillage
BEFORE INSERT ON Village
FOR EACH ROW
BEGIN
  :new.nomJoueur := UPPER(:new.nomJoueur);
  IF (:new.niveauJoueur IS NULL) THEN :new.niveauJoueur := 1;
  END IF;
  IF (:new.capaciteeCampMax IS NULL) THEN
  calculCapaciteMax(:new.niveauJoueur,:new.capaciteeCampMax);
  END IF;
END;
/

prompt "Trigger nouvelleReserve"

--[trigger qui ajoute une reserve à chaque création d un village]
CREATE OR REPLACE TRIGGER nouvelleReserve
AFTER INSERT ON Village
DECLARE
  qMax INTEGER;
BEGIN
  FOR record IN (SELECT idVillage FROM Village WHERE idVillage NOT IN (SELECT idVillage FROM Reserves))
  LOOP
    qMax := calculQuantiteMax(record.idVillage);
    INSERT INTO Reserves(idVillage, typeReserve, quantiteMax, quantite) VALUES(record.idVillage, 'OR', qMax, 0);
    INSERT INTO Reserves(idVillage, typeReserve, quantiteMax, quantite) VALUES(record.idVillage, 'ELIXIR', qMax, 0);
    INSERT INTO Reserves(idVillage, typeReserve, quantiteMax, quantite) VALUES(record.idVillage, 'ELIXIRNOIR', qMax, 0);
  END LOOP;
END;
/

prompt "Trigger changementChefDeClan"

--[trigger chef de clan défini aléatoirement si le chef quitte]
CREATE OR REPLACE TRIGGER changementChefDeClan
AFTER UPDATE ON Village
FOR EACH ROW
DECLARE
  idChef INTEGER;
  nbMembres INTEGER;
  nouveauChef INTEGER;
BEGIN
  IF (:old.idClan != :new.idClan) 
    THEN 
    BEGIN
      SELECT COUNT(*) INTO nbMembres FROM Village WHERE Village.idClan = :old.idClan;
      SELECT idChefDeClan INTO idChef FROM Clan WHERE idClan = :old.idClan;
      IF (nbMembres <= 0) 
        THEN 
          DELETE FROM Clan WHERE idClan = :old.idClan;
      ELSIF (:new.idVillage = idChef) 
        THEN 
          BEGIN
            SELECT idVillage INTO nouveauChef FROM Village WHERE (idClan = :old.idClan) FETCH FIRST 1 ROWS ONLY;
            UPDATE Clan SET idChefDeClan = nouveauChef WHERE idClan = :old.idClan;
          END;
      END IF;
    END;
  END IF;
END;
/



prompt "Trigger calculTrophéesNegatifs"

--[trigger si les Trophées sont en négatif, ils passent à 0]
CREATE OR REPLACE TRIGGER calculTropheesNegatifs
BEFORE UPDATE ON Village
FOR EACH ROW
BEGIN
  IF :new.trophees < 0 
    THEN :new.trophees := 0;
  END IF;
END;
/



prompt "Trigger calculAttaque"

--[trigger pour ajouter à l'attaquant les ressources gagnées et les trophées après une attaque et les enlever au défenseur]
CREATE OR REPLACE TRIGGER calculAttaque
AFTER INSERT ON Attaque
FOR EACH ROW
BEGIN
  UPDATE Village SET trophees = trophees + :new.tropheesPris WHERE (idVillage=:new.idAttaquant); 
  UPDATE Reserves SET quantite = quantite + :new.orRecolte WHERE (idVillage=:new.idAttaquant AND typeReserve='OR');
  UPDATE Reserves SET quantite = quantite + :new.elixirRecolte WHERE (idVillage=:new.idAttaquant AND typeReserve='ELIXIR');
  UPDATE Reserves SET quantite = quantite + :new.elixirNoirRecolte WHERE (idVillage=:new.idAttaquant AND typeReserve='ELIXIRNOIR');
  UPDATE Village SET trophees = trophees - :new.tropheesPris WHERE (idVillage=:new.idDefenseur);
  UPDATE Reserves SET quantite = quantite - :new.orRecolte WHERE (idVillage=:new.idDefenseur AND typeReserve='OR');
  UPDATE Reserves SET quantite = quantite - :new.elixirRecolte WHERE (idVillage=:new.idDefenseur AND typeReserve='ELIXIR');
  UPDATE Reserves SET quantite = quantite - :new.elixirNoirRecolte WHERE (idVillage=:new.idDefenseur AND typeReserve='ELIXIRNOIR');
END;
/

prompt "Trigger nouvelleTroupe"

--[trigger pour créer une troupe en vérifiant qu'on a la place et les ressources nécessaires]
CREATE OR REPLACE TRIGGER nouvelleTroupe
BEFORE INSERT ON Camp
FOR EACH ROW
DECLARE
  placeTotalePrise INTEGER;
  elixirDispo INTEGER;
  elixirNoirDispo INTEGER;
  elixirPrix INTEGER;
  elixirNoirPrix INTEGER;
  capaMaxVillage INTEGER;
BEGIN
  SELECT placeOccupee * :new.nbrTroupe INTO placeTotalePrise FROM Troupe
  WHERE idTroupe = :new.idTroupe;
  SELECT quantite INTO elixirDispo FROM Reserves 
  WHERE Reserves.idVillage = :new.idVillage AND typeReserve = 'ELIXIR';
  SELECT quantite INTO elixirNoirDispo FROM Reserves 
  WHERE Reserves.idVillage = :new.idVillage AND typeReserve = 'ELIXIRNOIR';
  SELECT prixElixir * :new.nbrTroupe INTO elixirPrix FROM Troupe
  WHERE idTroupe = :new.idTroupe;
  SELECT prixElixirNoir * :new.nbrTroupe INTO elixirNoirPrix FROM Troupe
  WHERE idTroupe = :new.idTroupe;
  SELECT capaciteeCampMax INTO capaMaxVillage FROM Village
  WHERE idVillage = :new.idVillage;
  IF ((capaMaxVillage >= placeTotalePrise) AND (elixirDispo >= elixirPrix) AND (elixirNoirDispo >= elixirNoirPrix)) THEN BEGIN
    UPDATE Reserves SET quantite = quantite - elixirPrix WHERE (idVillage=:new.idVillage AND typeReserve='ELIXIR');
    UPDATE Reserves SET quantite = quantite - elixirNoirPrix WHERE (idVillage=:new.idVillage AND typeReserve='ELIXIRNOIR');
    END; 
  ELSE RAISE_APPLICATION_ERROR (-20500, 'Vous n avez pas assez de ressource pour créer la troupe.');
  END IF;
END;
/

prompt "Trigger RejoindreChefClan"

--[trigger pour ajouter l'id d'un clan à un Village qui en est le chef]
CREATE OR REPLACE TRIGGER RejoindreChefClan
AFTER INSERT OR UPDATE ON Clan
FOR EACH ROW
BEGIN
  UPDATE Village SET idClan = :new.idClan WHERE idVillage = :new.idChefDeClan;
END;
/

prompt "Trigger RejoindrePlaceClan"

--[trigger pour voir si il reste une place dans le clan quand qqn rejoins (max 50)]
CREATE OR REPLACE TRIGGER RejoindrePlaceClan
BEFORE UPDATE ON Clan
FOR EACH ROW
DECLARE
  nbMembres INTEGER;
BEGIN
  SELECT COUNT(*) INTO nbMembres FROM Village
  WHERE Village.idClan = :new.idClan;
  IF nbMembres >= 50 
    THEN RAISE_APPLICATION_ERROR (-20600, 'Le clan est plein.');
  END IF;
END;
/

prompt "Trigger SupprimerClanVide"

--[trigger pour supprimer un clan s'il est vide]
CREATE OR REPLACE TRIGGER SupprimerClanVide
AFTER UPDATE ON Clan
FOR EACH ROW
DECLARE
  nbMembres INTEGER;
BEGIN
  SELECT COUNT(*) INTO nbMembres FROM Village
  WHERE Village.idClan = :new.idClan;
  IF nbMembres <= 0 THEN 
    DELETE FROM Clan WHERE idClan = :new.idChefDeClan;
  END IF;
END;
/

prompt "Trigger calculReservesNegatives"

--[trigger si les réserves sont en négatif, elles passent à 0]
CREATE OR REPLACE TRIGGER calculReservesNegatives
BEFORE UPDATE ON Reserves
FOR EACH ROW
BEGIN
  IF :new.quantite < 0 
    THEN :new.quantite := 0;
  END IF;
END;
/


prompt -Triggers lancés
