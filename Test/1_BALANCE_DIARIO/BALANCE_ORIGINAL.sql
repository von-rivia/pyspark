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
SELECT 
[001_Plan_Cuentas_BSC].cuenta, 
[001_Plan_Cuentas_BSC].descripcion, 
[001_Plan_Cuentas_BSC].num_cta_sbif_mdr, 
[002_Saldos_Contables_BSC].fecha, 
[002_Saldos_Contables_BSC].sdo_mes_peso, 
[002_Saldos_Contables_BSC].sdo_peso, 
[002_Saldos_Contables_BSC].sdo_mes_orig, 
[002_Saldos_Contables_BSC].sdo_orig, 
[001_Plan_Cuentas_BSC].cent_resp, 
[001_Plan_Cuentas_BSC].cod_producto, 
[002_Saldos_Contables_BSC].sucur, 
[001_Plan_Cuentas_BSC].cod_reaj, 
[002_Saldos_Contables_BSC].moned
FROM 001_Plan_Cuentas_BSC 
INNER JOIN 002_Saldos_Contables_BSC 
    ON [001_Plan_Cuentas_BSC].cuenta = [002_Saldos_Contables_BSC].codig;

-- 004_700_Base_MBMRMC
SELECT 
Left([num_cta_sbif_mdr],1) AS Clase, 
[001_Plan_Cuentas_BSC].num_cta_sbif_mdr, 
[001_Plan_Cuentas_BSC].cuenta, 
[001_Plan_Cuentas_BSC].descripcion, 
[001_Plan_Cuentas_BSC].tipo_moneda, 
[001_Plan_Cuentas_BSC].cod_reaj, 
[002_Saldos_Contables_BSC].sdo_peso, 
[002_Saldos_Contables_BSC].fecha
FROM 001_Plan_Cuentas_BSC INNER JOIN 002_Saldos_Contables_BSC 
    ON [001_Plan_Cuentas_BSC].cuenta = [002_Saldos_Contables_BSC].codig;

-- 005_701_MB
SELECT 
[004_700_Base_MBMRMC].Clase, 
[004_700_Base_MBMRMC].num_cta_sbif_mdr, 
[004_700_Base_MBMRMC].cuenta, 
[004_700_Base_MBMRMC].descripcion, 
[004_700_Base_MBMRMC].tipo_moneda, 
[004_700_Base_MBMRMC].cod_reaj, 
IIf([Clase]<>1,[sdo_peso]*-1,[sdo_peso]) AS Importe, 
[004_700_Base_MBMRMC].fecha
FROM 004_700_Base_MBMRMC
WHERE ((([004_700_Base_MBMRMC].Clase)="1" Or ([004_700_Base_MBMRMC].Clase)="2" Or ([004_700_Base_MBMRMC].Clase)="3"));

-- 006_702_MR
SELECT 
[004_700_Base_MBMRMC].Clase, 
[004_700_Base_MBMRMC].num_cta_sbif_mdr, 
[004_700_Base_MBMRMC].cuenta, [004_700_Base_MBMRMC].descripcion, 
[004_700_Base_MBMRMC].tipo_moneda, 
[004_700_Base_MBMRMC].cod_reaj, 
[sdo_peso]*-1 AS Importe, 
[004_700_Base_MBMRMC].fecha
FROM 004_700_Base_MBMRMC
WHERE ((([004_700_Base_MBMRMC].Clase)="4"));

-- 007_703_MC
SELECT 
[004_700_Base_MBMRMC].Clase, 
[004_700_Base_MBMRMC].num_cta_sbif_mdr, 
[004_700_Base_MBMRMC].cuenta, 
[004_700_Base_MBMRMC].descripcion, 
[004_700_Base_MBMRMC].tipo_moneda, 
[004_700_Base_MBMRMC].cod_reaj, 
[sdo_peso]*-1 AS Importe, 
[004_700_Base_MBMRMC].fecha
FROM 004_700_Base_MBMRMC
WHERE ((([004_700_Base_MBMRMC].Clase)="9" Or ([004_700_Base_MBMRMC].Clase)="8"));

