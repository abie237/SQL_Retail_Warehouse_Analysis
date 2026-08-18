DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS promotions;
DROP TABLE IF EXISTS returns;
DROP TABLE IF EXISTS shipments;
DROP TABLE IF EXISTS stores;
DROP TABLE IF EXISTS suppliers;

-- tip : " First Create the independent tables who do not have foreign key dependent columns in case the child table does not exist yet"
Create table categories(
	 category_id integer PRIMARY KEY,
	 category_name varchar(50)
) -- 1st created table

Create table customers(
	 customer_id integer PRIMARY KEY,
	 city varchar(50),
	 signup_date date
) -- 4th created table

Create table employees(
	 employee_id integer PRIMARY KEY,
	 store_id integer,
	 salary integer,
	 constraint fk_store
	 	FOREIGN KEY (store_id)
		references stores(store_id)
) --6th execution

Create table order_items(
	 order_item_id integer PRIMARY KEY,
	 order_id integer,
	 product_id integer,
	 qty integer,
	 price integer,
	 Constraint fk_order_3
		 FOREIGN KEY (order_id)
		 REFERENCES orders(order_id),
	 Constraint fk_product
	 	FOREIGN KEY (product_id)
		REFERENCES products(product_id)
) -- 11th Execution

Create table orders(
	 order_id integer PRIMARY KEY,
	 customer_id integer,
	 store_id integer,
	 order_date date,
	 promotion_id integer,
	 Constraint fk_customer
		 FOREIGN KEY (customer_id)
		 REFERENCES customers(customer_id),
	 Constraint fk_store
		 FOREIGN KEY (store_id)
		 REFERENCES stores(store_id),
	 Constraint fk_promotion
		 FOREIGN KEY (promotion_id)
		 REFERENCES promotions(promotion_id)
) --8th Execution

Create table payments(
	 payment_id integer PRIMARY KEY,
	 order_id integer,
	 amount integer,
	 Constraint fk_order
	 	FOREIGN KEY (order_id)
		REFERENCES orders(order_id)
) -- 9th Execution
Create table products(
	 product_id integer PRIMARY KEY,
	 category_id integer, -- FK category table
	 supplier_id integer, -- FK supplier id
	 price integer,
	 CONSTRAINT fk_category
	 	FOREIGN KEY (category_id)
		 REFERENCES categories(category_id),
	CONSTRAINT fk_supplier
		FOREIGN KEY(supplier_id)
		REFERENCES suppliers(supplier_id)
) --7th execution
Create table promotions(
	 promotion_id integer Primary Key,
	 discount integer	 
) -- 5th Execution
Create table returns(
	 return_id integer Primary Key,
	 order_item_id integer,
	 refund integer,
	 Constraint fk_order_item1
	 	FOREIGN KEY (order_item_id)
		REFERENCES order_items(order_item_id)
) -- 12th Execution
Create table shipments(
	 shipment_id integer Primary Key,
	 order_id integer,
	 status varchar(50),
	 Constraint fk_order_2
	 	FOREIGN KEY (order_id)
		REFERENCES orders(order_id)
) -- 9th Execution
Create table stores(
	store_id integer PRIMARY KEY,
	city varchar(50) not NULL
) -- 3rd table created
Create table suppliers(
	supplier_id integer PRIMARY KEY,
	country varchar(50) not NULL
) -- 2nd table created




-- promotions, returns, shipments



