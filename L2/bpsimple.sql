-- CONSULTAS SQL - JOINS Y SUBCONSULTAS (Continuación)
-- Base de datos: bpsimple
-- PostgreSQL

-- ============================================================================
-- SECCIÓN 1: INNER JOINS BÁSICOS
-- ============================================================================

--37. Mostrar el ID de pedido, nombre del cliente y ciudad de origen de cada pedido.
-- Explicación: Combinamos orderinfo con customer para obtener datos del cliente en cada pedido.
SELECT oi.orderinfo_id, c.fname, c.lname, c.town
FROM orderinfo AS oi
INNER JOIN customer AS c ON oi.customer_id = c.customer_id
ORDER BY oi.orderinfo_id;

--38. Listar los productos (descripción) que tienen código de barras registrado junto con su código.
-- Explicación: Unimos item con barcode para ver qué productos tienen código de barras.
SELECT i.description, b.barcode_ean
FROM item AS i
INNER JOIN barcode AS b ON i.item_id = b.item_id
ORDER BY i.description;

--39. Mostrar el nombre completo del cliente, su ciudad y el número de pedidos que ha realizado.
-- Explicación: Agrupamos por cliente después de hacer JOIN con orderinfo para contar pedidos.
SELECT c.fname, c.lname, c.town, COUNT(oi.orderinfo_id) AS num_pedidos
FROM customer AS c
INNER JOIN orderinfo AS oi ON c.customer_id = oi.customer_id
GROUP BY c.customer_id, c.fname, c.lname, c.town
ORDER BY num_pedidos DESC;

--40. Listar todos los productos vendidos con su cantidad total vendida y ordenarlos de mayor a menor.
-- Explicación: JOIN entre item y orderline, luego sumamos cantidades agrupando por producto.
SELECT i.description, SUM(ol.quantity) AS total_vendido
FROM item AS i
INNER JOIN orderline AS ol ON i.item_id = ol.item_id
GROUP BY i.item_id, i.description
ORDER BY total_vendido DESC;

--41. Mostrar los clientes (nombre, apellido) que viven en 'Bingham' y han realizado al menos un pedido.
-- Explicación: Filtramos por ciudad después de hacer JOIN, y agrupamos para asegurar que hayan pedido.
SELECT DISTINCT c.fname, c.lname, c.town
FROM customer AS c
INNER JOIN orderinfo AS oi ON c.customer_id = oi.customer_id
WHERE c.town = 'Bingham';

-- ============================================================================
-- SECCIÓN 2: JOINS CON MÚLTIPLES TABLAS
-- ============================================================================

--42. Mostrar el ID de pedido, nombre del cliente, descripción del producto y cantidad pedida.
-- Explicación: JOIN de 4 tablas para conectar cliente -> pedido -> línea de pedido -> producto.
SELECT oi.orderinfo_id, c.fname, c.lname, i.description, ol.quantity
FROM customer AS c
INNER JOIN orderinfo AS oi ON c.customer_id = oi.customer_id
INNER JOIN orderline AS ol ON oi.orderinfo_id = ol.orderinfo_id
INNER JOIN item AS i ON ol.item_id = i.item_id
ORDER BY oi.orderinfo_id, i.description;

--43. Calcular el importe total de cada pedido mostrando ID de pedido, fecha y total.
-- Explicación: Multiplicamos precio de venta por cantidad, sumamos por pedido.
SELECT oi.orderinfo_id, oi.date_placed, SUM(i.sell_price * ol.quantity) AS importe_total
FROM orderinfo AS oi
INNER JOIN orderline AS ol ON oi.orderinfo_id = ol.orderinfo_id
INNER JOIN item AS i ON ol.item_id = i.item_id
GROUP BY oi.orderinfo_id, oi.date_placed
ORDER BY importe_total DESC;

--44. Mostrar productos que están en stock y tienen código de barras, con su cantidad disponible.
-- Explicación: JOIN de 3 tablas (item, stock, barcode) para productos con ambas características.
SELECT i.description, s.quantity, b.barcode_ean
FROM item AS i
INNER JOIN stock AS s ON i.item_id = s.item_id
INNER JOIN barcode AS b ON i.item_id = b.item_id
ORDER BY s.quantity DESC;

