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

This project focuses on performing an Exploratory Data Analysis (EDA) using SQL on the publicly available Olist e-commerce dataset from Kaggle. The dataset contains information about orders, customers, sellers, products, payments, and reviews from a Brazilian e-commerce platform. The goal is to extract meaningful insights by analyzing customer behavior, sales trends, product performance, and order dynamics.

# Dataset Source and Overview

For this analysis, I used the publicly available Olist dataset from Kaggle, which can be found[here](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce). Below is the schema illustrating the relationships between the tables:

</br>
<div style="text-align: center;">
    <img width="1000" alt="Metrics" src="Data Base Diagram.png"> <!-- Increased width -->
</div>
</br>

The schema code can be found [here](Codes/Schema.sql).

# Tools Used

SQL

PostgreSQL

# Key Questions

We start by answering questions for each table individually, then progressively introduce more complex queries by combining multiple tables. Here are the questions we address in this project:

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

The queries to answer these questions is available ![here](Codes/Olist-EDA.sql)

# key Insights

# Conclusions

In Progress ...
