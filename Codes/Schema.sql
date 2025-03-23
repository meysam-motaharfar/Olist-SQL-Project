CREATE TABLE "customer"(
    "customer_id" VARCHAR(50) NOT NULL,
    "customer_unique_id" VARCHAR(50) NOT NULL,
    "customer_zip_code_prefix" INTEGER NOT NULL,
    "customer_city" VARCHAR(50) NOT NULL,
    "customer_state" VARCHAR(50) NOT NULL
);
ALTER TABLE
    "customer" ADD PRIMARY KEY("customer_id");
CREATE TABLE "geolocation"(
    "geolocation_zip_code_prefix" INTEGER NOT NULL,
    "geolocation_lat" DECIMAL NOT NULL,
    "geolocation_lng" DECIMAL NOT NULL,
    "geolocation_city" VARCHAR(50) NOT NULL,
    "geolocation_state" VARCHAR(10) NOT NULL
);
CREATE TABLE "leads_closed"(
    "mql_id" VARCHAR(50) NOT NULL,
    "seller_id" VARCHAR(50) NOT NULL,
    "sdr_id" VARCHAR(50) NOT NULL,
    "sr_id" VARCHAR(50) NOT NULL,
    "won_date" TIMESTAMP NOT NULL,
    "business_segment" VARCHAR(50),
    "lead_type" VARCHAR(50),
    "lead_behaviour_profile" VARCHAR(50),
    "has_company" DECIMAL,
    "has_gtin" DECIMAL,
    "average_stock" VARCHAR(10),
    "business_type" VARCHAR(50),
    "declared_product_catalog_size" DECIMAL,
    "declared_monthly_revenue" DECIMAL
);
ALTER TABLE
    "leads_closed" ADD PRIMARY KEY("mql_id");
CREATE TABLE "leads_qualified"(
    "mql_id" VARCHAR(50) NOT NULL,
    "first_contact_dat" DATE,
    "landing_page_id" VARCHAR(50),
    "origin" VARCHAR(50)
);
ALTER TABLE
    "leads_qualified" ADD PRIMARY KEY("mql_id");
CREATE TABLE "order_items"(
    "order_id" VARCHAR(50) NOT NULL,
    "order_item_id" INTEGER,
    "product_id" VARCHAR(50),
    "seller_id" VARCHAR(50),
    "shipping_limit_date" DATE,
    "price" DECIMAL,
    "freight_value" DECIMAL
);
CREATE TABLE "order_payments"(
    "order_id" VARCHAR(50) NOT NULL,
    "payment_sequential" INTEGER,
    "payment_type" VARCHAR(50),
    "payment_installments" INTEGER,
    "payment_value" DECIMAL(8, 2)
);
CREATE TABLE "order_reviews"(
    "order_reviews" VARCHAR(50) NOT NULL,
    "order_id" VARCHAR(50),
    "review_score" INTEGER,
    "review_comment_title" VARCHAR(255),
    "review_comment_message" VARCHAR(255),
    "review_creation_date" TIMESTAMP,
    "review_answer_timestamp" TIMESTAMP
);
CREATE TABLE "orders"(
    "order_id" VARCHAR(50) NOT NULL,
    "customer_id" VARCHAR(50),
    "order_status" VARCHAR(50),
    "order_purchase_timestamp" TIMESTAMP,
    "order_approved_at" TIMESTAMP,
    "order_delivered_carrier_date" TIMESTAMP,
    "order_delivered_customer_date" TIMESTAMP,
    "order_estimated_delivery_date" TIMESTAMP
);
ALTER TABLE
    "orders" ADD PRIMARY KEY("order_id");
CREATE TABLE "product_category_name_translation"(
    "product_category_name" VARCHAR(255) NOT NULL,
    "product_category_name_english" VARCHAR(255)
);
ALTER TABLE
    "product_category_name_translation" ADD PRIMARY KEY("product_category_name");
CREATE TABLE "products"(
    "product_id" VARCHAR(50) NOT NULL,
    "product_category_name" VARCHAR(50),
    "product_name_lenght" DECIMAL,
    "product_description_lenght" DECIMAL,
    "product_photos_qty" DECIMAL,
    "product_weight_g" DECIMAL,
    "product_length_cm" DECIMAL,
    "product_height_cm" DECIMAL,
    "product_width_cm" DECIMAL
);
ALTER TABLE
    "products" ADD PRIMARY KEY("product_id");
CREATE TABLE "sellers"(
    "seller_id" VARCHAR(50) NOT NULL,
    "seller_zip_code_prefix" INTEGER,
    "seller_city" VARCHAR(50),
    "seller_state" VARCHAR(10)
);
ALTER TABLE
    "sellers" ADD PRIMARY KEY("seller_id");
ALTER TABLE
    "leads_closed" ADD CONSTRAINT "leads_closed_mql_id_foreign" FOREIGN KEY("mql_id") REFERENCES "leads_qualified"("mql_id");
ALTER TABLE
    "order_items" ADD CONSTRAINT "order_items_product_id_foreign" FOREIGN KEY("product_id") REFERENCES "products"("product_id");
ALTER TABLE
    "order_payments" ADD CONSTRAINT "order_payments_order_id_foreign" FOREIGN KEY("order_id") REFERENCES "orders"("order_id");
ALTER TABLE
    "orders" ADD CONSTRAINT "orders_customer_id_foreign" FOREIGN KEY("customer_id") REFERENCES "customer"("customer_id");
ALTER TABLE
    "order_reviews" ADD CONSTRAINT "order_reviews_order_id_foreign" FOREIGN KEY("order_id") REFERENCES "orders"("order_id");
ALTER TABLE
    "products" ADD CONSTRAINT "products_product_category_name_foreign" FOREIGN KEY("product_category_name") REFERENCES "product_category_name_translation"("product_category_name");
ALTER TABLE
    "leads_closed" ADD CONSTRAINT "leads_closed_seller_id_foreign" FOREIGN KEY("seller_id") REFERENCES "sellers"("seller_id");
ALTER TABLE
    "order_items" ADD CONSTRAINT "order_items_order_id_foreign" FOREIGN KEY("order_id") REFERENCES "orders"("order_id");
ALTER TABLE
    "order_items" ADD CONSTRAINT "order_items_seller_id_foreign" FOREIGN KEY("seller_id") REFERENCES "sellers"("seller_id");