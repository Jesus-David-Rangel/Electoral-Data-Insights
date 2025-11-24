--- Análisis de resultados electorales
--- Respuesta a preguntas específicas sobre los datos electorales

--- 1. ¿Cuáles fueron los 3 candidatos con más votos?
SELECT 
    c.nombres || ' ' || c.apellidos AS candidato,
    p.nombre AS partido,
    SUM(r.votos) AS total_votos
FROM resultado r
JOIN candidato c ON c.id = r.candidato_id
JOIN partido p ON p.id = c.partido_id
GROUP BY c.id
ORDER BY total_votos DESC
LIMIT 3;

--- 2. ¿Cuántos votos obtuvieron los 5 partidos con más votados?
SELECT p.nombre AS partido,
       SUM(r.votos) AS votos_totales
FROM resultado r
JOIN candidato c ON c.id = r.candidato_id
JOIN partido p ON p.id = c.partido_id
GROUP BY p.id
ORDER BY votos_totales DESC;


--- 3. ¿Cuántos votos emitieron en cada municipio?
SELECT mu.nombre AS municipio,
       SUM(r.votos) AS votos_totales
FROM resultado r
JOIN mesa m ON m.id = r.mesa_id
JOIN puesto p ON p.id = m.puesto_id
JOIN municipio mu ON mu.id = p.municipio_id
GROUP BY mu.id
ORDER BY votos_totales DESC;

--- 4. ¿Cuántos votos emitieron en cada departamento?
SELECT d.nombre AS departamento,
       SUM(r.votos) AS votos_totales
FROM resultado r
JOIN mesa m ON m.id = r.mesa_id
JOIN puesto p ON p.id = m.puesto_id
JOIN municipio mu ON mu.id = p.municipio_id
JOIN departamento d ON d.id = mu.departamento_id
GROUP BY d.id
ORDER BY votos_totales DESC;

--- 5. ¿Cuáles fueron las 5 mesas con más votos registrados?
SELECT m.id AS mesa
       SUM(r.votos) AS total_votos
FROM resultado r
JOIN mesa m ON m.id = r.mesa_id
GROUP BY m.id
ORDER BY total_votos DESC
LIMIT 5;

--- 6. ¿Cuál fue el ganador de las elecciones en cada municipio?
SELECT municipio, candidato, votos
FROM (
    SELECT 
        mu.nombre AS municipio,
        c.nombres || ' ' || c.apellidos AS candidato,
        SUM(r.votos) AS votos,
        ROW_NUMBER() OVER (
            PARTITION BY mu.id ORDER BY SUM(r.votos) DESC
        ) AS pos
    FROM resultado r
    JOIN candidato c ON r.candidato_id = c.id
    JOIN mesa m ON r.mesa_id = m.id
    JOIN puesto p ON m.puesto_id = p.id
    JOIN municipio mu ON p.municipio_id = mu.id
    GROUP BY mu.id, c.id
)
WHERE pos = 1;



--- 7. ¿Cuál fue el ganador de las elecciones en cada departamento?
SELECT departamento, partido, votos
FROM (
    SELECT 
        d.nombre AS departamento,
        p.nombre AS partido,
        SUM(r.votos) AS votos,
        ROW_NUMBER() OVER (
            PARTITION BY d.id ORDER BY SUM(r.votos) DESC
        ) AS pos
    FROM resultado r
    JOIN candidato c ON r.candidato_id = c.id
    JOIN partido p ON c.partido_id = p.id
    JOIN mesa m ON r.mesa_id = m.id
    JOIN puesto pu ON m.puesto_id = pu.id
    JOIN municipio mu ON pu.municipio_id = mu.id
    JOIN departamento d ON mu.departamento_id = d.id
    GROUP BY d.id, p.id
)
WHERE pos = 1
ORDER BY departamento;


--- 8. ¿Cuántos votos hubo en total en la elección presidencial?
SELECT e.tipo,
       SUM(r.votos) AS total_votos
FROM resultado r
JOIN eleccion e ON e.id = r.eleccion_id
GROUP BY e.id;

--- 9. ¿Cuál fue el porcentaje de votos obtenidos por cada partido en la elección presidencial?
SELECT 
    p.nombre AS partido,
    SUM(r.votos) AS votos,
    ROUND(100.0 * SUM(r.votos) / (SELECT SUM(votos) FROM resultado), 2) AS porcentaje
FROM resultado r
JOIN candidato c ON r.candidato_id = c.id
JOIN partido p ON c.partido_id = p.id
GROUP BY p.id
ORDER BY votos DESC;

--- 10. ¿Cuál fue el promedio de votos por partido en las elecciones?
SELECT 
    p.nombre AS partido,
    ROUND(AVG(r.votos), 2) AS promedio_votos
FROM resultado r
JOIN candidato c ON r.candidato_id = c.id
JOIN partido p ON c.partido_id = p.id
GROUP BY p.id
ORDER BY promedio_votos DESC;