--45. Listar clientes con el número de productos diferentes que han comprado.
-- Explicación: Contamos items distintos por cliente haciendo JOIN de customer -> orderinfo -> orderline.
SELECT c.customer_id, c.fname, c.lname, COUNT(DISTINCT ol.item_id) AS productos_diferentes
FROM customer AS c
INNER JOIN orderinfo AS oi ON c.customer_id = oi.customer_id
INNER JOIN orderline AS ol ON oi.orderinfo_id = ol.orderinfo_id
GROUP BY c.customer_id, c.fname, c.lname
ORDER BY productos_diferentes DESC;

--46. Mostrar pedidos realizados en abril de 2004 con nombre del cliente y ciudad.
-- Explicación: Filtramos por mes y año usando EXTRACT después del JOIN.
SELECT oi.orderinfo_id, c.fname, c.lname, c.town, oi.date_placed
FROM orderinfo AS oi
INNER JOIN customer AS c ON oi.customer_id = c.customer_id
WHERE EXTRACT(MONTH FROM oi.date_placed) = 4
AND EXTRACT(YEAR FROM oi.date_placed) = 2004;

-- ============================================================================
-- SECCIÓN 3: LEFT JOIN Y OUTER JOINS
-- ============================================================================

--47. Mostrar todos los productos con su cantidad en stock (0 si no están en stock).
-- Explicación: LEFT JOIN permite incluir productos sin stock, usando COALESCE para mostrar 0.
SELECT i.description, COALESCE(s.quantity, 0) AS cantidad_stock
FROM item AS i
LEFT JOIN stock AS s ON i.item_id = s.item_id
ORDER BY cantidad_stock DESC;

--48. Listar todos los clientes con el número de pedidos realizados (incluso si no han pedido nada).
-- Explicación: LEFT JOIN para incluir clientes sin pedidos, COUNT contará 0 para ellos.
SELECT c.customer_id, c.fname, c.lname, COUNT(oi.orderinfo_id) AS num_pedidos
FROM customer AS c
LEFT JOIN orderinfo AS oi ON c.customer_id = oi.customer_id
GROUP BY c.customer_id, c.fname, c.lname
ORDER BY num_pedidos DESC;

--49. Mostrar productos sin código de barras registrado.
-- Explicación: LEFT JOIN y filtrar por NULL para encontrar productos sin barcode.
SELECT i.description, i.sell_price
FROM item AS i
LEFT JOIN barcode AS b ON i.item_id = b.item_id
WHERE b.barcode_ean IS NULL;

--50. Listar todas las ciudades con el número de pedidos enviados a cada una (incluso ciudades sin pedidos).
-- Explicación: LEFT JOIN desde customer permite ver ciudades sin pedidos.
SELECT c.town, COUNT(oi.orderinfo_id) AS pedidos_enviados
FROM customer AS c
LEFT JOIN orderinfo AS oi ON c.customer_id = oi.customer_id
GROUP BY c.town
ORDER BY pedidos_enviados DESC;

--51. Mostrar productos vendidos con su beneficio total, incluyendo productos no vendidos (beneficio 0).
-- Explicación: LEFT JOIN con orderline, calculamos beneficio solo para vendidos.
SELECT i.description, 
       COALESCE(SUM(ol.quantity * (i.sell_price - i.cost_price)), 0) AS beneficio_total
FROM item AS i
LEFT JOIN orderline AS ol ON i.item_id = ol.item_id
GROUP BY i.item_id, i.description
ORDER BY beneficio_total DESC;

-- ============================================================================
-- SECCIÓN 4: SUBCONSULTAS EN WHERE
-- ============================================================================

--52. Mostrar clientes que han gastado más de 50 dólares en total.
-- Explicación: Subconsulta calcula gasto por cliente, WHERE filtra los que superan 50.
SELECT c.customer_id, c.fname, c.lname
FROM customer AS c
WHERE c.customer_id IN (
    SELECT oi.customer_id
    FROM orderinfo AS oi
    INNER JOIN orderline AS ol ON oi.orderinfo_id = ol.orderinfo_id
    INNER JOIN item AS i ON ol.item_id = i.item_id
    GROUP BY oi.customer_id
    HAVING SUM(i.sell_price * ol.quantity) > 50
);

