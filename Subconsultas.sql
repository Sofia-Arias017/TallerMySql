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

