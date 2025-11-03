-- CONSULTAS SQL - JOINS Y SUBCONSULTAS (Continuación)
-- Base de datos: DVDRental
-- PostgreSQL

-- ============================================================================
-- SECCIÓN 1: INNER JOINS BÁSICOS
-- ============================================================================

--38. Listar todos los actores junto con las películas en las que han actuado, mostrando nombre del actor y título de la película.
-- Explicación: JOIN de 3 tablas para conectar actor -> film_actor -> film.
SELECT a.first_name, a.last_name, f.title
FROM actor AS a
INNER JOIN film_actor AS fa ON a.actor_id = fa.actor_id
INNER JOIN film AS f ON fa.film_id = f.film_id
ORDER BY a.last_name, a.first_name, f.title;

--39. Mostrar el nombre de la categoría y el título de las películas de esa categoría, ordenadas por categoría.
-- Explicación: Unimos category -> film_category -> film para ver qué películas hay en cada categoría.
SELECT c.name AS categoria, f.title
FROM category AS c
INNER JOIN film_category AS fc ON c.category_id = fc.category_id
INNER JOIN film AS f ON fc.film_id = f.film_id
ORDER BY c.name, f.title;

--40. Listar el nombre completo de los clientes con su dirección completa (dirección, ciudad, país).
-- Explicación: JOIN de 4 tablas para obtener la ubicación completa del cliente.
SELECT cu.first_name, cu.last_name, a.address, ci.city, co.country
FROM customer AS cu
INNER JOIN address AS a ON cu.address_id = a.address_id
INNER JOIN city AS ci ON a.city_id = ci.city_id
INNER JOIN country AS co ON ci.country_id = co.country_id
ORDER BY co.country, ci.city, cu.last_name;

--41. Mostrar el título de las películas con su idioma correspondiente.
-- Explicación: JOIN simple entre film y language para ver el idioma de cada película.
SELECT f.title, l.name AS idioma
FROM film AS f
INNER JOIN language AS l ON f.language_id = l.language_id
ORDER BY f.title;

--42. Listar las películas disponibles en la tienda 1 con su categoría.
-- Explicación: JOIN desde inventory filtrando por tienda hasta category.
SELECT DISTINCT f.title, c.name AS categoria
FROM inventory AS i
INNER JOIN film AS f ON i.film_id = f.film_id
INNER JOIN film_category AS fc ON f.film_id = fc.film_id
INNER JOIN category AS c ON fc.category_id = c.category_id
WHERE i.store_id = 1
ORDER BY c.name, f.title;

-- ============================================================================
-- SECCIÓN 2: JOINS CON AGREGACIONES
-- ============================================================================

--43. Calcular el número total de alquileres por cada cliente, mostrando nombre completo y total.
-- Explicación: Agrupamos por cliente después de JOIN con rental para contar alquileres.
SELECT c.customer_id, c.first_name, c.last_name, COUNT(r.rental_id) AS total_alquileres
FROM customer AS c
INNER JOIN rental AS r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_alquileres DESC;

--44. Mostrar el número de películas en cada categoría, ordenado de mayor a menor.
-- Explicación: Contamos películas agrupando por categoría.
SELECT c.name AS categoria, COUNT(fc.film_id) AS num_peliculas
FROM category AS c
INNER JOIN film_category AS fc ON c.category_id = fc.category_id
GROUP BY c.category_id, c.name
ORDER BY num_peliculas DESC;

--45. Calcular el ingreso total generado por cada película (suma de pagos).
-- Explicación: JOIN completo desde film hasta payment, sumando importes.
SELECT f.film_id, f.title, SUM(p.amount) AS ingreso_total
FROM film AS f
INNER JOIN inventory AS i ON f.film_id = i.film_id
INNER JOIN rental AS r ON i.inventory_id = r.inventory_id
INNER JOIN payment AS p ON r.rental_id = p.rental_id
GROUP BY f.film_id, f.title
ORDER BY ingreso_total DESC;

--46. Mostrar el número de actores por película, solo para películas con más de 10 actores.
-- Explicación: Agrupamos por película, contamos actores y filtramos con HAVING.
SELECT f.title, COUNT(fa.actor_id) AS num_actores
FROM film AS f
INNER JOIN film_actor AS fa ON f.film_id = fa.film_id
GROUP BY f.film_id, f.title
HAVING COUNT(fa.actor_id) > 10
ORDER BY num_actores DESC;

