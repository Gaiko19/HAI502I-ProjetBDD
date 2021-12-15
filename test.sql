@creationVillage.sql

@fonctions.sql

@triggers.sql 

prompt "---------------------------------------------"
--Test trigger Nom de troupe en majuscule lors de l'ajout
prompt -Test du Trigger NomDeTroupeMajuscule
INSERT INTO Troupe VALUES (25, 'gnomes', 100, 30, 1, 250, 0);

prompt "---------------------------------------------"
--Test trigger Nom de village en majuscule lors de l'ajout et calcul capamax
prompt -Test du Trigger NomDeVillageMajuscule et MiseANiveauNouveauVillage
INSERT INTO Village(idVillage, nomJoueur, niveauJoueur,capaciteeCampMax, trophees, idClan) VALUES (18, 'martin', 45, 1200, 1300, null);

prompt "---------------------------------------------"
--Test trigger changement de chef
prompt -Test du Trigger changementChefDeClan


prompt "---------------------------------------------"
--Test trigger calcul Attaque
prompt -Test du Trigger calculAttaque

prompt "Ajout de l'attaquant"
INSERT INTO Village(idVillage, nomJoueur, niveauJoueur,capaciteeCampMax, trophees, idClan) VALUES (19, 'attaquant', 45, 1200, 1300, null);
prompt -Ajout du defenseur
INSERT INTO Village(idVillage, nomJoueur, niveauJoueur,capaciteeCampMax, trophees, idClan) VALUES (20, 'defenseur', 55, 1200, 1350, null);

prompt "Affichage des trophees du village attaquant avant l'attaque"
SELECT Trophees FROM Village where idVillage = 19;
prompt "Affichage des trophees du village defenseur avant l'attaque"
SELECT Trophees FROM Village where idVillage = 20;

prompt -Attaque terminée

INSERT INTO Attaque VALUES (21, 19, 20, 3, 100, 12000, 14000, 1000, null);
prompt "Affichage des trophees du village attaquant après l'attaque"
SELECT Trophees FROM Village where idVillage = 19;
prompt "Affichage des trophees du village defenseur après l'attaque"
SELECT Trophees FROM Village where idVillage = 20;

prompt "---------------------------------------------"
--Test trigger ajout de troupe si on à la place
prompt -Test du Trigger nouvelleTroupe

prompt -Insertion de 40 archères dans le village de martin
INSERT INTO Camp VALUES (1, 2, 18, 40);

prompt -Nombre de troupes et leurs id pour le village de Martin
SELECT nbrTroupe, idTroupe FROM Camp where idVillage=18 GROUP BY idTroupe; 
prompt "Tentative d'insertion de 300 archères dans le village de martin"
INSERT INTO Camp VALUES (20, 2, 18, 300);

prompt "---------------------------------------------"
--Test trigger rejoindre un clan s'il n'y a pas de place
prompt -Test pour voir si il reste une place dans le idClan
prompt "Creation d'un clan avec Martin comme chef"
INSERT INTO Clan VALUES (33,'TEST','FR',15, 18);

prompt "Création de 49 membres (C'est long)"
INSERT INTO Village(idVillage, nomJoueur, idClan) VALUES (100, '1', 33);
INSERT INTO Village(idVillage, nomJoueur, idClan) VALUES (101, '2', 33);
INSERT INTO Village(idVillage, nomJoueur, idClan) VALUES (102, '3', 33);
INSERT INTO Village(idVillage, nomJoueur, idClan) VALUES (103, '4', 33);
INSERT INTO Village(idVillage, nomJoueur, idClan) VALUES (104, '5', 33);
INSERT INTO Village(idVillage, nomJoueur, idClan) VALUES (105, '6', 33);
INSERT INTO Village(idVillage, nomJoueur, idClan) VALUES (106, '7', 33);
INSERT INTO Village(idVillage, nomJoueur, idClan) VALUES (107, '8', 33);
INSERT INTO Village(idVillage, nomJoueur, idClan) VALUES (108, '9', 33);
INSERT INTO Village(idVillage, nomJoueur, idClan) VALUES (109, '10', 33);

