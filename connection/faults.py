import csv
from db_connect import connect, create_cursor, close_connection
from xml.etree.ElementTree import fromstring, ElementTree

with open('./data/Match.csv') as csv_file:
    connection = connect('db_connection', 'localhost',
                         'postgres', 'admin', '5432')
    cursor = create_cursor(connection)

    csv_reader = csv.reader(csv_file, delimiter=',')
    query = 'INSERT INTO faults (match_api_id, home_faults, away_faults)'
    inserts = []
    for row in csv_reader:
        if (len(row[80]) > 10):
            tree = ElementTree(fromstring(str(row[80])))
            root = tree.getroot()
            home_faults = 0
            away_faults = 0
            for x in root.findall('value'):
                try:
                    team = x.find('team')
                    if (team.text == str(row[7])):
                        home_faults += 1
                    else:
                        away_faults += 1
                except:
                    pass
            inserts.append('({0}, {1}, {2})'.format(
                row[6], home_faults, away_faults))

    query += ' VALUES ' + ', '.join(inserts)
    print(query)
    cursor.execute(query)
    connection.commit()
    close_connection(connection)
