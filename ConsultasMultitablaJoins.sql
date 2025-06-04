-- Active: 1748438148148@@127.0.0.1@3307@tallersql
SELECT usuarios.nombre, detalles_pedidos.pedido_id, detalles_pedidos.producto_id
FROM usuarios
JOIN pedidos ON pedidos.cliente_id = usuarios.usuario_id
JOIN detalles_pedidos ON detalles_pedidos.pedido_id = pedidos.pedido_id;

SELECT p.pedido_id, GROUP_CONCAT(CONCAT(po.nombre,  ',',po.categoria)) AS productos, SUM(dp.cantidad * dp.precio_unitario) as Total
FROM pedidos AS p
INNER JOIN detalles_pedidos AS dp ON p.pedido_id = dp.pedido_id
INNER JOIN productos AS po ON dp.producto_id = po.producto_id
GROUP BY p.pedido_id;
