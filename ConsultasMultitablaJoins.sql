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

-- 5.Encuentra los productos y, si existen, 
--los detalles de pedidos en los que no se ha incluido el producto usando RIGHT JOIN.--

SELECT
    productos.producto_id,
    productos.nombre AS Nombre,
    productos.precio AS Precio,
    detalles_pedidos.cantidad AS Cantidad,
    detalles_pedidos.detalle_id AS DetallePedido_id
FROM detalles_pedidos
RIGHT JOIN productos
ON detalles_pedidos.producto_id = productos.producto_id;

-- 6. Lista todos los empleados junto con los pedidos que han gestionado, 
-- si existen, usando LEFT JOIN para ver los empleados sin pedidos.

SELECT
    empleados.empleado_id,
    empleados.puesto AS Puesto,
    empleados.fecha_contratacion AS FechaContratacion,
    empleados.salario AS Salario,
    pedidos.fecha_pedido AS FechaPedido,
    pedidos.estado AS Estado
FROM empleados
LEFT JOIN pedidos
ON empleados.empleado_id = pedidos.empleado_id;

-- 7. Encuentra los empleados que no han gestionado ningún pedido usando un --LEFT JOIN combinado con WHERE.

SELECT
    empleados.empleado_id,
    empleados.puesto AS Puesto,
    empleados.fecha_contratacion AS FechaContratacion,
    empleados.salario AS Salario,
    pedidos.fecha_pedido AS FechaPedido,
    pedidos.estado As Estado
FROM empleados
LEFT JOIN pedidos
ON empleados.empleado_id = pedidos.empleado_id
WHERE pedidos.fecha_pedido IS NULL AND pedidos.estado IS NULL;

-- 8. Calcula el total gastado en cada pedido, mostrando el ID del pedido y el 
-- total, usando JOIN.

-- Cuando utilizemos el Group BY tenemenos que seleccionar solamente los utilizados
-- no por ejemplos colocar muchos solamente los necesarios 
-- error similar al #1 
SELECT 
    pedidos.pedido_id AS PedidoID,
    pedidos.fecha_pedido AS FechaPedido,
    SUM(detalles_pedidos.precio_unitario * detalles_pedidos.cantidad) AS TotalGastado
FROM pedidos
JOIN detalles_pedidos
ON pedidos.pedido_id = detalles_pedidos.pedido_id
GROUP BY pedidos.pedido_id, pedidos.fecha_pedido;

-- 9. Realiza un CROSS JOIN entre clientes y productos para mostrar todas las 
-- combinaciones posibles de clientes y productos.

SELECT *
FROM usuarios
CROSS JOIN productos;

-- 10. Encuentra los nombres de los clientes y los productos que han comprado, si
-- existen, incluyendo los clientes que no han realizado pedidos usando LEFT JOIN.

SELECT 
    usuarios.nombre AS NombreCliente,
    productos.nombre AS ProductoComprado
FROM  usuarios
LEFT JOIN pedidos
    ON usuarios.usuario_id = pedidos.cliente_id
LEFT JOIN detalles_pedidos
    ON pedidos.pedido_id = detalles_pedidos.pedido_id
LEFT JOIN productos
    ON detalles_pedidos.producto_id = productos.producto_id;

-- 11.Listar todos los proveedores que suministran un determinado producto.

SELECT 
    p.proveedor_id,
    p.nombre AS nombre_proveedor,
    p.email,
    pr.nombre AS nombre_producto
FROM 
    proveedores p
JOIN 
    proveedores_productos pp ON p.proveedor_id = pp.proveedor_id
JOIN 
    productos pr ON pp.producto_id = pr.producto_id
WHERE 
    pr.nombre = 'Laptop';

-- 12.Obtener todos los productos que ofrece un proveedor específico.

SELECT 
    pr.producto_id,
    pr.nombre AS nombre_producto,
    pr.precio,
    p.nombre AS nombre_proveedor
FROM 
    productos pr
JOIN 
    proveedores_productos pp ON pr.producto_id = pp.producto_id
JOIN 
    proveedores p ON pp.proveedor_id = p.proveedor_id
WHERE 
    p.nombre = 'Tech Supplies S.A.';

-- 13.Lista los proveedores que no están asociados a ningún producto (es decir, que aún no suministran).

SELECT 
    p.proveedor_id,
    p.nombre
FROM 
    proveedores p
LEFT JOIN 
    proveedores_productos pp ON p.proveedor_id = pp.proveedor_id
WHERE 
    pp.producto_id IS NULL;

-- 14.Contar cuántos proveedores tiene cada producto.

SELECT 
    p.producto_id,
    p.nombre AS nombre_producto,
    COUNT(pp.proveedor_id) AS cantidad_proveedores
FROM 
    productos p
JOIN 
    proveedores_productos pp ON p.producto_id = pp.producto_id
GROUP BY 
    p.producto_id, p.nombre;

-- 15.Para un proveedor determinado (p. ej. proveedor_id = 3),
-- muestra el nombre de todos los productos que suministra.

SELECT p.nombre AS nombre_producto
FROM productos p
JOIN proveedores_productos pp ON p.producto_id = pp.producto_id
WHERE pp.proveedor_id = 3;

-- 16.Para un producto específico (p. ej. producto_id = 1),
-- muestra todos los proveedores que lo distribuyen, con sus datos de contacto.

SELECT
    p.proveedor_id,
    p.nombre AS proveedor,
    p.email,
    p.telefono,
    p.direccion,
    p.ciudad,
    p.pais
FROM
    proveedores p
JOIN
    proveedores_productos pp ON p.proveedor_id = pp.proveedor_id
WHERE
    pp.producto_id = 1;

-- 17.Cuenta cuántos proveedores tiene cada producto,
-- listando producto_id, nombre y cantidad_proveedores.

SELECT 
    p.producto_id,
    p.nombre,
    COUNT(pp.proveedor_id) AS cantidad_proveedores
FROM 
    productos p
LEFT JOIN 
    proveedores_productos pp ON p.producto_id = pp.producto_id
GROUP BY 
    p.producto_id, p.nombre;

-- 18.Cuenta cuántos productos suministra cada proveedor,
-- mostrando proveedor_id, nombre_proveedor y total_productos.

SELECT 
    pr.proveedor_id,
    pr.nombre AS nombre_proveedor,
    COUNT(pp.producto_id) AS total_productos
FROM 
    proveedores pr
LEFT JOIN 
    proveedores_productos pp ON pr.proveedor_id = pp.proveedor_id
GROUP BY 
    pr.proveedor_id, pr.nombre;










