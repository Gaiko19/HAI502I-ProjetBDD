/*
Suppression des relations 
*/
/*
*************************************************
ATTENTION NE PAS TOUCHER AUX LIGNES SUIVANTES
ELLES PERMETTENT DE SUPPRIMER PROPREMENT LES RELATIONS
*************************************************
*/

prompt "Suppression des relations"

/*BEGIN
EXECUTE IMMEDIATE 'ALTER TABLE Village DROP CONSTRAINT FK_idClan';
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE != -942 THEN
    RAISE;
    END IF;
END;
/*/

BEGIN
EXECUTE IMMEDIATE 'DROP TABLE AttaqueDeGuerre';
EXCEPTION
 WHEN OTHERS THEN
  IF SQLCODE != -942 THEN
  RAISE;
  END IF;
END;
/

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


/*
*************************************************
*/


/*
Création des relations 
*/

prompt "Création des relations"



CREATE TABLE Village(
	idVillage NUMBER(10) NOT NULL, 
  nomJoueur VARCHAR(20) UNIQUE NOT NULL,
  niveauJoueur NUMERIC(3,0) DEFAULT 1,
  capaciteeCampMax NUMBER(10) NOT NULL,
  idClan NUMBER(10),
  CONSTRAINT PK_IDVILLLAGE PRIMARY KEY (idVillage)
);

CREATE TABLE Clan(
  idClan NUMBER(10),
  nomClan VARCHAR(20) UNIQUE NOT NULL,
  regionClan VARCHAR(20),
  membresMax NUMBER(10) NOT NULL,
  niveauClan NUMBER(10) NOT NULL,
  tropheesMinimum NUMBER(10),
  chefDeClan NUMBER(10) NOT NULL,
  CONSTRAINT PK_idClan PRIMARY KEY (idClan),
  CONSTRAINT FK_CHEFDECLAN FOREIGN KEY (chefDeClan) REFERENCES Village(idVillage)
);

CREATE TABLE Troupe(
  idTroupe NUMBER(10),
  nomTroupe VARCHAR(30) NOT NULL,
  PV NUMBER(10) NOT NULL,
  degats NUMBER(10) NOT NULL,
  vitesseAttaque NUMBER(10) NOT NULL,
  portee NUMBER(10) NOT NULL,
  placeOccupee NUMBER(10) NOT NULL,
  prixElixir NUMBER(10) NOT NULL,
  prixElixirNoir NUMBER(10) NOT NULL,
  tempsFormation NUMBER(10) NOT NULL,
  CONSTRAINT PK_IDTROUPE PRIMARY KEY (idTroupe)
);

CREATE TABLE Camp(
  idCamp NUMBER(10),
  typeTroupe NUMBER(10) NOT NULL,
  idVillage NUMBER(10) NOT NULL,
  CONSTRAINT PK_IDCAMP PRIMARY KEY (idCamp),
  CONSTRAINT FK_typeTroupe FOREIGN KEY (typeTroupe) REFERENCES Troupe(idTroupe),
  CONSTRAINT FK_idVillageCamp FOREIGN KEY (idVillage) REFERENCES Village(idVillage)
);

CREATE TABLE Heros(
  idHeros NUMBER(10),
  typeHeros VARCHAR(10) CHECK( typeHeros IN ('Reine des Archers', 'Roi des barbares', 'Grand Gardien', 'Championne Royale')),
  niveauHeros NUMERIC(2,0) DEFAULT 1,
  vieHeros NUMBER(5),
  idVillage NUMBER(10) NOT NULL,
  CONSTRAINT PK_IDHEROS PRIMARY KEY (idHeros),
  CONSTRAINT FK_idVillageHeros FOREIGN KEY (idVillage) REFERENCES Village(idVillage)
);

CREATE TABLE Reserves(
  idReserve NUMBER(10),
  typeReserve VARCHAR(10) CHECK( typeReserve IN ('Or', 'Elixir', 'ElixirNoir')),
  quantiteMax NUMBER(10) DEFAULT 10000000,
  quantite NUMBER(10) DEFAULT 0,
  idVillage NUMBER(10) NOT NULL,
  CONSTRAINT PK_IDRESERVE PRIMARY KEY (idReserve),
  CONSTRAINT FK_idVillageReserve FOREIGN KEY (idVillage) REFERENCES Village(idVillage)
);

CREATE TABLE GuerreDeClan(
  idGuerre NUMBER(10),
  idClan1 NUMBER(10) NOT NULL,
  idClan2 NUMBER(10) NOT NULL,
  dateDebut TIMESTAMP NOT NULL,
  etoilesClan1 NUMERIC(3,0) DEFAULT 0,
  etoilesClan2 NUMERIC(3,0) DEFAULT 0,
  CONSTRAINT PK_IDGUERRE PRIMARY KEY (idGuerre),
  CONSTRAINT FK_idClan1 FOREIGN KEY (idClan1) REFERENCES Clan(idClan),
  CONSTRAINT FK_idClan2 FOREIGN KEY (idClan2) REFERENCES Clan(idClan)
);

CREATE TABLE Attaque(
  idAttaque NUMBER(10) NOT NULL,
  idAttaquant NUMBER(10) NOT NULL,
  idDefenseur NUMBER(10) NOT NULL,
  nombreEtoiles NUMBER(10),
  pourcentage NUMBER(10),
  temps NUMBER(10),
  elixirRecolte NUMBER(10),
  orRecolte NUMBER(10),
  elixirNoirRecolte NUMBER(10),
  CONSTRAINT PK_idAttaque PRIMARY KEY (idAttaque),
  CONSTRAINT FK_idAttaquant FOREIGN KEY (idAttaquant) REFERENCES Village(idVillage),
  CONSTRAINT FK_idDefenseur FOREIGN KEY (idDefenseur) REFERENCES Village(idVillage)
);

CREATE TABLE AttaqueDeGuerre(
  idGuerre NUMBER(10) NOT NULL,
  idAttaque NUMBER(10) NOT NULL,
  CONSTRAINT PK_IDATTAQUECLAN PRIMARY KEY (idGuerre, idAttaque),
  CONSTRAINT FK_idGuerre FOREIGN KEY (idGuerre) REFERENCES GuerreDeClan(idGuerre),
  CONSTRAINT FK_idAttaque FOREIGN KEY (idAttaque) REFERENCES Attaque(idAttaque)
);

/*
*************************************************
*/


/*
Ajout des clés étrangères nécessitant une table
*/

prompt "Ajout des clés etrangères"

ALTER TABLE Village ADD CONSTRAINT FK_idClan FOREIGN KEY (idClan) REFERENCES Clan(idClan);