-- CONSULTAS SQL - NIVEL BÁSICO (Continuación)
-- Base de datos: bpsimple
-- Este archivo continúa con consultas del mismo nivel que las básicas

-- ============================================================================
-- SECCIÓN 1: SELECCIÓN Y FILTRADO (Continuación)
-- ============================================================================

-- 22. Muestra todos los productos cuyo precio de venta sea exactamente 11.99 dólares.
SELECT *
FROM item
WHERE sell_price = 11.99;

-- 23. Selecciona los clientes cuyo apellido termine en 'son'.
SELECT fname, lname, town
FROM customer
WHERE lname LIKE '%son';

-- 24. Muestra los productos cuya descripción tenga exactamente 4 caracteres.
SELECT description, sell_price
FROM item
WHERE LENGTH(description) = 4;

-- 25. Selecciona los clientes que NO sean de Bingham ni de Nicetown.
SELECT customer_id, fname, lname, town
FROM customer
WHERE town NOT IN ('Bingham', 'Nicetown');

-- 26. Muestra todos los pedidos realizados en el año 2004.
SELECT *
FROM orderinfo
WHERE EXTRACT(YEAR FROM date_placed) = 2004;

-- 27. Selecciona los productos cuyo precio de coste esté entre 5 y 10 dólares (ambos inclusive).
SELECT description, cost_price, sell_price
FROM item
WHERE cost_price BETWEEN 5 AND 10;

-- 28. Muestra los clientes cuyo nombre tenga más de 5 caracteres.
SELECT fname, lname
FROM customer
WHERE LENGTH(fname) > 5;

-- ============================================================================
-- SECCIÓN 2: ORDENACIÓN Y LIMITACIÓN
-- ============================================================================

-- 29. Muestra los 5 productos más caros según su precio de venta.
SELECT description, sell_price
FROM item
ORDER BY sell_price DESC
LIMIT 5;

-- 30. Lista todos los clientes ordenados primero por ciudad y luego por apellido.
SELECT town, lname, fname
FROM customer
ORDER BY town, lname;

-- 31. Muestra los productos ordenados por margen de beneficio (sell_price - cost_price) de mayor a menor.
SELECT description, cost_price, sell_price, (sell_price - cost_price) AS margen
FROM item
ORDER BY margen DESC;

-- 32. Lista las 3 primeras ciudades alfabéticamente que aparecen en la tabla customer (sin repetir).
SELECT DISTINCT town
FROM customer
ORDER BY town
LIMIT 3;

-- 33. Muestra todos los pedidos ordenados del más reciente al más antiguo.
SELECT orderinfo_id, customer_id, date_placed
FROM orderinfo
ORDER BY date_placed DESC;

-- ============================================================================
-- SECCIÓN 3: FUNCIONES DE AGREGACIÓN BÁSICAS
-- ============================================================================

-- 34. Calcula cuántos productos hay en total en la tabla item.
SELECT COUNT(*) AS total_productos
FROM item;

-- 35. Calcula el precio de venta máximo de todos los productos.
SELECT MAX(sell_price) AS precio_maximo
FROM item;

-- 36. Calcula el precio de coste mínimo de todos los productos.
SELECT MIN(cost_price) AS precio_minimo
FROM item;

-- 37. Calcula la suma total de los precios de venta de todos los productos.
SELECT SUM(sell_price) AS suma_precios
FROM item;

-- 38. Calcula el precio medio de coste de todos los productos (redondeado a 2 decimales).
SELECT ROUND(AVG(cost_price), 2) AS precio_medio_coste
FROM item;

-- 39. Cuenta cuántos clientes tienen teléfono registrado.
SELECT COUNT(phone) AS clientes_con_telefono
FROM customer;

-- 40. Cuenta cuántas ciudades diferentes hay en la tabla customer.
SELECT COUNT(DISTINCT town) AS ciudades_diferentes
FROM customer;

-- ============================================================================
-- SECCIÓN 4: GROUP BY Y HAVING
-- ============================================================================

-- 41. Muestra cuántos clientes hay en cada ciudad.
SELECT town, COUNT(*) AS num_clientes
FROM customer
GROUP BY town;

-- 42. Muestra cuántos productos hay por cada precio de venta.
SELECT sell_price, COUNT(*) AS num_productos
FROM item
GROUP BY sell_price
ORDER BY sell_price;

-- 43. Calcula el número de pedidos que ha realizado cada cliente.
SELECT customer_id, COUNT(*) AS num_pedidos
FROM orderinfo
GROUP BY customer_id
ORDER BY num_pedidos DESC;

-- 44. Muestra solo las ciudades que tienen exactamente 2 clientes.
SELECT town, COUNT(*) AS num_clientes
FROM customer
GROUP BY town
HAVING COUNT(*) = 2;

-- 45. Muestra los títulos (title) que tienen al menos 3 clientes asociados.
SELECT title, COUNT(*) AS num_clientes
FROM customer
WHERE title IS NOT NULL
GROUP BY title
HAVING COUNT(*) >= 3;

-- 46. Calcula cuántos pedidos se han realizado cada año.
SELECT EXTRACT(YEAR FROM date_placed) AS año, COUNT(*) AS num_pedidos
FROM orderinfo
GROUP BY año
ORDER BY año;

-- 47. Muestra el precio de venta medio de los productos agrupados por precio de coste (redondeado a 2 decimales).
SELECT cost_price, ROUND(AVG(sell_price), 2) AS precio_venta_medio
FROM item
GROUP BY cost_price
ORDER BY cost_price;

