Olist-SQL-Project (In Progress)
================================================

Exploratory Data Analysis (EDA)

AUTHORS: Meysam Motaharfar 

# Table of Contents
1. [Project Overview](#Project-Overview)
2. [Dataset Source and Overview](#Dataset-Source-And-Overview)
3. [Tools Used](#Tools-Used)
4. [Key Questions](#Key-Questions)
5. [Key Insights](#Key-Insights)
6. [Conclusions](#Conclusions)

# Project Overview

This project aims to conduct an Exploratory Data Analysis (EDA) using SQL on the publicly available Olist e-commerce dataset from Kaggle. The dataset provides comprehensive information about orders, customers, sellers, products, payments, and reviews within the context of a Brazilian e-commerce platform. The primary objective is to extract actionable insights related to customer behavior, sales performance, product popularity, and order dynamics.

In this analysis, we focus on answering critical business and data-driven questions to uncover trends and patterns that can guide future business decisions. The project uses SQL for data querying and PostgreSQL as the database management system for handling and analyzing the data.

# Dataset Source and Overview

The dataset for this project is publicly available on Kaggle and can be accessed [here](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce). Below is the schema illustrating the relationships between various tables within the dataset:

</br>
<div style="text-align: center;">
    <img width="1000" alt="Metrics" src="Data Base Diagram.png"> <!-- Increased width -->
</div>
</br>

For a deeper understanding of the database schema, the schema code can be found [here](Codes/Schema.sql).

# Tools Used

SQL: Structured Query Language for data querying.

PostgreSQL: The relational database management system (RDBMS) used to store and analyze the data.

# Key Questions

The project begins by addressing fundamental questions about each table individually. We then progressively combine tables to explore more complex queries and derive meaningful insights. The questions addressed in this analysis include:

**1) Product Categories**

Distinct Product Categories: Identifying the number of unique product categories available on the platform.

**2) Customers**

Customer Demographics: Analyzing the total number of customers and their geographic distribution across cities and states.

Customer Distribution: Understanding the average number of customers per city/state, and identifying the top cities/states by customer count.

Top Cities/States: Identifying the cities and states with the highest concentration of customers, as well as the top three cities per state.

Customer Concentration: Measuring the percentage of the total customer base located in the top ten cities and states.

**3) Sellers**

Seller Demographics: Analyzing the total number of sellers and their geographic distribution across cities and states.

Seller Distribution: Identifying the top cities and states with the highest concentration of sellers, and the top three cities per state.

Seller Concentration: Measuring the percentage of the total seller base in the top ten cities and states.

**4) Products**

Product Overview: Analyzing the total number of products and identifying the top ten categories with the highest product counts.

Product Characteristics: Examining various product attributes such as volume, density, weight, and dimensions, along with descriptive statistics for these features.

Top Categories by Product Characteristics: Identifying which product categories have the largest, heaviest, and densest products, and examining descriptive statistics for product attributes within the top ten categories.

**5) Orders**

Order Delivery Insights: Analyzing the overall delivery rate, how it changes over time, and delivery efficiency across years, quarters, and months.

Purchase Timing: Examining when customers are most likely to make purchases based on the time of day.

Approval and Delivery Times: Measuring the average approval time and carrier delivery time, and how these metrics change over time.

Order Delivery Accuracy: Analyzing how accurate the estimated delivery date is, and how it changes across different time periods.

Delivery Patterns: Identifying the most frequent purchase days, delivery days, and understanding how delivery and purchase behaviors shift over time.

The SQL queries used to answer these questions can be found [here](Codes/Olist-EDA.sql).

# key Insights

Some of the key findings from the analysis include:

# Conclusions

In Progress ...
