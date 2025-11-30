# Inventory-Tracking-Reorder-Analysis
📦 Inventory Tracking & Reorder Analysis
​

📋 Project Overview
This project analyzes an inventory‑tracking dataset to identify products that need immediate reorder, understand where most inventory value is concentrated, and assess supplier lead times and stockout risk. The goal is to help the business reduce stockouts on high‑value SKUs and optimize reorder and safety‑stock policies.​

🧾 Dataset Description
Source table: inventory-tracking (one row per SKU).​

Key columns: ProductID, ProductName, QuantityInStock, ReorderPoint, Supplier, SupplierContact, LeadTime, StorageLocation, UnitCost, plus derived fields like InventoryValue and PriorityScore.​

🧹 Data Cleaning Steps
Checked data types for all columns and converted quantities, lead times, and unit costs to numeric types where needed.​

Identified and handled missing values (ProductID, ProductName, QuantityInStock, ReorderPoint, UnitCost, LeadTime) using counts of NULLs and business rules.​

Standardized text fields (ProductName, Supplier, StorageLocation) using TRIM and consistent casing to avoid duplicates.

Validated business rules (no negative quantities or costs, reasonable reorder points vs current stock) and flagged anomalies.​

Created derived columns such as InventoryValue = QuantityInStock * UnitCost and ReorderGap = QuantityInStock - ReorderPoint.​

Removed or merged duplicate SKUs based on ProductID and supplier and saved the cleaned table for analysis.​

🎯 Business Questions
Which products need immediate reorder (QuantityInStock ≤ ReorderPoint)?​

Which items hold the highest share of total inventory value?​

What is the total inventory value, and which suppliers have the longest average lead time?​

What are the total units and total value overall, by product, and by supplier?​

Which low‑inventory‑value items and storage locations might still create local stockout problems?​

Which SKUs have the highest priority to reorder when combining stock levels, value, and lead time?​

📊 Key Metrics & Logic
Immediate Reorder: filter SKUs where QuantityInStock <= ReorderPoint.​

Inventory Value: InventoryValue = QuantityInStock * UnitCost; rank descending to find high‑value items.​

Supplier Performance: group by Supplier to compute total value and average LeadTime.​

Priority Score (example): combine negative ReorderGap, InventoryValue, and LeadTime to rank reorder urgency.​

🔍 Main Findings (Example)
Desks, chairs, monitors, and tablets from key suppliers are at or below their reorder point while holding very high inventory value, creating high‑impact stockout risk.​

A small group of high‑value SKUs contributes a large share of total inventory value and therefore requires stricter monitoring and higher safety stock.​

Long‑lead‑time suppliers that provide these critical SKUs increase risk if reorders are delayed.​

🚀 Business Recommendations
Immediately reorder high‑priority SKUs where stock is below the reorder point and lead time is long.​

Review and adjust reorder points and safety‑stock levels for high‑value items (desks, chairs, monitors, tablets) to reduce future stockout risk.​

Work with key suppliers to improve lead times and reliability for critical SKUs and consider secondary suppliers where feasible.​

🛠️ Tech Stack
SQL (MySQL / compatible) for data cleaning and analysis.​

Optional: Excel / Power BI / Tableau for dashboarding and visualization of inventory KPIs.​

📂 Project Structure (Example)
sql/01_create_clean_table.sql – create cleaned inventory table.​

sql/02_eda_inventory.sql – exploratory queries for stock levels and value.​

sql/03_business_questions.sql – queries answering the business questions listed above.​

reports/inventory_insights.md – narrative summary for stakeholders.​

📜 How to Run
Load the raw dataset into a database as inventory-tracking.​

Run the data‑cleaning SQL script to create the cleaned inventory table.​

Execute analysis scripts to generate all metrics and priority lists, then export results or connect them to a BI tool.​

