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

SELECT c.nombre AS nombre_cliente, e.nombre AS nombre_empleado
FROM pedidos AS p
INNER JOIN usuarios AS c ON p.cliente_id = c.usuario_id
INNER JOIN empleados emp ON p.empleado_id = emp.empleado_id
INNER JOIN usuarios AS e ON emp.usuario_id = e.usuario_id
GROUP BY p.pedido_id;

--4. Muestra todos los pedidos y, si existen, los productos en cada pedido,
--incluyendo los pedidos sin productos usando LEFT JOIN--

SELECT 
    productos.nombre AS Producto,
    pedidos.cliente_id AS Cliente_id,
    pedidos.empleado_id AS Empleado_id,
    detalles_pedidos.cantidad AS Cantidad,
    pedidos.fecha_pedido AS Fecha,
    pedidos.estado AS Estado
FROM pedidos
LEFT JOIN detalles_pedidos
ON pedidos.pedido_id = detalles_pedidos.pedido_id
LEFT JOIN productos
ON detalles_pedidos.producto_id = productos.producto_id;