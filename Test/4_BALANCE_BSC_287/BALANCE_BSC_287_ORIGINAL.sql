-- 001_Plan_Ctas_Sbif_Sypcon
SELECT 
Left([NUM_CTA_SBIF_MDR],1) 
AS RUBRO, 
Left([CUENTA_SBIF],4) AS SBIF, 
"00000" & [CUENTA] AS CUENTA_15_, 
bu_syp_in_plancta_contab_fusion.CUENTA, 
bu_syp_in_plancta_contab_fusion.DESCRIPCION, 
bu_syp_in_plancta_contab_fusion.TIPO_CUENTA, 
bu_syp_in_plancta_contab_fusion.NUM_CTA_SBIF_MDR, 
bu_syp_in_plancta_contab_fusion.EST_CUENTA, 
bu_syp_in_plancta_contab_fusion.COD_REAJ, 
bu_syp_in_plancta_contab_fusion.COD_LINEA 
INTO Tabla_Plan_Ctas_Sbif_Sypcon
FROM bu_syp_in_plancta_contab_fusion
WHERE (((bu_syp_in_plancta_contab_fusion.TIPO_CUENTA)<>" ") AND ((bu_syp_in_plancta_contab_fusion.EST_CUENTA)="A"));

-- 002_Saldos_Ctas_Sypcon_Diaria
SELECT 
bu_syp_in_sdo_contab_fusion.SUCUR, 
bu_syp_in_sdo_contab_fusion.MONED, 
bu_syp_in_sdo_contab_fusion.TIPO_MONEDA, 
Left([NUM_CTA_SBIF_MDR],1) AS RUBRO_, 
Left([CUENTA_SBIF],4) AS SBIF, 
"00000" & [CUENTA] AS CUENTA15_, 
bu_syp_in_plancta_contab_fusion.CUENTA, 
bu_syp_in_plancta_contab_fusion.DESCRIPCION, 
bu_syp_in_sdo_contab_fusion.SDO_ORIG, 
bu_syp_in_sdo_contab_fusion.SDO_PESO, 
bu_syp_in_sdo_contab_fusion.PROM_PESO, 
bu_syp_in_sdo_contab_fusion.SDO_MES_PESO, 
bu_syp_in_sdo_contab_fusion.PROM_ANUAL_PESO, 
bu_syp_in_sdo_contab_fusion.FECHA, 
bu_syp_in_plancta_contab_fusion.NUM_CTA_SBIF_MDR, 
bu_syp_in_plancta_contab_fusion.CUENTA_SBIF, 
bu_syp_in_plancta_contab_fusion.COD_REAJ, 
Left([NUM_CTA_SBIF_MDR],5) AS MB2 
INTO Tabla_Saldos_Ctas_Sypcon
FROM bu_syp_in_plancta_contab_fusion INNER JOIN bu_syp_in_sdo_contab_fusion 
ON bu_syp_in_plancta_contab_fusion.cuenta = bu_syp_in_sdo_contab_fusion.codig
WHERE (((bu_syp_in_sdo_contab_fusion.SUCUR)=9999) AND ((bu_syp_in_sdo_contab_fusion.FECHA)=[Ingrese Fecha:]));

