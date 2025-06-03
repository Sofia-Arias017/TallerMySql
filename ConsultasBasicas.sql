SELECT * FROM usuarios;

SELECT nombre, email FROM usuarios
WHERE ciudad = 'Madrid';

SELECT nombre, precio FROM productos
WHERE precio>100000;

SELECT usuarios.nombre, empleados.puesto,empleados.salario
FROM usuarios
JOIN empleados ON usuarios.usuario_id = empleados.usuario_id
WHERE empleados.salario > 2500000;