--53. Listar productos más caros que el precio promedio de venta.
-- Explicación: Subconsulta calcula el promedio, WHERE compara cada producto con ese promedio.
SELECT description, sell_price
FROM item
WHERE sell_price > (
    SELECT AVG(sell_price)
    FROM item
)
ORDER BY sell_price DESC;

--54. Mostrar clientes que han comprado el producto más caro.
-- Explicación: Subconsulta encuentra el item más caro, luego buscamos quién lo compró.
SELECT DISTINCT c.fname, c.lname
FROM customer AS c
INNER JOIN orderinfo AS oi ON c.customer_id = oi.customer_id
INNER JOIN orderline AS ol ON oi.orderinfo_id = ol.orderinfo_id
WHERE ol.item_id = (
    SELECT item_id
    FROM item
    ORDER BY sell_price DESC
    LIMIT 1
);

--55. Listar productos que se han vendido más veces que el promedio de ventas por producto.
-- Explicación: Subconsulta calcula promedio de ventas, comparamos cada producto con ese valor.
SELECT i.description, COUNT(ol.orderinfo_id) AS veces_vendido
FROM item AS i
INNER JOIN orderline AS ol ON i.item_id = ol.item_id
GROUP BY i.item_id, i.description
HAVING COUNT(ol.orderinfo_id) > (
    SELECT AVG(veces_vendido)
    FROM (
        SELECT COUNT(*) AS veces_vendido
        FROM orderline
        GROUP BY item_id
    ) AS subquery
)
ORDER BY veces_vendido DESC;

--56. Mostrar pedidos con un importe superior al importe promedio de todos los pedidos.
-- Explicación: Subconsulta calcula importe promedio, filtramos pedidos que lo superan.
SELECT oi.orderinfo_id, SUM(i.sell_price * ol.quantity) AS importe_pedido
FROM orderinfo AS oi
INNER JOIN orderline AS ol ON oi.orderinfo_id = ol.orderinfo_id
INNER JOIN item AS i ON ol.item_id = i.item_id
GROUP BY oi.orderinfo_id
HAVING SUM(i.sell_price * ol.quantity) > (
    SELECT AVG(importe)
    FROM (
        SELECT SUM(i2.sell_price * ol2.quantity) AS importe
        FROM orderinfo AS oi2
        INNER JOIN orderline AS ol2 ON oi2.orderinfo_id = ol2.orderinfo_id
        INNER JOIN item AS i2 ON ol2.item_id = i2.item_id
        GROUP BY oi2.orderinfo_id
    ) AS importes_pedidos
)
ORDER BY importe_pedido DESC;

-- ============================================================================
-- SECCIÓN 5: SUBCONSULTAS CON NOT IN / NOT EXISTS
-- ============================================================================

--57. Mostrar clientes que nunca han realizado un pedido.
-- Explicación: NOT IN con subconsulta que lista todos los customer_id que han pedido.
SELECT c.customer_id, c.fname, c.lname, c.town
FROM customer AS c
WHERE c.customer_id NOT IN (
    SELECT DISTINCT customer_id
    FROM orderinfo
);

--58. Listar productos que están en stock pero nunca se han vendido.
-- Explicación: Productos en stock (JOIN) que NO están en orderline (NOT IN).
SELECT i.description, s.quantity
FROM item AS i
INNER JOIN stock AS s ON i.item_id = s.item_id
WHERE i.item_id NOT IN (
    SELECT DISTINCT item_id
    FROM orderline
);

--59. Mostrar clientes que NO han comprado ningún producto con precio superior a 15 dólares.
-- Explicación: NOT IN con subconsulta de clientes que SÍ compraron productos caros.
SELECT c.customer_id, c.fname, c.lname
FROM customer AS c
WHERE c.customer_id NOT IN (
    SELECT DISTINCT oi.customer_id
    FROM orderinfo AS oi
    INNER JOIN orderline AS ol ON oi.orderinfo_id = ol.orderinfo_id
    INNER JOIN item AS i ON ol.item_id = i.item_id
    WHERE i.sell_price > 15
);

--60. Listar productos sin código de barras y que no están en stock.
-- Explicación: Dos condiciones NOT IN para excluir productos con barcode o stock.
SELECT i.description, i.sell_price
FROM item AS i
WHERE i.item_id NOT IN (
    SELECT item_id
    FROM barcode
)
AND i.item_id NOT IN (
    SELECT item_id
    FROM stock
);

