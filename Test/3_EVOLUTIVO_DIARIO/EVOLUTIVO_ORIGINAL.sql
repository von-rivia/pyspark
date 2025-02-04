-- 001_Crea_Plan_Cuentas_BSC
SELECT 
bu_syp_in_plancta_contab_fusion.empresa, 
bu_syp_in_plancta_contab_fusion.cuenta, 
bu_syp_in_plancta_contab_fusion.descripcion, 
bu_syp_in_plancta_contab_fusion.cod_reaj, 
bu_syp_in_plancta_contab_fusion.tipo_moneda, 
bu_syp_in_plancta_contab_fusion.cent_resp, 
bu_syp_in_plancta_contab_fusion.num_cta_sbif_mdr, 
bu_syp_in_plancta_contab_fusion.cod_producto INTO 001_Plan_Cuentas_BSC
FROM bu_syp_in_plancta_contab_fusion;

-- 002_Crea_Saldos_Contables_BSC
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
WHERE (((bu_syp_in_sdo_contab_fusion.sucur)=9999) 
    AND ((bu_syp_in_sdo_contab_fusion.fecha) BETWEEN 20250101 AND 20250131))
ORDER BY bu_syp_in_sdo_contab_fusion.fecha;

-- 002_Saldos_Contables_BSC tabla
TRANSFORM Sum([002_Saldos_Contables_BSC].sdo_peso) AS SumaDesdo_peso
SELECT 
[002_Saldos_Contables_BSC].codig,                        -- 001_Plan_Cuentas_BSC = pc
CStr([descripcion]) AS descripcion1,                     -- 002_Saldos_Contables_BSC = sc
[001_Plan_Cuentas_BSC].num_cta_sbif_mdr, 
[002_Saldos_Contables_BSC].moned, 
[001_Plan_Cuentas_BSC].cent_resp, 
[001_Plan_Cuentas_BSC].cod_producto
FROM 001_Plan_Cuentas_BSC INNER JOIN 002_Saldos_Contables_BSC 
ON [001_Plan_Cuentas_BSC].cuenta = [002_Saldos_Contables_BSC].codig
GROUP BY 
[002_Saldos_Contables_BSC].codig, 
CStr([descripcion]), 
[001_Plan_Cuentas_BSC].num_cta_sbif_mdr, 
[002_Saldos_Contables_BSC].moned, 
[001_Plan_Cuentas_BSC].cent_resp, 
[001_Plan_Cuentas_BSC].cod_producto
PIVOT [002_Saldos_Contables_BSC].fecha;

