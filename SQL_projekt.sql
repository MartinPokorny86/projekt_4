/*
 * SQL_projekt.sql: čtvrtý projekt do Engeto Online Python Akademie
 * author: Martin Pokorný
 * email: pokornymartin2@gmail.com
 * discord: martin_pokorny86
*/

# Zdrojové datové sady

SELECT *
FROM czechia_payroll AS cpay;

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
	cpay.id, cpay.value, cpay.value_type_code, cpvt.name AS value_type_name,
	cpay.unit_code, cpu.name AS unit_name, cpay.calculation_code, cpc.name AS calculation_name, 
	cpay.industry_branch_code, cpib.name AS industry_branch_name, cpay.payroll_year, cpay.payroll_quarter 
FROM czechia_payroll AS cpay
LEFT JOIN czechia_payroll_value_type AS cpvt
	ON cpay.value_type_code = cpvt.code
LEFT JOIN czechia_payroll_unit AS cpu
	ON cpay.unit_code = cpu.code
LEFT JOIN czechia_payroll_calculation AS cpc
	ON cpay.calculation_code = cpc.code
LEFT JOIN czechia_payroll_industry_branch AS cpib
	ON cpay.industry_branch_code = cpib.code;

# přepočtená průměrná hrubá mzda na zaměstnance v Česku ve vybraném sektoru a roce - pouze pro kontrolu dat

SELECT
	cpay.id, cpay.value, cpay.value_type_code, cpvt.name AS value_type_name,
	cpay.unit_code, cpu.name AS unit_name, cpay.calculation_code, cpc.name AS calculation_name, 
	cpay.industry_branch_code, cpib.name AS industry_branch_name, cpay.payroll_year, cpay.payroll_quarter 
FROM czechia_payroll AS cpay
LEFT JOIN czechia_payroll_value_type AS cpvt
	ON cpay.value_type_code = cpvt.code
LEFT JOIN czechia_payroll_unit AS cpu
	ON cpay.unit_code = cpu.code
LEFT JOIN czechia_payroll_calculation AS cpc
	ON cpay.calculation_code = cpc.code
LEFT JOIN czechia_payroll_industry_branch AS cpib
	ON cpay.industry_branch_code = cpib.code
WHERE cpay.value_type_code = 5958 AND cpay.calculation_code  = 200 AND cpay.industry_branch_code = "E" AND cpay.payroll_year = "2021";

# přepočtená průměrná hrubá mzda na zaměstnance v Česku podle čtvrtletí jednotlivých let - podrobná tabulka (s kódy)

SELECT
	concat(cpay.payroll_year, '_', cpay.payroll_quarter) AS year_quarter, 
	cpay.payroll_year, cpay.payroll_quarter, cpay.value, cpay.value_type_code, cpvt.name AS value_type_name,
	cpay.unit_code, cpu.name AS unit_name, cpay.calculation_code, cpc.name AS calculation_name, 
	COALESCE (cpay.industry_branch_code, 'CZ') AS industry_branch_code, COALESCE (cpib.name, 'Czechia') AS industry_branch_name
FROM czechia_payroll AS cpay
LEFT JOIN czechia_payroll_value_type AS cpvt
	ON cpay.value_type_code = cpvt.code
LEFT JOIN czechia_payroll_unit AS cpu
	ON cpay.unit_code = cpu.code
LEFT JOIN czechia_payroll_calculation AS cpc
	ON cpay.calculation_code = cpc.code
LEFT JOIN czechia_payroll_industry_branch AS cpib
	ON cpay.industry_branch_code = cpib.code
WHERE cpay.value_type_code = 5958 AND cpay.calculation_code  = 200
GROUP BY cpay.industry_branch_code, cpay.payroll_year, cpay.payroll_quarter;

# přepočtená průměrná hrubá mzda na zaměstnance v Česku podle kvartálů jednotlivých let - zjednodušená tabulka

SELECT
	concat(cpay.payroll_year, '_', cpay.payroll_quarter) AS year_quarter,
	cpay.payroll_year, cpay.payroll_quarter, cpay.value AS avg_salary, CONCAT(cpu.name, ' / ', 'měsíc') AS unit_name,
	cpvt.name AS value_type_name, cpc.name AS calculation_name,
	COALESCE (cpay.industry_branch_code, 'CZ') AS industry_branch_code, COALESCE (cpib.name, 'Czechia') AS industry_branch_name
FROM czechia_payroll AS cpay
LEFT JOIN czechia_payroll_value_type AS cpvt
	ON cpay.value_type_code = cpvt.code
LEFT JOIN czechia_payroll_unit AS cpu
	ON cpay.unit_code = cpu.code
LEFT JOIN czechia_payroll_calculation AS cpc
	ON cpay.calculation_code = cpc.code