--61. Mostrar ciudades desde donde no se ha realizado ningún pedido.
-- Explicación: LEFT JOIN y filtrar por NULL, alternativa a NOT IN.
SELECT DISTINCT c.town
FROM customer AS c
LEFT JOIN orderinfo AS oi ON c.customer_id = oi.customer_id
WHERE oi.orderinfo_id IS NULL;

-- ============================================================================
-- SECCIÓN 6: SUBCONSULTAS CORRELACIONADAS
-- ============================================================================

--62. Mostrar productos cuyo precio de venta es mayor que el precio promedio de su categoría (stock/no stock).
-- Explicación: Subconsulta correlacionada compara cada producto con promedio de su grupo.
SELECT i.description, i.sell_price,
       CASE WHEN EXISTS (SELECT 1 FROM stock s WHERE s.item_id = i.item_id) 
            THEN 'En Stock' 
            ELSE 'Sin Stock' 
       END AS estado_stock
FROM item AS i
WHERE i.sell_price > (
    SELECT AVG(i2.sell_price)
    FROM item AS i2
    WHERE EXISTS (SELECT 1 FROM stock s WHERE s.item_id = i2.item_id) = 
          EXISTS (SELECT 1 FROM stock s WHERE s.item_id = i.item_id)
)
ORDER BY i.sell_price DESC;

--63. Listar clientes que han realizado al menos un pedido en cada mes disponible en la base de datos.
-- Explicación: Cuenta meses distintos en los que cada cliente ha pedido.
SELECT c.customer_id, c.fname, c.lname, COUNT(DISTINCT EXTRACT(MONTH FROM oi.date_placed)) AS meses_activos
FROM customer AS c
INNER JOIN orderinfo AS oi ON c.customer_id = oi.customer_id
GROUP BY c.customer_id, c.fname, c.lname
HAVING COUNT(DISTINCT EXTRACT(MONTH FROM oi.date_placed)) = (
    SELECT COUNT(DISTINCT EXTRACT(MONTH FROM date_placed))
    FROM orderinfo
);

--64. Mostrar productos que se han vendido en todos los meses en que hubo ventas.
-- Explicación: Cuenta en cuántos meses distintos se vendió cada producto.
SELECT i.description, COUNT(DISTINCT EXTRACT(MONTH FROM oi.date_placed)) AS meses_vendido
FROM item AS i
INNER JOIN orderline AS ol ON i.item_id = ol.item_id
INNER JOIN orderinfo AS oi ON ol.orderinfo_id = oi.orderinfo_id
GROUP BY i.item_id, i.description
HAVING COUNT(DISTINCT EXTRACT(MONTH FROM oi.date_placed)) = (
    SELECT COUNT(DISTINCT EXTRACT(MONTH FROM date_placed))
    FROM orderinfo
)
ORDER BY i.description;

-- ============================================================================
-- SECCIÓN 7: AGREGACIONES CON JOINS
-- ============================================================================

--65. Calcular el beneficio total por cliente (nombre, apellido y beneficio).
-- Explicación: Beneficio = (sell_price - cost_price) * quantity, agrupado por cliente.
SELECT c.customer_id, c.fname, c.lname, 
       ROUND(SUM((i.sell_price - i.cost_price) * ol.quantity), 2) AS beneficio_total
FROM customer AS c
INNER JOIN orderinfo AS oi ON c.customer_id = oi.customer_id
INNER JOIN orderline AS ol ON oi.orderinfo_id = ol.orderinfo_id
INNER JOIN item AS i ON ol.item_id = i.item_id
GROUP BY c.customer_id, c.fname, c.lname
ORDER BY beneficio_total DESC;

--66. Mostrar el gasto promedio por pedido de cada cliente.
-- Explicación: Calculamos total por pedido, luego promediamos agrupando por cliente.
SELECT c.customer_id, c.fname, c.lname, 
       ROUND(AVG(pedido_total), 2) AS gasto_promedio_pedido
