-- 001_Crea_Plan_Cuentas_BSC
CREATE TABLE 001_Plan_Cuentas_BSC AS
SELECT 
    empresa,
    cuenta,
    descripcion,
    cod_reaj,
    tipo_moneda,
    cent_resp,
    num_cta_sbif_mdr,
    cod_producto
FROM bu_syp_in_plancta_contab_fusion;

-- 002_Crea_Saldos_Diarios_BSC
CREATE TABLE 002_Saldos_Contables_BSC AS
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
FROM bu_syp_in_sdo_contab_fusion
WHERE sucur = 9999 AND fecha = ${val};

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
FROM 001_Plan_Cuentas_BSC AS a
INNER JOIN 002_Saldos_Contables_BSC AS b
ON a.cuenta =

CREATE TABLE 004_700_Base_MBMRMC AS
SELECT 
    LEFT(num_cta_sbif_mdr, 1) AS Clase,
    num_cta_sbif_mdr,
    cuenta,
    descripcion,
    tipo_moneda,
    cod_reaj,
    sdo_peso,
    fecha
FROM 001_Plan_Cuentas_BSC AS a
INNER JOIN 002_Saldos_Contables_BSC AS b
ON a.cuenta = b.codig;

CREATE TABLE 005_701_MB AS
SELECT 
    Clase,
    num_cta_sbif_mdr,
    cuenta,
    descripcion,
    tipo_moneda,
    cod_reaj,
    CASE WHEN Clase <> '1' THEN sdo_peso * -1 ELSE sdo_peso END AS Importe,
    fecha
FROM 004_700_Base_MBMRMC
WHERE Clase IN ('1', '2', '3');

-- 006_702_MR
CREATE TABLE 006_702_MR AS
SELECT 
    Clase,
    num_cta_sbif_mdr,
    cuenta,
    descripcion,
    tipo_moneda,
    cod_reaj,
    sdo_peso * -1 AS Importe,
    fecha
FROM 004_700_Base_MBMRMC
WHERE Clase = '4';


-- 007_703_MC
CREATE TABLE 007_703_MC AS
SELECT 
    Clase,
    num_cta_sbif_mdr,
    cuenta,
    descripcion,
    tipo_moneda,
    cod_reaj,
    sdo_peso * -1 AS Importe,
    fecha
FROM 004_700_Base_MBMRMC
WHERE Clase IN ('8', '9');


-- 008_Agrupador_moneda
CREATE TABLE 008_Agrupador_moneda AS
SELECT 
    Clase,
    num_cta_sbif_mdr,
    cuenta,
    descripcion,
    tipo_moneda,
    cod_reaj,
    Importe,
    fecha,
    CONCAT(tipo_moneda, '_', cod_reaj) AS Agrupador_mon
FROM 001_700_MBMRMC;


-- 009_Agrupador_glsa_moneda
CREATE TABLE 009_Agrupador_glsa_moneda AS
SELECT 
    a.num_cta_sbif_mdr,
    a.cuenta,
    a.descripcion,
    a.tipo_moneda,
    a.cod_reaj,
    COALESCE(a.Importe, 0) AS Sdo_Acum,
    a.fecha,
    a.Agrupador_mon,
    b.Glsa_moneda
FROM 008_Agrupador_moneda AS a
INNER JOIN 003_Agrupador_Moneda AS b
ON a.Agrupador_mon = b.Moneda;


-- 010_Genera_Interfaz_Def
CREATE TABLE 010_Genera_Interfaz_Def AS
SELECT 
    num_cta_sbif_mdr AS Cod_CMF,
    ABS(COALESCE(Total, 0)) AS 0,
    CASE WHEN Total > 0 THEN '+' ELSE '-' END AS 0_0,
    ABS(COALESCE([01_No Reajustable], 0)) AS 1,
    CASE WHEN [01_No Reajustable] > 0 THEN '+' ELSE '-' END AS 1_0,
    ABS(COALESCE([02_Reajustable IPC], 0)) AS 2,
    CASE WHEN [02_Reajustable IPC] > 0 THEN '+' ELSE '-' END AS 2_0,
    ABS(COALESCE([03_Reajustable TC], 0)) AS 3,
    CASE WHEN [03_Reajustable TC] > 0 THEN '+' ELSE '-' END AS 3_0,
    ABS(COALESCE([04_Equivalente], 0)) AS 4,
    CASE WHEN [04_Equivalente] > 0 THEN '+' ELSE '-' END AS 4_0
FROM 001_Crea_Interfaz;


CREATE TABLE 001_Crea_Interfaz AS
SELECT 
    num_cta_sbif_mdr,
    SUM(Sdo_Acum) AS Total
FROM 009_Agrupador_glsa_moneda
WHERE num_cta_sbif_mdr <> 0
GROUP BY num_cta_sbif_mdr
PIVOT Glsa_moneda
TRANSFORM SUM(Sdo_Acum);


-- 001_700_MBMRMC
CREATE TABLE 001_700_MBMRMC AS
SELECT 
    Clase,
    num_cta_sbif_mdr,
    cuenta,
    descripcion,
    tipo_moneda,
    cod_reaj,
    Importe,
    fecha
FROM 005_701_MB
UNION ALL
SELECT 
    Clase,
    num_cta_sbif_mdr,
    cuenta,
    descripcion,
    tipo_moneda,
    cod_reaj,
    Importe,
    fecha
FROM 006_702_MR
UNION ALL
SELECT 
    Clase,
    num_cta_sbif_mdr,
    cuenta,
    descripcion,
    tipo_moneda,
    cod_reaj,
    

