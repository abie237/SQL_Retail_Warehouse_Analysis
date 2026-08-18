
-- Stakeholders Business Questions



-- 1. Which products contribute the most to revenue, and which products have the highest and lowest average selling price?
		
		WITH product_revenue AS (
		    SELECT
		        p.product_id,
		        SUM(oi.qty * oi.price) AS total_revenue
		    FROM order_items oi
		    JOIN products p
		        ON p.product_id = oi.product_id
		    GROUP BY p.product_id
		)
		SELECT *
		FROM product_revenue
		ORDER BY total_revenue DESC;
				
		---- Highest/lowest average selling price
		with average_selling_prices
		AS
		(
		Select 
			product_id,
			ROUND(SUM(price*qty)::numeric / SUM(qty), 2) AS average_selling_price
		from order_items
		group by product_id
		)
		select
		*
		from average_selling_prices
		where
		 average_selling_price = (select max(average_selling_price) from average_selling_prices)
		 OR
		 average_selling_price = (select min(average_selling_price) from average_selling_prices)
		 
-- 2. What are the top-selling product categories by quantity and by revenue, and how do they vary by store or city?

   --- i.  
	        SELECT
			    c.category_name,
			    SUM(oi.qty) AS total_qty_ordered
			FROM order_items oi
			JOIN products p
			    ON oi.product_id = p.product_id
			JOIN categories c
			    ON p.category_id = c.category_id
			GROUP BY c.category_name
			ORDER BY total_qty_ordered DESC;
	-- ii.
	        SELECT
			    c.category_name,
			    SUM(oi.qty * oi.price) AS total_revenue
			FROM order_items oi
			JOIN products p
			    ON oi.product_id = p.product_id
			JOIN categories c
			    ON p.category_id = c.category_id
			GROUP BY c.category_name
			ORDER BY total_revenue DESC;
	-- iii.
	        SELECT
			    s.city,
			    s.store_id,
			    c.category_name,
			    SUM(oi.qty) AS total_qty_ordered
			FROM orders o
			JOIN stores s
			    ON o.store_id = s.store_id
			JOIN order_items oi
			    ON o.order_id = oi.order_id
			JOIN products p
			    ON oi.product_id = p.product_id
			JOIN categories c
			    ON p.category_id = c.category_id
			GROUP BY s.city, s.store_id, c.category_name
			ORDER BY total_qty_ordered DESC;
	--iv
	        SELECT
			    s.city,
			    s.store_id,
			    c.category_name,
			    SUM(oi.qty * oi.price) AS total_revenue
			FROM orders o
			JOIN stores s
			    ON o.store_id = s.store_id
			JOIN order_items oi
			    ON o.order_id = oi.order_id
			JOIN products p
			    ON oi.product_id = p.product_id
			JOIN categories c
			    ON p.category_id = c.category_id
			GROUP BY s.city, s.store_id, c.category_name
			ORDER BY total_revenue DESC;
	 
	   
		
		
-- 3. Which suppliers provide the most profitable products, and which suppliers are associated with the highest-return items?

  -- find the most profitable products
     select 
	    s.supplier_id,
		p.product_id,
		sum(oi.qty*oi.price) as total_revenue
	 from order_items oi
	 join products  p
	 	on oi.product_id = p.product_id
	 join suppliers s
	 	on s.supplier_id = p.supplier_id
	 group by s.supplier_id,p.product_id
	 order by total_revenue DESC
  -- supplier associated with the highest returns
    select 
	    s.supplier_id,
		count(r.return_id) as number_of_returns
	from returns r
	join order_items oi
		on r.order_item_id = oi.order_item_id
	join products p
		on p.product_id = oi.product_id
	 join suppliers s
	 	on s.supplier_id = p.supplier_id
	 group by s.supplier_id
	 order by number_of_returns DESC

-- 4. What is the customer retention pattern, and how many customers place repeat orders after their first purchase?

	-- find customers that placed more than one order, this first and last order dates
	with customer_orders
	as
	(
	select
	    customer_id,
		count(*) as order_count,
		min(order_date) as first_order_date,
		max(order_date) as last_order_date
	from orders
	GROUP BY customer_id
	order by order_count DESC
	)
	-- retention rate
	select 
	 	count(*) as total_customers,
		count(*) FILTER(where order_count >=2) total_repeating_orders_customers,
		ROUND(
			count(*) FILTER(where order_count >=2)::numeric * 100
			/ count(*)
		,2) as repeated_order_rate
	FROM customer_orders
	

-- 5. Which customers have the highest lifetime value, and how does their ordering behavior differ from other customers?

   with order_totals AS(
         Select 
		 	o.customer_id,
			o.order_id,
			COALESCE(sum(oi.qty*oi.price),2) as order_total
		from orders o
		left join order_items oi
				on o.order_id = oi.order_id
		group by o.customer_id, o.order_id
   )
   select customer_id,
   sum(order_total) AS total_orders_amt,
   count(*)  AS number_of_orders,
     ROUND(AVG(order_total)::numeric, 2) AS average_order_amt
	FROM order_totals
	GROUP BY customer_id
	ORDER BY total_orders_amt DESC, number_of_orders DESC, average_order_amt DESC;

	select count(*)
	from orders
	where customer_id = 33455
