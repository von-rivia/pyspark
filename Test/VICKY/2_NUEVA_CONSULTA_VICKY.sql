SELECT 
    cod_linea,
    rol_cuenta,
    descripcion,
    CONCAT(SUBSTRING(fecha, 1, 4), SUBSTRING(fecha, 5, 2)) as mes,
    codig,
    ROUND(SUM(
        CASE 
            WHEN SUBSTRING(fecha, 1, 6) = DATE_FORMAT(current_date(), 'yyyyMM') THEN 
                (credito - debito) / (DAY(current_date()) - 1) * 31
            ELSE 
                (credito - debito) / DAY(last_day(TO_DATE(fecha, 'yyyyMMdd'))) * 31
        END
    ), 0) as saldo
    
FROM sandbox.ganafinanciero.revision_devengos_24
WHERE fecha BETWEEN 20241001 AND 20250131
GROUP BY 
    cod_linea,
    rol_cuenta,
    fecha,
    codig,
    descripcion,
    debito,
    credito
ORDER BY fecha;

