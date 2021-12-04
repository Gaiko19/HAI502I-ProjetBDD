prompt -Lancement des Triggers 

--[Trigger Nom de la troupe en majuscule]
CREATE OR REPLACE TRIGGER NomTroupeMajuscule
BEFORE INSERT ON Troupe
FOR EACH ROW
BEGIN
  :new.nomTroupe := UPPER(:new.nomTroupe);
END;
/

--[trigger pour actualiser le nombre de joueurs dans un clan lors de la suppression d'un joueur] 
CREATE OR REPLACE TRIGGER SupprimerJoueurClan
AFTER DELETE ON Village
FOR EACH ROW 
BEGIN
  UPDATE clan SET membresMax = (membresMax - 1) WHERE Clan.idVillage = :old.idVillage;
END;
/

--[Trigger pour ajouter un nouveau village avec uniquement le nom du joueur et Nom du joueur en majuscule]
--INSERT INTO Village VALUES (idVillage, nomJoueur, niveauJoueur, capaciteeCampMax, trophees, idClan);
CREATE OR REPLACE TRIGGER nouveauVillage
BEFORE INSERT ON Village
FOR EACH ROW
DECLARE
  id_vil number;
BEGIN
  :new.nomJoueur := UPPER(:new.nomJoueur);
  
  IF :new.niveauJoueur IS NULL THEN :new.niveauJoueur := 1;
  ENF IF;

  :new.capaciteeCampMax := calculCapaMax(:new.niveauJoueur);
END;
/

--[trigger pour créer une troupe en vérifiant qu'on a la place et les sous]
CREATE OR REPLACE TRIGGER nouvelleTroupe
BEFORE INSERT ON Camp
BEGIN
  IF ((:new.idVillage.capaciteeCampMax >= (SELECT SUM(placeOccupee) FROM Camp, Troupe WHERE Camp.typeTroupe = Troupe.idTroupe AND Camp.idVillage = :new.idVillage) + :new.typeTroupe.) AND ((SELECT quantite FROM Reserves WHERE Reserves.idVillage == :new.idVillage AND typeReserve == 'Elixir') >= :new.typeTroupe.prixElixir) AND ((SELECT quantite FROM Reserves WHERE Reserves.idVillage == :new.idVillage AND typeReserve == 'ElixirNoir') >= :new.typeTroupe.prixElixirNoir)) THEN 
  /* /!\ Là j'ai vérifié si la capa max du village était >= à la capa prise par les troupes du village + la troupe ajoutée, si le village avait assez d elixir et d elixir noir, mais jsp comment faire pour rejeter le INSERT si jamais y a pas la place ou pas les sous. Et ensuite si y a les tout qui est bon on ajoute la troupe et on enleve les ressources necessaires
  
  https://stackoverflow.com/questions/41092940/prevent-insert-trigger
  ça good
  */


prompt -Triggers lancés



/*
à faire :

[trigger pour ajouter l'argent gagné après une attaque et l'enlever au défenseur]
[trigger pour ajouter les trophés gagnés après une attaque et les enlever au défenseur]
[trigger pour voir si il reste une place dans le clan qd un mec rejoins (max 50) et si il a le nombre de trophées requis]
*/