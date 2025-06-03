SELECT * FROM usuarios;

SELECT nombre, email FROM usuarios
WHERE ciudad = 'Madrid';

SELECT nombre, precio FROM productos
WHERE precio>100000;

SELECT usuarios.nombre, empleados.puesto,empleados.salario
FROM usuarios
JOIN empleados ON usuarios.usuario_id = empleados.usuario_id
WHERE empleados.salario > 2500000;

SELECT nombre, categoria FROM productos
WHERE categoria = 'Electrónica'
ORDER BY nombre ASC;

SELECT pedidos.cliente_id, pedidos.fecha_pedido,pedidos.estado,detalles_pedidos.pedido_id
FROM pedidos
JOIN detalles_pedidos ON pedidos.pedido_id = detalles_pedidos.pedido_id
WHERE pedidos.estado = 'Pendiente';

SELECT nombre, precio FROM productos
WHERE precio =  (SELECT MAX(precio) FROM productos);

SELECT cliente_id, COUNT(*) FROM pedidos GROUP BY cliente_id;