-- 002_Saldos_Ctas_Sypcon_Historica
SELECT 
bu_syp_in_hist_sdo_contab_fusion.SUCUR, 
bu_syp_in_hist_sdo_contab_fusion.MONED, 
bu_syp_in_hist_sdo_contab_fusion.TIPO_MONEDA, 
Left([NUM_CTA_SBIF_MDR],1) AS RUBRO_, 
Left([CUENTA_SBIF],4) AS SBIF, 
"00000" & [CUENTA] AS CUENTA15_, 
bu_syp_in_plancta_contab_fusion.COD_REAJ, 
bu_syp_in_hist_sdo_contab_fusion.SDO_ORIG, 
bu_syp_in_plancta_contab_fusion.CUENTA, 
bu_syp_in_plancta_contab_fusion.DESCRIPCION, 
bu_syp_in_hist_sdo_contab_fusion.SDO_PESO, 
bu_syp_in_hist_sdo_contab_fusion.PROM_PESO, 
bu_syp_in_hist_sdo_contab_fusion.SDO_MES_PESO, 
bu_syp_in_hist_sdo_contab_fusion.PROM_ANUAL_PESO, 
bu_syp_in_hist_sdo_contab_fusion.FECHA, 
Left([NUM_CTA_SBIF_MDR],5) AS MB2, 
bu_syp_in_plancta_contab_fusion.NUM_CTA_SBIF_MDR, 
bu_syp_in_hist_sdo_contab_fusion.DATA_DATE_PART 
INTO Tabla_Saldos_Ctas_Sypcon
FROM bu_syp_in_hist_sdo_contab_fusion LEFT JOIN bu_syp_in_plancta_contab_fusion 
ON bu_syp_in_hist_sdo_contab_fusion.CODIG = bu_syp_in_plancta_contab_fusion.CUENTA
WHERE (((bu_syp_in_hist_sdo_contab_fusion.SUCUR)=9999) AND ((bu_syp_in_hist_sdo_contab_fusion.FECHA)=[Ingrese fecha :]) AND ((bu_syp_in_hist_sdo_contab_fusion.DATA_DATE_PART)=[Ingrese data :]));

-- 009_Datos_Cuentas_Sypcon
SELECT 
Tabla_Saldos_Ctas_Sypcon.SUCUR, 
Tabla_Saldos_Ctas_Sypcon.MONED, 
Tabla_Saldos_Ctas_Sypcon.TIPO_MONEDA, 
Tabla_Saldos_Ctas_Sypcon.CUENTA, 
Tabla_Saldos_Ctas_Sypcon.DESCRIPCION, 
Tabla_Saldos_Ctas_Sypcon.SDO_PESO, 
Tabla_Saldos_Ctas_Sypcon.PROM_ANUAL_PESO, 
Tabla_Saldos_Ctas_Sypcon.FECHA
FROM Tabla_Saldos_Ctas_Sypcon;

-- 010_Detalle_Sypcon_Sbif_MDR
SELECT 
Tabla_Plan_Ctas_Sbif_Sypcon.RUBRO, 
Tabla_Sbif_Detalle_Mtx.Sbif_Detalle_, 
Tabla_Sbif_Detalle_Mtx.Descripcion_Sbif_Detalle_, 
Tabla_Plan_Ctas_Sbif_Sypcon.CUENTA, 
Tabla_Plan_Ctas_Sbif_Sypcon.DESCRIPCION, 
Sum(Tabla_Saldos_Ctas_Sypcon.SDO_PESO) AS SumaDeSDO_PESO, 
Sum(Tabla_Saldos_Ctas_Sypcon.PROM_PESO) AS SumaDePROM_PESO, 
Sum(Tabla_Saldos_Ctas_Sypcon.SDO_MES_PESO) AS SumaDeSDO_MES_PESO, 
Sum(Tabla_Saldos_Ctas_Sypcon.PROM_ANUAL_PESO) AS SumaDePROM_ANUAL_PESO, 
Tabla_Plan_Ctas_Sbif_Sypcon.COD_REAJ, 
Tabla_Saldos_Ctas_Sypcon.FECHA
FROM (Tabla_Plan_Ctas_Sbif_Sypcon RIGHT JOIN Tabla_Saldos_Ctas_Sypcon 
ON Tabla_Plan_Ctas_Sbif_Sypcon.CUENTA = Tabla_Saldos_Ctas_Sypcon.CUENTA) 
    LEFT JOIN Tabla_Sbif_Detalle_Mtx 
        ON Tabla_Saldos_Ctas_Sypcon.NUM_CTA_SBIF_MDR = Tabla_Sbif_Detalle_Mtx.Sbif_Detalle_
