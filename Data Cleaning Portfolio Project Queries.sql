/*
  Cleaning Data in SQL Queries

 */

 Select*
 From PortfolioProject.dbo.NashvilliHousing

 --Standardize Date Format

 Select SaleDateConverted,CONVERT(date,saledate)
 from PortfolioProject.dbo.NashvilliHousing

 Update NashvilliHousing
 Set saledate = Convert(date,saledate)

 Alter Table NashvilliHousing
 Add SaleDateConverted date;

 Update NashvilliHousing
 Set SaleDateConverted = Convert(date,saledate)

 --Populate Property Address Data

 Select *
 From PortfolioProject.dbo.NashvilliHousing
 --where propertyaddress is null
 Order By parcelid

 Select a.parcelid,a.propertyaddress,b.parcelid,b.propertyaddress,isnull(a.propertyaddress,b.propertyaddress)
 From PortfolioProject.dbo.NashvilliHousing a
 Join PortfolioProject.dbo.NashvilliHousing b
 On a.parcelid = b.parcelid
 And a.[UniqueID ]<>b.[UniqueID ]
 Where a.propertyaddress is null

 Update a
 Set propertyaddress = isnull(a.propertyaddress,b.propertyaddress)
 From PortfolioProject.dbo.NashvilliHousing a
 Join PortfolioProject.dbo.NashvilliHousing b
 On a.parcelid = b.parcelid
 And a.[UniqueID ]<>b.[UniqueID ]
 Where a.propertyaddress is null

  --breaking out address into individual columns (address,city,state)

  Select  propertyaddress
  From PortfolioProject.dbo.NashvilliHousing

  Select 
  SUBSTRING(propertyaddress,1,charindex(',',propertyaddress)-1)as Address,
  SUBSTRING(propertyaddress,charindex(',',propertyaddress)+1,LEN(PropertyAddress))as Address
  From PortfolioProject.dbo.NashvilliHousing

 Alter table NashvilliHousing
 Add propertysplitaddress Nvarchar(255);


Update NashvilliHousing
Set propertysplitaddress = SUBSTRING(propertyaddress,1,charindex(',',propertyaddress)-1)

 
Alter table NashvilliHousing
Add propertysplitcity Nvarchar(255);


Update NashvilliHousing
Set propertysplitcity =  SUBSTRING(propertyaddress,charindex(',',propertyaddress)+1,LEN(PropertyAddress))

Select OwnerAddress
From  PortfolioProject.dbo.NashvilliHousing

Select
PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
From  PortfolioProject.dbo.NashvilliHousing

Alter table NashvilliHousing
 Add Ownersplitaddress Nvarchar(255);


Update NashvilliHousing
Set Ownersplitaddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)
 
Alter table NashvilliHousing
Add Ownersplitcity Nvarchar(255);


Update NashvilliHousing
Set Ownersplitcity =  PARSENAME(REPLACE(OwnerAddress,',','.'),2)

Alter table NashvilliHousing
Add Ownersplitstate Nvarchar(255);


Update NashvilliHousing
Set Ownersplitstate =  PARSENAME(REPLACE(OwnerAddress,',','.'),1)

Select*
From  PortfolioProject.dbo.NashvilliHousing

--Change y and N to YES AND NO in "Sold as Vacant" field

Select Distinct(SoldAsVacant),COUNT(SoldAsVacant)
From  PortfolioProject.dbo.NashvilliHousing
Group by SoldAsVacant
Order by 2

Select SoldAsVacant,
CASE When SoldAsVacant = 'Y' Then 'Yes'
     When SoldAsVacant = 'N' Then 'No'
	 ELSE SoldAsVacant
	 END
From  PortfolioProject.dbo.NashvilliHousing

Update NashvilliHousing
Set SoldAsVacant = CASE When SoldAsVacant = 'Y' Then 'Yes'
     When SoldAsVacant = 'N' Then 'No'
	 ELSE SoldAsVacant
	 END

--Remove Duplicates

With RowNumCTE AS(
Select*,
      ROW_NUMBER()OVER(
	  PARTITION BY ParcelID,
	               PropertyAddress,
				   SalePrice,
				   SaleDate,
				   LegalReference
				   ORDER BY
				      UniqueID
					  ) row_num
From  PortfolioProject.dbo.NashvilliHousing
)
Select*
From RowNumCTE
Where row_num>1
Order by PropertyAddress


Select*
From  PortfolioProject.dbo.NashvilliHousing

--Delete Unused Columns

Select*
From  PortfolioProject.dbo.NashvilliHousing

ALTER TABLE  PortfolioProject.dbo.NashvilliHousing
DROP COLUMN OwnerAddress,TaxDistrict,PropertyAddress

ALTER TABLE  PortfolioProject.dbo.NashvilliHousing
DROP COLUMN SaleDate