--47. Calcular el promedio de duración de películas por categoría.
-- Explicación: Agrupamos por categoría y calculamos la media de la duración.
SELECT c.name AS categoria, ROUND(AVG(f.length), 2) AS duracion_promedio
FROM category AS c
INNER JOIN film_category AS fc ON c.category_id = fc.category_id
INNER JOIN film AS f ON fc.film_id = f.film_id
GROUP BY c.category_id, c.name
ORDER BY duracion_promedio DESC;

--48. Mostrar el total de pagos recibidos por cada empleado del staff.
-- Explicación: Sumamos pagos agrupando por empleado.
SELECT s.staff_id, s.first_name, s.last_name, SUM(p.amount) AS total_pagos
FROM staff AS s
INNER JOIN payment AS p ON s.staff_id = p.staff_id
GROUP BY s.staff_id, s.first_name, s.last_name
ORDER BY total_pagos DESC;

-- ============================================================================
-- SECCIÓN 3: LEFT JOIN Y OUTER JOINS
-- ============================================================================

--49. Listar todas las películas con el número de veces que se han alquilado (incluso películas nunca alquiladas).
-- Explicación: LEFT JOIN permite incluir películas sin alquileres, mostrando 0.
SELECT f.title, COUNT(r.rental_id) AS veces_alquilada
FROM film AS f
LEFT JOIN inventory AS i ON f.film_id = i.film_id
LEFT JOIN rental AS r ON i.inventory_id = r.inventory_id
GROUP BY f.film_id, f.title
ORDER BY veces_alquilada DESC;

--50. Mostrar todos los actores con el número de películas en las que han actuado (incluso actores sin películas).
-- Explicación: LEFT JOIN para incluir actores que no tienen películas asignadas.
SELECT a.first_name, a.last_name, COUNT(fa.film_id) AS num_peliculas
FROM actor AS a
LEFT JOIN film_actor AS fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name
ORDER BY num_peliculas DESC;

--51. Listar todas las categorías con el ingreso total generado (incluso categorías sin ingresos).
-- Explicación: Múltiples LEFT JOIN para incluir categorías sin alquileres.
SELECT c.name AS categoria, COALESCE(SUM(p.amount), 0) AS ingreso_total
FROM category AS c
LEFT JOIN film_category AS fc ON c.category_id = fc.category_id
LEFT JOIN film AS f ON fc.film_id = f.film_id
LEFT JOIN inventory AS i ON f.film_id = i.film_id
LEFT JOIN rental AS r ON i.inventory_id = r.inventory_id
LEFT JOIN payment AS p ON r.rental_id = p.rental_id
GROUP BY c.category_id, c.name
ORDER BY ingreso_total DESC;

--52. Mostrar todos los clientes con el total gastado (incluso clientes que no han pagado nada).
-- Explicación: LEFT JOIN para incluir clientes sin pagos, COALESCE para mostrar 0.
SELECT c.customer_id, c.first_name, c.last_name, COALESCE(SUM(p.amount), 0) AS total_gastado
FROM customer AS c
LEFT JOIN payment AS p ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_gastado DESC;

--53. Listar todas las tiendas con el número de alquileres gestionados (incluso si no han gestionado ninguno).
-- Explicación: LEFT JOIN para incluir tiendas sin actividad.
SELECT s.store_id, COUNT(r.rental_id) AS num_alquileres
FROM store AS s
LEFT JOIN staff AS st ON s.store_id = st.store_id
LEFT JOIN rental AS r ON st.staff_id = r.staff_id
GROUP BY s.store_id
ORDER BY num_alquileres DESC;

-- ============================================================================
-- SECCIÓN 4: SUBCONSULTAS EN WHERE
-- ============================================================================

--54. Listar películas cuyo coste de reemplazo es superior al promedio.
-- Explicación: Subconsulta calcula el promedio, WHERE filtra películas que lo superan.
SELECT title, replacement_cost
FROM film
WHERE replacement_cost > (
    SELECT AVG(replacement_cost)
    FROM film
)
ORDER BY replacement_cost DESC;