LEFT JOIN czechia_payroll_industry_branch AS cpib
	ON cpay.industry_branch_code = cpib.code
WHERE cpay.value_type_code = 5958 AND cpay.calculation_code  = 200
GROUP BY cpay.industry_branch_code, cpay.payroll_year, cpay.payroll_quarter;

# průměrná hrubá mzda na zaměstnance (fyzické osoby) v Česku podle kvartálů jednotlivých let - zjednodušená tabulka

SELECT
	concat(cpay.payroll_year, '_', cpay.payroll_quarter) AS year_quarter,
	cpay.payroll_year, cpay.payroll_quarter, cpay.value AS avg_salary, CONCAT(cpu.name, ' / ', 'měsíc') AS unit_name,
	cpvt.name AS value_type_name, cpc.name AS calculation_name,
	COALESCE (cpay.industry_branch_code, 'CZ') AS industry_branch_code, COALESCE (cpib.name, 'Czechia') AS industry_branch_name
FROM czechia_payroll AS cpay
LEFT JOIN czechia_payroll_value_type AS cpvt
	ON cpay.value_type_code = cpvt.code
LEFT JOIN czechia_payroll_unit AS cpu
	ON cpay.unit_code = cpu.code
LEFT JOIN czechia_payroll_calculation AS cpc
	ON cpay.calculation_code = cpc.code
LEFT JOIN czechia_payroll_industry_branch AS cpib
	ON cpay.industry_branch_code = cpib.code
WHERE cpay.value_type_code = 5958 AND cpay.calculation_code  = 100
GROUP BY cpay.industry_branch_code, cpay.payroll_year, cpay.payroll_quarter;

# přiřazení definic ke kódům do tabulky czechia_price - podrobná tabulka

SELECT
	cpay.id, cpay.category_code, cpc.name AS category_name, cpay.value,
	cpc.price_value, cpc.price_unit, cpay.date_from, cpay.date_to,
	COALESCE (cpay.region_code, 'CZ0') AS region_code,
	COALESCE (cr.name, 'Czechia') AS region_name,
	YEAR(date_to) AS date_to_year,
	CASE 
		WHEN MONTH(date_to) BETWEEN 1 AND 3 THEN '1'
		WHEN MONTH(date_to) BETWEEN 4 AND 6 THEN '2'
		WHEN MONTH(date_to) BETWEEN 7 AND 9 THEN '3'
		ELSE '4'
	END AS date_to_quarter
FROM czechia_price AS cpay
LEFT JOIN czechia_price_category AS cpc
	ON cpay.category_code = cpc.code
LEFT JOIN czechia_region AS cr
	ON cpay.region_code = cr.code
ORDER BY cpay.category_code, cpay.date_to, cpay.region_code ASC;

# přiřazení definic ke kódům do tabulky czechia_price - zjednodušená tabulka

SELECT
	CONCAT(YEAR(date_to), '_',
		CASE 
			WHEN MONTH(date_to) BETWEEN 1 AND 3 THEN '1'
			WHEN MONTH(date_to) BETWEEN 4 AND 6 THEN '2'
			WHEN MONTH(date_to) BETWEEN 7 AND 9 THEN '3'
			ELSE '4'
		END) AS year_quarter,
	YEAR(date_to) AS date_to_year,
	CASE 
		WHEN MONTH(date_to) BETWEEN 1 AND 3 THEN '1'
		WHEN MONTH(date_to) BETWEEN 4 AND 6 THEN '2'
		WHEN MONTH(date_to) BETWEEN 7 AND 9 THEN '3'
		ELSE '4'
	END AS date_to_quarter,
	cpay.date_from, cpay.date_to,
	cpay.category_code, cpc.name AS category_name, cpay.value,
	COALESCE (cpay.region_code, 'CZ0') AS region_code,
	COALESCE (cr.name, 'Czechia') AS region_name,
	cpc.price_value, cpc.price_unit
FROM czechia_price AS cpay
LEFT JOIN czechia_price_category AS cpc
	ON cpay.category_code = cpc.code
LEFT JOIN czechia_region AS cr
	ON cpay.region_code = cr.code
ORDER BY cpay.category_code, cpay.date_to, cpay.region_code ASC;


# dílčí zdrojové tabulky

SELECT *
FROM czechia_price_category AS cpcat;

SELECT *
FROM czechia_price AS cp;

SELECT *
FROM czechia_region AS cr;


# VYTVOŘENÍ DVOU TABULEK do localhost - czechia_payroll_edited a czechia_price_edited

# Vytvořena tabulka "czechia_payroll_edited"
# Tabulka vytvořena z kódu, který byl pod názvem: přepočtená průměrná hrubá mzda na zaměstnance v Česku podle kvartálů jednotlivých let - zjednodušená tabulka

