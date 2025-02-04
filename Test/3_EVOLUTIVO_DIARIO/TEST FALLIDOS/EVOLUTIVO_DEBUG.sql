-- Verificar datos en las vistas creadas
SELECT * FROM sandbox.ganafinanciero.001_Plan_Cuentas_BSC LIMIT 10;
SELECT * FROM sandbox.ganafinanciero.002_Saldos_Contables_BSC LIMIT 10;

-- Verificar datos dentro del rango de fechas
SELECT * FROM informacional_prd.bu_syp_in.sdo_contab_fusion WHERE sucur = 9999 AND fecha BETWEEN 20240101 AND 20241231 LIMIT 10;

-- Verificar cada subconsulta por separado
WITH fechas_unicas AS (
    SELECT DISTINCT fecha 
    FROM sandbox.ganafinanciero.002_Saldos_Contables_BSC
)
SELECT * FROM fechas_unicas LIMIT 10;

WITH case_statements AS (
    SELECT 
        CONCAT(
            'SUM(CASE WHEN sc.fecha = ''', 
            fecha, 
            ''' THEN sc.sdo_peso ELSE 0 END) AS Suma_sdo_peso_', 
            REPLACE(fecha, '-', '_')
        ) AS case_statement
    FROM fechas_unicas
)
SELECT * FROM case_statements LIMIT 10;

WITH dynamic_query AS (
    SELECT 
        sc.codig, 
        CAST(sc.descripcion AS STRING) AS descripcion1, 
        pc.num_cta_sbif_mdr, 
        sc.moned, 
        pc.cent_resp, 
        pc.cod_producto, 
        collect_list(case_statement) AS dynamic_case_statements
    FROM sandbox.ganafinanciero.001_Plan_Cuentas_BSC pc
    INNER JOIN sandbox.ganafinanciero.002_Saldos_Contables_BSC sc ON pc.cuenta = sc.codig
    CROSS JOIN case_statements
    GROUP BY 
        sc.codig, 
        CAST(sc.descripcion AS STRING), 
        pc.num_cta_sbif_mdr, 
        sc.moned, 
        pc.cent_resp, 
        pc.cod_producto
)
SELECT *, array_join(dynamic_case_statements, ', ') AS dynamic_query FROM dynamic_query LIMIT 10;