FROM customer AS c
INNER JOIN (
    SELECT oi.customer_id, oi.orderinfo_id, SUM(i.sell_price * ol.quantity) AS pedido_total
    FROM orderinfo AS oi
    INNER JOIN orderline AS ol ON oi.orderinfo_id = ol.orderinfo_id
    INNER JOIN item AS i ON ol.item_id = i.item_id
    GROUP BY oi.customer_id, oi.orderinfo_id
) AS pedidos ON c.customer_id = pedidos.customer_id
GROUP BY c.customer_id, c.fname, c.lname
ORDER BY gasto_promedio_pedido DESC;

--67. Mostrar productos con su margen de beneficio promedio por unidad vendida.
-- Explicación: Margen = sell_price - cost_price, agrupamos por producto.
SELECT i.description, 
       ROUND(AVG(i.sell_price - i.cost_price), 2) AS margen_promedio,
       SUM(ol.quantity) AS unidades_vendidas
FROM item AS i
INNER JOIN orderline AS ol ON i.item_id = ol.item_id
GROUP BY i.item_id, i.description
ORDER BY margen_promedio DESC;

--68. Calcular el número promedio de productos por pedido.
-- Explicación: Contamos items distintos por pedido, luego sacamos el promedio.
SELECT ROUND(AVG(items_por_pedido), 2) AS promedio_items_pedido
FROM (
    SELECT oi.orderinfo_id, COUNT(DISTINCT ol.item_id) AS items_por_pedido
    FROM orderinfo AS oi
    INNER JOIN orderline AS ol ON oi.orderinfo_id = ol.orderinfo_id
    GROUP BY oi.orderinfo_id
) AS subconsulta;

--69. Mostrar el mes con mayores ventas totales (en cantidad de productos vendidos).
-- Explicación: Agrupamos por mes, sumamos cantidades y ordenamos descendente.
SELECT EXTRACT(MONTH FROM oi.date_placed) AS mes,
       EXTRACT(YEAR FROM oi.date_placed) AS año,
       SUM(ol.quantity) AS total_unidades_vendidas
FROM orderinfo AS oi
INNER JOIN orderline AS ol ON oi.orderinfo_id = ol.orderinfo_id
GROUP BY EXTRACT(YEAR FROM oi.date_placed), EXTRACT(MONTH FROM oi.date_placed)
ORDER BY total_unidades_vendidas DESC
LIMIT 1;

-- ============================================================================
-- SECCIÓN 8: COMBINACIONES AVANZADAS
-- ============================================================================

--70. Mostrar clientes de 'Bingham' que han gastado más que el promedio de su ciudad.
-- Explicación: Subconsulta calcula promedio de Bingham, filtramos clientes que lo superan.
SELECT c.customer_id, c.fname, c.lname, SUM(i.sell_price * ol.quantity) AS gasto_total
FROM customer AS c
INNER JOIN orderinfo AS oi ON c.customer_id = oi.customer_id
INNER JOIN orderline AS ol ON oi.orderinfo_id = ol.orderinfo_id
INNER JOIN item AS i ON ol.item_id = i.item_id
WHERE c.town = 'Bingham'
GROUP BY c.customer_id, c.fname, c.lname
HAVING SUM(i.sell_price * ol.quantity) > (
    SELECT AVG(gasto_cliente)
    FROM (
        SELECT c2.customer_id, SUM(i2.sell_price * ol2.quantity) AS gasto_cliente
        FROM customer AS c2
        INNER JOIN orderinfo AS oi2 ON c2.customer_id = oi2.customer_id
        INNER JOIN orderline AS ol2 ON oi2.orderinfo_id = ol2.orderinfo_id
        INNER JOIN item AS i2 ON ol2.item_id = i2.item_id
        WHERE c2.town = 'Bingham'
        GROUP BY c2.customer_id
    ) AS gastos_bingham
)
ORDER BY gasto_total DESC;

--71. Listar productos que solo se vendieron en un único pedido.
-- Explicación: Agrupamos por producto y contamos pedidos distintos, filtramos los que tienen 1.
SELECT i.description, ol.orderinfo_id, SUM(ol.quantity) AS cantidad_vendida
FROM item AS i
INNER JOIN orderline AS ol ON i.item_id = ol.item_id
WHERE i.item_id IN (
    SELECT item_id
    FROM orderline
    GROUP BY item_id
    HAVING COUNT(DISTINCT orderinfo_id) = 1
)
GROUP BY i.item_id, i.description, ol.orderinfo_id;

