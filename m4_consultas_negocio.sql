
USE Ventas_Tech_DB;

-- Consulta 1 — Resumen ejecutivo mensual

SELECT 
    MONTH(fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    COUNT(*) AS cantidad_pedidos,
    AVG(cantidad * precio_unitario) AS ticket_promedio
FROM ventas
GROUP BY MONTH(fecha_venta);

-- Consulta 2 — Ranking de productos (Top 5)

SELECT TOP 5
    id_producto,
    SUM(cantidad) AS unidades_vendidas,
    SUM(cantidad * precio_unitario) AS total_generado
FROM ventas
GROUP BY id_producto
ORDER BY total_generado DESC;

-- Consulta 3 — Clientes recurrentes

SELECT 
    id_cliente,
    COUNT(*) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1;

-- Consulta 4 — Productos por encima/por debajo del promedio

WITH VentasPorProducto AS (
    SELECT 
        id_producto,
        SUM(cantidad * precio_unitario) AS total_producto
    FROM ventas
    GROUP BY id_producto
)
SELECT 
    id_producto,
    total_producto,
    CASE 
        WHEN total_producto >= (SELECT AVG(total_producto) FROM VentasPorProducto) THEN 'Por encima'
        ELSE 'Por debajo'
    END AS clasificacion_promedio
FROM VentasPorProducto;

--- BLOQUE DE CIERRE: 3 Hallazgos de Negocio
-- 1. El producto con id_producto = 1 (Laptop Pro 15) es el principal generador de ingresos con $3,600.00, representando el 55% de la facturación total del mes ($6,324.00) con apenas 3 unidades vendidas.
-- 2. Dos clientes (id 1, id 5) concentran el 73% de la facturación mensual en un total de 4 pedidos.
-- 3. Únicamente 2 productos (id 1, id 3) lograron superar el umbral promedio de facturación por producto.