GROUP BY Tabla_Plan_Ctas_Sbif_Sypcon.RUBRO, Tabla_Sbif_Detalle_Mtx.Sbif_Detalle_, Tabla_Sbif_Detalle_Mtx.Descripcion_Sbif_Detalle_, Tabla_Plan_Ctas_Sbif_Sypcon.CUENTA, Tabla_Plan_Ctas_Sbif_Sypcon.DESCRIPCION, Tabla_Plan_Ctas_Sbif_Sypcon.COD_REAJ, Tabla_Saldos_Ctas_Sypcon.FECHA;


-- 011_Cuadre_Sypcon_Sbif_MDR_Total
SELECT 
Tabla_NUM_CTA_SBIF_MDR.DESCRIPCION, 
Tabla_NUM_CTA_SBIF_MDR.RUBRO, 
Sum(([SumaDeSDO_PESO])) AS SDO_PESO_, 
Sum(([SumaDePROM_PESO])) AS PROM_PESO_, 
Sum(([SumaDeSDO_MES_PESO])) AS SDO_MES_PESO_, 
Sum(([SumaDePROM_ANUAL_PESO])) AS PROM_ANUAL_PESO_, 
[010_Detalle_Sypcon_Sbif_MDR].FECHA
FROM 010_Detalle_Sypcon_Sbif_MDR INNER JOIN Tabla_NUM_CTA_SBIF_MDR 
ON [010_Detalle_Sypcon_Sbif_MDR].RUBRO = Tabla_NUM_CTA_SBIF_MDR.RUBRO
GROUP BY 
Tabla_NUM_CTA_SBIF_MDR.DESCRIPCION, 
Tabla_NUM_CTA_SBIF_MDR.RUBRO, 
[010_Detalle_Sypcon_Sbif_MDR].FECHA
ORDER BY Tabla_NUM_CTA_SBIF_MDR.RUBRO;

-- 013_Cuentas_Activos_Sbif_MDR
SELECT 
[010_Detalle_Sypcon_Sbif_MDR].RUBRO, 
[010_Detalle_Sypcon_Sbif_MDR].Sbif_Detalle_, 
[010_Detalle_Sypcon_Sbif_MDR].Descripcion_Sbif_Detalle_, 
[010_Detalle_Sypcon_Sbif_MDR].CUENTA, 
[010_Detalle_Sypcon_Sbif_MDR].DESCRIPCION, 
[010_Detalle_Sypcon_Sbif_MDR].SumaDeSDO_PESO AS SDO_PESO_, 
[010_Detalle_Sypcon_Sbif_MDR].SumaDePROM_PESO AS PROM_PESO_, 
[010_Detalle_Sypcon_Sbif_MDR].SumaDeSDO_MES_PESO AS SDO_MES_PESO_, 
[010_Detalle_Sypcon_Sbif_MDR].SumaDePROM_ANUAL_PESO AS PROM_ANUAL_PESO_, 
[010_Detalle_Sypcon_Sbif_MDR].FECHA
FROM 010_Detalle_Sypcon_Sbif_MDR
WHERE ((([010_Detalle_Sypcon_Sbif_MDR].RUBRO)="1"));

-- 0014_Cuentas_Pasivos_Sbif_MDR
SELECT 
[010_Detalle_Sypcon_Sbif_MDR].RUBRO, 
[010_Detalle_Sypcon_Sbif_MDR].Sbif_Detalle_, 
[010_Detalle_Sypcon_Sbif_MDR].Descripcion_Sbif_Detalle_, 
[010_Detalle_Sypcon_Sbif_MDR].CUENTA, 
[010_Detalle_Sypcon_Sbif_MDR].DESCRIPCION, 
[010_Detalle_Sypcon_Sbif_MDR].SumaDeSDO_PESO AS SDO_PESO_, 
[010_Detalle_Sypcon_Sbif_MDR].SumaDePROM_PESO AS PROM_PESO_, 
[010_Detalle_Sypcon_Sbif_MDR].SumaDeSDO_MES_PESO AS SDO_MES_PESO_, 
[010_Detalle_Sypcon_Sbif_MDR].SumaDePROM_ANUAL_PESO AS PROM_ANUAL_PESO_, 
[010_Detalle_Sypcon_Sbif_MDR].FECHA
FROM 010_Detalle_Sypcon_Sbif_MDR
WHERE ((([010_Detalle_Sypcon_Sbif_MDR].RUBRO)="2"));


