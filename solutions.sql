USE PUBLICATIONS;


-- Desafío 1 - ¿Quién ha publicado qué y dónde?
-- En este desafío escribirás una consulta SELECT de MySQL que una varias tablas para descubrir qué títulos ha publicado cada autor en qué editoriales. Tu salida debe tener al menos las siguientes columnas:

-- AUTHOR ID - el ID del autor
-- LAST NAME - apellido del autor
-- FIRST NAME - nombre del autor
-- TITLE - nombre del título publicado
-- PUBLISHER - nombre de la editorial donde se publicó el título

-- SOLUTION

SELECT 
    T1.au_id AS 'AUTHOR ID',
    T1.au_lname AS 'LAST NAME',
    T1.au_fname AS 'FIRST NAME',
    T3.title AS 'TITLE',
    t4.pub_name AS 'PUBLISHER'
FROM
    authors AS T1
        LEFT JOIN
    titleauthor AS T2 ON T1.au_id = T2.au_id
        LEFT JOIN
    titles AS T3 ON T2.title_id = T3.title_id
        LEFT JOIN
    publishers AS T4 ON T3.pub_id = T4.pub_id
WHERE
    T3.title IS NOT NULL
        AND T4.pub_name IS NOT NULL
ORDER BY T1.au_id , T3.title DESC
;


-- Desafío 2 - ¿Quién ha publicado cuántos y dónde?
-- Partiendo de tu solución en el Desafío 1, consulta cuántos títulos ha publicado cada autor en cada editorial. Tu salida debería parecerse a esto:

-- SOLUTION
SELECT 
    T1.au_id AS 'AUTHOR ID',
    T1.au_lname AS 'LAST NAME',
    T1.au_fname AS 'FIRST NAME',
    t4.pub_name AS 'PUBLISHER',
    COUNT(T3.title) AS 'TITLE COUNT'    
FROM
    authors AS T1
        LEFT JOIN
    titleauthor AS T2 ON T1.au_id = T2.au_id
        LEFT JOIN
    titles AS T3 ON T2.title_id = T3.title_id
        LEFT JOIN
    publishers AS T4 ON T3.pub_id = T4.pub_id
WHERE
    T3.title IS NOT NULL
        AND T4.pub_name IS NOT NULL
GROUP BY T1.au_id, T1.au_lname, T1.au_fname, T4.pub_name
ORDER BY T1.au_id desc, T4.pub_name DESC
;

-- Desafío 3 - Autores Más Vendidos
-- ¿Quiénes son los 3 principales autores que han vendido el mayor número de títulos? Escribe una consulta para averiguarlo.

-- Requisitos:

-- Tu salida debería tener las siguientes columnas:
-- AUTHOR ID - el ID del autor
-- LAST NAME - apellido del autor
-- FIRST NAME - nombre del autor
-- TOTAL - número total de títulos vendidos de este autor
-- Tu salida debería estar ordenada basándose en TOTAL de mayor a menor.
-- Solo muestra los 3 mejores autores en ventas.

-- Solution:

SELECT 
    T1.au_id AS 'AUTHOR ID',
    T1.au_lname AS 'LAST NAME',
    T1.au_fname AS 'FIRST NAME',
    sum(T3.qty) AS 'TOTAL'    
FROM
    authors AS T1
        LEFT JOIN
    titleauthor AS T2 ON T1.au_id = T2.au_id
		LEFT JOIN
	sales AS T3 ON T3.title_id = T2.title_id

WHERE T3.qty IS NOT NULL
GROUP BY T1.au_id, T1.au_lname, T1.au_fname, T3.qty
ORDER BY T3.qty desc
LIMIT 3;

-- Desafío 4 - Ranking de Autores Más Vendidos
-- Ahora modifica tu solución en el Desafío 3 para que la salida muestre a todos los 23 autores en lugar de solo los 3 principales. 
-- Ten en cuenta que los autores que han vendido 0 títulos también deben aparecer en tu salida (idealmente muestra 0 en lugar de NULL como TOTAL). 
-- También ordena tus resultados basándose en TOTAL de mayor a menor.

-- Solution:
SELECT 
    T1.au_id AS 'AUTHOR ID',
    T1.au_lname AS 'LAST NAME',
    T1.au_fname AS 'FIRST NAME',
    coalesce(sum(T3.qty),0) AS 'TOTAL'    
FROM
    authors AS T1
        LEFT JOIN
    titleauthor AS T2 ON T1.au_id = T2.au_id
		LEFT JOIN
	sales AS T3 ON T3.title_id = T2.title_id

GROUP BY T1.au_id, T1.au_lname, T1.au_fname, T3.qty
ORDER BY T3.qty desc;