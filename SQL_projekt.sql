/*
 * SQL_projekt.sql: čtvrtý projekt do Engeto Online Python Akademie
 * author: Martin Pokorný
 * email: pokornymartin2@gmail.com
 * discord: martin_pokorny86
*/

# Zdrojové datové sady

SELECT *
FROM czechia_payroll AS cp;

/*
 * calculation_code:
 * 100	fyzický
 * 200	přepočtený
 * 
 * unit_code:
 * 200		Kč
 * 80403	tis. osob (tis. os.)
 * 
 * value_type_code:
 * 316	Průměrný počet zaměstnaných osob
 * 5958	Průměrná hrubá mzda na zaměstnance
*/

SELECT *
FROM czechia_payroll_calculation AS cpc;

SELECT *
FROM czechia_payroll_industry_branch AS cpib;

SELECT *
FROM czechia_payroll_unit AS cpu;

SELECT *
FROM czechia_payroll_value_type AS cpvt;

SELECT *
FROM czechia_price AS cp;

SELECT *
FROM czechia_price_category AS cpcat;

SELECT *
FROM czechia_region AS cr;

SELECT *
FROM czechia_district AS cd;

SELECT *
FROM countries AS c;

SELECT *
FROM economies AS e;

# přiřazení definic ke kódům do tabulky czechia_payroll

SELECT
	cp.id, cp.value, cp.value_type_code, cpvt.name AS value_type_name,
	cp.unit_code, cpu.name AS unit_name, cp.calculation_code, cpc.name AS calculation_name, 
	cp.industry_branch_code, cpib.name AS industry_branch_name, cp.payroll_year, cp.payroll_quarter 
FROM czechia_payroll AS cp
LEFT JOIN czechia_payroll_value_type AS cpvt
	ON cp.value_type_code = cpvt.code
LEFT JOIN czechia_payroll_unit AS cpu
	ON cp.unit_code = cpu.code
LEFT JOIN czechia_payroll_calculation AS cpc
	ON cp.calculation_code = cpc.code
LEFT JOIN czechia_payroll_industry_branch AS cpib
	ON cp.industry_branch_code = cpib.code;

# přepočtená průměrná hrubá mzda na zaměstnance ve vybraném sektoru a roce - pouze pro kontrolu dat

SELECT
	cp.id, cp.value, cp.value_type_code, cpvt.name AS value_type_name,
	cp.unit_code, cpu.name AS unit_name, cp.calculation_code, cpc.name AS calculation_name, 
	cp.industry_branch_code, cpib.name AS industry_branch_name, cp.payroll_year, cp.payroll_quarter 
FROM czechia_payroll AS cp
LEFT JOIN czechia_payroll_value_type AS cpvt
	ON cp.value_type_code = cpvt.code
LEFT JOIN czechia_payroll_unit AS cpu
	ON cp.unit_code = cpu.code
LEFT JOIN czechia_payroll_calculation AS cpc
	ON cp.calculation_code = cpc.code
LEFT JOIN czechia_payroll_industry_branch AS cpib
	ON cp.industry_branch_code = cpib.code
WHERE cp.value_type_code = 5958 AND cp.calculation_code  = 200 AND cp.industry_branch_code = "E" AND cp.payroll_year = "2021";

# přepočtená průměrná hrubá mzda na zaměstnance v Česku podle kvartálů jednotlivých let - podrobná tabulka (s kódy)

SELECT
	cp.payroll_year, cp.payroll_quarter, cp.value, cp.value_type_code, cpvt.name AS value_type_name,
	cp.unit_code, cpu.name AS unit_name, cp.calculation_code, cpc.name AS calculation_name, 
	cp.industry_branch_code, cpib.name AS industry_branch_name
FROM czechia_payroll AS cp
LEFT JOIN czechia_payroll_value_type AS cpvt
	ON cp.value_type_code = cpvt.code
LEFT JOIN czechia_payroll_unit AS cpu
	ON cp.unit_code = cpu.code
LEFT JOIN czechia_payroll_calculation AS cpc
	ON cp.calculation_code = cpc.code
LEFT JOIN czechia_payroll_industry_branch AS cpib
	ON cp.industry_branch_code = cpib.code
WHERE cp.value_type_code = 5958 AND cp.calculation_code  = 200 AND cp.industry_branch_code IS NULL
GROUP BY cp.industry_branch_code, cp.payroll_year, cp.payroll_quarter;

# přepočtená průměrná hrubá mzda na zaměstnance v Česku podle kvartálů jednotlivých let - zjednodušená tabulka

SELECT
	cp.payroll_year, cp.payroll_quarter, cp.value AS avg_salary, CONCAT(cpu.name, ' / ', 'měsíc') AS unit_name,
	cpvt.name AS value_type_name, cpc.name AS calculation_name
FROM czechia_payroll AS cp
LEFT JOIN czechia_payroll_value_type AS cpvt
	ON cp.value_type_code = cpvt.code
LEFT JOIN czechia_payroll_unit AS cpu
	ON cp.unit_code = cpu.code
LEFT JOIN czechia_payroll_calculation AS cpc
	ON cp.calculation_code = cpc.code
LEFT JOIN czechia_payroll_industry_branch AS cpib
	ON cp.industry_branch_code = cpib.code
WHERE cp.value_type_code = 5958 AND cp.calculation_code  = 200 AND cp.industry_branch_code IS NULL
GROUP BY cp.industry_branch_code, cp.payroll_year, cp.payroll_quarter;

# průměrná hrubá mzda na zaměstnance (fyzické osoby) v Česku podle kvartálů jednotlivých let - zjednodušená tabulka

SELECT
	cp.payroll_year, cp.payroll_quarter, cp.value AS avg_salary, CONCAT(cpu.name, ' / ', 'měsíc') AS unit_name,
	cpvt.name AS value_type_name, cpc.name AS calculation_name
FROM czechia_payroll AS cp
LEFT JOIN czechia_payroll_value_type AS cpvt
	ON cp.value_type_code = cpvt.code
LEFT JOIN czechia_payroll_unit AS cpu
	ON cp.unit_code = cpu.code
LEFT JOIN czechia_payroll_calculation AS cpc
	ON cp.calculation_code = cpc.code
LEFT JOIN czechia_payroll_industry_branch AS cpib
	ON cp.industry_branch_code = cpib.code
WHERE cp.value_type_code = 5958 AND cp.calculation_code  = 100 AND cp.industry_branch_code IS NULL
GROUP BY cp.industry_branch_code, cp.payroll_year, cp.payroll_quarter;


	