--55. Mostrar clientes que han alquilado más películas que el promedio de alquileres por cliente.
-- Explicación: Subconsulta calcula promedio de alquileres, filtramos clientes que lo superan.
SELECT c.customer_id, c.first_name, c.last_name, COUNT(r.rental_id) AS num_alquileres
FROM customer AS c
INNER JOIN rental AS r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(r.rental_id) > (
    SELECT AVG(alquileres_por_cliente)
    FROM (
        SELECT COUNT(*) AS alquileres_por_cliente
        FROM rental
        GROUP BY customer_id
    ) AS subquery
)
ORDER BY num_alquileres DESC;

--56. Listar actores que han trabajado en películas de la categoría 'Action'.
-- Explicación: Subconsulta obtiene IDs de películas de acción, filtramos actores.
SELECT DISTINCT a.first_name, a.last_name
FROM actor AS a
INNER JOIN film_actor AS fa ON a.actor_id = fa.actor_id
WHERE fa.film_id IN (
    SELECT fc.film_id
    FROM film_category AS fc
    INNER JOIN category AS c ON fc.category_id = c.category_id
    WHERE c.name = 'Action'
)
ORDER BY a.last_name, a.first_name;

--57. Mostrar películas que duran más que la duración promedio de su categoría.
-- Explicación: Subconsulta correlacionada compara cada película con el promedio de su categoría.
SELECT f.title, f.length, c.name AS categoria
FROM film AS f
INNER JOIN film_category AS fc ON f.film_id = fc.film_id
INNER JOIN category AS c ON fc.category_id = c.category_id
WHERE f.length > (
    SELECT AVG(f2.length)
    FROM film AS f2
    INNER JOIN film_category AS fc2 ON f2.film_id = fc2.film_id
    WHERE fc2.category_id = fc.category_id
)
ORDER BY c.name, f.length DESC;

--58. Listar clientes que viven en ciudades donde hay más de 5 clientes.
-- Explicación: Subconsulta cuenta clientes por ciudad, filtramos las ciudades populares.
SELECT c.customer_id, c.first_name, c.last_name, ci.city
FROM customer AS c
INNER JOIN address AS a ON c.address_id = a.address_id
INNER JOIN city AS ci ON a.city_id = ci.city_id
WHERE ci.city_id IN (
    SELECT a2.city_id
    FROM customer AS c2
    INNER JOIN address AS a2 ON c2.address_id = a2.address_id
    GROUP BY a2.city_id
    HAVING COUNT(c2.customer_id) > 5
)
ORDER BY ci.city, c.last_name;

-- ============================================================================
-- SECCIÓN 5: SUBCONSULTAS CON NOT IN / NOT EXISTS
-- ============================================================================

--59. Listar películas que nunca se han alquilado.
-- Explicación: NOT IN con subconsulta de películas que SÍ se han alquilado.
SELECT f.title, f.release_year
FROM film AS f
WHERE f.film_id NOT IN (
    SELECT DISTINCT i.film_id
    FROM inventory AS i
    INNER JOIN rental AS r ON i.inventory_id = r.inventory_id
)
ORDER BY f.title;

--60. Mostrar actores que NO han trabajado en ninguna película de la categoría 'Horror'.
-- Explicación: NOT IN excluye actores que han actuado en películas de terror.
SELECT a.first_name, a.last_name
FROM actor AS a
WHERE a.actor_id NOT IN (
    SELECT DISTINCT fa.actor_id
    FROM film_actor AS fa
    INNER JOIN film_category AS fc ON fa.film_id = fc.film_id
    INNER JOIN category AS c ON fc.category_id = c.category_id
    WHERE c.name = 'Horror'
)
ORDER BY a.last_name, a.first_name;

--61. Listar clientes que NO han alquilado ninguna película en 2006.
-- Explicación: NOT IN con subconsulta de clientes que SÍ alquilaron en 2006.
SELECT c.customer_id, c.first_name, c.last_name
FROM customer AS c
WHERE c.customer_id NOT IN (
    SELECT DISTINCT customer_id
    FROM rental
    WHERE EXTRACT(YEAR FROM rental_date) = 2006
)
ORDER BY c.last_name;

