-- Crear tabla Plan de Cuentas
%sql
CREATE TABLE sandbox.ganafinanciero.001_Plan_Cuentas_BSC AS
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

-- Crear tabla Saldos Contables
%sql
CREATE TABLE sandbox.ganafinanciero.002_Saldos_Contables_BSC AS
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
WHERE sucur = 9999 
    AND fecha BETWEEN 20250101 AND 20250131
ORDER BY fecha;

-- Crear vista temporal base_data
%sql
CREATE OR REPLACE TEMP VIEW base_data AS
SELECT 
    sc.codig, 
    CAST(sc.descripcion AS STRING) AS descripcion1, 
    pc.num_cta_sbif_mdr, 
    sc.moned, 
    pc.cent_resp, 
    pc.cod_producto, 
    sc.fecha, 
    sc.sdo_peso
FROM sandbox.ganafinanciero.001_Plan_Cuentas_BSC pc
INNER JOIN sandbox.ganafinanciero.002_Saldos_Contables_BSC sc 
ON pc.cuenta = sc.codig;

-- Obtener las fechas únicas
%sql
CREATE OR REPLACE TEMP VIEW unique_dates AS
SELECT DISTINCT fecha
FROM base_data;

-- Crear una lista con las fechas únicas
%sql
CREATE OR REPLACE TEMP VIEW date_columns AS
SELECT 
    'SUM(CASE WHEN fecha = ''' || fecha || ''' THEN sdo_peso ELSE 0 END) AS Suma_sdo_peso_' || REPLACE(fecha, '-', '_') AS column_expression
FROM unique_dates;

-- Unir las expresiones de las columnas en una sola cadena
%sql
CREATE OR REPLACE TEMP VIEW dynamic_sql AS
SELECT concat_ws(', ', collect_list(column_expression)) AS columns
FROM date_columns;

-- Obtener la lista de columnas
%sql
SELECT columns FROM dynamic_sql;

# Obtener la lista de columnas desde SQL
columns = spark.sql("SELECT columns FROM dynamic_sql").collect()[0][0]

# Construir y ejecutar la consulta final
query = f"""
SELECT codig, descripcion1, num_cta_sbif_mdr, moned, cent_resp, cod_producto, {columns}
FROM base_data
GROUP BY codig, descripcion1, num_cta_sbif_mdr, moned, cent_resp, cod_producto
"""

result = spark.sql(query)
result.show()
