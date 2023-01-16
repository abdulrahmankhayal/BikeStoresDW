# BikeStoresDW
Dimensional Modeling and ETL of BikeStores DB Using SSIS and implements Slowly Changing Dimension (SCD) handling using Merge statement.

## Data Model
![](https://github.com/abdulrahmankhayal/BikeStoresDW/blob/master/DW_Diagram.png)

## SSIS Packages

1. DimCustomers_TSQL: This package loads data into the DimCustomer dimension table.
2. DimProducts_TSQL: This package loads data into the DimProducts dimension table.
3. DimStores_TSQL: This package loads data into the DimStores dimension table.
4. FactOrders_TSQL: This package loads data into the FactOrders fact table.
