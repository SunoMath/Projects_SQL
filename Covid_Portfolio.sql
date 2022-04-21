--Total number of rows in CovidDeath Table
select *
from CovidDeaths


--Looking at Total cases vs Population
select location,date, Population, total_cases, (total_cases/population)* 100 as Death_Percentage
from CovidDeaths
order by 1, 2 DESC

--Looking at countries with highest infection rate
select location, Population, MAX(total_cases) as HighestInfection_Count, MAX((total_cases/population))* 100 as Percentage_PopulationAffected
from CovidDeaths
Group by location, Population
Order by Percentage_PopulationAffected DESC


--Showing location with the highest death count per population
select location, MAX (CAST(Total_deaths as int)) as TotalDeathCount
from CovidDeaths
where continent is  null
Group By location
order by TotalDeathCount DESC

--Showing continents with the highest death count per population
select continent, MAX (CAST(Total_deaths as int)) as TotalDeathCount
from CovidDeaths
where continent is not null
Group By continent
order by TotalDeathCount DESC


-- Global Numbers
select SUM(new_cases) as Total_cases, SUM(CAST(new_deaths as int)) as Total_Deaths, SUM(CAST(new_deaths as int))/SUM(new_cases) *100 as DeathPercentage
from CovidDeaths
--Group by date
order by 1 DESC


-- Total Population vs Vaccination
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.date) as Rolling_Count
from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccination vac
 On dea.location = vac.location
 and dea.date = vac.date
where dea.continent is not null
--order by 2,3



-- Using CTE
With PopvsVac (continent, location, date, population, New_vaccinations, Rolling_Count)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.date) as Rolling_Count
from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccination vac
 On dea.location = vac.location
 and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
Select *, (Rolling_Count/population) * 100 as Roll_by_Population
from PopvsVac


--TEMP TABLE
DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
Rolling_count numeric
)
Insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.date) as Rolling_Count
from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccination vac
 On dea.location = vac.location
 and dea.date = vac.date
where dea.continent is not null
--order by 2,3

Select *, (Rolling_count/population) * 100 as Roll_by_Population
from #PercentPopulationVaccinated





--Creating View

Create View PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.date) as Rolling_Count
from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccination vac
 On dea.location = vac.location
 and dea.date = vac.date
where dea.continent is not null
--order by 2,3



select *
from PercentPopulationVaccinated

