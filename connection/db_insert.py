from pd_read_csv import read_csv_file


def get_insert_format(names_and_types, table):
    format = "INSERT INTO {}".format(table.lower()) + "("
    length = len(names_and_types)
    iteration = 0
    for name, type in names_and_types:
        if (iteration != length-1):
            format += name + ", "
        else:
            format += name + ") VALUES "
        iteration += 1
    return format


def get_values_format(names_and_types):
    format = "("
    length = len(names_and_types)
    iteration = 0
    for name, type in names_and_types:
        if (iteration != length-1):
            if (type == "TEXT" or type == "TIMESTAMP"):
                format += "'{}', "
            else:
                format += "{}, "
        else:
            if (type == "TEXT" or type == "TIMESTAMP"):
                format += "'{}')"
            else:
                format += "{})"
        iteration += 1
    return format


def get_execute_format(insert_format, values_format, table, names):
    data = read_csv_file('./data', table + '.csv')
    data_list = data[names].values.tolist()
    format = insert_format
    length = len(data_list)
    iteration = 0
    for row in data_list:
        row = [r.replace("'", "''") if (type(r) == str) else r for r in row]
        values = values_format.format(*row)
        format += values
        if (iteration != length-1):
            format += ", "
        iteration += 1
    format += ";"
    return format


def get_names(names_and_types):
    names = []
    for name, type in names_and_types:
        names.append(name)
    return names


def insert_data(conn, cursor, table, names_and_types):
    insert_format = get_insert_format(names_and_types, table)
    values_format = get_values_format(names_and_types)
    execute_format = get_execute_format(
        insert_format, values_format, table, get_names(names_and_types))
    cursor.execute(execute_format)
    conn.commit()
    return True
