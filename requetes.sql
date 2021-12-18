
prompt "Toutes les différentes troupes du village de 'MAXIME' (Requete Group By)"

SELECT Troupe.nomTroupe FROM Troupe, Camp, Village
WHERE Troupe.idTroupe=Camp.idTroupe
AND Camp.idVillage=Village.idVillage
AND Village.nomJoueur='MAXIME'
GROUP BY Troupe.nomTroupe;

prompt "Or Moyen du clan GNUMZ"

SELECT AVG(quantite) FROM Reserves, Village, Clan
WHERE Reserves.idVillage = Village.idVillage AND Clan.idClan = Village.idClan 
AND Reserves.typeReserve='OR'
AND Reserves.idVillage=Village.idVillage
AND Village.idClan=Clan.idClan
AND Clan.nomClan='GNUMZ';

prompt "Requete group by : Nombre de troupes du village de 'JEAN'"

SELECT Village.nomJoueur, COUNT(*) FROM Camp, Village
WHERE Village.idVillage = Camp.idVillage
AND Camp.idVillage=Village.idVillage
AND Village.nomJoueur='JEAN'
GROUP BY Village.nomJoueur;

prompt "Requete avec division : Existe-t-il un village tel qu'il n'existe aucune troupe qui ne soit pas formé par ce village ?"
prompt "Autrement dit : Existe-t-il un village qui possède toutes les troupes ?"

SELECT * FROM Village
  WHERE NOT EXISTS
    (SELECT * FROM Troupe WHERE NOT EXISTS
      (SELECT * FROM Camp WHERE Camp.idVillage = Village.idVillage
                          AND Camp.idTroupe = Troupe.idTroupe));


prompt "Des unités non utilisées dans le camp (Sous-requête)"

/*SELECT Troupe.idTroupe, Troupe.NomTroupe FROM Troupe 
WHERE Troupe.idTroupe NOT IN (SELECT Camp.idTroupe FROM Camp 
                            GROUP BY Camp.idTroupe);*/


prompt "Requete avec sous requete corrélative : Quels sont les villages qui possèdent des troupes"

SELECT idVillage, nomJoueur FROM Village Vil WHERE EXISTS(SELECT * FROM Camp WHERE Vil.idVillage = Camp.idVillage); 
