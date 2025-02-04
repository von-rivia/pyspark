-- TABLA PLANCTA_CONTA_FUSION
SELECT * 
FROM informacional_prd.bu_syp_in_hist.plancta_contab_fusion
WHERE data_date_part BETWEEN '2024-01-01' AND '2024-04-30'
LIMIT 10000;

-- TABLA sdo_contab_fusion
SELECT * 
FROM informacional_prd.bu_syp_in_hist.sdo_contab_fusion
WHERE data_date_part BETWEEN '2024-01-01' AND '2024-04-30'
LIMIT 10000;

