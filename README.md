Olist
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

1) PRODUCT_CATEGORY_NAME_TRANSLATION:
   
   How many distinct category is there?

2) CUSTOMERS

   How many customers are there?
    
   How many distinct cities and states are there?
    
   What is the average number of customers per city or state?
    
   Which are the top ten cities with the most customers?
    
   How many cities have more than 500 customers?
    
   Which are the top ten states with the most customers?
    
   How many cities are there per state?
    
   What percentage of the customer base do the top ten cities account for?
    
   What percentage of the customer base do the top ten states account for?
    
   What are the top three cities with the most customers in each state?
    
   What percentage of the total customer base does the top three cities in each state account for?

The queries to answer these questions are available [here](Codes/Olist-EDA.sql).

# key Insights

# Conclusions

In Progress ...
