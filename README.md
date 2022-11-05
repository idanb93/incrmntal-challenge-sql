Incrmntal SQL Challenge
=======================

In this repository you find scripts for spawning a database using Docker and applying database migrations to it
which will populate the DB with some tables and example data. You do not need to use Docker, but we find it a
convenient tool. You can as well just use a local postgres database
(for example [Postgres App on macOS](https://postgresapp.com/) or your linux distribution's postgres, for example
[on debian](https://packages.debian.org/bullseye/postgresql)).


Using the scripts
-----------------

```
    ./run.sh     Will spawn a docker container "incrmntal-challenge" and apply migrations+data to it.
                 localhost:5432 will host a postgres instance with a database called "incrmntal" in it.
                 Credentials to connect: user="challenger", password="T2xKc2L1GR"
    ./stop.sh    Will stop that container (shorthand for `docker stop incrmntal-challenge`).
    ./delete.sh  Will stop and remove that container.
    ./restart.sh Simply invoked ./delete.sh followed by ./run.sh
```

You can always start over and re-create the database by issuing `./restart.sh`.

Allow the migrations to run for a couple of minutes as they insert a few thousands rows to the database.


Using a vanilla database
------------------------

Just issue the migrations from the `migrations/` directory one by one.


Solving the challenge
---------------------

The challenges are to generate reports from the data in that test database. All challenges can be solved
by using PostgreSQL only, i.e. using only SQL queries. You are free however to generate the reports any way you want.
If you find it easier/more fitting to export some CSV and process that using Python (or any programming environment really)
you are free to do so.

Either way please provide the queries or scripts you used to generate the reports along with the reports so we can
get an understanding on how you are approaching the challanges presented here.

Please provide the reports in plain text like so:

```
+------------------------------------+------------------------------------------------------------------------------+
|id                                  |name                                                                          |
+------------------------------------+------------------------------------------------------------------------------+
|031ec5e8-43af-5939-b78d-80ab49176251|/train-times/portadown-to-london                                              |
|016f675f-1fd2-5222-939e-cd681e52a5f1|/train-times/birmingham-new-street-to-llandudno-junction/26-November-2021/1525|
|e7f83dab-232a-5f44-8ecc-ac2ac8d10d2f|train-times/london-euston-to-burnley-manchester-road                          |
|3ecff8fc-bc57-5516-9816-813e55552435|Reach Level 30 -- PPE                                                         |
|06fbd772-b3ef-5171-9442-2dd5e41a4537|UK_en_Destinations_222_Wellingborough [WEL]_BSH15E8                           |
|00941df5-4419-5964-90b3-59b2e6bfb92e|/en/train-times/bagni-di-tivoli-to-carsoli                                    |
|e7270b12-3163-513a-886e-a3360e799e66|train-times/southampton-to-wakefield                                          |
|5c064d42-d6fe-59ac-abf2-078fb3d922e1|Reach level 25 in Back Gammon- Lord of the Board -- TR_Backgammon_CPE_Level25 |
|01686df7-87b4-5f67-a41d-94839ea6026d|TW_MAP_KW5_US_IOS_EN                                                          |
|8894ec3e-888c-5c1b-8514-c5d570bf5d16|p-se-branding-always-on                                                       |
+------------------------------------+------------------------------------------------------------------------------+
```

Sometimes you are only asked to provide a single `count()` or `sum()`, just give the number then.


The Challenges
==============


Warm Up
-------

The database contains some pretty generic definitions. There are `customer` entities
which can have many `contact` items, each belong to a certain `contact_kind` (like
`email` or `address`).


**Challenge 0 (Example)** We would like to get a list of all email contacts in the system
so we can send a Newsletter. Please provide a report with the following information:

- `Customer` (the `display_name` from `customer`)
- `Contact` (the `display_name` from `contact`)
- `E-Mail Address` (the `value` from `contact`)

*Example solution:*

Query:

```sql
select cs.display_name as "Customer",
       c.display_name  as "Contact",
       c.value         as "E-Mail Address"
from customer cs
         join contact c on cs.customer_id = c.customer_id
         join contact_kind ck on c.contact_kind_id = ck.contact_kind_id
where ck.key = 'email'
order by cs.display_name;
```

Report:

```
+---------+------------------+------------------+
|Customer |Contact           |E-Mail Address    |
+---------+------------------+------------------+
|1&1      |Press             |press@1und1.de    |
|1&1      |Investor Relations|ir@1und1.de       |
|INCRMNTAL|Maor (Founder)    |maor@incrmntal.com|
|INCRMNTAL|Moti (Co-Founder) |moti@incrmntal.com|
+---------+------------------+------------------+
```


Items
-----

**Challenge 1** There is the `item` table which has items per customer. Generate
a report that breaks down how many items there are per customer. The table should
have the following columns:

- `Customer` (the `display_name` from `customer`)
- `count`

The table should be sorted by the customer's display name.


**Challenge 2** As you can see from the definition of the `item` table the available
items are organized in a hierarchy. Each item can have a parent item. By default every
client has an item which is the root of the hierarchy – the one row which has

```
parent_item_id = item_id = uuid_nil() = '00000000-0000-0000-0000-000000000000'
```

The items which are on the first level of the hierarchy are the ones which have this
root item as their parent and are themselves not that root item.

Generate the same report as in the previous challenge, but only taking into account
the respective items from the first level. Have the table again be sorted by the
customer's display name.


Analytics
---------

There are ads running for all the items. The performance of these ads is tracked in the `analytics` table.
The key metrics are `spend`, `impressions`, `clicks`, and `conversions`.


**Challenge 3** Lets get a feeling for the data first. The following questions ask for simple aggregations
(e.g. `count()`, `sum()`) of the data.

1. How many items are there in the database to begin with?
2. How many analytics rows are there in the database?
3. What are the sums of the four metrics?
4. What are the base 10 logarithms (`log()`) of these four sums?


**Challenge 4** There are some items for which there are no analytics rows in the database at all.
How many items are there which do not have analytics and which are not the `uuid_nil()` item?


**Challenge 5** Usually there are less clicks than impressions, as every click must have a preceeding impression.
Sometimes the data tells us there are more clicks than impressions, which is likely fraud. How many cases are there
(i.e. how many rows in the analytics table) for which there are more clicks than impressions?

Break down the result by customer and generate a report which features the customer's display name and the number
of occurrences where there are more clicks than impressions.


**Challenge 6** The analytics are per item per day. We do not necessarily have data for all days for each item, i.e.
there are items for which there are no analytics for some days. For how many days, on average, do we have analytics
per item?

Here is a quick example: For one item we might have data for 2022-02-03, 2022-02-04, and 2022-02-06 - so we have three
days of data for this item. For another item we might have data for seven days, so on average we would have data for
five days for these two items.

Please give the result rounded to a precision of two digits after the decimal point.


Bonus
-----

You do not need to solve the following challenge. It is for fun only 🤪


**Challenge N+1** Generate a report that breaks down how many entities each customer
has per level in the hierarchy. We are looking for a report like this:

```
+-------------+-----+-----+
|Customer     |level|count|
+-------------+-----+-----+
|1&1          |1    |17   |
|Amazon Europe|...  |...  |
|...          |...  |...  |
|1&1          |2    |199  |
|...          |...  |...  |
|1&1          |3    |826  |
|...          |...  |...  |
|1&1          |4    |847  |
|...          |...  |...  |
+-------------+-----+-----+
```

You can use this example to validate your report as the levels and counts for `1&1`
are correct /wrt to the data provided.

Remember that you are free to solve the challenges in SQL or using a scripting language
of your choice.

Using this report – can you answer the following questions?

- What is the deepest level that any customer has in their hierarchy?
- Are there customers which have a smaller number of levels in the hierarchy than that?
