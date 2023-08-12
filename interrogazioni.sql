--ANDREA DI VIA 4486604




--PARTE 2
 
--CREAZIONE VISTA
/*
La definizione di una vista che fornisca alcune informazioni riassuntive per ogni gioco: il numero di sfide rela-
tive a quel gioco disputate, la durata media di tali sfide, il numero di squadre e di giocatori partecipanti a tali
sfide, i punteggi minimo, medio e massimo ottenuti dalle squadre partecipanti a tali sfide;
*/


CREATE VIEW riassunto_gioco1 AS
SELECT sfida.idgioco,count(distinct membri.nome) as nsquadre, count(distinct membri.email) as nmembri, count(distinct sfida.idgioco) as nsfide, avg(sfida.durata_max) as durata
FROM SFIDA NATURAL full JOIN MEMBRI
GROUP BY sfida.idgioco, sfida.data, sfida.ora;

CREATE VIEW RIASSUNTO_GIOCO AS
SELECT idgioco, sum(nsquadre) as nsquadre, sum(nmembri) as nmembri, sum(nsfide) as nsfide, avg(durata) as durata
FROM riassunto_gioco1
GROUP BY idgioco;




--INTERROGAZIONI

--Determinare i giochi che contengono caselle a cui sono associati task;


SELECT idGioco
FROM  include_task 
GROUP BY idGioco;

--Determinare i giochi che non contengono caselle a cui sono associati task;


SELECT idGioco
FROM  gioco

EXCEPT 

SELECT idGioco
FROM  include_task 
GROUP BY idGioco;

--Determinare le sfide che hanno durata superiore alla durata media delle sfide relative allo stesso gioco.

create view temporary as
SELECT idgioco, sfida.data, sfida.ora, durata_max, avg(durata_max) as durata
FROM sfida
GROUP BY idgioco, sfida.data, sfida.ora;

SELECT a.idgioco, a.DATA, a.ORA
FROM temporary as a
where a.DURATA > all( SELECT avg(b.durata) from temporary as b)
GROUP BY a.IDGIOCO, a.data, a.ora;