--72. Mostrar el top 3 de productos más vendidos en cada mes.
-- Explicación: Usamos window functions con partición por mes para rankear productos.
SELECT mes, año, description, total_vendido, ranking
FROM (
    SELECT EXTRACT(MONTH FROM oi.date_placed) AS mes,
           EXTRACT(YEAR FROM oi.date_placed) AS año,
           i.description,
           SUM(ol.quantity) AS total_vendido,
           RANK() OVER (PARTITION BY EXTRACT(MONTH FROM oi.date_placed) 
                       ORDER BY SUM(ol.quantity) DESC) AS ranking
    FROM item AS i
    INNER JOIN orderline AS ol ON i.item_id = ol.item_id
    INNER JOIN orderinfo AS oi ON ol.orderinfo_id = oi.orderinfo_id
    GROUP BY EXTRACT(MONTH FROM oi.date_placed), EXTRACT(YEAR FROM oi.date_placed), i.description
) AS ranked
WHERE ranking <= 3
ORDER BY mes, ranking;

--73. Encontrar parejas de clientes que han comprado exactamente los mismos productos.
-- Explicación: Self-join de clientes comparando sus conjuntos de productos comprados.
SELECT DISTINCT c1.customer_id AS cliente1, c1.fname AS nombre1, c1.lname AS apellido1,
                c2.customer_id AS cliente2, c2.fname AS nombre2, c2.lname AS apellido2
FROM customer AS c1
INNER JOIN customer AS c2 ON c1.customer_id < c2.customer_id
WHERE NOT EXISTS (
    -- Productos que compró c1 pero no c2
    SELECT ol1.item_id
    FROM orderinfo AS oi1
    INNER JOIN orderline AS ol1 ON oi1.orderinfo_id = ol1.orderinfo_id
    WHERE oi1.customer_id = c1.customer_id
    AND ol1.item_id NOT IN (
        SELECT ol2.item_id
        FROM orderinfo AS oi2
        INNER JOIN orderline AS ol2 ON oi2.orderinfo_id = ol2.orderinfo_id
        WHERE oi2.customer_id = c2.customer_id
    )
)
AND NOT EXISTS (
    -- Productos que compró c2 pero no c1
    SELECT ol2.item_id
    FROM orderinfo AS oi2
    INNER JOIN orderline AS ol2 ON oi2.orderinfo_id = ol2.orderinfo_id
    WHERE oi2.customer_id = c2.customer_id
    AND ol2.item_id NOT IN (
        SELECT ol1.item_id
        FROM orderinfo AS oi1
        INNER JOIN orderline AS ol1 ON oi1.orderinfo_id = ol1.orderinfo_id
        WHERE oi1.customer_id = c1.customer_id
    )
);

--74. Mostrar productos cuyo stock actual es menor que la cantidad promedio vendida por pedido.
-- Explicación: Comparamos cantidad en stock con promedio de cantidad en orderline.
SELECT i.description, s.quantity AS stock_actual,
       ROUND((SELECT AVG(quantity) FROM orderline WHERE item_id = i.item_id), 2) AS promedio_por_pedido
FROM item AS i
INNER JOIN stock AS s ON i.item_id = s.item_id
WHERE s.quantity < (
    SELECT AVG(quantity)
    FROM orderline
    WHERE item_id = i.item_id
)
ORDER BY s.quantity;

--75. Calcular la tasa de conversión de productos en stock (% que se han vendido al menos una vez).
-- Explicación: Cuenta productos en stock vendidos vs total en stock, calcula porcentaje.
SELECT 
    COUNT(DISTINCT s.item_id) AS productos_en_stock,
    COUNT(DISTINCT CASE WHEN ol.item_id IS NOT NULL THEN s.item_id END) AS productos_vendidos,
    ROUND(
        (COUNT(DISTINCT CASE WHEN ol.item_id IS NOT NULL THEN s.item_id END)::NUMERIC / 
         COUNT(DISTINCT s.item_id) * 100), 
        2
    ) AS tasa_conversion_porcentaje
FROM stock AS s
LEFT JOIN orderline AS ol ON s.item_id = ol.item_id;
