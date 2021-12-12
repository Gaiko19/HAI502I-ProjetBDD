/* =======================================
  Groupe 2 - La Bataille des Villages
    21905365 SAID ADAM
    21901688 BOURRET MAXIME
    21903888 HADDAD GATIEN
    21901021 COSSU ARNAUD
  =========================================
*/

/*  ==============================
    |  Suppression des relations |
    ==============================
*/

prompt "Suppression des relations"

BEGIN
EXECUTE IMMEDIATE 'DROP TABLE Camp';
EXCEPTION
 WHEN OTHERS THEN
  IF SQLCODE != -942 THEN
  RAISE;
  END IF;
END;
/

BEGIN
EXECUTE IMMEDIATE 'DROP TABLE Clan CASCADE CONSTRAINT';
EXCEPTION
 WHEN OTHERS THEN
  IF SQLCODE != -942 THEN
  RAISE;
  END IF;
END;
/

BEGIN
EXECUTE IMMEDIATE 'DROP TABLE Village CASCADE CONSTRAINT';
EXCEPTION
 WHEN OTHERS THEN
  IF SQLCODE != -942 THEN
  RAISE;
  END IF;
END;
/

BEGIN
EXECUTE IMMEDIATE 'DROP TABLE GuerreDeClan';
EXCEPTION
 WHEN OTHERS THEN
  IF SQLCODE != -942 THEN
  RAISE;
  END IF;
END;
/

BEGIN
EXECUTE IMMEDIATE 'DROP TABLE Reserves';
EXCEPTION
 WHEN OTHERS THEN
  IF SQLCODE != -942 THEN
  RAISE;
  END IF;
END;
/

BEGIN
EXECUTE IMMEDIATE 'DROP TABLE Heros';
EXCEPTION
 WHEN OTHERS THEN
  IF SQLCODE != -942 THEN
  RAISE;
  END IF;
END;
/

BEGIN
EXECUTE IMMEDIATE 'DROP TABLE Troupe';
EXCEPTION
 WHEN OTHERS THEN
  IF SQLCODE != -942 THEN
  RAISE;
  END IF;
END;
/


BEGIN
EXECUTE IMMEDIATE 'DROP TABLE Attaque';
EXCEPTION
 WHEN OTHERS THEN
  IF SQLCODE != -942 THEN
  RAISE;
  END IF;
END;
/



-- *************************************************



/*  ===========================
    |  Création des relations |
    ===========================
*/  

prompt "Création des relations"



CREATE TABLE Village(
	idVillage NUMBER(10) NOT NULL, 
  nomJoueur VARCHAR(20) UNIQUE NOT NULL,
  niveauJoueur NUMBER(10) DEFAULT 1,
  capaciteeCampMax NUMBER(10) NOT NULL,
  trophees NUMBER(10) DEFAULT 100,
  idClan NUMBER(10),
  CONSTRAINT PK_IDVILLLAGE PRIMARY KEY (idVillage)
);

CREATE TABLE Clan(
  idClan NUMBER(10),
  nomClan VARCHAR(20) UNIQUE NOT NULL,
  regionClan VARCHAR(20),
  niveauClan NUMBER(10) DEFAULT 1 NOT NULL,
  idChefDeClan NUMBER(10) NOT NULL,
  CONSTRAINT PK_idClan PRIMARY KEY (idClan),
  CONSTRAINT FK_CHEFDECLAN FOREIGN KEY (idchefDeClan) REFERENCES Village(idVillage)
);

CREATE TABLE Troupe(
  idTroupe NUMBER(10),
  nomTroupe VARCHAR(50) NOT NULL,
  PV NUMBER(10) NOT NULL,
  degats NUMBER(10) NOT NULL,
  placeOccupee NUMBER(10) NOT NULL,
  prixElixir NUMBER(10) NOT NULL,
  prixElixirNoir NUMBER(10) NOT NULL,
  CONSTRAINT PK_IDTROUPE PRIMARY KEY (idTroupe)
);

