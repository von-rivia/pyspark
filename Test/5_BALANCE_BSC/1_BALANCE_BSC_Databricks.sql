-- 001_Crea_Plan_Cuentas_BSC
SELECT 
bu_syp_in_plancta_contab_fusion.empresa, 
bu_syp_in_plancta_contab_fusion.cuenta, 
bu_syp_in_plancta_contab_fusion.descripcion, 
bu_syp_in_plancta_contab_fusion.cod_reaj, 
bu_syp_in_plancta_contab_fusion.tipo_moneda, 
bu_syp_in_plancta_contab_fusion.cent_resp, 
bu_syp_in_plancta_contab_fusion.num_cta_sbif_mdr, 
bu_syp_in_plancta_contab_fusion.cod_producto 
INTO 001_Plan_Cuentas_BSC
FROM bu_syp_in_plancta_contab_fusion;



-- 002_Crea_Saldos_Diarios_BSC
SELECT 
bu_syp_in_sdo_contab_fusion.empresa, 
bu_syp_in_sdo_contab_fusion.sucur, 
bu_syp_in_sdo_contab_fusion.moned, 
bu_syp_in_sdo_contab_fusion.codig, 
bu_syp_in_sdo_contab_fusion.fecha, 
bu_syp_in_sdo_contab_fusion.tipo_moneda, 
bu_syp_in_sdo_contab_fusion.sdo_orig, 
bu_syp_in_sdo_contab_fusion.sdo_peso, 
bu_syp_in_sdo_contab_fusion.prom_orig, 
bu_syp_in_sdo_contab_fusion.prom_peso, 
bu_syp_in_sdo_contab_fusion.sdo_mes_orig, 
bu_syp_in_sdo_contab_fusion.sdo_mes_peso, 
bu_syp_in_sdo_contab_fusion.prom_anual_orig, 
bu_syp_in_sdo_contab_fusion.prom_anual_peso 
INTO 002_Saldos_Contables_BSC
FROM bu_syp_in_sdo_contab_fusion
WHERE (((bu_syp_in_sdo_contab_fusion.sucur)=9999) AND ((bu_syp_in_sdo_contab_fusion.fecha)=[val]));


-- 003_Detalle_Contable_BSC
CREATE TABLE 003_Detalle_Contable_BSC AS
SELECT 
  a.cuenta, 
  a.descripcion, 
  a.num_cta_sbif_mdr, 
  b.fecha, 
  b.sdo_mes_peso, 
  b.sdo_peso, 
  b.sdo_mes_orig, 
  b.sdo_orig, 
  a.cent_resp, 
  a.cod_producto, 
  b.sucur, 
  a.cod_reaj, 
  b.moned
FROM 001_Plan_Cuentas_BSC a
INNER JOIN 002_Saldos_Contables_BSC b
ON a.cuenta = b.codig;

-- 004_700_MBMRMC
CREATE TABLE 004_700_MBMRMC AS
SELECT 
  LEFT(num_cta_sbif_mdr, 1) AS Clase, 
  a.num_cta_sbif_mdr, 
  a.cuenta, 
  a.descripcion, 
  a.tipo_moneda, 
  a.cod_reaj, 
  b.sdo_peso, 
  b.fecha
FROM 001_Plan_Cuentas_BSC a
INNER JOIN 002_Saldos_Contables_BSC b
ON a.cuenta = b.codig;

-- 005_701_MB
CREATE TABLE 005_701_MB AS
SELECT 
  Clase AS Expr1, 
  num_cta_sbif_mdr AS Expr2, 
  cuenta AS Expr3, 
  descripcion AS Expr4, 
  tipo_moneda AS Expr5, 
  cod_reaj AS Expr6, 
  CASE WHEN Clase <> 1 THEN sdo_peso * -1 
    ELSE sdo_peso 
  END AS Importe, 
  fecha AS Expr7
FROM 004_700_MBMRMC
WHERE Clase IN ('1', '2', '3');