-- ============================================================================
-- SECCIÓN 5: FUNCIONES DE TEXTO Y TRANSFORMACIÓN
-- ============================================================================

-- 48. Muestra los nombres de clientes en mayúsculas y los apellidos en minúsculas.
SELECT UPPER(fname) AS nombre, LOWER(lname) AS apellido
FROM customer;

-- 49. Muestra la descripción de los productos con la primera letra en mayúscula.
SELECT INITCAP(description) AS descripcion
FROM item;

-- 50. Concatena el nombre completo de los clientes en formato "Apellido, Nombre".
SELECT CONCAT(lname, ', ', fname) AS nombre_completo
FROM customer;

-- 51. Muestra los primeros 3 caracteres del apellido de cada cliente.
SELECT fname, lname, SUBSTRING(lname, 1, 3) AS apellido_corto
FROM customer;

-- 52. Muestra la descripción de los productos reemplazando espacios por guiones.
SELECT description, REPLACE(description, ' ', '-') AS descripcion_sin_espacios
FROM item;

-- 53. Elimina los espacios al inicio y final de las descripciones de productos.
SELECT description, TRIM(description) AS descripcion_limpia
FROM item;

-- ============================================================================
-- SECCIÓN 6: FUNCIONES DE FECHA
-- ============================================================================

-- 54. Muestra el día, mes y año de cada pedido por separado.
SELECT 
    orderinfo_id,
    date_placed,
    EXTRACT(DAY FROM date_placed) AS dia,
    EXTRACT(MONTH FROM date_placed) AS mes,
    EXTRACT(YEAR FROM date_placed) AS año
FROM orderinfo;

-- 55. Muestra los pedidos realizados en el mes de marzo (de cualquier año).
SELECT *
FROM orderinfo
WHERE EXTRACT(MONTH FROM date_placed) = 3;

-- 56. Calcula cuántos días han pasado desde cada pedido hasta hoy.
SELECT 
    orderinfo_id,
    date_placed,
    CURRENT_DATE - date_placed AS dias_desde_pedido
FROM orderinfo;

-- 57. Muestra la fecha de cada pedido en formato 'DD/MM/YYYY'.
SELECT 
    orderinfo_id,
    TO_CHAR(date_placed, 'DD/MM/YYYY') AS fecha_formateada
FROM orderinfo;

-- 58. Muestra los pedidos del primer trimestre (enero, febrero, marzo) de cualquier año.
SELECT *
FROM orderinfo
WHERE EXTRACT(MONTH FROM date_placed) IN (1, 2, 3);

-- ============================================================================
-- SECCIÓN 7: OPERACIONES MATEMÁTICAS Y FUNCIONES NUMÉRICAS
-- ============================================================================

-- 59. Calcula el margen de beneficio porcentual de cada producto (redondeado a 1 decimal).
SELECT 
    description,
    cost_price,
    sell_price,
    ROUND(((sell_price - cost_price) / cost_price) * 100, 1) AS margen_porcentual
FROM item;

-- 60. Muestra el precio de venta redondeado al entero más cercano.
SELECT description, sell_price, ROUND(sell_price) AS precio_redondeado
FROM item;

-- 61. Calcula el precio de venta elevado al cuadrado (para simulación de descuentos compuestos).
SELECT description, sell_price, POWER(sell_price, 2) AS precio_cuadrado
FROM item;

-- 62. Muestra la raíz cuadrada del precio de coste (redondeado a 2 decimales).
SELECT description, cost_price, ROUND(SQRT(cost_price), 2) AS raiz_cuadrada
FROM item;

-- 63. Calcula el valor absoluto de la diferencia entre precio de venta y 15 dólares.
SELECT description, sell_price, ABS(sell_price - 15) AS diferencia_con_15
FROM item;

-- ============================================================================
-- SECCIÓN 8: EXPRESIONES CONDICIONALES (CASE)
-- ============================================================================

-- 64. Clasifica los productos como 'Económico', 'Medio' o 'Caro' según su precio de venta.
SELECT 
    description,
    sell_price,
    CASE 
        WHEN sell_price < 5 THEN 'Económico'
        WHEN sell_price < 15 THEN 'Medio'
        ELSE 'Caro'
    END AS categoria_precio
FROM item;

-- 65. Muestra si cada cliente tiene o no teléfono registrado.
SELECT 
    fname,
    lname,
    CASE 
        WHEN phone IS NULL THEN 'Sin teléfono'
        ELSE 'Con teléfono'
    END AS estado_telefono
FROM customer;

-- 66. Clasifica los márgenes de beneficio como 'Bajo', 'Normal' o 'Alto'.
SELECT 
    description,
    (sell_price - cost_price) AS margen,
    CASE 
        WHEN (sell_price - cost_price) < 3 THEN 'Bajo'
        WHEN (sell_price - cost_price) < 7 THEN 'Normal'
        ELSE 'Alto'
    END AS tipo_margen
FROM item;

-- 67. Asigna un descuento del 10% a productos caros (precio > 15) y del 5% al resto.
SELECT 
    description,
    sell_price,
    CASE 
        WHEN sell_price > 15 THEN ROUND(sell_price * 0.90, 2)
        ELSE ROUND(sell_price * 0.95, 2)
    END AS precio_con_descuento
FROM item;

-- 68. Clasifica los pedidos según su antigüedad: 'Antiguo' (más de 6 meses) o 'Reciente'.
SELECT 
    orderinfo_id,
    date_placed,
    CASE 
        WHEN CURRENT_DATE - date_placed > 180 THEN 'Antiguo'
        ELSE 'Reciente'
    END AS antiguedad
FROM orderinfo;
