
--CONSULTA 1: RESUMEN EJECUTIVO MENSUAL (Total facturado, cantidad de pedidos y ticket promedio, agrupados por mes)--

SELECT 
MONTH(fecha_venta) AS mes,
SUM(cantidad * precio_unitario) AS total_facturado,
COUNT(id_venta) AS cantidad_pedidos,
AVG(cantidad * precio_unitario) AS ticket_promedio
FROM Ventas
GROUP BY MONTH(fecha_venta);




--CONSULTA 2: RANKING DE PRODUCTOS (TOP 5 de id_producto por total facturado)--

SELECT TOP 5 id_producto,
SUM(cantidad) AS unidades_vendidas,
SUM(cantidad * precio_unitario) AS total_facturado
FROM Ventas
GROUP BY id_producto
ORDER BY total_facturado DESC;




--CONSULTA 3: CLIENTES RECURRENTES (Clientes que realizaron más de 1 pedido)--

SELECT
id_cliente,
COUNT(*) AS total_pedidos,
SUM(cantidad * precio_unitario) AS total_gastado
FROM Ventas
GROUP BY id_cliente
HAVING COUNT (*) > 1;




--CONSULTA 4: PRODUCTOS POR ENCIMA/POR DEBAJO DEL PROMEDIO--

WITH promedio_facturacion AS
	(SELECT
	id_producto,
	SUM(cantidad * precio_unitario) AS total_facturado
	FROM Ventas
	GROUP BY id_producto)
SELECT
id_producto,
total_facturado,
CASE 
	WHEN total_facturado >= (SELECT AVG(total_facturado) FROM promedio_facturacion)
	THEN 'Por encima'
	ELSE 'Por debajo'
	END AS estado_promedio
FROM promedio_facturacion;




--BLOQUE DE CIERRE: Se observa que la mayor cantidad de pedidos realizados fue en el mes de Marzo, con un total de 10 pedidos realizados que sumaron un total facturado de $6444--
--El id_producto 1 lidera la facturación, con un total de 3 unidades vendidas--
--Comparando los clientes, los 5 realizaron 2 pedidos en total cada uno, pero vemos que el id_cliente 1 es el que más gastó en sus compras--
--Podemos notar que el id_producto 1 y 3 se encuentran por encima del promedio del total facturado, superando los $1350 como mínimo, y el resto de los productos por debajo del promedio, sin alcanzar a los $400--

