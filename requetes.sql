prompt "      "
prompt "##########################################################"
prompt "Toutes les différentes troupes du village de 'MAXIME' (Requete Group By)"
prompt "##########################################################"
prompt "      "

SELECT Troupe.nomTroupe FROM Troupe, Camp, Village
WHERE Troupe.idTroupe=Camp.idTroupe
AND Camp.idVillage=Village.idVillage
AND Village.nomJoueur='MAXIME'
GROUP BY Troupe.nomTroupe;

prompt "      "
prompt "##########################################################"
prompt "Or Moyen du clan GNUMZ"
prompt "##########################################################"
prompt "      "

SELECT AVG(quantite) FROM Reserves, Village, Clan
WHERE Reserves.idVillage = Village.idVillage AND Clan.idClan = Village.idClan 
AND Reserves.typeReserve='OR'
AND Reserves.idVillage=Village.idVillage
AND Village.idClan=Clan.idClan
AND Clan.nomClan='GNUMZ';

prompt "      "
prompt "##########################################################"
prompt "Requete group by : Nombre de troupes du village de 'JEAN'"
prompt "##########################################################"
prompt "      "

SELECT Village.nomJoueur, COUNT(*) FROM Camp, Village
WHERE Village.idVillage = Camp.idVillage
AND Camp.idVillage=Village.idVillage
AND Village.nomJoueur='JEAN'
GROUP BY Village.nomJoueur;

prompt "      "
prompt "##########################################################"
prompt "Requete avec division : Existe-t-il un village tel qu'il n'existe aucune troupe qui ne soit pas formé par ce village ?"
prompt "Autrement dit : Existe-t-il un village qui possède toutes les troupes ?"
prompt "##########################################################"
prompt "      "

SELECT * FROM Village
  WHERE NOT EXISTS
    (SELECT * FROM Troupe WHERE NOT EXISTS
      (SELECT * FROM Camp WHERE Camp.idVillage = Village.idVillage
                          AND Camp.idTroupe = Troupe.idTroupe));

prompt "      "
prompt "##########################################################"
prompt "Les villages qui ne possèdent pas de troupe (Sous-requête)"
prompt "##########################################################"
prompt "      "

SELECT idVillage FROM Village, Camp WHERE Village.idVillage = Camp.idVillage AND idVillage NOT IN (SELECT idVillage FROM Camp GROUP BY idVillage);

prompt "      "
prompt "##########################################################"
prompt "Requete avec sous requete corrélative : Quels sont les villages qui possèdent des troupes"
prompt "##########################################################"
prompt "      "

SELECT idVillage, nomJoueur FROM Village Vil WHERE EXISTS(SELECT * FROM Camp WHERE Vil.idVillage = Camp.idVillage); 