CREATE TABLE czechia_payroll_edited AS
SELECT
	concat(cpay.payroll_year, '_', cpay.payroll_quarter, '_', 'CZ') AS year_quarter,
	cpay.payroll_year, cpay.payroll_quarter, cpay.value AS avg_salary, CONCAT(cpu.name, ' / ', 'měsíc') AS unit_name,
	cpvt.name AS value_type_name, cpc.name AS calculation_name,
	COALESCE (cpay.industry_branch_code, 'CZ') AS industry_branch_code, COALESCE (cpib.name, 'Czechia') AS industry_branch_name
FROM czechia_payroll AS cpay
LEFT JOIN czechia_payroll_value_type AS cpvt
	ON cpay.value_type_code = cpvt.code
LEFT JOIN czechia_payroll_unit AS cpu
	ON cpay.unit_code = cpu.code
LEFT JOIN czechia_payroll_calculation AS cpc
	ON cpay.calculation_code = cpc.code
LEFT JOIN czechia_payroll_industry_branch AS cpib
	ON cpay.industry_branch_code = cpib.code
WHERE cpay.value_type_code = 5958 AND cpay.calculation_code  = 200 AND cpay.industry_branch_code IS NULL # tj. výběr mzdy za celé Česko, ne v rozdělení dle odvětví
GROUP BY cpay.industry_branch_code, cpay.payroll_year, cpay.payroll_quarter;

# Vytvořena tabulka "czechia_price_edited"
# Tabulka vytvořena z kódu, který byl pod názvem: přiřazení definic ke kódům do tabulky czechia_price - zjednodušená tabulka

CREATE TABLE czechia_price_edited AS
SELECT
	CONCAT(YEAR(date_to), '_',
		CASE 
			WHEN MONTH(date_to) BETWEEN 1 AND 3 THEN '1'
			WHEN MONTH(date_to) BETWEEN 4 AND 6 THEN '2'
			WHEN MONTH(date_to) BETWEEN 7 AND 9 THEN '3'
			ELSE '4'
		END, '_', 'CZ') AS year_quarter,
	YEAR(date_to) AS date_to_year,
	CASE 
		WHEN MONTH(date_to) BETWEEN 1 AND 3 THEN '1'
		WHEN MONTH(date_to) BETWEEN 4 AND 6 THEN '2'
		WHEN MONTH(date_to) BETWEEN 7 AND 9 THEN '3'
		ELSE '4'
	END AS date_to_quarter,
	cp.date_from, cp.date_to,
	cp.category_code, cpc.name AS category_name, cp.value,
	COALESCE (cp.region_code, 'CZ0') AS region_code,
	COALESCE (cr.name, 'Czechia') AS region_name,
	cpc.price_value, cpc.price_unit
FROM czechia_price AS cp
LEFT JOIN czechia_price_category AS cpc
	ON cp.category_code = cpc.code
LEFT JOIN czechia_region AS cr
	ON cp.region_code = cr.code
ORDER BY cp.category_code, cp.date_to, cp.region_code ASC;



/*
 * Tabulka 1: t_Martin_Pokorny_project_SQL_primary_final
 * Výpočet cenové dostupnosti potravin z přepočtené průměrné hrubé mzdy na zaměstnance v Česku celkem za období let 2006 - 2018 (čtvrtletně)
 */

SELECT *
FROM czechia_payroll_edited AS cpae;

SELECT *
FROM czechia_price_edited AS cpre;

SELECT
	cpre.year_quarter, cpre.date_from, cpre.date_to,
	cpre.category_code, cpre.category_name, cpre.value,
	cpre.region_code, cpre.region_name, cpre.price_value,
	cpre.price_unit, cpae.avg_salary, cpae.unit_name,
	cpae.value_type_name, cpae.calculation_name,
	ROUND ((cpre.value / cpae.avg_salary) *100 , 3) AS food_affordability_percent
FROM czechia_price_edited AS cpre
LEFT JOIN czechia_payroll_edited AS cpae
	ON cpre.year_quarter = cpae.year_quarter;

/*
 * Tabulka 2: t_Martin_Pokorny_project_SQL_secondary_final
 * Evropské státy podle základních ukazatelů: HDP, GINI koeficient, populace za období let 2006 - 2018
 */

# zdrojové datové sady

SELECT *
FROM countries AS c;

SELECT *
FROM economies AS e;

# finální verze pohledu "t_Martin_Pokorny_project_SQL_secondary_final":

SELECT
	e.`year`, e.country, c.continent, e.GDP, e.gini, e.population
FROM economies AS e
LEFT JOIN countries AS c
	ON e.country = c.country
WHERE c.continent = 'Europe' AND e.`year` BETWEEN 2006 AND 2018
ORDER BY e.`year` ASC, e.country ASC;