-- 6. What is the average order value by store, by city, and by promotion usage?

	-- find the order value by store

	    Select 
			s.store_id,
			Round(sum(oi.qty*oi.price)::numeric/sum(qty),2) average_order_value
		from orders o
		left join order_items oi
			on o.order_id = oi.order_id
		join stores s 
			on o.store_id = s.store_id
		group by s.store_id
		order by average_order_value DESC

	-- order value by city
	   Select 
			s.city,
			Round(sum(oi.qty*oi.price)::numeric/sum(qty),2) average_order_value
		from orders o
		left join order_items oi
			on o.order_id = oi.order_id
		join stores s 
			on o.store_id = s.store_id
		group by s.city
		order by average_order_value DESC

	-- average value by promotion_d
	   Select 
			o.promotion_id,
			Round(sum(oi.qty*oi.price)::numeric/sum(qty),2) average_order_value
		from orders o
		left join order_items oi
			on o.order_id = oi.order_id
		join stores s 
			on o.store_id = s.store_id
		group by o.promotion_id
		order by o.promotion_id DESC
	

-- 7. How do promotions affect order volume, revenue, and discount performance over time?

   -- order volumes, revenue according to each promotion
   WITH promos 
   AS
   (
	   select 
	    p.promotion_id,
		sum(oi.qty*oi.price) as revenue,
	   	count(oi.qty) as order_volume
	   from order_items oi
	   left join orders o
	   	on oi.order_id = o.order_id
	   join promotions p
	   	on o.promotion_id = p.promotion_id
		group by p.promotion_id
		order by order_volume DESC, revenue DESC
		)

		select 
			promos.promotion_id,
			promos.revenue,
			promos.order_volume,
			promotions.discount
		from promos
		left join promotions
			on promos.promotion_id = promotions.promotion_id
		order by order_volume DESC, promos.revenue DESC


	

-- 8. What is the return rate by product, category, supplier,  items are most frequently refunded?
       -- return rate
	   -- i learned that a view must always end with a select statement
     -- with sold items as 
		CREATE VIEW refunded_items_view AS
		WITH sold_items AS (
		    SELECT 
		        oi.product_id,
		        SUM(qty) AS qty_ordered
		    FROM order_items oi
		    GROUP BY oi.product_id
		),
		refunded_items AS (
		    SELECT 
		        oi.product_id,
		        c.category_name,
		        p.supplier_id,
		        SUM(oi.qty) AS qty_returned
		    FROM returns r
		    JOIN order_items oi
		        ON r.order_item_id = oi.order_item_id
		    LEFT JOIN products p
		        ON oi.product_id = p.product_id
		    LEFT JOIN categories c
		        ON p.category_id = c.category_id
		    GROUP BY oi.product_id, c.category_name, p.supplier_id
		)

		SELECT
		    si.product_id,
		    si.qty_ordered,
			COALESCE(ri.qty_returned,0) AS qty_returned,
			ROUND((COALESCE(ri.qty_returned,0) * 100)/si.qty_ordered, 2) as return_rate,
		    ri.category_name,
		    ri.supplier_id
		FROM sold_items si
		LEFT JOIN refunded_items ri
		    ON si.product_id = ri.product_id

			-- return_rate per product
			SELECT
			    product_id,
			    SUM(qty_ordered) AS total_ordered,
			    SUM(qty_returned) AS total_returned,
			    ROUND((SUM(qty_returned) * 100.0) / SUM(qty_ordered), 2) AS return_rate,
				DENSE_RANK() OVER(
							order by ROUND((SUM(qty_returned) * 100.0)
							/ SUM(qty_ordered), 2) DESC) as most_returned_rank
			FROM refunded_items_view
			GROUP BY product_id
			ORDER BY return_rate DESC;

			-- return_rate per category
			SELECT
			    category_name,
			    SUM(qty_ordered) AS total_ordered,
			    SUM(qty_returned) AS total_returned,
			    ROUND((SUM(qty_returned) * 100.0) / SUM(qty_ordered), 2) AS return_rate
			FROM refunded_items_view
			GROUP BY category_name
			ORDER BY return_rate DESC;

			-- return_rate per supplier
			SELECT
			    supplier_id,
			    SUM(qty_ordered) AS total_ordered,
			    SUM(qty_returned) AS total_returned,
			    ROUND((SUM(qty_returned) * 100.0) / SUM(qty_ordered), 2) AS return_rate
			FROM refunded_items_view
			GROUP BY supplier_id
			ORDER BY return_rate DESC;



-- 9. How efficient are shipments, and what is the relationship between order date ?
		SELECT
		    status,
		    COUNT(*) AS total_shipments,
		    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS percentage
		FROM shipments
		GROUP BY status
		ORDER BY percentage DESC;

