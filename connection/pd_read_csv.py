import pandas as pd


def read_csv_file(dir, name, set_header=0):
    return pd.read_csv(dir + '/' + name, header=set_header)
