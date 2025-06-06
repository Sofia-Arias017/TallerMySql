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

-- 11.Muestra los productos pedidos al menos una vez en los últimos 3 meses.

SELECT productos.nombre AS Producto, productos.precio AS Precio
FROM productos
WHERE productos.producto_id IN (
    SELECT detalles_pedidos.producto_id
    FROM detalles_pedidos
    JOIN pedidos ON detalles_pedidos.pedido_id = pedidos.pedido_id
    WHERE pedidos.fecha_pedido >= DATE_SUB(NOW(), INTERVAL 3 MONTH)
);

-- 12.Lista los empleados que no han gestionado ningún pedido.

SELECT empleados.empleado_id AS EmpleadoID, empleados.puesto AS Puesto
FROM empleados
WHERE empleados.empleado_id NOT IN (
    SELECT pedidos.empleado_id
    FROM pedidos
)

-- 13.Encuentra los clientes que han comprado más de tres tipos distintos de productos.

SELECT usuarios.nombre AS Nombre, usuarios.ciudad AS Ciudad
FROM usuarios
WHERE usuarios.usuario_id IN (
    SELECT pedidos.cliente_id
    FROM pedidos
    JOIN detalles_pedidos ON pedidos.pedido_id = detalles_pedidos.pedido_id
    GROUP BY pedidos.cliente_id
    HAVING COUNT(DISTINCT detalles_pedidos.producto_id) > 3
);

-- 14.Muestra el nombre del producto más caro que se ha pedido al menos cinco veces.

SELECT productos.nombre, productos.precio
FROM productos
WHERE productos.producto_id IN (
    SELECT producto_id
    FROM detalles_pedidos
    GROUP BY producto_id
    HAVING COUNT(*) >= 5
)
ORDER BY productos.precio DESC
LIMIT 1;

-- 15.Lista los clientes cuyo primer pedido fue un año después de su registro.

SELECT usuarios.*
FROM usuarios
WHERE(
    SELECT 1
    FROM pedidos
    WHERE pedidos.cliente_id = usuarios.usuario_id
    GROUP BY pedidos.cliente_id
    HAVING MIN(pedidos.fecha_pedido) = DATE_ADD(usuarios.fecha_registro, INTERVAL 1 YEAR)
);

-- 16.Encuentra los nombres de los productos que tienen
-- un stock inferior al promedio del stock de todos los productos.

SELECT  productos.nombre AS Productos,
        productos.stock AS Stock
FROM productos
WHERE productos.stock < (
    SELECT AVG(stock)
    FROM productos
);

-- 17.Lista los clientes que han realizado menos de tres pedidos.

SELECT usuarios.nombre, usuarios.email, usuarios.pais
FROM usuarios
WHERE tipo_id = 1
AND (
    SELECT COUNT(*)
    FROM pedidos
    WHERE pedidos.cliente_id = usuarios.usuario_id
) < 3;

-- 18.Encuentra los nombres de los productos que fueron
-- pedidos por los clientes que registraron en el último año.

SELECT pedido_id, cliente_id, fecha_pedido
FROM pedidos
WHERE cliente_id IN (
    SELECT usuario_id
    FROM usuarios
    WHERE fecha_registro >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
);

-- 19.Obtén el nombre del empleado que gestionó el mayor número de pedidos.

SELECT usuarios.nombre
FROM empleados
JOIN usuarios ON empleados.usuario_id = usuarios.usuario_id
WHERE empleados.empleado_id = (
    SELECT empleado_id
    FROM pedidos
    GROUP BY empleado_id
    ORDER BY COUNT(*) DESC
    LIMIT 1
);


