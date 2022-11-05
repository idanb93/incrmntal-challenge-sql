-- Challenge 1

SELECT cs.display_name as "Customer", count
FROM customer cs
JOIN (
  SELECT customer_id, count(*) as count
  FROM item
  GROUP BY customer_id
) it
ON it.customer_id = cs.customer_id
ORDER BY cs.display_name ASC;

--    Customer    | count
-- ---------------+-------
--  1&1           |  1890
--  Amazon Europe |  3555
--  Honda Motors  |   261
--  INCRMNTAL     |   263


-- Challenge 2

SELECT cs.display_name as "Customer", count
FROM customer cs
JOIN (
  SELECT customer_id, count(*)-1 as count
  FROM item
  WHERE parent_item_id = uuid_nil()
  GROUP BY customer_id
) it
ON it.customer_id = cs.customer_id
ORDER BY cs.display_name ASC;

--    Customer    | count
-- ---------------+-------
--  1&1           |    17
--  Amazon Europe |    17
--  Honda Motors  |    15
--  INCRMNTAL     |    10


-- Challenge 3

  -- Question 1

  SELECT count (*)
  FROM (
    SELECT distinct item_id
    FROM item
  ) as all_items_in_db;

  --  5966

  -- Question 2

  SELECT count(*) FROM analytics;

  -- 144591

  -- Question 3

  SELECT
  sum(spend) as spend_sum,
  sum(impressions) as impressions_sum,
  sum(clicks) as clicks_sum,
  sum(conversions) as conversions_sum
  FROM analytics;

  --      spend_sum     |  impressions_sum   |     clicks_sum     |  conversions_sum
  -- -------------------+--------------------+--------------------+--------------------
  --  218014207452.9145 | 21758016535.823174 | 2204436029.1046214 | 213336423.39954007

  -- Questionn 4

  SELECT
  LOG10(sum(spend)) as spend_sum,
  LOG10(sum(impressions)) as impressions_sum,
  LOG10(sum(clicks)) as clicks_sum,
  LOG10(sum(conversions)) as conversions_sum
  FROM analytics;

  --      spend_sum      |  impressions_sum   |    clicks_sum     |  conversions_sum
  -- --------------------+--------------------+-------------------+-------------------
  --  11.338484796436486 | 10.337619302477941 | 9.343297500481473 | 8.329065009837583


-- Challenge 4

SELECT count(*)
FROM
(
  SELECT DISTINCT item_id
  FROM item
  WHERE item_id != uuid_nil()
  AND item_id NOT IN (
    SELECT DISTINCT item_id
    FROM analytics
  )
) as items_without_analytics;

-- 399


-- Challenge 5

SELECT cs.display_name as "Customer", count
FROM customer cs
JOIN (
  SELECT customer_id, count(*) as count
  FROM analytics
  WHERE clicks > impressions
  GROUP BY customer_id
) it
ON it.customer_id = cs.customer_id;

--    Customer    | count
-- ---------------+-------
--  INCRMNTAL     |   185
--  Amazon Europe |  4421
--  1&1           |  2496
--  Honda Motors  |   261


-- Challenge 6

SELECT CAST(AVG(appearance) as decimal(10,2))
FROM (
  SELECT item_id, count(*) as appearance
  FROM analytics
  GROUP BY item_id
) as item_appearances;

-- 25.98