SELECT 
cod_linea,
rol_cuenta,
descripcion,
CONCAT(SUBSTRING(fecha,1,4),SUBSTRING(fecha,5,2)) as mes,
codig, 
ROUND(SUM(credito-debito),0) as saldo
FROM sandbox.ganafinanciero.revision_devengos_24
WHERE fecha BETWEEN 20241001 AND 20250131
GROUP BY 
cod_linea,
rol_cuenta,
fecha,codig,
descripcion,
debito,
credito
ORDER BY fecha;


((credito-debito)/DAY(LAST_DATE(TO_DATE(fecha, 'yyyyMMdd')))*31)