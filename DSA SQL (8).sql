#PostgreSQL
WITH measure_record AS (SELECT
CAST(measurement_time as Date) as measurement_day,
measurement_value,
Row_Number() Over(PARTITION BY CAST(measurement_time as Date)
ORDER BY measurement_time ASC) as meansure_num_rnk
FROM measurements)

SELECT measurement_day,
sum(measurement_value) FILTER(WHERE meansure_num_rnk % 2 != 0) AS odd_sum,
sum(measurement_value) FILTER(WHERE meansure_num_rnk % 2 = 0 ) AS even_sum
FROM measure_record
GROUP BY measurement_day;

#OR MySQL
WITH numbered_measurements AS (
    SELECT
        DATE(measurement_time) AS measurement_day,
        measurement_value,

        ROW_NUMBER() OVER (
            PARTITION BY DATE(measurement_time)
            ORDER BY measurement_time, measurement_id
        ) AS measurement_number

    FROM measurements
)

SELECT
    measurement_day,

    SUM(
        CASE
            WHEN measurement_number % 2 = 1
            THEN measurement_value
            ELSE 0
        END
    ) AS odd_sum,

    SUM(
        CASE
            WHEN measurement_number % 2 = 0
            THEN measurement_value
            ELSE 0
        END
    ) AS even_sum

FROM numbered_measurements
GROUP BY measurement_day
ORDER BY measurement_day;

#SWAPED ORDERS
#Zomato is a leading online food delivery service that connects users with various restaurants and cuisines, allowing them to browse menus, place orders, and get meals delivered to their doorsteps.
#Recently, Zomato encountered an issue with their delivery system. Due to an error in the delivery driver instructions, each item's order was swapped with the item in the subsequent row. As a data analyst, you're asked to correct this swapping error and return the proper pairing of order ID and item.
#If the last item has an odd order ID, it should remain as the last item in the corrected data. For example, if the last item is Order ID 7 Tandoori Chicken, then it should remain as Order ID 7 in the corrected data.
#In the results, return the correct pairs of order IDs and items.

WITH order_total AS (SELECT count(order_id) as tot_order
FROM orders)


SELECT 
order_id,
CASE
    WHEN order_id % 2 != 0 AND order_id != tot_order  THEN order_id + 1
    WHEN order_id % 2 != 0 AND order_id = tot_order THEN order_id
    ELSE order_id - 1
    END AS correct_order_id
  ,
item
from orders CROSS JOIN order_total
ORDER BY correct_order_id;