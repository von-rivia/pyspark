CREATE TABLE 001_Crea_Interfaz AS
SELECT 
  num_cta_sbif_mdr AS Expr1, 
  SUM(Sdo_Acum) AS Total, 
  Glsa_moneda
FROM 009_Agrupador_glsa_moneda
WHERE num_cta_sbif_mdr <> 0
GROUP BY num_cta_sbif_mdr, Glsa_moneda
PIVOT Glsa_moneda;

CREATE TABLE test_pivot AS
SELECT
    id,
    nombre,
    apellido,
    puesto,
    salario
FROM empleados
GROUP BY id, nombre
PIVOT fecha_contratacion



SELECT *
FROM (
  SELECT
    *
  FROM
    empleados
) AS source_table
PIVOT (
  nombre || " " || apellido FOR nombre IN ('María', 'Carlos', 'Juan', 'Ana')
) AS pivot_table
ORDER BY id;


from pyspark.sql import SparkSession

# Crear una sesión de Spark
spark = SparkSession.builder \
    .appName("ConsultaSQL") \
    .enableHiveSupport() \
    .getOrCreate()

# Ejecutar la consulta SQL y mostrar los resultados
test = spark.sql("SELECT * FROM informacional_prd.bu_syp_in.plancta_contab_fusion")
test.show()

# Parar la sesión de Spark
spark.stop()