/*
 * Otázka č. 1: Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
 * Řešení - tabulka A: Průměrné přepočtené hrubé mzdy na zaměstnance v průběhu let v odvětvích většinou rostou, nicméně není tomu tak vždy. 
 * Například v odvětví Těžby a dobývání klesla v roce 2013 mzda oproti roku 2012 o 1 053 Kč/měsíc, (tj. z 32 540 Kč/měsíc na 31 487 Kč/měsíc).
 * K významnému poklesu došlo v odvětví D. Výroba a rozvod elektřiny mezi roky 2012 a 2013 (z 42 657 Kč/měsíc v roce 2012 na 40 762 Kč/měsíc v roce 2013).
 * 
 * V tabulce B jsou uvedeny změny mezd podle čtvrtletí v jednotlivých odvětvích, kde je patrná větší dynamika mezičtvrtletních změn výše mezd
 */


# Tabulka A: přepočtená průměrná hrubá mzda na zaměstnance v Česku podle jednotlivých let - zjednodušená tabulka

SELECT
	cpay.payroll_year,
	COALESCE (cpay.industry_branch_code, 'CZ') AS industry_branch_code, COALESCE (cpib.name, 'Czechia') AS industry_branch_name,
	ROUND(AVG(cpay.value),0) AS avg_salary, CONCAT(cpu.name, ' / ', 'měsíc') AS unit_name,
	cpvt.name AS value_type_name, cpc.name AS calculation_name
FROM czechia_payroll AS cpay
LEFT JOIN czechia_payroll_value_type AS cpvt
	ON cpay.value_type_code = cpvt.code
LEFT JOIN czechia_payroll_unit AS cpu
	ON cpay.unit_code = cpu.code
LEFT JOIN czechia_payroll_calculation AS cpc
	ON cpay.calculation_code = cpc.code
LEFT JOIN czechia_payroll_industry_branch AS cpib
	ON cpay.industry_branch_code = cpib.code
WHERE cpay.value_type_code = 5958 AND cpay.calculation_code  = 200
GROUP BY cpay.industry_branch_code, cpay.payroll_year;


# Tabulka B: přepočtená průměrná hrubá mzda na zaměstnance v Česku podle čtvrtletí jednotlivých let - zjednodušená tabulka

SELECT
	CONCAT(cpay.payroll_year, '_', cpay.payroll_quarter) AS year_quarter,
	COALESCE (cpay.industry_branch_code, 'CZ') AS industry_branch_code, COALESCE (cpib.name, 'Czechia') AS industry_branch_name,
	cpay.value AS avg_salary, CONCAT(cpu.name, ' / ', 'měsíc') AS unit_name,
	cpvt.name AS value_type_name, cpc.name AS calculation_name,
	((LEAD(cpay.value, 1) OVER (ORDER BY cpay.id) / cpay.value) * 100) - 100 AS next_vs_previous_pct
FROM czechia_payroll AS cpay
LEFT JOIN czechia_payroll_value_type AS cpvt
	ON cpay.value_type_code = cpvt.code
LEFT JOIN czechia_payroll_unit AS cpu
	ON cpay.unit_code = cpu.code
LEFT JOIN czechia_payroll_calculation AS cpc
	ON cpay.calculation_code = cpc.code
LEFT JOIN czechia_payroll_industry_branch AS cpib
	ON cpay.industry_branch_code = cpib.code
WHERE cpay.value_type_code = 5958 AND cpay.calculation_code  = 200
GROUP BY cpay.industry_branch_code, cpay.payroll_year, cpay.payroll_quarter;

/*
 * Otázka č. 2: Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
 * 
 * Řešení: Sledované období je 16.12.2018 a 16.12.2007. Výsledky kupní síly vychází z přepočtené průměrné hrubé mzdy na zaměstnance v Česku.
 * 
 * Ačkoliv konzumní chléb mezi roky 2007 a 2018 zdražil o 1,68 Kč/kg (z 23,06 Kč/kg v roce 2007 na 24,74 Kč/kg v roce 2018),
 * mohl si kupující v Česku v roce 2018 zakoupit ze své mzdy téměř o 395 kg více než v roce 2007 (V roce 2018 si kupující mohl zakoupit 1 376,60 kg,
 * v roce 2007 si mohl ze své mzdy zakoupit 981,83 kg).
 * Mléko polotučné pasterované ve sledovaném období podražilo o 1,63 Kč. Zatímco v polovině prosince roku 2007 stál litr mléka 17,92 Kč, o jedenáct let později
 * byla cena litru mléka ve stejném období ve výši 19,55 Kč. Kupní síla se 16.12.2018 oproti 16.12.2007 zvýšila o téměř 480 litrů a kupující si tak mohl v roce 2018 zakoupit
 * ze své mzdy 1 742,05 litrů mléka, ve stejném období roku 2007 si kupující mohl zakoupit 1 263,45 litrů mléka.
 * 
 */