-- 015_Cuentas_Capital_y_Reservas_Sbif_MDR
SELECT 
[010_Detalle_Sypcon_Sbif_MDR].RUBRO, 
[010_Detalle_Sypcon_Sbif_MDR].Sbif_Detalle_, 
[010_Detalle_Sypcon_Sbif_MDR].Descripcion_Sbif_Detalle_, 
[010_Detalle_Sypcon_Sbif_MDR].CUENTA, 
[010_Detalle_Sypcon_Sbif_MDR].DESCRIPCION, 
[010_Detalle_Sypcon_Sbif_MDR].SumaDeSDO_PESO AS SDO_PESO_, 
[010_Detalle_Sypcon_Sbif_MDR].SumaDePROM_PESO AS PROM_PESO_, 
[010_Detalle_Sypcon_Sbif_MDR].SumaDeSDO_MES_PESO AS SDO_MES_PESO_, 
[010_Detalle_Sypcon_Sbif_MDR].SumaDePROM_ANUAL_PESO AS PROM_ANUAL_PESO_, 
[010_Detalle_Sypcon_Sbif_MDR].FECHA
FROM 010_Detalle_Sypcon_Sbif_MDR
WHERE ((([010_Detalle_Sypcon_Sbif_MDR].RUBRO)="3"));


-- 016_Cuentas_Resultados_Sbif_MDR
SELECT 
[010_Detalle_Sypcon_Sbif_MDR].RUBRO, 
[010_Detalle_Sypcon_Sbif_MDR].Sbif_Detalle_, 
[010_Detalle_Sypcon_Sbif_MDR].Descripcion_Sbif_Detalle_, 
[010_Detalle_Sypcon_Sbif_MDR].CUENTA, 
[010_Detalle_Sypcon_Sbif_MDR].DESCRIPCION, 
[010_Detalle_Sypcon_Sbif_MDR].SumaDeSDO_PESO AS SDO_PESO_, 
[010_Detalle_Sypcon_Sbif_MDR].SumaDePROM_PESO AS PROM_PESO_, 
[010_Detalle_Sypcon_Sbif_MDR].SumaDeSDO_MES_PESO AS SDO_MES_PESO_, 
[010_Detalle_Sypcon_Sbif_MDR].SumaDePROM_ANUAL_PESO AS PROM_ANUAL_PESO_, 
[010_Detalle_Sypcon_Sbif_MDR].FECHA
FROM 010_Detalle_Sypcon_Sbif_MDR
WHERE ((([010_Detalle_Sypcon_Sbif_MDR].RUBRO)="4"));


-- 017_Cuentas_Orden_Sbif_MDR
SELECT 
[010_Detalle_Sypcon_Sbif_MDR].RUBRO, 
[010_Detalle_Sypcon_Sbif_MDR].Sbif_Detalle_, 
[010_Detalle_Sypcon_Sbif_MDR].Descripcion_Sbif_Detalle_, 
[010_Detalle_Sypcon_Sbif_MDR].CUENTA, 
[010_Detalle_Sypcon_Sbif_MDR].DESCRIPCION, 
[010_Detalle_Sypcon_Sbif_MDR].SumaDeSDO_PESO AS SDO_PESO_, 
[010_Detalle_Sypcon_Sbif_MDR].SumaDePROM_PESO AS PROM_PESO_, 
[010_Detalle_Sypcon_Sbif_MDR].SumaDeSDO_MES_PESO AS SDO_MES_PESO_, 
[010_Detalle_Sypcon_Sbif_MDR].SumaDePROM_ANUAL_PESO AS PROM_ANUAL_PESO_, 
[010_Detalle_Sypcon_Sbif_MDR].FECHA
FROM 010_Detalle_Sypcon_Sbif_MDR
WHERE ((([010_Detalle_Sypcon_Sbif_MDR].RUBRO)="8" Or ([010_Detalle_Sypcon_Sbif_MDR].RUBRO)="9"));


