import pandas as pd
import re
import yaml
import snowflake.connector
from snowflake.connector.pandas_tools import write_pandas

def normalize_text(text):
    if pd.isnull(text):
        return ''
    return re.sub(r'\s+', ' ', str(text).strip().title())

def get_snowflake_connection_from_yaml(yaml_path='snowflake_creds.yaml'):
    """
    Read all Snowflake connection values from a YAML file and return a connection object.
    """
    with open(yaml_path, 'r') as f:
        creds = yaml.safe_load(f)
        conn = snowflake.connector.connect(
        user=creds['username'],
        password=creds['password'],
        account=creds['account'],
        warehouse=creds.get('warehouse'),
        database=creds.get('database'),
        schema=creds.get('schema'),
        role=creds.get('role')
    )
    return conn

def write_df_to_snowflake_with_mapping(df, table_name, conn, schema='PUBLIC'):
    conn = get_snowflake_connection_from_yaml()
    cursor = conn.cursor()
    cursor.execute(f"SHOW COLUMNS IN {schema}.{table_name}")
    table_columns = [row[2] for row in cursor.fetchall()]
    cursor.close()
    df_mapped = df.append()
    col_map = {col: next((tc for tc in table_columns if tc.lower() == col.lower()), col) for col in df.columns}
    df_mapped.rename(columns=col_map, inplace=True)
    df_mapped = df_mapped[[col for col in table_columns if col in df_mapped.columns]]
    return write_pandas(conn, df_mapped, table_name, schema=schema, quote_identifiers=False)

def pad_id(prod_id, padlen=6):
    m = re.match(r'^PROD(\d+)$', str(prod_id).strip())
    if m:
        return f'PROD{m.group(1).zfill(padlen)}'
    return prod_id


