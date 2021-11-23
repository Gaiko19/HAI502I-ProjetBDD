/* 
Des unités non utilisées dans le camp (Group By) : 
*/
SELECT Troupe.idTroupe, Troupe.NomTroupe FROM Troupe WHERE Troupe.idTroupe NOT IN (SELECT Camp.TypeTroupe FROM Camp GROUP BY Camp.TypeTroupe);
 


/*
Or Moyen du clan daudé (Sous requête) :
*/
SELECT AVG(quantite) FROM Reserve, Village, Clan
AND Reserve.typeReserve='Or'
AND Reserve.idVillage=Village.