--62. Mostrar películas que NO tienen ningún actor con apellido 'Davis'.
-- Explicación: NOT IN excluye películas donde actúa alguien apellidado Davis.
SELECT f.title
FROM film AS f
WHERE f.film_id NOT IN (
    SELECT DISTINCT fa.film_id
    FROM film_actor AS fa
    INNER JOIN actor AS a ON fa.actor_id = a.actor_id
    WHERE a.last_name = 'Davis'
)
ORDER BY f.title;

--63. Listar categorías que no tienen ninguna película con rating 'PG-13'.
-- Explicación: NOT IN con subconsulta de categorías que SÍ tienen películas PG-13.
SELECT c.name AS categoria
FROM category AS c
WHERE c.category_id NOT IN (
    SELECT DISTINCT fc.category_id
    FROM film_category AS fc
    INNER JOIN film AS f ON fc.film_id = f.film_id
    WHERE f.rating = 'PG-13'
)
ORDER BY c.name;

-- ============================================================================
-- SECCIÓN 6: SUBCONSULTAS CORRELACIONADAS
-- ============================================================================

--64. Mostrar películas que tienen más actores que el promedio de actores por película en su categoría.
-- Explicación: Subconsulta correlacionada compara cada película con el promedio de su categoría.
SELECT f.title, c.name AS categoria, COUNT(fa.actor_id) AS num_actores
FROM film AS f
INNER JOIN film_category AS fc ON f.film_id = fc.film_id
INNER JOIN category AS c ON fc.category_id = c.category_id
INNER JOIN film_actor AS fa ON f.film_id = fa.film_id
GROUP BY f.film_id, f.title, c.name, fc.category_id
HAVING COUNT(fa.actor_id) > (
    SELECT AVG(num_actores)
    FROM (
        SELECT COUNT(fa2.actor_id) AS num_actores
        FROM film AS f2
        INNER JOIN film_category AS fc2 ON f2.film_id = fc2.film_id
        INNER JOIN film_actor AS fa2 ON f2.film_id = fa2.film_id
        WHERE fc2.category_id = fc.category_id
        GROUP BY f2.film_id
    ) AS subquery
)
ORDER BY num_actores DESC;

--65. Listar clientes que han gastado más que el promedio de su país.
-- Explicación: Subconsulta correlacionada compara gasto del cliente con promedio de su país.
SELECT c.customer_id, c.first_name, c.last_name, co.country, SUM(p.amount) AS total_gastado
FROM customer AS c
INNER JOIN address AS a ON c.address_id = a.address_id
INNER JOIN city AS ci ON a.city_id = ci.city_id
INNER JOIN country AS co ON ci.country_id = co.country_id
INNER JOIN payment AS p ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, co.country, co.country_id
HAVING SUM(p.amount) > (
    SELECT AVG(gasto_cliente)
    FROM (
        SELECT c2.customer_id, SUM(p2.amount) AS gasto_cliente
        FROM customer AS c2
        INNER JOIN address AS a2 ON c2.address_id = a2.address_id
        INNER JOIN city AS ci2 ON a2.city_id = ci2.city_id
        INNER JOIN payment AS p2 ON c2.customer_id = p2.customer_id
        WHERE ci2.country_id = co.country_id
        GROUP BY c2.customer_id
    ) AS subquery
)
ORDER BY co.country, total_gastado DESC;

-- ============================================================================
-- SECCIÓN 7: ANÁLISIS POR PAÍS Y CIUDAD
-- ============================================================================

--66. Mostrar el número de clientes y el total de pagos recibidos por cada país.
-- Explicación: JOIN completo para conectar payment con country, agrupamos por país.
SELECT co.country, COUNT(DISTINCT c.customer_id) AS num_clientes, SUM(p.amount) AS total_pagos
FROM country AS co
INNER JOIN city AS ci ON co.country_id = ci.country_id
INNER JOIN address AS a ON ci.city_id = a.city_id
INNER JOIN customer AS c ON a.address_id = c.address_id
INNER JOIN payment AS p ON c.customer_id = p.customer_id
GROUP BY co.country_id, co.country
ORDER BY total_pagos DESC;