# category_code
# 114 201 - mléko polotučné pasterované
# 111 301 - chléb konzumní kmínový


SELECT
	CONCAT(YEAR(date_to), '_',
		CASE 
			WHEN MONTH(date_to) BETWEEN 1 AND 3 THEN '1'
			WHEN MONTH(date_to) BETWEEN 4 AND 6 THEN '2'
			WHEN MONTH(date_to) BETWEEN 7 AND 9 THEN '3'
			ELSE '4'
		END, '_', 'CZ') AS year_quarter,
	YEAR(date_to) AS date_to_year,
	CASE 
		WHEN MONTH(date_to) BETWEEN 1 AND 3 THEN '1'
		WHEN MONTH(date_to) BETWEEN 4 AND 6 THEN '2'
		WHEN MONTH(date_to) BETWEEN 7 AND 9 THEN '3'
		ELSE '4'
	END AS date_to_quarter,
	concat(DAY(cp.date_from), '.', MONTH(cp.date_from), '.', YEAR(cp.date_from)) AS date_from_edited, 
	concat(DAY(cp.date_to), '.', MONTH(cp.date_to), '.', YEAR(cp.date_to)) AS date_to_edited, DATEDIFF(cp.date_to, cp.date_from) AS number_of_days, 
	cp.category_code, cpc.name AS category_name, cp.value,
	COALESCE (cp.region_code, 'CZ0') AS region_code,
	COALESCE (cr.name, 'Czechia') AS region_name,
	cpc.price_value, cpc.price_unit, cpay.payroll_year, cpay.payroll_quarter, cpay.value AS avg_salary,
	concat(ROUND(cpay.value/cp.value,2),' ', cpc.price_unit) AS purchasing_power
FROM czechia_price AS cp
LEFT JOIN czechia_price_category AS cpc
	ON cp.category_code = cpc.code
LEFT JOIN czechia_region AS cr
	ON cp.region_code = cr.code
LEFT JOIN czechia_payroll AS cpay
	ON YEAR(cp.date_to) = cpay.payroll_year AND QUARTER(cp.date_to) = cpay.payroll_quarter
WHERE (concat(DAY(cp.date_to), '.', MONTH(cp.date_to), '.', YEAR(cp.date_to)) = '16.12.2018' OR 
concat(DAY(cp.date_to), '.', MONTH(cp.date_to), '.', YEAR(cp.date_to)) = '16.12.2007') AND 
(cp.category_code = 114201 OR cp.category_code = 111301) AND (region_code IS NULL) 
AND (cpay.value_type_code = 5958 AND cpay.calculation_code  = 200 AND cpay.industry_branch_code IS NULL)
ORDER BY cp.category_code, cp.date_to, cp.region_code ASC;


/*
 * Otázka č. 3: Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?
 * 
 * Řešení: Nejpomaleji zdražovala v roce 2007 rajská jablka červená kulatá, jelikož oproti roku 2006 zlevnila o 30 % na 40,32 Kč/kg
 * (jejich cena byla v roce 2006 ve výši 57,83 Kč/kg)
 * 
 */

# finální kód:

SELECT 
    category_row_nr,
    date_to_year, 
    category_code, 
    category_name, 
    price_value, 
    price_unit, 
    average_year_price, 
    next_vs_previous_pct
FROM (
	SELECT
		ROW_NUMBER() OVER (PARTITION BY cp.category_code ORDER BY cp.date_to) AS category_row_nr,	
		YEAR(cp.date_to) AS date_to_year, 
		cp.category_code, cpc.name AS category_name, 
		cpc.price_value, cpc.price_unit,
		ROUND(AVG(cp.value), 2) AS average_year_price,
		CASE 
			WHEN ROW_NUMBER() OVER (PARTITION BY cp.category_code ORDER BY cp.date_to) BETWEEN 1 AND 12 
			AND CONCAT(YEAR(cp.date_to), '_', cp.category_code, '_', ROW_NUMBER() OVER (PARTITION BY cp.category_code ORDER BY cp.date_to)) != '2018_212101_4'
			THEN ROUND(((LEAD(AVG(cp.value), 1) OVER (ORDER BY cp.category_code) / AVG(cp.value)) * 100),2) - 100
			ELSE NULL 
		END AS next_vs_previous_pct
	FROM czechia_price AS cp
	LEFT JOIN czechia_price_category AS cpc
		ON cp.category_code = cpc.code
	LEFT JOIN czechia_region AS cr
		ON cp.region_code = cr.code
	GROUP BY cp.category_code, YEAR(cp.date_to)
) sub
	ORDER BY  
    	next_vs_previous_pct IS NULL,
		next_vs_previous_pct, 
    	category_code, 
    	date_to_year;

