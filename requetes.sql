
/* Toutes les troupes différentes du village de 'MateoDu13' (group by) */
SELECT Troupe.nomTroupe FROM Troupe, Camp, Village
WHERE Troupe.idTroupe=Camp.typeTroupe
AND Camp.idVillage=Village.idVillage
AND Village.nomJoueur='MatLeBg'
GROUP BY Troupe.nomTroupe;

/* Des unités non utilisées dans le camp (Sous-requête) */
SELECT Troupe.idTroupe, Troupe.NomTroupe FROM Troupe 
WHERE Troupe.idTroupe NOT IN (SELECT Camp.TypeTroupe FROM Camp 
                            GROUP BY Camp.TypeTroupe);

/* Or Moyen du clan daudé (Sous requête) */
SELECT AVG(quantite) FROM Reserve, Village, Clan
AND Reserve.typeReserve='Or'
AND Reserve.idVillage=Village.idVillage
AND Village.idClan=Clan.idClan
AND Clan.nomClan='daudé'

/* Nombre de troupes du village de 'Chumm' (group by) */
SELECT Village.nomJoueur, COUNT(*) FROM Camp, Village
AND Camp.idVillage=Village.idVillage
AND Village.nomJoueur='Chumm'
GROUP BY Village.nomJoueur;

