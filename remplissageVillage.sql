/*
INSERT INTO Troupe VALUES (ID,NOM,PV,DEGAT,PLACE,PRIX_ELIXIR,prix_noir);
*/

INSERT INTO Troupe VALUES (1,'Barbare',100,30,1,250,0);
INSERT INTO Troupe VALUES (2,'Archère',50,25,1,500,0);
INSERT INTO Troupe VALUES (3,'Géant',1250,100,5,3500,0);
INSERT INTO Troupe VALUES (4,'Gobelin',75,27,1,150,0);
INSERT INTO Troupe VALUES (5,'Sapeur',70,500,2,1500,0);
INSERT INTO Troupe VALUES (6,'Ballon',550,400,5,4500,0);
INSERT INTO Troupe VALUES (7,'Sorcier',200,300,4,3500,0);
INSERT INTO Troupe VALUES (8,'Guérisseuse',1200,70,14,10000,0);
INSERT INTO Troupe VALUES (9,'Dragon',3100,500,20,18000,0);
INSERT INTO Troupe VALUES (10,'PEKKA',5200,1600,25,25000,0);
INSERT INTO Troupe VALUES (11,'Bébé Dragon',1500,85,10,7000,0);
INSERT INTO Troupe VALUES (12,'Mineur',700,100,6,5500,0);
INSERT INTO Troupe VALUES (13,'Electro Dragon',3200,1200,30,28000,0);
INSERT INTO Troupe VALUES (14,'Yeti',2900,500,18,19000,0);
INSERT INTO Troupe VALUES (15,'Chevaucheur de Dragon',4100,550,25,22000,0);
INSERT INTO Troupe VALUES (16,'Gargouille',75,50,2,0,30);
INSERT INTO Troupe VALUES (17,'Chevaucheur de cochon',480,80,5,0,65);
INSERT INTO Troupe VALUES (18,'Valkyrie',900,70,8,0,100);
INSERT INTO Troupe VALUES (19,'Golem',6300,26,30,0,500);
INSERT INTO Troupe VALUES (20,'Sorcière',400,100,12,0,200);
INSERT INTO Troupe VALUES (21,'Molosse de lave',6800,14,30,0,600);
INSERT INTO Troupe VALUES (22,'Bouliste',310,50,6,0,90);
INSERT INTO Troupe VALUES (23,'Golem de glace',2600,12,15,0,300);
INSERT INTO Troupe VALUES (24,'Chasseuse de têtes',360,105,6,0,120);

/*
INSERT INTO Village VALUES (ID, NOM_village, lvl, capacité_camp, clan);
*/
INSERT INTO Village VALUES (1, 'MateoDu13', 1, 260, 12, NULL);
INSERT INTO Village VALUES (2, 'MAXIME', 125, 240, 2800, NULL);
INSERT INTO Village VALUES (3, 'ADAM', 53, 160, 600, NULL);
INSERT INTO Village VALUES (4, 'ARNAUD', 75, 200, 800, NULL);
INSERT INTO Village VALUES (5, 'BLAISE', 47, 120, 1200, NULL);
INSERT INTO Village VALUES (6, 'DOOBY', 26, 80, 50, NULL);
INSERT INTO Village VALUES (7, 'AROUF', 210, 320, 4500, NULL);
INSERT INTO Village VALUES (8, 'LACRIM', 92, 220, 2000, NULL);
INSERT INTO Village VALUES (9, 'EPHEM', 111, 240, 2100, NULL);
INSERT INTO Village VALUES (10, 'GAZO', 136, 260, 2500, NULL);
INSERT INTO Village SET (nomJoueur) VALUES ('GATIEN');

/*
INSERT INTO Attaque VALUES (ID,id_atk,id_def,nb_etoiles,pourcentage,elixir,or,elixir_noir);
*/
INSERT INTO Attaque VALUES (1,0002,0001,2,67,928680,874315,8436);
INSERT INTO Attaque VALUES (2,0001,0007,1,52,125864,130221,589);

/*
INSERT INTO Clan VALUES (ID,Nom,region,niveau,chef)
*/
INSERT INTO Clan VALUES (01,'Gnumz Team','FR',15,3)
INSERT INTO Clan VALUES (02,'FC GANGST','US',12,7)
INSERT INTO Clan VALUES (03,'Les Zoulettes','ES',4,6)
INSERT INTO Clan VALUES (4,'Les Zelus','MONTPELLIER',1,1)

/*
INSERT INTO GuerreDeClan VALUES (idGuerre,idClan1,idClan2,date,etoiles1,etoiles2)
*/
INSERT INTO GuerreDeClan VALUES (01,01,02,)