# pracovní kód (pro kontrolu a porovnání dat s následujícím rokem) - výběr kategorie "Rajská jablka červená kulatá"
SELECT
	ROW_NUMBER() OVER (PARTITION BY cp.category_code ORDER BY cp.date_to) AS category_row_nr,	
	YEAR(cp.date_to) AS date_to_year, 
	cp.category_code, cpc.name AS category_name, 
	cpc.price_value, cpc.price_unit,
	ROUND(AVG(cp.value), 2) AS average_year_price,
	CASE 
		WHEN ROW_NUMBER() OVER (PARTITION BY cp.category_code ORDER BY cp.date_to) BETWEEN 1 AND 12 
		AND CONCAT(YEAR(cp.date_to), '_', cp.category_code, '_', ROW_NUMBER() OVER (PARTITION BY cp.category_code ORDER BY cp.date_to)) != '2018_212101_4'
		THEN ROUND(((LEAD(AVG(cp.value), 1) OVER (ORDER BY cp.category_code) / AVG(cp.value)) * 100),2) - 100
		ELSE '*'
	END AS next_vs_previous_pct
FROM czechia_price AS cp
LEFT JOIN czechia_price_category AS cpc
	ON cp.category_code = cpc.code
LEFT JOIN czechia_region AS cr
	ON cp.region_code = cr.code
WHERE cp.category_code = 117101
GROUP BY cp.category_code, YEAR(cp.date_to)
ORDER BY cp.category_code, cp.date_to ASC;

# pracovní kód (pro kontrolu a porovnání dat s následujícím rokem) - všechny kategorie
SELECT
	ROW_NUMBER() OVER (PARTITION BY cp.category_code ORDER BY cp.date_to) AS category_row_nr,	
	YEAR(cp.date_to) AS date_to_year, 
	cp.category_code, cpc.name AS category_name, 
	cpc.price_value, cpc.price_unit,
	ROUND(AVG(cp.value), 2) AS average_year_price,
	CASE 
		WHEN ROW_NUMBER() OVER (PARTITION BY cp.category_code ORDER BY cp.date_to) BETWEEN 1 AND 12 
		AND CONCAT(YEAR(cp.date_to), '_', cp.category_code, '_', ROW_NUMBER() OVER (PARTITION BY cp.category_code ORDER BY cp.date_to)) != '2018_212101_4'
		THEN ROUND(((LEAD(AVG(cp.value), 1) OVER (ORDER BY cp.category_code) / AVG(cp.value)) * 100),2) - 100
		ELSE '*'
	END AS next_vs_previous_pct
FROM czechia_price AS cp
LEFT JOIN czechia_price_category AS cpc
	ON cp.category_code = cpc.code
LEFT JOIN czechia_region AS cr
	ON cp.region_code = cr.code
GROUP BY cp.category_code, YEAR(cp.date_to)
ORDER BY cp.category_code, cp.date_to ASC;

/*
 * Otázka č. 4: Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
 * Řešení: Ano, z upravené tabulky z předchozí otázky najdeme některé kategorie potravin, jejichž cena rostla meziročně více jak o 10 %
 * a zároveň byl trend růstu cen vyšší než růst mezd, jejichž výše za sledované období nepřekročila hranici 9 % (viz upravená tabulka B z řešení první otázky).
 * Nejvyšší nárůst cen, téměř o 95 %, byl zaznamenán u kategorie potravin "papriky". V roce 2006 byla cena paprik 35,31 Kč/kg, v roce 2007 cena činila 68,79 Kč/kg.
 * 
 */

# upravená finální tabulka ze 3. otázky:

SELECT 
    category_row_nr,
    date_to_year, 
    category_code, 
    category_name, 
    price_value, 
    price_unit, 
    average_year_price, 
    next_vs_previous_pct
FROM (
	SELECT
		ROW_NUMBER() OVER (PARTITION BY cp.category_code ORDER BY cp.date_to) AS category_row_nr,	
		YEAR(cp.date_to) AS date_to_year, 
		cp.category_code, cpc.name AS category_name, 
		cpc.price_value, cpc.price_unit,
		ROUND(AVG(cp.value), 2) AS average_year_price,
		CASE 
			WHEN ROW_NUMBER() OVER (PARTITION BY cp.category_code ORDER BY cp.date_to) BETWEEN 1 AND 12 
			AND CONCAT(YEAR(cp.date_to), '_', cp.category_code, '_', ROW_NUMBER() OVER (PARTITION BY cp.category_code ORDER BY cp.date_to)) != '2018_212101_4'
			THEN ROUND(((LEAD(AVG(cp.value), 1) OVER (ORDER BY cp.category_code) / AVG(cp.value)) * 100),2) - 100
			ELSE NULL 
		END AS next_vs_previous_pct
	FROM czechia_price AS cp
	LEFT JOIN czechia_price_category AS cpc
		ON cp.category_code = cpc.code
	LEFT JOIN czechia_region AS cr
		ON cp.region_code = cr.code
	GROUP BY cp.category_code, YEAR(cp.date_to)
) sub
	WHERE next_vs_previous_pct > 10
	ORDER BY  
    	next_vs_previous_pct IS NULL,
		next_vs_previous_pct, 
    	category_code, 
    	date_to_year;