CREATE TABLE Camp(
  idCamp NUMBER(10),
  idTroupe NUMBER(10) NOT NULL,
  idVillage NUMBER(10) NOT NULL,
  nbrTroupe NUMBER(10) DEFAULT 1,
  CONSTRAINT PK_IDCAMP PRIMARY KEY (idCamp),
  CONSTRAINT FK_typeTroupe FOREIGN KEY (idTroupe) REFERENCES Troupe(idTroupe),
  CONSTRAINT FK_idVillageCamp FOREIGN KEY (idVillage) REFERENCES Village(idVillage)
);

CREATE TABLE Heros(
  idHeros NUMBER(10),
  typeHeros VARCHAR(50) CHECK(typeHeros IN ('Reine des Archers', 'Roi des Barbares', 'Grand Gardien', 'Championne Royale')),
  niveauHeros NUMBER(10) DEFAULT 1,
  vieHeros NUMBER(10),
  idVillage NUMBER(10) NOT NULL,
  CONSTRAINT PK_IDHEROS PRIMARY KEY (idHeros),
  CONSTRAINT FK_idVillageHeros FOREIGN KEY (idVillage) REFERENCES Village(idVillage)
);

CREATE TABLE Reserves(
  idVillage NUMBER(10) NOT NULL,
  typeReserve VARCHAR(10) CHECK(typeReserve IN ('OR', 'ELIXIR', 'ELIXIRNOIR')),
  quantiteMax NUMBER(10) NOT NULL,
  quantite NUMBER(10) DEFAULT 0,
  CONSTRAINT PK_IDVILLAGE PRIMARY KEY (idVillage),
  CONSTRAINT FK_idVillageReserve FOREIGN KEY (idVillage) REFERENCES Village(idVillage)
);

CREATE TABLE GuerreDeClan(
  idGuerre NUMBER(10),
  idClan1 NUMBER(10) NOT NULL,
  idClan2 NUMBER(10) NOT NULL,
  nombreAttaquesMax NUMBER(10) DEFAULT 10,
  CONSTRAINT PK_IDGUERRE PRIMARY KEY (idGuerre),
  CONSTRAINT FK_idClan1 FOREIGN KEY (idClan1) REFERENCES Clan(idClan),
  CONSTRAINT FK_idClan2 FOREIGN KEY (idClan2) REFERENCES Clan(idClan)
);

CREATE TABLE Attaque(
  idAttaque NUMBER(10) NOT NULL,
  idAttaquant NUMBER(10) NOT NULL,
  idDefenseur NUMBER(10) NOT NULL,
  tropheesPris NUMBER(10),
  etoiles NUMBER(10),
  pourcentage NUMBER(10),
  orRecolte NUMBER(10),
  elixirRecolte NUMBER(10),
  elixirNoirRecolte NUMBER(10),
  idGuerre NUMBER(10),
  CONSTRAINT PK_idAttaque PRIMARY KEY (idAttaque),
  CONSTRAINT FK_idAttaquant FOREIGN KEY (idAttaquant) REFERENCES Village(idVillage),
  CONSTRAINT FK_idDefenseur FOREIGN KEY (idDefenseur) REFERENCES Village(idVillage)
);


-- *************************************************

/*  ====================
    |  Clés Etrangères |
    ====================
*/  

prompt "Ajout des clés etrangères"

ALTER TABLE Village ADD CONSTRAINT FK_idClan FOREIGN KEY (idClan) REFERENCES Clan(idClan);

/*  ==============================
    |  Suppression des fonctions |
    ==============================
*/

prompt "Suppression des Fonctions"


begin
   execute immediate 'drop procedure calculCapaMax';
exception when others then
   if sqlcode != -4043 or SQLCODE != -955 then
      raise;
   end if;
end;
/

BEGIN
EXECUTE IMMEDIATE 'DROP FUNCTION calculQuantiteMax';
EXCEPTION
 WHEN OTHERS THEN
  IF SQLCODE != -4043 THEN
  RAISE;
  END IF;
END;
/



