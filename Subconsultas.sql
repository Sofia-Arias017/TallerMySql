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

-- 5.Muestra los nombres de los clientes que han realizado
-- más pedidos que el promedio de pedidos de todos los clientes.

SELECT usuarios.nombre AS Nombre
FROM usuarios
WHERE usuarios.usuario_id IN (
    SELECT pedidos.cliente_id
    FROM pedidos
    GROUP BY pedidos.cliente_id
    HAVING COUNT(*) > (
        SELECT AVG(pedidos_por_cliente.total_pedidos)
        FROM (
            SELECT pedidos.cliente_id, COUNT(*) AS total_pedidos
            FROM pedidos
            GROUP BY pedidos.cliente_id
        ) AS pedidos_por_cliente
    )
);

-- 6.Obtén los productos cuyo precio es superior al precio promedio de todos los productos.

SELECT productos.nombre AS Producto, productos.precio AS Precio
FROM productos
WHERE productos.precio > (
    SELECT AVG(productos.precio)
    FROM productos
);

-- 7.Lista los clientes que han gastado más de $1.000.000 en total.

SELECT usuarios.nombre AS Cliente
FROM usuarios
WHERE usuarios.usuario_id IN (
    SELECT pedidos.cliente_id
    FROM pedidos
    JOIN detalles_pedidos ON pedidos.pedido_id = detalles_pedidos.pedido_id
    GROUP BY pedidos.cliente_id
    HAVING SUM(detalles_pedidos.cantidad * detalles_pedidos.precio_unitario) > 1000000
);

-- 8.Encuentra los empleados que ganan un salario mayor al promedio de la empresa.

SELECT empleados.empleado_id AS EmpleadoID, empleados.salario AS Salario
FROM empleados
WHERE empleados.salario > (
    SELECT AVG(salario)
    FROM empleados
);

-- 9.Obtén los productos que generaron ingresos mayores al ingreso promedio por producto.

SELECT productos.nombre AS Producto, productos.categoria AS Categoria
FROM productos
JOIN detalles_pedidos ON productos.producto_id = detalles_pedidos.producto_id
GROUP BY productos.producto_id
HAVING SUM(detalles_pedidos.cantidad * detalles_pedidos.precio_unitario) > (
    SELECT AVG(ingreso_total) FROM (
        SELECT SUM(cantidad * precio_unitario) AS ingreso_total
        FROM detalles_pedidos
        GROUP BY producto_id
    ) AS ingresos_por_producto
);

-- 10.Encuentra el nombre del cliente que realizó el pedido más reciente.

SELECT  usuarios.nombre AS Nombre,
        usuarios.ciudad AS Ciudad,
        pedidos.fecha_pedido AS FechaPedido
FROM usuarios
JOIN pedidos ON usuarios.usuario_id = pedidos.cliente_id
WHERE pedidos.fecha_pedido = (
    SELECT MAX(fecha_pedido)
    FROM pedidos
);