-- 008_Agrupador_moneda
SELECT 
[001_700_MBMRMC].Clase, 
[001_700_MBMRMC].num_cta_sbif_mdr, 
[001_700_MBMRMC].cuenta, 
[001_700_MBMRMC].descripcion, 
[001_700_MBMRMC].tipo_moneda, 
[001_700_MBMRMC].cod_reaj, 
[001_700_MBMRMC].Importe, 
[001_700_MBMRMC].fecha, 
[tipo_moneda] & "_" & [cod_reaj] AS Agrupador_mon
FROM 001_700_MBMRMC;


-- 009_Agrupador_glsa_moneda
SELECT 
[008_Agrupador_moneda].num_cta_sbif_mdr, 
[008_Agrupador_moneda].cuenta, [008_Agrupador_moneda].descripcion, 
[008_Agrupador_moneda].tipo_moneda, 
[008_Agrupador_moneda].cod_reaj, 
IIf([Importe] Is Null,0,[Importe]) AS Sdo_Acum, 
[008_Agrupador_moneda].fecha, 
[008_Agrupador_moneda].Agrupador_mon, 
[003_Agrupador_Moneda].Glsa_moneda
FROM 008_Agrupador_moneda INNER JOIN 003_Agrupador_Moneda 
    ON [008_Agrupador_moneda].Agrupador_mon = [003_Agrupador_Moneda].Moneda;

-- 010_Genera_Interfaz_Def
SELECT 
([num_cta_sbif_mdr]) AS Cod_CMF, 
Abs(IIf([Total] Is Null,0,[Total])) AS 0, 
IIf([Total]>0,"+","-") AS 0_0, 
Abs(IIf([01_No Reajustable] Is Null,0,[01_No Reajustable])) AS 1, 
IIf([01_No Reajustable]>0,"+","-") AS 1_0, 
Abs(IIf([02_Reajustable IPC] Is Null,0,[02_Reajustable IPC])) AS 2, 
IIf([02_Reajustable IPC]>0,"+","-") AS 2_0, 
Abs(IIf([03_Reajustable TC] Is Null,0,[03_Reajustable TC])) AS 3, 
IIf([03_Reajustable TC]>0,"+","-") AS 3_0, 
Abs(IIf([04_Equivalente] Is Null,0,[04_Equivalente])) AS 4, 
IIf([04_Equivalente]>0,"+","-") AS 4_0
FROM 001_Crea_Interfaz;


-- 001_Crea_Interfaz
TRANSFORM Sum([009_Agrupador_glsa_moneda].Sdo_Acum) AS SumaDeSdo_Acum
SELECT 
[009_Agrupador_glsa_moneda].num_cta_sbif_mdr, 
Sum([009_Agrupador_glsa_moneda].Sdo_Acum) AS Total
FROM 009_Agrupador_glsa_moneda
WHERE ((([009_Agrupador_glsa_moneda].num_cta_sbif_mdr)<>0))
GROUP BY [009_Agrupador_glsa_moneda].num_cta_sbif_mdr
PIVOT [009_Agrupador_glsa_moneda].Glsa_moneda;


-- 001_700_MBMRC
SELECT 
Clase,num_cta_sbif_mdr, 
cuenta, 
descripcion, 
tipo_moneda, 
cod_reaj, 
[Importe], 
fecha
FROM 005_701_MB  UNION 
SELECT 
Clase, 
num_cta_sbif_mdr, 
cuenta, descripcion, 
tipo_moneda, cod_reaj, 
[Importe], 
fecha
FROM 006_702_MR  UNION 
SELECT 
Clase, 
num_cta_sbif_mdr, 
cuenta, 
descripcion, 
tipo_moneda, cod_reaj, 
[Importe], 
fecha
FROM 007_703_MC;



