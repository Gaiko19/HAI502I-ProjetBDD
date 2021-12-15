
--Toutes les troupes différentes du village de 'MateoDu13' (Requete Group By)
SELECT Troupe.nomTroupe FROM Troupe, Camp, Village
WHERE Troupe.idTroupe=Camp.typeTroupe
AND Camp.idVillage=Village.idVillage
AND Village.nomJoueur='MATEODU13'
GROUP BY Troupe.nomTroupe;

--Or Moyen du clan GNUMZ
SELECT AVG(quantite) FROM Reserve, Village, Clan
AND Reserve.typeReserve='OR'
AND Reserve.idVillage=Village.idVillage
AND Village.idClan=Clan.idClan
AND Clan.nomClan='GNUMZ'

--Nombre de troupes du village de 'Chumm' (group by x2)
SELECT Village.nomJoueur, COUNT(*) FROM Camp, Village
AND Camp.idVillage=Village.idVillage
AND Village.nomJoueur='DOOBY'
GROUP BY Village.nomJoueur;

-- Requete avec division

-- Des unités non utilisées dans le camp (Sous-requête)
SELECT Troupe.idTroupe, Troupe.NomTroupe FROM Troupe 
WHERE Troupe.idTroupe NOT IN (SELECT Camp.TypeTroupe FROM Camp 
                            GROUP BY Camp.TypeTroupe);


-- Requete avec ss requete corrélative