--67. Calcular el promedio de alquileres por cliente en cada ciudad.
-- Explicación: Contamos alquileres por cliente y ciudad, luego promediamos.
SELECT ci.city, ROUND(AVG(num_alquileres), 2) AS promedio_alquileres_por_cliente
FROM (
    SELECT ci2.city_id, c.customer_id, COUNT(r.rental_id) AS num_alquileres
    FROM city AS ci2
    INNER JOIN address AS a ON ci2.city_id = a.city_id
    INNER JOIN customer AS c ON a.address_id = c.address_id
    LEFT JOIN rental AS r ON c.customer_id = r.customer_id
    GROUP BY ci2.city_id, c.customer_id
) AS subquery
INNER JOIN city AS ci ON subquery.city_id = ci.city_id
GROUP BY ci.city
ORDER BY promedio_alquileres_por_cliente DESC;

--68. Listar los 5 países con mayor número de alquileres totales.
-- Explicación: JOIN de país hasta rental, contamos y limitamos a top 5.
SELECT co.country, COUNT(r.rental_id) AS total_alquileres
FROM country AS co
INNER JOIN city AS ci ON co.country_id = ci.country_id
INNER JOIN address AS a ON ci.city_id = a.city_id
INNER JOIN customer AS c ON a.address_id = c.address_id
INNER JOIN rental AS r ON c.customer_id = r.customer_id
GROUP BY co.country_id, co.country
ORDER BY total_alquileres DESC
LIMIT 5;

-- ============================================================================
-- SECCIÓN 8: ANÁLISIS TEMPORAL
-- ============================================================================

--69. Mostrar el número de alquileres por mes en el año 2005.
-- Explicación: Extraemos mes de la fecha, agrupamos y contamos.
SELECT EXTRACT(MONTH FROM rental_date) AS mes, COUNT(rental_id) AS num_alquileres
FROM rental
WHERE EXTRACT(YEAR FROM rental_date) = 2005
GROUP BY mes
ORDER BY mes;

--70. Calcular el ingreso total por mes y año.
-- Explicación: Agrupamos pagos por año y mes, sumamos importes.
SELECT EXTRACT(YEAR FROM payment_date) AS año,
       EXTRACT(MONTH FROM payment_date) AS mes,
       SUM(amount) AS ingreso_total
FROM payment
GROUP BY año, mes
ORDER BY año, mes;

--71. Listar las películas alquiladas en la primera semana de junio de 2005.
-- Explicación: Filtramos por rango de fechas específico.
SELECT DISTINCT f.title, r.rental_date
FROM film AS f
INNER JOIN inventory AS i ON f.film_id = i.film_id
INNER JOIN rental AS r ON i.inventory_id = r.inventory_id
WHERE r.rental_date BETWEEN '2005-06-01' AND '2005-06-07'
ORDER BY r.rental_date, f.title;

--72. Mostrar el día de la semana con más alquileres.
-- Explicación: Extraemos día de la semana, agrupamos y ordenamos.
SELECT TO_CHAR(rental_date, 'Day') AS dia_semana, COUNT(rental_id) AS num_alquileres
FROM rental
GROUP BY dia_semana
ORDER BY num_alquileres DESC
LIMIT 1;

-- ============================================================================
-- SECCIÓN 9: ANÁLISIS DE INVENTARIO Y DISPONIBILIDAD
-- ============================================================================

--73. Mostrar películas que están en inventario pero nunca se han alquilado.
-- Explicación: LEFT JOIN con rental y filtramos por NULL.
SELECT DISTINCT f.title
FROM film AS f
INNER JOIN inventory AS i ON f.film_id = i.film_id
LEFT JOIN rental AS r ON i.inventory_id = r.inventory_id
WHERE r.rental_id IS NULL
ORDER BY f.title;

--74. Calcular el número de copias disponibles de cada película en cada tienda.
-- Explicación: Contamos inventario agrupando por película y tienda.
SELECT s.store_id, f.title, COUNT(i.inventory_id) AS num_copias
FROM store AS s
INNER JOIN inventory AS i ON s.store_id = i.store_id
INNER JOIN film AS f ON i.film_id = f.film_id
GROUP BY s.store_id, f.film_id, f.title
ORDER BY s.store_id, num_copias DESC;