# pro analýzu dat meziročního nárůstu mezd používám trochu upravenou tabulku B z řešení první otázky:

# Tabulka B: přepočtená průměrná hrubá mzda na zaměstnance v Česku podle čtvrtletí jednotlivých let - zjednodušená tabulka

SELECT
	cpay.payroll_year,
	COALESCE (cpay.industry_branch_code, 'CZ') AS industry_branch_code, COALESCE (cpib.name, 'Czechia') AS industry_branch_name,
	round(avg(cpay.value),2) AS avg_salary, CONCAT(cpu.name, ' / ', 'měsíc') AS unit_name,
	cpvt.name AS value_type_name, cpc.name AS calculation_name,
	((LEAD(AVG(cpay.value), 1) OVER (ORDER BY cpay.payroll_year) / AVG(cpay.value)) * 100) - 100 AS next_vs_previous_pct
FROM czechia_payroll AS cpay
LEFT JOIN czechia_payroll_value_type AS cpvt
	ON cpay.value_type_code = cpvt.code
LEFT JOIN czechia_payroll_unit AS cpu
	ON cpay.unit_code = cpu.code
LEFT JOIN czechia_payroll_calculation AS cpc
	ON cpay.calculation_code = cpc.code
LEFT JOIN czechia_payroll_industry_branch AS cpib
	ON cpay.industry_branch_code = cpib.code
WHERE cpay.value_type_code = 5958 AND cpay.calculation_code  = 200 AND cpay.industry_branch_code IS NULL
GROUP BY cpay.industry_branch_code, cpay.payroll_year;

/*
 * Otázka č. 5: Má výška HDP vliv na změny ve mzdách a cenách potravin? 
 * Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?
 * Řešení: 
 * 
 * Vliv HDP na změny ve mzdách:
 * 
 * Největší nárůst HDP v Česku byl v období let 2000 až 2020 zaznamenán mezi roky 2006 a 2005, kdy se v roce 2006 zvýšilo HDP oproti předchozímu roku o 6,8 %.
 * Mzdy se v roce 2006 zvýšily o 6,5 % oproti roku 2005.
 * 
 * V roce 2007 došlo oproti roku 2006 k mírnějšímu nárůstu HDP o 5,6 %. I přes menší nárůst HDP než tomu bylo při porovnání let 2006 a 2005 (o cca 1 %) došlo 
 * v roce 2007 oproti roku 2006 k výraznějšímu nárůstu mezd o 7,2 %.
 * 
 * V roce 2018 se HDP oproti roku 2017 zvýšilo o 3,2 %. A v roce 2018 došlo k výraznému růstu mezd oproti roku 2017 o 8,2 %.
 * 
 * Závěrem lze říci, že výraznější růst HDP nemá pravidelný vliv na výrazný růst mezd.
 * 
 * Vliv HDP na změny v cenách potravin
 * 
 * Z finální tabulky, kterou jsem použil ve třetí otázce, je patrné, že nejmenší meziroční růst cen byl zaznamenán u rajských jablek červených kulatých.
 * V roce 2007 došlo ke snížení jejich ceny oproti roku 2006 o 30,3 %. 
 * 
 * V roce 2018 se HDP oproti roku 2017 zvýšilo o 3,2 %. Změna výše HDP byla v tomto období nižší než mezi lety 2007 a 2006, kdy činila 5,6 %.
 * 
 * Při porovnání s rokem 2017 cena rajských jablek v roce 2018 klesla o 0,5 %.
 * 
 * V roce 2007 bylo největší zdražení zaznamenáno u paprik, konkrétně o 94,81 % oproti roku 2006.
 * 
 * Při porovnání s rokem 2017 cena paprik v roce 2018 klesla o 3,1 %
 * 
 * V roce 2007 byla pšeničná mouka hladká dražší o 22,6 % než tomu bylo v roce 2006. V té době byl nárůst HDP o 5,6 %. 
 * Naopak v roce 2018 byla hladká mouka z pšenice o 0,05 % dražší než v roce 2017. Mouka tak byla v roce 2018 cenově dostupnější, byť v té době bylo HDP
 * o 3,2 % větší než v minulém roce.
 * 
 * Závěrem lze říci, že rajčata byla levnější při vyšším meziročním růstu HDP (porovnání let 2007/2006) a dražší při nižším meziročním růstu HDP (porovnání let 2018/2017).
 * Naopak papriky byly při vyšším meziročním růstu HDP v roce 2007 mnohem dražší než v roce 2018, kdy meziroční změna HDP činila 3,2 %.
 * Pšeničná mouka hladká byla v rámci porovnání let 2007/2006 dražší než při porovnání let 2018/2017.
 * Výše HDP má tedy různý vliv na cenu u jednotlivých kategorií potravin.
 * 
 */

