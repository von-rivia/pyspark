-- -- 001_Crea_Plan_Cuentas_BSC
%sql
CREATE TABLE sandbox.ganafinanciero.001_Plan_Cuentas_BSC AS
SELECT 
    informacional_prd.bu_syp_in.plancta_contab_fusion.empresa, 
    informacional_prd.bu_syp_in.plancta_contab_fusion.cuenta, 
    informacional_prd.bu_syp_in.plancta_contab_fusion.descripcion, 
    informacional_prd.bu_syp_in.plancta_contab_fusion.cod_reaj, 
    informacional_prd.bu_syp_in.plancta_contab_fusion.tipo_moneda, 
    informacional_prd.bu_syp_in.plancta_contab_fusion.cent_resp, 
    informacional_prd.bu_syp_in.plancta_contab_fusion.num_cta_sbif_mdr, 
    informacional_prd.bu_syp_in.plancta_contab_fusion.cod_producto 
FROM informacional_prd.bu_syp_in.plancta_contab_fusion;

-- 002_Crea_Saldos_Contables_BSC
%sql
CREATE TABLE sandbox.ganafinanciero.002_Saldos_Contables_BSC AS
SELECT 
    informacional_prd.bu_syp_in.sdo_contab_fusion.empresa, 
    informacional_prd.bu_syp_in.sdo_contab_fusion.sucur, 
    informacional_prd.bu_syp_in.sdo_contab_fusion.moned, 
    informacional_prd.bu_syp_in.sdo_contab_fusion.codig, 
    informacional_prd.bu_syp_in.sdo_contab_fusion.fecha, 
    informacional_prd.bu_syp_in.sdo_contab_fusion.tipo_moneda, 
    informacional_prd.bu_syp_in.sdo_contab_fusion.sdo_orig, 
    informacional_prd.bu_syp_in.sdo_contab_fusion.sdo_peso, 
    informacional_prd.bu_syp_in.sdo_contab_fusion.prom_orig, 
    informacional_prd.bu_syp_in.sdo_contab_fusion.prom_peso, 
    informacional_prd.bu_syp_in.sdo_contab_fusion.sdo_mes_orig, 
    informacional_prd.bu_syp_in.sdo_contab_fusion.sdo_mes_peso, 
    informacional_prd.bu_syp_in.sdo_contab_fusion.prom_anual_orig, 
    informacional_prd.bu_syp_in.sdo_contab_fusion.prom_anual_peso 
FROM informacional_prd.bu_syp_in.sdo_contab_fusion
WHERE (((informacional_prd.bu_syp_in.sdo_contab_fusion.sucur) = 9999) 
    AND ((informacional_prd.bu_syp_in.sdo_contab_fusion.fecha) BETWEEN 20250101 AND 20250131))
ORDER BY informacional_prd.bu_syp_in.sdo_contab_fusion.fecha;

-- 002_Saldos_Contables_BSC tabla
%sql
CREATE OR REPLACE TEMP VIEW sandbox.ganafinanciero.base_data AS
SELECT 
    sandbox.ganafinanciero.002_Saldos_Contables_BSC.codig, 
    CAST(sandbox.ganafinanciero.002_Saldos_Contables_BSC.descripcion AS STRING) AS descripcion1, 
    sandbox.ganafinanciero.001_Plan_Cuentas_BSC.num_cta_sbif_mdr, 
    sandbox.ganafinanciero.002_Saldos_Contables_BSC.moned, 
    sandbox.ganafinanciero.001_Plan_Cuentas_BSC.cent_resp, 
    sandbox.ganafinanciero.001_Plan_Cuentas_BSC.cod_producto, 
    sandbox.ganafinanciero.002_Saldos_Contables_BSC.fecha, 
    sandbox.ganafinanciero.002_Saldos_Contables_BSC.sdo_peso
FROM sandbox.ganafinanciero.001_Plan_Cuentas_BSC
INNER JOIN sandbox.ganafinanciero.002_Saldos_Contables_BSC 
ON sandbox.ganafinanciero.001_Plan_Cuentas_BSC.cuenta = sandbox.ganafinanciero.002_Saldos_Contables_BSC.codig;

-- Primero, obtener las fechas únicas que queremos pivotar
CREATE OR REPLACE TEMP VIEW sandbox.ganafinanciero.unique_dates AS
SELECT DISTINCT sandbox.ganafinanciero.base_data.fecha
FROM sandbox.ganafinanciero.base_data;

-- Crear una lista con las fechas únicas
CREATE OR REPLACE TEMP VIEW date_columns AS
SELECT 
    'SUM(CASE WHEN fecha = ''' || fecha || ''' THEN sdo_peso ELSE 0 END) AS Suma_sdo_peso_' || REPLACE(fecha, '-', '_') AS column_expression
FROM unique_dates;

-- Unir las expresiones de las columnas en una sola cadena
CREATE OR REPLACE TEMP VIEW sandbox.ganafinanciero.dynamic_sql AS
SELECT concat_ws(', ', collect_list(column_expression)) AS columns
FROM date_columns;

-- Obtener la lista de columnas
SELECT columns FROM sandbox.ganafinanciero.dynamic_sql;

%python
# Obtener la lista de columnas desde SQL
columns = spark.sql("SELECT columns FROM sandbox.ganafinanciero.dynamic_sql").collect()[0][0]

# Construir y ejecutar la consulta final
query = f"""
SELECT codig, descripcion1, num_cta_sbif_mdr, moned, cent_resp, cod_producto, {columns}
FROM sandbox.ganafinanciero.base_data
GROUP BY codig, descripcion1, num_cta_sbif_mdr, moned, cent_resp, cod_producto
"""

result = spark.sql(query)
result.show()






-- 001_Plan_Cuentas_BSC = pc
-- 002_Saldos_Contables_BSC = sc
-- 002_Saldos_Contables_BSC tabla
TRANSFORM Sum(sc.sdo_peso) AS SumaDesdo_peso
SELECT 
sc.codig,                        
CStr([descripcion]) AS descripcion1,                     
pc.num_cta_sbif_mdr, 
sc.moned, 
pc.cent_resp, 
pc.cod_producto
FROM 001_Plan_Cuentas_BSC INNER JOIN 002_Saldos_Contables_BSC 
ON pc.cuenta = sc.codig
GROUP BY 
sc.codig, 
CStr([descripcion]), 
pc.num_cta_sbif_mdr, 
sc.moned, 
pc.cent_resp, 
pc.cod_producto
PIVOT sc.fecha;