/*  ===========================
    |  Création des fonctions |
    ===========================
*/  

prompt "Création des fonctions"

-- Renvoie la capacité max du village en fonction du niveau du village
CREATE OR REPLACE PROCEDURE calculCapaMax (
  lvl IN INTEGER,
  nb OUT INTEGER) IS
BEGIN
  IF lvl < 100 THEN nb := (100 + 2*lvl);
  ELSE nb := 300;
  END IF;
END;
/


-- Renvoie la quantité de ressource maximale du village en fonction du niveau du village
CREATE OR REPLACE FUNCTION calculQuantiteMax (id IN INTEGER) 
RETURN INTEGER IS nb INTEGER;
lvl INTEGER;
BEGIN
  SELECT niveauJoueur INTO lvl FROM Village WHERE idVillage=id;
  IF lvl < 100 THEN nb := 100000*lvl;
  ELSE nb := 10000000;
  END IF;
  RETURN (nb);
END; 
/


prompt "Fonctions créées"

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
  SELECT calculQuantiteMax(idVillage) INTO qMax FROM Village WHERE idvillage = :new.idVillage;
  INSERT INTO Reserves(idVillage, typeReserve, quantiteMax) VALUES(:new.idVillage, 'OR', qMax);
  INSERT INTO Reserves(idVillage, typeReserve, quantiteMax) VALUES(:new.idVillage, 'ELIXIR', qMax);
  INSERT INTO Reserves(idVillage, typeReserve, quantiteMax) VALUES(:new.idVillage, 'ELIXIRNOIR', qMax);
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

    IF (nbMembres <= 0) THEN DELETE FROM Clan WHERE idClan = :new.idChefDeClan
    ELSIF (:new.idVillage == idChef) THEN BEGIN
      SELECT idVillage INTO nouveauChef FROM Village WHERE (idClan = :old.idClan) FETCH FIRST 1 ROWS ONLY;
      UPDATE Clan SET (idChefDeClan = nouveauChef) WHERE idClan = :old.idClan
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
  UPDATE Village SET (trophees += :new.tropheesPris) WHERE (idVillage=:new.idAttaquant);
  UPDATE Reserves SET (quantite += :new.orRecolte) WHERE (idVillage=:new.idAttaquant AND typeReserve='OR');
  UPDATE Reserves SET (quantite += :new.elixirRecolte) WHERE (idVillage=:new.idAttaquant AND typeReserve='ELIXIR');
  UPDATE Reserves SET (quantite += :new.elixirNoirRecolte) WHERE (idVillage=:new.idAttaquant AND typeReserve='ELIXIRNOIR');
  UPDATE Village SET (trophees -= :new.tropheesPris) WHERE (idVillage=:new.idDefenseur);
  UPDATE Reserves SET (quantite -= :new.orRecolte) WHERE (idVillage=:new.idDefenseur AND typeReserve='OR');
  UPDATE Reserves SET (quantite -= :new.elixirRecolte) WHERE (idVillage=:new.idDefenseur AND typeReserve='ELIXIR');
  UPDATE Reserves SET (quantite -= :new.elixirNoirRecolte) WHERE (idVillage=:new.idDefenseur AND typeReserve='ELIXIRNOIR');
END;
/

prompt "Trigger nouvelleTroupe"