SELECT
	e.country, e.`year`, e.GDP,
	((LEAD(e.GDP, 1) OVER (ORDER BY e.`year`) / (e.GDP)) * 100) - 100 AS gdp_next_vs_previous_pct
FROM economies AS e
WHERE country = 'Czech Republic' AND e.YEAR >= 1990
ORDER BY e.`year` ASC;

# pro analýzu dat vlivu meziročního nárůstu hdp a mezd používám tabulku B z řešení čtvrté otázky:

# Tabulka B: přepočtená průměrná hrubá mzda na zaměstnance v Česku podle čtvrtletí jednotlivých let - zjednodušená tabulka

SELECT
	cpay.payroll_year,
	COALESCE (cpay.industry_branch_code, 'CZ') AS industry_branch_code, COALESCE (cpib.name, 'Czechia') AS industry_branch_name,
	round(avg(cpay.value),0) AS avg_salary, CONCAT(cpu.name, ' / ', 'měsíc') AS unit_name,
	cpvt.name AS value_type_name, cpc.name AS calculation_name,
	((LEAD(AVG(cpay.value), 1) OVER (ORDER BY cpay.payroll_year) / AVG(cpay.value)) * 100) - 100 AS next_vs_previous_pct, 
	e.YEAR AS gdp_year, e.country,
	((LEAD(e.GDP, 1) OVER (ORDER BY e.`year`) / (e.GDP)) * 100) - 100 AS gdp_next_vs_previous_pct
FROM czechia_payroll AS cpay
LEFT JOIN czechia_payroll_value_type AS cpvt
	ON cpay.value_type_code = cpvt.code
LEFT JOIN czechia_payroll_unit AS cpu
	ON cpay.unit_code = cpu.code
LEFT JOIN czechia_payroll_calculation AS cpc
	ON cpay.calculation_code = cpc.code
LEFT JOIN czechia_payroll_industry_branch AS cpib
	ON cpay.industry_branch_code = cpib.code
LEFT JOIN economies AS e 
	ON cpay.payroll_year = e.`year` 
WHERE cpay.value_type_code = 5958 AND cpay.calculation_code  = 200 AND cpay.industry_branch_code IS NULL AND e.country = 'Czech Republic'
GROUP BY cpay.industry_branch_code, cpay.payroll_year;

# pro analýzu dat vlivu meziročního nárůstu hdp a cen potravin používám tabulku "finální kód" z řešení třetí otázky:

SELECT 
    category_row_nr,
    date_to_year, 
    category_code, 
    category_name, 
    price_value, 
    price_unit, 
    average_year_price, 
    next_vs_previous_pct
FROM (
	SELECT
		ROW_NUMBER() OVER (PARTITION BY cp.category_code ORDER BY cp.date_to) AS category_row_nr,	
		YEAR(cp.date_to) AS date_to_year, 
		cp.category_code, cpc.name AS category_name, 
		cpc.price_value, cpc.price_unit,
		ROUND(AVG(cp.value), 2) AS average_year_price,
		CASE 
			WHEN ROW_NUMBER() OVER (PARTITION BY cp.category_code ORDER BY cp.date_to) BETWEEN 1 AND 12 
			AND CONCAT(YEAR(cp.date_to), '_', cp.category_code, '_', ROW_NUMBER() OVER (PARTITION BY cp.category_code ORDER BY cp.date_to)) != '2018_212101_4'
			THEN ROUND(((LEAD(AVG(cp.value), 1) OVER (ORDER BY cp.category_code) / AVG(cp.value)) * 100),2) - 100
			ELSE NULL 
		END AS next_vs_previous_pct
	FROM czechia_price AS cp
	LEFT JOIN czechia_price_category AS cpc
		ON cp.category_code = cpc.code
	LEFT JOIN czechia_region AS cr
		ON cp.region_code = cr.code
	GROUP BY cp.category_code, YEAR(cp.date_to)
) sub
	ORDER BY  
    	next_vs_previous_pct IS NULL,
		next_vs_previous_pct, 
    	category_code, 
    	date_to_year;