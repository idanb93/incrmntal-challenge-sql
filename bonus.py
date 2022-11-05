import psycopg2

report = {}


def dfs(dfs_cursor, cust_id, level, root_id):
    query = "SELECT item_id FROM item WHERE parent_item_id = '" + root_id + "' AND customer_id = '" + cust_id + "'"
    print(query)
    print(customer_id)
    dfs_cursor.execute(query)
    all_children = dfs_cursor.fetchall()
    all_children_fixed = [child[0] for child in all_children]
    for child_id in all_children_fixed:
        if report[cust_id]:
            report[cust_id][level] = report[cust_id][level] + 1
        else:
            report[cust_id][level] = 1
        dfs(dfs_cursor, cust_id, level+1, child_id)


try:
    connection = psycopg2.connect(
        host="localhost",
        database="incrmntal",
        user="postgres",
        password="root")
    cursor = connection.cursor()

    postgreSQL_select_Query = "select * from customer"

    cursor.execute(postgreSQL_select_Query)
    customers = cursor.fetchall()

    customers_ids = [customer_info[0] for customer_info in customers]
    for customer_id in customers_ids:
        report[customer_id] = {}
        dfs(cursor, customer_id, 1, '00000000-0000-0000-0000-000000000000')

    print(report)
except (Exception, psycopg2.Error) as error:
    print("Error while fetching data from PostgreSQL", error)

finally:
    # closing database connection.
    if connection:
        cursor.close()
        connection.close()
        print("PostgreSQL connection is closed")
