CREATE TABLE Village(
	idVillage INT(10) NOT NULL, 
  nomJoueur VARCHAR(20) UNIQUE NOT NULL,
  niveauJoueur NUMERIC(3,0) DEFAULT 1,
  capaciteeCampMax INT(100) NOT NULL,
  idClan INT(10),
  CONSTRAINT PK_IDVILLLAGE PRIMARY KEY idVillage,
  CONSTRAINT FK_IDVILLLAGE FOREIGN KEY idClan REFERENCES Clan(idClan)
);

CREATE TABLE Clan(
  idClan INT(10),
  nomClan VARCHAR(20) UNIQUE NOT NULL,
  regionClan VARCHAR(20),
  membresMax INT(100) NOT NULL,
  niveauClan INT(100) NOT NULL,
  tropheesMinimum INT(100),
  chefDeClan INT(10) NOT NULL,
  CONSTRAINT PK_idClan PRIMARY KEY idClan,
  CONSTRAINT FK_CHEFDECLAN FOREIGN KEY chefDeClan REFERENCES Village(idVillage)
);

CREATE TABLE Troupe(
  idTroupe INT(10),
  nomTroupe VARCHAR(20) NOT NULL,
  PV INT(10) NOT NULL,
  degats INT(10) NOT NULL,
  vitesseAttaque INT(10) NOT NULL,
  portee INT(10) NOT NULL,
  niveau INT(10) NOT NULL DEFAULT 1,
  placeOccupée INT(10) NOT NULL,
  prixElixir INT(10) NOT NULL,
  prixElixirNoir INT(10) NOT NULL,
  tempsFormation INT(10) NOT NULL,
  CONSTRAINT PK_IDTROUPE PRIMARY KEY idTroupe
);

CREATE TABLE Camp(
  idCamp INT(10),
  typeTroupe INT(10) NOT NULL,
  idVillage INT(10) NOT NULL,
  CONSTRAINT PK_IDCAMP PRIMARY KEY idCamp,
  CONSTRAINT FK_typeTroupe FOREIGN KEY typeTroupe REFERENCES Troupe(idTroupe),
  CONSTRAINT FK_idVillage FOREIGN KEY idVillage REFERENCES Village(idVillage)
);

CREATE TABLE Heros(
  idHeros INT(10),
  typeHeros ENUM('Reine des Archers', 'Roi des barbares', 'Grand Gardien', 'Championne Royale'),
  niveauHeros NUMERIC(2,0) DEFAULT 1,
  vieHeros INT(5),
  idVillage INT(10) NOT NULL,
  CONSTRAINT PK_IDHEROS PRIMARY KEY idHeros,
  CONSTRAINT FK_idVillage FOREIGN KEY idVillage REFERENCES Village(idVillage)
);

CREATE TABLE Reserves(
  idReserve INT(10),
  typeReserve ENUM('Or', 'Elixir', 'ElixirNoir'),
  quantiteMax INT(10) DEFAULT 100,
  quantite INT(10) DEFAULT 0,
  idVillage INT(10) NOT NULL,
  CONSTRAINT PK_IDRESERVE PRIMARY KEY idReserve,
  CONSTRAINT FK_idVillageReserve FOREIGN KEY idVillage REFERENCES Village(idVillage)
);

CREATE TABLE GuerreDeClan(
  idGuerre INT(10),
  idClan1 INT(10) NOT NULL,
  idClan2 INT(10) NOT NULL,
  dateDebut TIMESTAMP NOT NULL,
  etoilesClan1 NUMERIC(3,0) DEFAULT 0,
  etoilesClan2 NUMERIC(3,0) DEFAULT 0,
  CONSTRAINT PK_IDGUERRE PRIMARY KEY idGuerre,
  CONSTRAINT FK_idClan1 FOREIGN KEY idClan1 REFERENCES Clan(idClan),
  CONSTRAINT FK_idClan2 FOREIGN KEY idClan2 REFERENCES Clan(idClan)
);

CREATE TABLE Attaque(
  idAttaque INT(10) NOT NULL,
  idAttaquant INT(10) NOT NULL,
  idDefenseur INT(10) NOT NULL,
  nombreEtoiles INT(10),
  pourcentage INT(100),
  temps INT(10),
  elixirRecolte INT(10),
  orRecolte INT(10),
  elixirNoirRecolte INT(10),
  CONSTRAINT PK_idAttaque PRIMARY KEY idAttaque,
  CONSTRAINT FK_idAttaquant FOREIGN KEY idAttaquant REFERENCES Village(idVillage),
  CONSTRAINT FK_idDefenseur FOREIGN KEY idDefenseur REFERENCES Village(idVillage)
);

CREATE TABLE AttaqueDeGuerre(
  idGuerre INT(10) NOT NULL,
  idAttaque INT(10) NOT NULL,
  CONSTRAINT PK_IDATTAQUECLAN PRIMARY KEY (idGuerre, idAttaque),
  CONSTRAINT PK_idGuerre FOREIGN KEY idGuerre REFERENCES GuerreDeClan(idGuerre),
  CONSTRAINT PK_idAttaque FOREIGN KEY idAttaque REFERENCES Attaque(idAttaque)
);