# E-commerce Sales Performance & Customer Insights Analysis

## Table of Contents
- [Overview](#overview)
- [Business Problem](#business-problem)
- [Data Overview](#data-overview)
- [Data Modeling Approach](#data-modeling-approach)
- [Analytical Approach](#analytical-approach)
- [Business Questions Addressed](#business-questions-addressed)
- [Key Insights](#key-insights)
- [Business Recommendations](#business-recommendations)
- [Project Structure](#project-structure)
- [Notes & Assumptions](#notes--assumptions)

---

## Overview
This project analyzes e-commerce sales data to understand revenue trends, product and category performance, platform effectiveness, geographic contribution, and customer experience signals. The analysis is designed to answer real business questions and support data-driven decision-making.

---

## Business Problem
Stakeholders want to understand:
- How revenue performs over time
- Which products and categories drive sales
- How platforms and cities contribute to revenue
- Where customer experience risks and growth opportunities exist

The objective is to provide insights that inform product strategy, platform investment, marketing focus, and customer experience improvements.

---

## Data Overview
The dataset represents transactional e-commerce orders and includes:
- Order-level sales data (date, quantity, revenue)
- Product attributes (product, brand, category)
- Platform and city information
- Customer experience indicators (ratings and reviews)

Raw data was cleaned, validated, and transformed for analytical use.

---

## Data Modeling Approach
The data was modeled using a star schema to separate transactional facts from descriptive dimensions. This approach improves query performance, simplifies analysis, and reflects common analytics warehouse design patterns.

The model includes:
- A central fact table capturing sales metrics
- Dimension tables for date, product, platform, and city

---

## Analytical Approach
The analysis followed a structured workflow:
1. Data cleaning and validation
2. Dimensional modeling for analytics-ready data
3. Aggregation and ranking to identify key performance drivers
4. Time-based analysis to evaluate trends and stability
5. Translation of results into business insights and recommendations

---

## Business Questions Addressed
- How does revenue trend month over month?
- Which months perform best and worst?
- Which products and categories generate the most revenue?
- How does performance vary by platform and city?
- Which cities drive platform-specific revenue?
- Which products generate high revenue but receive low ratings?
- Are there high-rated products with untapped revenue potential?
- How stable is revenue when viewed using rolling trends?
- Which categories dominate revenue by month?

---

## Key Insights
- Revenue remains relatively stable throughout the year, with a noticeable peak in mid-year and a decline toward year-end.
- A small group of products contributes a disproportionate share of total revenue.
- Platform performance is balanced overall, but platform dominance varies by city.
- Several high-revenue products receive below-average ratings, indicating potential customer experience risks.
- Revenue and customer ratings do not always move together.
- Rolling revenue trends show consistent performance without extreme volatility.

---

## Business Recommendations
- Prioritize inventory and promotional planning around top-performing months and products.
- Investigate customer feedback for high-revenue, low-rated products to mitigate long-term risk.
- Apply city-specific strategies for platform optimization rather than uniform campaigns.
- Increase visibility for high-rated products that currently underperform in revenue.
- Use rolling revenue trends for executive reporting and forecasting.

---

## Project Structure

ecommerce-sales-performance-analysis/

│

├── README.md

├── INSIGHTS.md

│

├── sql/

│   ├── 01_model.sql        -- data modeling and table creation

│   ├── 02_analysis.sql     -- business question queries

│   └── 03_validation.sql   -- data quality checks

---

## Notes & Assumptions
- The analysis is based on a single year of transactional data.
- Revenue values are assumed to be final and do not account for refunds or cancellations.
- Insights are intended to guide strategic discussion rather than serve as formal forecasts.

