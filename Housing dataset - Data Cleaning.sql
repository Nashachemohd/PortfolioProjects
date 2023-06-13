/*
Cleaning data in SQL Queries
*/

SELECT SaleDateConverted, CONVERT(Date, SaleDate)
FROM PortfolioProject.dbo.NashvilleHousing

UPDATE NashvilleHousing --Not working
SET SaleDate = CONVERT(Date, SaleDate)

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate)

--------------------------------------------------------------------------------------------------

--Populate Property Address Data

SELECT *
FROM PortfolioProject.dbo.NashvilleHousing
--WHERE PropertyAddress is null
ORDER BY ParcelID


--put the NULL Property Address into the same Property Address
SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL (a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject.dbo.NashvilleHousing a
JOIN  PortfolioProject.dbo.NashvilleHousing b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID] <> b.[UniqueID]
WHERE a.PropertyAddress is null

--none of the Property Address is null
Update a
SET PropertyAddress = ISNULL (a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject.dbo.NashvilleHousing a
JOIN  PortfolioProject.dbo.NashvilleHousing b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID] <> b.[UniqueID]

---------------------------------------------------------------------------------------
--Breaking out Address into Individual Columns (Address, City, State)

SELECT PropertyAddress
FROM PortfolioProject.dbo.NashvilleHousing
--WHERE PropertyAddress is null
--ORDER BY ParcelID



SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress)) as City
FROM PortfolioProject.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1)

ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress))



SELECT * FROM PortfolioProject.dbo.NashvilleHousing


SELECT OwnerAddress
FROM PortfolioProject.dbo.NashvilleHousing

SELECT 
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)
, PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)
, PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM PortfolioProject.dbo.NashvilleHousing



ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

SELECT * FROM PortfolioProject.dbo.NashvilleHousing

-----------------------------------------------------------------------------------------
-- Change Y and N to Yes and No in 'Sold as Vacant' field


SELECT Distinct(SoldAsVacant), Count(SoldAsVacant)
FROM PortfolioProject.dbo.NashvilleHousing
GROUP BY SoldAsVacant
Order by 2


SELECT SoldAsVacant
, CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant 
	End
FROM PortfolioProject.dbo.NashvilleHousing



UPDATE NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant 
	End
FROM PortfolioProject.dbo.NashvilleHousing

---------------------------------------------------------------------------------
--Remove Duplicates
--Notes: do not delete data

With RowNumCTE AS (
SELECT *,
	ROW_NUMBER() OVER  (
	PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
	ORDER BY UniqueID) row_num

FROM PortfolioProject.dbo.NashvilleHousing
--ORDER BY ParcelID
)
Select * 
from RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress


--DELETE THE DUPLICATES
With RowNumCTE AS (
SELECT *,
	ROW_NUMBER() OVER  (
	PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
	ORDER BY UniqueID) row_num

FROM PortfolioProject.dbo.NashvilleHousing
--ORDER BY ParcelID
)
DELETE
from RowNumCTE
WHERE row_num > 1
--ORDER BY PropertyAddress

-----------------------------------------------------------------------------
-- Delete unused columns

SELECT * 
FROM PortfolioProject.dbo.NashvilleHousing

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN SaleDate

----------------------------------------------------------------------------------

