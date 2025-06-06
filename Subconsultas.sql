-- 1.Encuentra los nombres de los clientes que han
-- realizado al menos un pedido de más de $500.000.

SELECT nombre
FROM usuarios
WHERE usuario_id IN (
    SELECT pedidos.cliente_id
    FROM pedidos
    JOIN detalles_pedidos
        ON pedidos.pedido_id = detalles_pedidos.pedido_id
    GROUP BY pedidos.cliente_id
    HAVING SUM(detalles_pedidos.precio_unitario * detalles_pedidos.cantidad) > 500000
);

-- 2.Muestra los productos que nunca han sido pedidos.

SELECT nombre
FROM productos
WHERE producto_id NOT IN (
    SELECT producto_id
    FROM detalles_pedidos
);

-- 3.Lista los empleados que han gestionado pedidos en los últimos 6 meses.

SELECT DISTINCT empleados.empleado_id, empleados.fecha_contratacion
FROM empleados 
WHERE empleados.empleado_id IN (
    SELECT pedidos.empleado_id
    FROM pedidos
    WHERE pedidos.fecha_pedido >= DATE_SUB(NOW(), INTERVAL 6 MONTH)
);

-- 4.Encuentra el pedido con el total de ventas más alto.

SELECT pedido_id, SUM(precio_unitario * cantidad) AS total_venta
FROM detalles_pedidos
GROUP BY pedido_id
ORDER BY total_venta DESC
LIMIT 1;