-- 018_Cuentas_Sin_Codigo_Sbif_MDR
SELECT 
[010_Detalle_Sypcon_Sbif_MDR].RUBRO, 
[010_Detalle_Sypcon_Sbif_MDR].Sbif_Detalle_, 
[010_Detalle_Sypcon_Sbif_MDR].Descripcion_Sbif_Detalle_, 
[010_Detalle_Sypcon_Sbif_MDR].CUENTA, 
[010_Detalle_Sypcon_Sbif_MDR].DESCRIPCION, 
[010_Detalle_Sypcon_Sbif_MDR].SumaDeSDO_PESO AS SDO_PESO_, 
[010_Detalle_Sypcon_Sbif_MDR].SumaDePROM_PESO AS PROM_PESO_, 
[010_Detalle_Sypcon_Sbif_MDR].SumaDeSDO_MES_PESO AS SDO_MES_PESO_, 
[010_Detalle_Sypcon_Sbif_MDR].SumaDePROM_ANUAL_PESO AS PROM_ANUAL_PESO_, 
[010_Detalle_Sypcon_Sbif_MDR].FECHA
FROM 010_Detalle_Sypcon_Sbif_MDR
WHERE ((([010_Detalle_Sypcon_Sbif_MDR].RUBRO)="0"));


-- 100_287_Formato_Balance_SBIF_Detalle
SELECT 
Tabla_Saldos_Ctas_Sypcon.NUM_CTA_SBIF_MDR, 
Tabla_Sbif_Detalle_Mtx.Descripcion_Sbif_Detalle_ AS DESCRIPCION_NUM_CTA_SBIF_MDR, 
Tabla_Saldos_Ctas_Sypcon.CUENTA, 
Tabla_Saldos_Ctas_Sypcon.DESCRIPCION, 
Tabla_Saldos_Ctas_Sypcon.SDO_PESO, 
Tabla_Saldos_Ctas_Sypcon.SDO_ORIG, 
Tabla_Saldos_Ctas_Sypcon.FECHA, 
Tabla_Saldos_Ctas_Sypcon.MONED, 
Tabla_Saldos_Ctas_Sypcon.COD_REAJ, 
Tabla_Saldos_Ctas_Sypcon.MB2
FROM Tabla_Saldos_Ctas_Sypcon LEFT JOIN Tabla_Sbif_Detalle_Mtx 
    ON Tabla_Saldos_Ctas_Sypcon.NUM_CTA_SBIF_MDR = Tabla_Sbif_Detalle_Mtx.Sbif_Detalle_
ORDER BY Tabla_Saldos_Ctas_Sypcon.CUENTA;


-- 200_Promedios_Balance_SBIF_Detalle
SELECT 
Tabla_Saldos_Ctas_Sypcon.CUENTA, 
Tabla_Saldos_Ctas_Sypcon.DESCRIPCION, 
Tabla_Saldos_Ctas_Sypcon.NUM_CTA_SBIF_MDR, 
Sum(Tabla_Saldos_Ctas_Sypcon.PROM_ANUAL_PESO) AS SumaDePROM_ANUAL_PESO, 
Tabla_Saldos_Ctas_Sypcon.FECHA
FROM Tabla_Saldos_Ctas_Sypcon LEFT JOIN Tabla_Sbif_Detalle_Mtx 
    ON Tabla_Saldos_Ctas_Sypcon.NUM_CTA_SBIF_MDR = Tabla_Sbif_Detalle_Mtx.Sbif_Detalle_
GROUP BY 
Tabla_Saldos_Ctas_Sypcon.CUENTA, 
Tabla_Saldos_Ctas_Sypcon.DESCRIPCION, 
Tabla_Saldos_Ctas_Sypcon.NUM_CTA_SBIF_MDR, 
Tabla_Saldos_Ctas_Sypcon.FECHA
HAVING (((Tabla_Saldos_Ctas_Sypcon.FECHA)=20160131))
ORDER BY Tabla_Saldos_Ctas_Sypcon.CUENTA;