-- 006_702_MR
CREATE TABLE 006_702_MR AS
SELECT 
  Clase AS Expr1, 
  num_cta_sbif_mdr AS Expr2, 
  cuenta AS Expr3, 
  descripcion AS Expr4, 
  tipo_moneda AS Expr5, 
  cod_reaj AS Expr6, 
  sdo_peso * -1 AS Importe, 
  fecha AS Expr7
FROM 004_700_MBMRMC
WHERE Clase = '4';

-- 007_703_MC
CREATE TABLE 007_703_MC AS
SELECT 
  Clase AS Expr1, 
  num_cta_sbif_mdr AS Expr2, 
  cuenta AS Expr3, 
  descripcion AS Expr4, 
  tipo_moneda AS Expr5, 
  cod_reaj AS Expr6, 
  sdo_peso * -1 AS Importe, 
  fecha AS Expr7
FROM 004_700_MBMRMC
WHERE Clase IN ('8', '9');

-- 008_Agrupador_moneda
CREATE TABLE 008_Agrupador_moneda AS
SELECT 
  Clase AS Expr1, 
  num_cta_sbif_mdr AS Expr2, 
  cuenta AS Expr3, 
  descripcion AS Expr4, 
  tipo_moneda AS Expr5, 
  cod_reaj AS Expr6, 
  Importe AS Expr7, 
  fecha AS Expr8, 
  CONCAT(tipo_moneda, '_', cod_reaj) AS Agrupador_mon
FROM 001_700_MBMRMC;

-- 009_Agrupador_glsa_moneda
SELECT 
CREATE TABLE 009_Agrupador_glsa_moneda AS
SELECT 
  a.num_cta_sbif_mdr, 
  a.cuenta, 
  a.descripcion, 
  a.tipo_moneda, 
  a.cod_reaj, 
  IFNULL(Importe, 0) AS Sdo_Acum, 
  a.fecha, 
  a.Agrupador_mon, 
  b.Glsa_moneda
FROM 008_Agrupador_moneda a
INNER JOIN 003_Agrupador_Moneda b
ON a.Agrupador_mon = b.Moneda;

-- 010_Genera_Interfaz_Def
CREATE TABLE 010_Genera_Interfaz_Def AS
SELECT 
  num_cta_sbif_mdr AS Cod_CMF, 
  ABS(IFNULL(Total, 0)) AS 0, 
  IF(Total > 0, '+', '-') AS 0_0, 
  ABS(IFNULL([01_No Reajustable], 0)) AS 1, 
  IF([01_No Reajustable] > 0, '+', '-') AS 1_0, 
  ABS(IFNULL([02_Reajustable IPC], 0)) AS 2, 
  IF([02_Reajustable IPC] > 0, '+', '-') AS 2_0, 
  ABS(IFNULL([03_Reajustable TC], 0)) AS 3, 
  IF([03_Reajustable TC] > 0, '+', '-') AS 3_0, 
  ABS(IFNULL([04_Equivalente], 0)) AS 4, 
  IF([04_Equivalente] > 0, '+', '-') AS 4_0
FROM 001_Crea_Interfaz;

-- 001_Crea_Interfaz
CREATE TABLE 001_Crea_Interfaz AS
SELECT 
  num_cta_sbif_mdr AS Expr1, 
  SUM(Sdo_Acum) AS Total, 
  Glsa_moneda
FROM 009_Agrupador_glsa_moneda
WHERE num_cta_sbif_mdr <> 0
GROUP BY num_cta_sbif_mdr, Glsa_moneda
PIVOT Glsa_moneda;

CREATE TABLE 001_700_MBMRMC AS
SELECT Clase, num_cta_sbif_mdr, cuenta, descripcion, tipo_moneda, cod_reaj, Importe, fecha
FROM 005_701_MB
UNION ALL
SELECT Clase, num_cta_sbif_mdr, cuenta, descripcion, tipo_moneda, cod_reaj, Importe, fecha
FROM 006_702_MR
UNION ALL
SELECT Clase, num_cta_sbif_mdr, cuenta, descripcion, tipo_moneda, cod_reaj, Importe, fecha
FROM 007_703_MC;



