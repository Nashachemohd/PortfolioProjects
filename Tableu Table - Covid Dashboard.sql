-- QUERIES FOR TABLEU USED 

--Tableu Table 1
select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
--where location = 'Malaysia'
where continent	 is not null
--Group by date
order by 1,2

--Tableu Table 2 
-- Europian Union is part of Europe
SELECT location, SUM(CAST(new_deaths AS bigint)) AS TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent is null
and location not in ('World', 'European Union', 'International')
and location NOT LIKE '%income%'
GROUP BY location
ORDER BY TotalDeathCount DESC

--Tableu Table 3
SELECT Location, Population, MAX(total_cases) AS HighestInfectionCount, MAX(total_cases/population)*100 AS PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
GROUP BY Location, Population
ORDER BY PercentPopulationInfected DESC

--Tableu Table 4
SELECT Location, Population, date, MAX(total_cases) as HighestInfectionCount, MAX(total_cases/population)*100 AS PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
GROUP BY Location, Population, date
ORDER BY PercentPopulationInfected DESC