INSERT INTO Village(idVillage, nomJoueur, idClan) VALUES (110, '11', 33);
INSERT INTO Village(idVillage, nomJoueur, idClan) VALUES (111, '12', 33);
INSERT INTO Village(idVillage, nomJoueur, idClan) VALUES (112, '13', 33);
INSERT INTO Village(idVillage, nomJoueur, idClan) VALUES (113, '14', 33);
INSERT INTO Village(idVillage, nomJoueur, idClan) VALUES (114, '15', 33);
INSERT INTO Village(idVillage, nomJoueur, idClan) VALUES (115, '16', 33);
INSERT INTO Village(idVillage, nomJoueur, idClan) VALUES (116, '17', 33);
INSERT INTO Village(idVillage, nomJoueur, idClan) VALUES (117, '18', 33);
INSERT INTO Village(idVillage, nomJoueur, idClan) VALUES (118, '19', 33);
INSERT INTO Village(idVillage, nomJoueur, idClan) VALUES (119, '20', 33);

INSERT INTO Village(idVillage, nomJoueur, idClan) VALUES (120, '21', 33);
INSERT INTO Village(idVillage, nomJoueur, idClan) VALUES (121, '22', 33);
INSERT INTO Village(idVillage, nomJoueur, idClan) VALUES (122, '23', 33);
INSERT INTO Village(idVillage, nomJoueur, idClan) VALUES (123, '24', 33);
INSERT INTO Village(idVillage, nomJoueur, idClan) VALUES (124, '25', 33);
INSERT INTO Village(idVillage, nomJoueur, idClan) VALUES (125, '26', 33);
INSERT INTO Village(idVillage, nomJoueur, idClan) VALUES (126, '27', 33);
INSERT INTO Village(idVillage, nomJoueur, idClan) VALUES (127, '28', 33);
INSERT INTO Village(idVillage, nomJoueur, idClan) VALUES (128, '29', 33);
INSERT INTO Village(idVillage, nomJoueur, idClan) VALUES (129, '30', 33);

INSERT INTO Village(idVillage, nomJoueur, idClan) VALUES (130, '31', 33);
INSERT INTO Village(idVillage, nomJoueur, idClan) VALUES (131, '32', 33);
INSERT INTO Village(idVillage, nomJoueur, idClan) VALUES (132, '33', 33);
INSERT INTO Village(idVillage, nomJoueur, idClan) VALUES (133, '34', 33);
INSERT INTO Village(idVillage, nomJoueur, idClan) VALUES (134, '35', 33);
INSERT INTO Village(idVillage, nomJoueur, idClan) VALUES (135, '36', 33);
INSERT INTO Village(idVillage, nomJoueur, idClan) VALUES (136, '37', 33);
INSERT INTO Village(idVillage, nomJoueur, idClan) VALUES (137, '38', 33);
INSERT INTO Village(idVillage, nomJoueur, idClan) VALUES (138, '39', 33);
INSERT INTO Village(idVillage, nomJoueur, idClan) VALUES (139, '40', 33);

INSERT INTO Village(idVillage, nomJoueur, idClan) VALUES (140, '41', 33);
INSERT INTO Village(idVillage, nomJoueur, idClan) VALUES (141, '42', 33);
INSERT INTO Village(idVillage, nomJoueur, idClan) VALUES (142, '43', 33);
INSERT INTO Village(idVillage, nomJoueur, idClan) VALUES (143, '44', 33);
INSERT INTO Village(idVillage, nomJoueur, idClan) VALUES (144, '45', 33);
INSERT INTO Village(idVillage, nomJoueur, idClan) VALUES (145, '46', 33);
INSERT INTO Village(idVillage, nomJoueur, idClan) VALUES (146, '47', 33);
INSERT INTO Village(idVillage, nomJoueur, idClan) VALUES (147, '48', 33);

prompt "Insertion du 50eme membres "
INSERT INTO Village(idVillage, nomJoueur, idClan) VALUES (148, '49', 33);

prompt "Tentative d'insertion d'un 51eme membre"
INSERT INTO Village(idVillage, nomJoueur, idClan) VALUES (149, '50', 33);

prompt "---------------------------------------------"
--Test trigger passage des reserves en négatif à 0
prompt -Test passage des reserves en négatif à 0
prompt "Modification d'une reserve"
UPDATE Reserves SET (quantite = -2) WHERE (idVillage == 2) AND (typeReserve == 'OR');