--[trigger pour créer une troupe en vérifiant qu'on a la place et les ressources nécessaires]
CREATE OR REPLACE TRIGGER nouvelleTroupe
BEFORE INSERT ON Camp
FOR EACH ROW
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
AFTER INSERT ON Clan
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

prompt "Insertion des tubles Troupe"


--INSERT INTO Troupe VALUES (ID,NOM,PV,DEGAT,PLACE,PRIX_ELIXIR,prix_noir);
INSERT INTO Troupe VALUES (1,'BARBARE',100,30,1,250,0);
INSERT INTO Troupe VALUES (2,'ARCHERE',50,25,1,500,0);
INSERT INTO Troupe VALUES (3,'GEANT',1250,100,5,3500,0);
INSERT INTO Troupe VALUES (4,'GOBELIN',75,27,1,150,0);
INSERT INTO Troupe VALUES (5,'SAPEUR',70,500,2,1500,0);
INSERT INTO Troupe VALUES (6,'BALLON',550,400,5,4500,0);
INSERT INTO Troupe VALUES (7,'SORCIER',200,300,4,3500,0);
INSERT INTO Troupe VALUES (8,'GUERISSEUSE',1200,70,14,10000,0);
INSERT INTO Troupe VALUES (9,'DRAGON',3100,500,20,18000,0);
INSERT INTO Troupe VALUES (10,'PEKKA',5200,1600,25,25000,0);
INSERT INTO Troupe VALUES (11,'BEBE DRAGON',1500,85,10,7000,0);
INSERT INTO Troupe VALUES (12,'MINEUR',700,100,6,5500,0);
INSERT INTO Troupe VALUES (13,'ELECTRO DRAGON',3200,1200,30,28000,0);
INSERT INTO Troupe VALUES (14,'YETI',2900,500,18,19000,0);
INSERT INTO Troupe VALUES (15,'CHEVAUCHEUR DE DRAGON',4100,550,25,22000,0);
INSERT INTO Troupe VALUES (16,'GARGOUILLES',75,50,2,0,30);
INSERT INTO Troupe VALUES (17,'CHEVAUCHEUR DE COCHON',480,80,5,0,65);
INSERT INTO Troupe VALUES (18,'VALKYRIE',900,70,8,0,100);
INSERT INTO Troupe VALUES (19,'GOLEM',6300,26,30,0,500);
INSERT INTO Troupe VALUES (20,'SORCIERE',400,100,12,0,200);
INSERT INTO Troupe VALUES (21,'MOLOSSE DE LAVE',6800,14,30,0,600);
INSERT INTO Troupe VALUES (22,'BOULISTE',310,50,6,0,90);
INSERT INTO Troupe VALUES (23,'GOLEM DE GLACE',2600,12,15,0,300);
INSERT INTO Troupe VALUES (24,'CHASSEUSE DE TETES',360,105,6,0,120);

prompt "Insertion des tuples Village"

--INSERT INTO Village VALUES (ID, NOM_village, lvl, capacité_camp, trophees, idClan);
INSERT INTO Village(idVillage, nomJoueur, niveauJoueur,capaciteeCampMax, trophees, idClan) VALUES (1, 'MATEODU13', 10, 12, 500, null);
INSERT INTO Village(idVillage, nomJoueur, niveauJoueur,capaciteeCampMax, trophees, idClan) VALUES (2, 'MAXIME', 125, 2800, 400, null);
INSERT INTO Village(idVillage, nomJoueur, niveauJoueur,capaciteeCampMax, trophees, idClan) VALUES (3, 'ADAM', 53, 600, 726, null);
INSERT INTO Village(idVillage, nomJoueur, niveauJoueur,capaciteeCampMax, trophees, idClan) VALUES (4, 'ARNAUD', 75, 800, 894, null);
INSERT INTO Village(idVillage, nomJoueur, niveauJoueur,capaciteeCampMax, trophees, idClan) VALUES (5, 'BLAISE', 47, 1200, 1300, null);
INSERT INTO Village(idVillage, nomJoueur, niveauJoueur,capaciteeCampMax, trophees, idClan) VALUES (6, 'DOOBY', 26, 50, 478, null);
INSERT INTO Village(idVillage, nomJoueur, niveauJoueur,capaciteeCampMax, trophees, idClan) VALUES (7, 'AROUF', 210, 4500, 365, null);
INSERT INTO Village(idVillage, nomJoueur, niveauJoueur,capaciteeCampMax, trophees, idClan) VALUES (8, 'LACRIM', 92, 2000, 957, null);
INSERT INTO Village(idVillage, nomJoueur, niveauJoueur,capaciteeCampMax, trophees, idClan) VALUES (9, 'DIAMS', 111, 2100, 1600, null);
INSERT INTO Village(idVillage, nomJoueur, niveauJoueur,capaciteeCampMax, trophees, idClan) VALUES (10, 'GAZO', 136, 2500, 1548, null);
INSERT INTO Village(idVillage, nomJoueur) VALUES (11, 'GATIEN');
INSERT INTO Village(idVillage, nomJoueur) VALUES (12, 'THOMAS');
INSERT INTO Village(idVillage, nomJoueur) VALUES (13, 'ECHARPE');
INSERT INTO Village(idVillage, nomJoueur) VALUES (14, 'CUISINE');
INSERT INTO Village(idVillage, nomJoueur) VALUES (15, 'DARK');
INSERT INTO Village(idVillage, nomJoueur) VALUES (16, 'WHITE');
INSERT INTO Village(idVillage, nomJoueur) VALUES (17, 'GREY');

prompt "Insertion des tuples Heros"

--INSERT INTO Heros VALUES (id,type,niveau,vie,idVillage);
INSERT INTO Heros VALUES (001,'Roi des Barbares',50,100,11);
INSERT INTO Heros VALUES (002,'Reine des Archers',50,100,11);
INSERT INTO Heros VALUES (003,'Grand Gardien',30,100,11);
INSERT INTO Heros VALUES (004,'Roi des Barbares',40,100,2);
INSERT INTO Heros VALUES (005,'Reine des Archers',40,100,2);
INSERT INTO Heros VALUES (006,'Grand Gardien',5,100,2);
INSERT INTO Heros VALUES (007,'Roi des Barbares',10,100,4);
INSERT INTO Heros VALUES (008,'Roi des Barbares',85,100,7);
INSERT INTO Heros VALUES (009,'Reine des Archers',85,100,7);
INSERT INTO Heros VALUES (010,'Grand Gardien',55,100,7);
INSERT INTO Heros VALUES (011,'Championne Royale',30,100,7);
INSERT INTO Heros VALUES (012,'Roi des Barbares',20,100,8);
INSERT INTO Heros VALUES (013,'Reine des Archers',10,100,8);
INSERT INTO Heros VALUES (014,'Roi des Barbares',35,100,9);
INSERT INTO Heros VALUES (015,'Reine des Archers',30,100,9);
INSERT INTO Heros VALUES (016,'Roi des Barbares',40,100,10);
INSERT INTO Heros VALUES (017,'Reine des Archers',45,100,10);
INSERT INTO Heros VALUES (018,'Grand Gardien',10,100,10);

prompt "Insertion des tuples Attaque"

--INSERT INTO Attaque VALUES (id,idAtt,idDef,trophees,etoiles,%,or,elix,noir,idGuerre);
INSERT INTO Attaque VALUES (1,2,11,14,2,67,928680,874315,8436,null);
INSERT INTO Attaque VALUES (2,11,7,5,1,52,125864,130221,589,null);
INSERT INTO Attaque VALUES (3,8,3,0,3,100,100000,100000,1000,1);
INSERT INTO Attaque VALUES (4,3,8,0,1,42,100000,100000,1000,1);
INSERT INTO Attaque VALUES (5,4,9,0,2,68,100000,100000,1000,1);
INSERT INTO Attaque VALUES (6,7,11,0,3,100,100000,100000,1000,1);
INSERT INTO Attaque VALUES (7,2,10,0,2,75,100000,100000,1000,1);
INSERT INTO Attaque VALUES (8,11,7,0,2,51,100000,100000,1000,1);
INSERT INTO Attaque VALUES (9,10,2,0,2,89,100000,100000,1000,1);
INSERT INTO Attaque VALUES (10,9,4,0,1,77,100000,100000,1000,1);
 -- TUPLES ATTAQUE A CORRIGER
prompt "Insertion des tuples Clan"

--INSERT INTO Clan VALUES (ID,Nom,region,niveau,chef) 
INSERT INTO Clan VALUES (1,'GNUMZ','FR',15,3);
INSERT INTO Clan VALUES (2,'FC GANGST','US',12,7);
INSERT INTO Clan VALUES (3,'TROPHY PUSH','US',20,10);
INSERT INTO Clan VALUES (4,'LES ZELUS','FR',1,1);
INSERT INTO Clan VALUES (5,'AROUF', 'ES', 15,12);
INSERT INTO Clan VALUES (6,'UM', 'FR', 7,13);
INSERT INTO Clan VALUES (7,'JAAJ', 'ES', 15,14);
INSERT INTO Clan VALUES (8,'MALEMORT', 'GI', 1,15);
INSERT INTO Clan VALUES (9,'DESPACITO', 'ES', 2,16);
INSERT INTO Clan VALUES (10,'FLAMENCO', 'ES', 7,17);

prompt "Ajout de membres à des clans"

-- Ajout de membres dans des clans (un trigger s'occupe déjà de rajouter le chef)
UPDATE Village SET idClan = 1 WHERE idVillage == 2;
UPDATE Village SET idClan = 1 WHERE idVillage == 11;
UPDATE Village SET idClan = 1 WHERE idVillage == 4;
UPDATE Village SET idClan = 4 WHERE idVillage == 5;
UPDATE Village SET idClan = 3 WHERE idVillage == 6;
UPDATE Village SET idClan = 2 WHERE idVillage == 8;
UPDATE Village SET idClan = 2 WHERE idVillage == 9;

prompt "Insertion des tuples GuerreDeClan"

--INSERT INTO GuerreDeClan VALUES (idGuerre,idClan1,idClan2,nbrAttaquesMax)
INSERT INTO GuerreDeClan VALUES (1,1,2,8);
INSERT INTO GuerreDeClan VALUES (2,2,4,7);
INSERT INTO GuerreDeClan VALUES (3,5,6,5);
INSERT INTO GuerreDeClan VALUES (4,7,8,5);
INSERT INTO GuerreDeClan VALUES (5,9,10,5);
INSERT INTO GuerreDeClan VALUES (6,10,1,5);
INSERT INTO GuerreDeClan VALUES (7,8,4,5);
INSERT INTO GuerreDeClan VALUES (8,6,2,7);
INSERT INTO GuerreDeClan VALUES (9,4,7,10);
INSERT INTO GuerreDeClan VALUES (10,10,2,5);

prompt "Insertion des tuples Reserves"
UPDATE Reserves SET (quantite = 1000000) WHERE (idVillage == 2) AND (typeReserve == 'OR');
UPDATE Reserves SET (quantite = 1000000) WHERE (idVillage == 2) AND (typeReserve == 'ELIXIR');
UPDATE Reserves SET (quantite = 10000) WHERE (idVillage == 2) AND (typeReserve == 'ELIXIRNOIR');
UPDATE Reserves SET (quantite = 100000) WHERE (idVillage == 3) AND (typeReserve == 'OR');
UPDATE Reserves SET (quantite = 100000) WHERE (idVillage == 3) AND (typeReserve == 'ELIXIR');
UPDATE Reserves SET (quantite = 1000) WHERE (idVillage == 3) AND (typeReserve == 'ELIXIRNOIR');
UPDATE Reserves SET (quantite = 1000000) WHERE (idVillage == 4) AND (typeReserve == 'OR');
UPDATE Reserves SET (quantite = 1000000) WHERE (idVillage == 4) AND (typeReserve == 'ELIXIR');
UPDATE Reserves SET (quantite = 10000) WHERE (idVillage == 4) AND (typeReserve == 'ELIXIRNOIR');
UPDATE Reserves SET (quantite = 1000000) WHERE (idVillage == 11) AND (typeReserve == 'OR');
UPDATE Reserves SET (quantite = 1000000) WHERE (idVillage == 11) AND (typeReserve == 'ELIXIR');
UPDATE Reserves SET (quantite = 10000) WHERE (idVillage == 11) AND (typeReserve == 'ELIXIRNOIR');

prompt "Insertion des tuples Camp"