--75. Listar las 10 películas más populares (más alquiladas) que tienen menos de 5 copias en inventario.
-- Explicación: Contamos alquileres y copias, filtramos y limitamos.
SELECT f.title, COUNT(DISTINCT i.inventory_id) AS num_copias, COUNT(r.rental_id) AS num_alquileres
FROM film AS f
INNER JOIN inventory AS i ON f.film_id = i.film_id
INNER JOIN rental AS r ON i.inventory_id = r.inventory_id
GROUP BY f.film_id, f.title
HAVING COUNT(DISTINCT i.inventory_id) < 5
ORDER BY num_alquileres DESC
LIMIT 10;

-- ============================================================================
-- SECCIÓN 10: CONSULTAS AVANZADAS
-- ============================================================================

--76. Encontrar actores que han trabajado juntos en más de 5 películas.
-- Explicación: Self-join de actores a través de film_actor para encontrar colaboraciones.
SELECT a1.first_name AS actor1_nombre, a1.last_name AS actor1_apellido,
       a2.first_name AS actor2_nombre, a2.last_name AS actor2_apellido,
       COUNT(DISTINCT fa1.film_id) AS peliculas_juntos
FROM actor AS a1
INNER JOIN film_actor AS fa1 ON a1.actor_id = fa1.actor_id
INNER JOIN film_actor AS fa2 ON fa1.film_id = fa2.film_id AND fa1.actor_id < fa2.actor_id
INNER JOIN actor AS a2 ON fa2.actor_id = a2.actor_id
GROUP BY a1.actor_id, a1.first_name, a1.last_name, a2.actor_id, a2.first_name, a2.last_name
HAVING COUNT(DISTINCT fa1.film_id) > 5
ORDER BY peliculas_juntos DESC;

--77. Mostrar el ranking de las 5 categorías más rentables (mayor ingreso total).
-- Explicación: JOIN completo hasta payment, sumamos por categoría.
SELECT c.name AS categoria, SUM(p.amount) AS ingreso_total,
       RANK() OVER (ORDER BY SUM(p.amount) DESC) AS ranking
FROM category AS c
INNER JOIN film_category AS fc ON c.category_id = fc.category_id
INNER JOIN film AS f ON fc.film_id = f.film_id
INNER JOIN inventory AS i ON f.film_id = i.film_id
INNER JOIN rental AS r ON i.inventory_id = r.inventory_id
INNER JOIN payment AS p ON r.rental_id = p.rental_id
GROUP BY c.category_id, c.name
ORDER BY ingreso_total DESC
LIMIT 5;

--78. Calcular la tasa de retención de películas (porcentaje de películas devueltas vs alquiladas).
-- Explicación: Contamos alquileres totales vs devueltos, calculamos porcentaje.
SELECT 
    COUNT(rental_id) AS total_alquileres,
    COUNT(return_date) AS total_devueltos,
    ROUND((COUNT(return_date)::NUMERIC / COUNT(rental_id) * 100), 2) AS tasa_devolucion
FROM rental;

--79. Listar clientes que han alquilado películas de todas las categorías disponibles.
-- Explicación: Comparamos número de categorías distintas alquiladas con total de categorías.
SELECT c.customer_id, c.first_name, c.last_name, COUNT(DISTINCT fc.category_id) AS categorias_alquiladas
FROM customer AS c
INNER JOIN rental AS r ON c.customer_id = r.customer_id
INNER JOIN inventory AS i ON r.inventory_id = i.inventory_id
INNER JOIN film AS f ON i.film_id = f.film_id
INNER JOIN film_category AS fc ON f.film_id = fc.film_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(DISTINCT fc.category_id) = (SELECT COUNT(*) FROM category)
ORDER BY c.last_name;

--80. Mostrar el promedio de días que cada cliente tarda en devolver una película.
-- Explicación: Calculamos diferencia entre fecha de devolución y alquiler, promediamos.
SELECT c.customer_id, c.first_name, c.last_name,
       ROUND(AVG(EXTRACT(DAY FROM (r.return_date - r.rental_date))), 2) AS promedio_dias_devolucion
FROM customer AS c
INNER JOIN rental AS r ON c.customer_id = r.customer_id
WHERE r.return_date IS NOT NULL
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY promedio_dias_devolucion DESC;
