-- 001_Crea_Plan_Cuentas_BSC
SELECT 
bu_syp_in_plancta_contab_fusion.empresa, 
bu_syp_in_plancta_contab_fusion.cuenta, 
bu_syp_in_plancta_contab_fusion.descripcion, 
bu_syp_in_plancta_contab_fusion.cod_reaj, 
bu_syp_in_plancta_contab_fusion.tipo_moneda, 
bu_syp_in_plancta_contab_fusion.cent_resp, 
bu_syp_in_plancta_contab_fusion.num_cta_sbif_mdr, 
bu_syp_in_plancta_contab_fusion.cod_producto, bu_syp_in_plancta_contab_fusion.cuenta_sbif 
INTO 001_Plan_Cuentas_BSC
FROM bu_syp_in_plancta_contab_fusion;


-- 002_Crea_Saldos_Diarios_BSC
SELECT 
bu_syp_in_sdo_contab_fusion.empresa, 
bu_syp_in_sdo_contab_fusion.sucur, 
bu_syp_in_sdo_contab_fusion.moned, 
bu_syp_in_sdo_contab_fusion.codig, 
bu_syp_in_sdo_contab_fusion.fecha, bu_syp_in_sdo_contab_fusion.tipo_moneda, 
bu_syp_in_sdo_contab_fusion.sdo_orig, bu_syp_in_sdo_contab_fusion.sdo_peso, bu_syp_in_sdo_contab_fusion.prom_orig, bu_syp_in_sdo_contab_fusion.prom_peso, bu_syp_in_sdo_contab_fusion.sdo_mes_orig, bu_syp_in_sdo_contab_fusion.sdo_mes_peso, bu_syp_in_sdo_contab_fusion.prom_anual_orig, bu_syp_in_sdo_contab_fusion.prom_anual_peso INTO 002_Saldos_Contables_BSC
FROM bu_syp_in_sdo_contab_fusion
WHERE (((bu_syp_in_sdo_contab_fusion.sucur)=9999) AND ((bu_syp_in_sdo_contab_fusion.fecha)=[val]));


--- 001_Saldo_Informe_Encaje
SELECT [002_Saldos_Contables_BSC].empresa, [002_Saldos_Contables_BSC].sucur, [002_Saldos_Contables_BSC].codig, CStr([descripcion]) AS descripcion1, Sum([002_Saldos_Contables_BSC].sdo_peso) AS sdo_peso, [002_Saldos_Contables_BSC].fecha, Sum([002_Saldos_Contables_BSC].sdo_orig) AS sdo_orig, [002_Saldos_Contables_BSC].moned, [001_Plan_Cuentas_BSC].num_cta_sbif_mdr, [001_Plan_Cuentas_BSC].cuenta_sbif, Left([cuenta_sbif],4) AS SBIF_
FROM 002_Saldos_Contables_BSC INNER JOIN 001_Plan_Cuentas_BSC ON [002_Saldos_Contables_BSC].codig = [001_Plan_Cuentas_BSC].cuenta
GROUP BY [002_Saldos_Contables_BSC].empresa, [002_Saldos_Contables_BSC].sucur, [002_Saldos_Contables_BSC].codig, CStr([descripcion]), [002_Saldos_Contables_BSC].fecha, [002_Saldos_Contables_BSC].moned, [001_Plan_Cuentas_BSC].num_cta_sbif_mdr, [001_Plan_Cuentas_BSC].cuenta_sbif, Left([cuenta_sbif],4);






