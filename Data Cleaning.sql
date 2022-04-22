--Data Cleaning in SQL

--Standardize Date format

Select SaleDateConverted, Saledate, CAST(Saledate as Date) as Date
from PortfolioProject..NashvilleHousing


Select *
from PortfolioProject..NashvilleHousing


ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;


Update NashvilleHousing
SET SaleDateConverted = CAST(Saledate as Date)

-------------------------------------------------------------------------------------------------------

--Populate Property Address (Remove NULLs)

Select *
from dbo.NashvilleHousing
where propertyAddress is NULL

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
from dbo.NashvilleHousing a
JOIN dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.uniqueID <> b.uniqueID
	where a.PropertyAddress is NULL


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from dbo.NashvilleHousing a
JOIN dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.uniqueID <> b.uniqueID
	where a.PropertyAddress is NULL

---------------------------------------------------------------------------------------------------------------
-- Breaking Address into Individual Columns using Substring (Address, City, State)

Select *
from NashvilleHousing;


SELECT
Substring(propertyaddress,1,CHARINDEX(',',propertyaddress)-1) as Address,
Substring(propertyaddress,CHARINDEX(',',propertyaddress)+1, LEN(PropertyAddress)) as Address
from NashvilleHousing;


ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = Substring(propertyaddress,1,CHARINDEX(',',propertyaddress)-1)



ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity =Substring(propertyaddress,CHARINDEX(',',propertyaddress)+1, LEN(PropertyAddress))


select *
from Nashvillehousing

 --- Doing the same for OwnerAddress with ParseName function
Select 
Parsename(Replace(Owneraddress,',','.'),3),
Parsename(Replace(Owneraddress,',','.'),2),
Parsename(Replace(Owneraddress,',','.'),1)
from NashvilleHousing;


ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = Parsename(Replace(Owneraddress,',','.'),3)


ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = Parsename(Replace(Owneraddress,',','.'),2)

ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = Parsename(Replace(Owneraddress,',','.'),1)

------------------------------------------------------------------------------------------------------

--Change Y and N to Yes and No in Sold as Vaccant

Select distinct(SoldasVacant), count(soldasvacant)
from NashvilleHousing
group by soldasvacant
order by 2


Select SoldasVacant
, case When Soldasvacant = 'Y' THEN 'Yes'
		when Soldasvacant = 'N' THEN 'NO'
        ELSE Soldasvacant
		END
from NashvilleHousing


Update NashvilleHousing
SET SoldasVacant = case When Soldasvacant = 'Y' THEN 'Yes'
		when Soldasvacant = 'N' THEN 'NO'
        ELSE Soldasvacant
		END
---------------------------------------------------------------------------------------------------------------
--Remove Duplicates

With ROWNUMCTE AS (
select *,
		ROW_NUMBER() OVER (
		PARTITION BY ParcelID,
		PropertyAddress,
		SalePrice,
		SaleDate,
		LegalReference
		ORDER BY
			UniqueID
			) row_num

from NashvilleHousing
)

Select *
from ROWNUMCTE
where row_num = 2

--------------------------------------------------------------------------------------------------------------
--Delete Unused Columns

Select *
from NashvilleHousing

ALTER TABLE NashvilleHousing
DROP COLUMN TaxDistrict, SaleDate

ALTER TABLE NashvilleHousing
DROP COLUMN PropertyAddress, OwnerAddress

