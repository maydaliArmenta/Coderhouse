

USE Ventas_Tech_DB;

-- Consulta 1 — Vista base del proyecto (INNER JOIN)

SELECT 
    v.fecha_venta,
    c.id_cliente,
    c.nombre AS nombre_cliente,
    c.ciudad AS region_cliente,
    p.id_producto,
    p.nombre_producto,
    cat.nombre_categoria,
    v.cantidad,
    v.precio_unitario,
    (v.cantidad * v.precio_unitario) AS total_venta
FROM ventas v
INNER JOIN clientes c ON v.id_cliente = c.id_cliente
INNER JOIN productos p ON v.id_producto = p.id_producto
INNER JOIN categorias cat ON p.id_categoria = cat.id_categoria;

-- Hallazgo: Se consolidaron las 10 transacciones con detalle descriptivo completo de clientes y productos, donde los productos de 'Computación' concentran los montos de venta más altos (1200).

-- Consulta 2 — Clientes sin ventas (LEFT JOIN)

SELECT 
    c.id_cliente,
    c.nombre AS nombre_cliente,
    c.email,
    c.fecha_registro
FROM clientes c
LEFT JOIN ventas v ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL;

-- Hallazgo: Mi consulta se ejecutó correctamente pero no trajo nada, debido a que todos los clientes tienen al menos una compra. actualmente estan todos activos.

-- Consulta 3 — Productos sin ventas (LEFT JOIN)

SELECT 
    p.id_producto,
    p.nombre_producto,
    cat.nombre_categoria,
    p.precio,
    p.stock
FROM productos p
INNER JOIN categorias cat ON p.id_categoria = cat.id_categoria
LEFT JOIN ventas v ON p.id_producto = v.id_producto
WHERE v.id_venta IS NULL;

-- Hallazgo: Al no mostrarme nada la consulta, corri completa la tabla y confirme que todos los productos fueron vendidos al menos una vez. 

-- Consulta 4 — Consolidado por canal (UNION ALL)

SELECT 
    canal,
    SUM(total) AS total_canal
FROM (
    SELECT 
        fecha_venta, 
        (cantidad * precio_unitario) AS total, 
        'Online' AS canal
    FROM ventas 
    WHERE fecha_venta <= '2024-03-10'

    UNION ALL
    
    SELECT 
        fecha_venta, 
        (cantidad * precio_unitario) AS total, 
        'Presencial' AS canal
    FROM ventas 
    WHERE fecha_venta > '2024-03-10'
) AS consolidado
GROUP BY canal;

-- Hallazgo: El canal online generó mayor facturación ($3620) en comparación con el canal presencial ($2,550.00),siendo el canal online quien concentra el 56% del ingreso del periodo.