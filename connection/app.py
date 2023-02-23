from pd_read_csv import read_csv_file
from db_connect import connect, create_cursor, close_connection
from db_insert import insert_data


def get_names_and_types(table):
    format = read_csv_file('./format', table + '.csv', None)
    return [line.split()[0:2] for line in list(format[0])]


def auto_insert_data(conn, cursor, table):
    names_and_types = get_names_and_types(table)
    return insert_data(conn, cursor, table, names_and_types)


connection = connect('db_connection', 'localhost', 'postgres', 'admin', '5432')
cursor = create_cursor(connection)

# print('Country', auto_insert_data(connection, cursor, 'Country'))
# print('League', auto_insert_data(connection, cursor, 'League'))
# print('Team', auto_insert_data(connection, cursor, 'Team'))

print('Player', auto_insert_data(connection, cursor, 'Player'))

close_connection(connection)
