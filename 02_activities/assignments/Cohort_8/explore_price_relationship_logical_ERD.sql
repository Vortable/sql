SELECT
v.product_id,
v.original_price,
cp.cost_to_customer_per_qty

FROM vendor_inventory v
INNER JOIN customer_purchases cp
	ON v.product_id = cp.product_id
GROUP BY v.product_id