from pyspark.sql import SparkSession

# Crear una sesión de Spark
spark = SparkSession.builder.appName("DynamicSQL").getOrCreate()

# Crear vistas
spark.sql("""
CREATE OR REPLACE VIEW informacional_prd.bu_syp_in.001_Plan_Cuentas_BSC AS
SELECT 
    empresa, 
    cuenta, 
    descripcion, 
    cod_reaj, 
    tipo_moneda, 
    cent_resp, 
    num_cta_sbif_mdr, 
    cod_producto
FROM informacional_prd.bu_syp_in.plancta_contab_fusion
""")

spark.sql("""
CREATE OR REPLACE VIEW informacional_prd.bu_syp_in.002_Saldos_Contables_BSC AS
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
FROM informacional_prd.bu_syp_in_sdo_contab_fusion
WHERE 
    sucur = 9999 
    AND fecha BETWEEN CURRENT_DATE - INTERVAL 30 DAY AND CURRENT_DATE
ORDER BY fecha
""")

# Obtener fechas únicas de la vista `002_Saldos_Contables_BSC`
df_fechas = spark.sql("SELECT DISTINCT fecha FROM informacional_prd.bu_syp_in.002_Saldos_Contables_BSC").collect()
fechas = [row.fecha for row in df_fechas]

# Crear statements dinámicos para cada fecha
case_statements = [
    f"SUM(CASE WHEN sc.fecha = '{fecha}' THEN sc.sdo_peso ELSE 0 END) AS Suma_sdo_peso_{fecha.replace('-', '_')}"
    for fecha in fechas
]
case_statements_str = ", ".join(case_statements)

# Construir la consulta completa
sql_query = f"""
SELECT 
    sc.codig, 
    CAST(sc.descripcion AS STRING) AS descripcion1, 
    pc.num_cta_sbif_mdr, 
    sc.moned, 
    pc.cent_resp, 
    pc.cod_producto, 
    {case_statements_str}
FROM informacional_prd.bu_syp_in.001_Plan_Cuentas_BSC pc
INNER JOIN informacional_prd.bu_syp_in.002_Saldos_Contables_BSC sc ON pc.cuenta = sc.codig
GROUP BY 
    sc.codig, 
    CAST(sc.descripcion AS STRING), 
    pc.num_cta_sbif_mdr, 
    sc.moned, 
    pc.cent_resp, 
    pc.cod_producto
"""

# Ejecutar la consulta dinámica
result_df = spark.sql(sql_query)

# Mostrar los resultados
result_df.show()