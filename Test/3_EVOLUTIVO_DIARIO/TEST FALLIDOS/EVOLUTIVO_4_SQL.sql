-- Crear una vista para Plan de Cuentas
CREATE OR REPLACE VIEW sandbox.ganafinanciero.001_Plan_Cuentas_BSC AS
SELECT 
    empresa, 
    cuenta, 
    descripcion, 
    cod_reaj, 
    tipo_moneda, 
    cent_resp, 
    num_cta_sbif_mdr, 
    cod_producto
FROM informacional_prd.bu_syp_in.plancta_contab_fusion;

-- Crear una vista para Saldos Contables
CREATE OR REPLACE VIEW sandbox.ganafinanciero.002_Saldos_Contables_BSC AS
SELECT 
    empresa, 
    sucur, 
    moned, 
    codig, 
    fecha, 
    tipo_moneda, 
    sdo_orig, 
    sdo_peso, 
    prom_orig, 
    prom_peso, 
    sdo_mes_orig, 
    sdo_mes_peso, 
    prom_anual_orig, 
    prom_anual_peso
FROM informacional_prd.bu_syp_in.sdo_contab_fusion
WHERE 
    sucur = 9999 
    AND fecha BETWEEN 20240101 AND 20241231
ORDER BY fecha;

-- Subconsultas para obtener fechas únicas y construir tabla final dynamic_query
WITH fechas_unicas AS (
    SELECT DISTINCT fecha 
    FROM sandbox.ganafinanciero.002_Saldos_Contables_BSC
),
case_statements AS (
    SELECT 
        CONCAT(
            'SUM(CASE WHEN sc.fecha = ''', 
            fecha, 
            ''' THEN sc.sdo_peso ELSE 0 END) AS Suma_sdo_peso_', 
            REPLACE(fecha, '-', '_')
        ) AS case_statement
    FROM fechas_unicas
),
dynamic_query AS (
    SELECT 
        sc.codig, 
        CAST(sc.descripcion AS STRING) AS descripcion1, 
        pc.num_cta_sbif_mdr, 
        sc.moned, 
        pc.cent_resp, 
        pc.cod_producto, 
        STRING_AGG(case_statement, ', ') AS dynamic_case_statements
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
SELECT * 
FROM dynamic_query;
