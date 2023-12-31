-- SELECT

--1- Selezionare tutte le software house americane (3)
SELECT * FROM `software_houses` 
WHERE `country` LIKE 'united states';
--2- Selezionare tutti i giocatori della città di 'Rogahnland' (2)
SELECT * FROM `players` 
WHERE `city` LIKE 'Rogahnland';
--3- Selezionare tutti i giocatori il cui nome finisce per "a" (220)
SELECT * FROM `players` 
WHERE `name` LIKE '%a';
--4- Selezionare tutte le recensioni scritte dal giocatore con ID = 800 (11)
SELECT * FROM `reviews` 
WHERE `player_id` = '800';
--5- Contare quanti tornei ci sono stati nell'anno 2015 (9)
SELECT COUNT(year) 
FROM `tournaments`
WHERE `year` = '2015';
--6- Selezionare tutti i premi che contengono nella descrizione la parola 'facere' (2)
SELECT * 
FROM `awards`
WHERE `description` LIKE '%facere%';
--7- Selezionare tutti i videogame che hanno la categoria 2 (FPS) o 6 (RPG), mostrandoli una sola volta (del videogioco vogliamo solo l'ID) (287) ----- NON DA RISULTATO SPERATO
SELECT DISTINCT `videogame_id`
FROM `pegi_label_videogame` 
WHERE `pegi_label_id` = '2' OR `pegi_label_id` = '6';
--8- Selezionare tutte le recensioni con voto compreso tra 2 e 4 (2947)
SELECT * 
FROM `reviews`
WHERE `rating` BETWEEN 2 AND 4;
--9- Selezionare tutti i dati dei videogiochi rilasciati nell'anno 2020 (46)
SELECT * 
FROM `videogames`
WHERE `release_date` LIKE '2020%';
--10- Selezionare gli id dei videogame che hanno ricevuto almeno una recensione da 5 stelle, mostrandoli una sola volta (443)
SELECT DISTINCT `videogame_id` 
FROM `reviews`
WHERE `rating` = 5;
--*********** BONUS ***********
--
--11- Selezionare il numero e la media delle recensioni per il videogioco con ID = 412 (review number = 12, avg_rating = 3.16 circa)
--
--12- Selezionare il numero di videogame che la software house con ID = 1 ha rilasciato nel 2018 (13)

---------------------------------------------------------------------------------------------------------------------------------------------------
-- GROUP BY

-- 1- Contare quante software house ci sono per ogni paese (3)
SELECT COUNT(id) 
FROM `software_houses`
GROUP BY `country`;
-- 2- Contare quante recensioni ha ricevuto ogni videogioco (del videogioco vogliamo solo l'ID) (500)
SELECT COUNT(id) 
FROM `reviews`
GROUP BY `videogame_id`;
-- 3- Contare quanti videogiochi ha ciascuna classificazione PEGI (della classificazione PEGI vogliamo solo l'ID) (13)
SELECT COUNT(videogame_id)
FROM `pegi_label_videogame`
GROUP BY `pegi_label_id`;
-- 4- Mostrare il numero di videogiochi rilasciati ogni anno (11)
SELECT YEAR(release_date) AS AnnoDiRilascio, COUNT(*) AS NumeroDiVideogiochi
FROM `videogames`
GROUP BY YEAR(release_date)
ORDER BY AnnoDiRilascio;
-- 5- Contare quanti videogiochi sono disponbiili per ciascun device (del device vogliamo solo l'ID) (7)
SELECT device_id, COUNT(videogame_id) AS NumeroDiVideogiochi
FROM `device_videogame`
GROUP BY `device_id`;
-- 6- Ordinare i videogame in base alla media delle recensioni (del videogioco vogliamo solo l'ID) (500)
SELECT `videogame_id`, AVG(rating) AS MediaRecensioni
FROM `reviews`
GROUP BY `videogame_id`
ORDER BY MediaRecensioni DESC;
------------------------------------------------------------------------------------------------------------------------------------------------------------

-- JOIN

-- 1- Selezionare i dati di tutti giocatori che hanno scritto almeno una recensione, mostrandoli una sola volta (996)
SELECT DISTINCT P.*
FROM `players` P
JOIN `reviews` R ON P.`id` = R.`player_id`;
-- 2- Sezionare tutti i videogame dei tornei tenuti nel 2016, mostrandoli una sola volta (226)
SELECT DISTINCT V.*
FROM `videogames` V
JOIN `tournament_videogame` TV ON V.`id` = TV.`videogame_id`
JOIN `tournaments` T ON TV.`tournament_id` = T.`id`
WHERE T.year = 2016;
-- 3- Mostrare le categorie di ogni videogioco (1718)
SELECT V.`id`, C.`name`
FROM `videogames` V
JOIN `category_videogame` CV ON V.`id` = CV.`videogame_id`
JOIN `categories` C ON CV.`category_id` = C.`id`;
-- 4- Selezionare i dati di tutte le software house che hanno rilasciato almeno un gioco dopo il 2020, mostrandoli una sola volta (6)
SELECT DISTINCT SH.*
FROM `software_houses` SH
JOIN `videogames` V ON `SH`.`id` = `V`.`software_house_id`
WHERE YEAR(V.release_date) > 2020;
-- 5- Selezionare i premi ricevuti da ogni software house per i videogiochi che ha prodotto (55)
SELECT SH.`id`, SH.`name` AS NomeSoftwareHouse, `A`.`name` AS NomePremio
FROM software_houses SH
JOIN videogames V ON SH.`id` = V.`software_house_id`
JOIN award_videogame AV ON V.`id` = `AV`.`videogame_id`
JOIN awards A ON `AV`.`award_id` = `A`.`id`;
-- 6- Selezionare categorie e classificazioni PEGI dei videogiochi che hanno ricevuto recensioni da 4 e 5 stelle, mostrandole una sola volta (3363)
SELECT DISTINCT `C`.`name`, `PL`.`name`
FROM videogames V
JOIN category_videogame CV ON `V`.`id` = `CV`.`videogame_id`
JOIN categories C ON `CV`.`category_id` = `C`.`id`
JOIN pegi_label_videogame PV ON `V`.`id` = `PV`.`videogame_id`
JOIN pegi_labels PL ON `PV`.`pegi_label_id` = `PL`.`id`
JOIN reviews R ON `V`.`id` = `R`.`videogame_id`
WHERE R.rating IN (4, 5);
-- 7- Selezionare quali giochi erano presenti nei tornei nei quali hanno partecipato i giocatori il cui nome inizia per 'S' (474) ------- ME NE DA 473
SELECT DISTINCT `V`.`name`
FROM videogames V
JOIN tournament_videogame TV ON `V`.`id` = `TV`.`videogame_id`
JOIN player_tournament PT ON `TV`.`tournament_id` = `PT`.`tournament_id`
JOIN players P ON `PT`.`player_id` = `P`.`id`
WHERE `P`.`name` LIKE 'S%';
-- 8- Selezionare le città in cui è stato giocato il gioco dell'anno del 2018 (36) -------- NON FUNZIONA
SELECT DISTINCT `T`.`city`
FROM tournaments T
JOIN tournament_videogame TV ON `T`.`id` = `TV`.`tournament_id`
JOIN award_videogame AV ON `TV`.`videogame_id` = `AV`.`videogame_id`
JOIN awards A ON `AV`.`award_id` = `A`.`id`
JOIN videogames V ON `AV`.`videogame_id` = `V`.`id`
WHERE `A`.`id` = 1 AND V.release_date = 2018;
-- 9- Selezionare i giocatori che hanno giocato al gioco più atteso del 2018 in un torneo del 2019 (3306) ----- NON FUNZIONA
SELECT DISTINCT P.*
FROM players P
JOIN player_tournament PT ON `P`.`id` = `PT`.`player_id`
JOIN tournament_videogame TV ON `PT`.`tournament_id` = `TV`.`tournament_id`
JOIN award_videogame AV ON `TV`.`videogame_id` = `AV`.`videogame_id`
JOIN awards A ON `AV`.`award_id` = `A`.`id`
JOIN videogames V ON `AV`.`videogame_id` = `V`.`id`
JOIN tournaments T ON `TV`.`tournament_id` = `T`.`id`
WHERE `A`.`id` = 5 AND V.release_date = 2018 AND T.year = 2019;
-- 
-- *********** BONUS ***********
-- 
-- 10- Selezionare i dati della prima software house che ha rilasciato un gioco, assieme ai dati del gioco stesso (software house id : 5)
-- 
-- 11- Selezionare i dati del videogame (id, name, release_date, totale recensioni) con più recensioni (videogame id : potrebbe uscire 449 o 398, sono entrambi a 20)
-- 
-- 12- Selezionare la software house che ha vinto più premi tra il 2015 e il 2016 (software house id : potrebbe uscire 3 o 1, sono entrambi a 3)
-- 
-- 13- Selezionare le categorie dei videogame i quali hanno una media recensioni inferiore a 2 (10)

award_videogame
categories
category_videogame
devices
device_videogame
failed_jobs
migrations
pegi_labels
pegi_label_videogame
players
player_tournament