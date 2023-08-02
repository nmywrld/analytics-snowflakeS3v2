from datetime import datetime  
import json
import os

# from airflow.models.baseoperator import chain
# from airflow.operators.empty import EmptyOperator
from airflow.models import DAG
from airflow.providers.snowflake.operators.snowflake import SnowflakeOperator
from airflow.operators.python import PythonOperator
from airflow.models.taskinstance import TaskInstance

from astro import sql as sql
from astro.files import File

from include.prefixMapping import prefixMapping
from include.terraformOutput import terraformOutput
import include.sql.sql_statements as sql_stmts
from include.extract_data import json_extract_selected


snowflake_default = "snowflake_default"

absolute_path = os.path.dirname(__file__)
relative_path = "../include/sql"
target_file = ""
sql_path = os.path.join(absolute_path, relative_path, target_file)



with DAG(
    "transform_data",
    start_date=datetime.now(),
    schedule_interval="@hourly",
    template_searchpath=sql_path,
    catchup=False
) as dag:
    
    def debug() :
        # include any operations and prints to debug your outputs.
        return

    def extract(**kwargs):
        col_names = []
        for name, datatype in prefixMapping[curr_prefix]["table_cols"].items():
            col_names.append(name)

        data = json.loads(TaskInstance.xcom_pull(self=TaskInstance, task_ids="get_json_content_from_file_in_stage", dag_id="transform_data",key="return_value")[0]['$1'])

        data_to_insert = ', '.join(f"'{w}'" for w in json_extract_selected(data, col_names))

        kwargs["ti"].xcom_push(key='extracted_data', value=data_to_insert)

    # get files in stage
    # for each file:
        # save full path
        # get prefix then get table
        # get json from file
        # insert values in json into table

    curr_file = ""
    curr_prefix = ""
    curr_table = ""

    list_files = SnowflakeOperator(
        # snowflake_conn_id="snowflake_default" 
        ## this is auto provisioned. as long as snowflake configuration is done properly in airflow after "astro dev start", this will work
        task_id = "list_all_files_in_stage",
        sql = sql_stmts.list_stage_items,
        params = {"stage_name":terraformOutput["snowflake_stage"]["value"]},
    )

    for file in TaskInstance.xcom_pull(self=TaskInstance, task_ids="list_all_files_in_stage", dag_id="transform_data"):
        # get full file path from stage
        full_file_path = file['name']

        # filter to get path from file (prefix/file)
        curr_file = full_file_path.replace(terraformOutput["s3_bucket_url"]["value"], "")

        # filter to get prefix of file
        curr_prefix = curr_file[:curr_file.index("/")]

        # use curr_prefix to get table name from prefix mappings
        curr_table = prefixMapping[curr_prefix]["table_name"]


        json_res = SnowflakeOperator(
                task_id = "get_json_content_from_file_in_stage",
                sql = sql_stmts.get_json_content,
                params = {"file_path" : f"{terraformOutput['snowflake_stage']['value']}/{curr_file}"},
                trigger_rule="all_done"
            )
    
        col_names = []

        for name, datatype in prefixMapping[curr_prefix]["table_cols"].items():
            name.upper()
            col_names.append(name)

        # get array of data points ready to insert into table (refer to include/extract_data.py)
        # we want to handle list of values differently (assuming they are multi values)
        # ASSUMPTION: colnames are the same as keys interested json file, data_points is in the same order as cols
        data_points =  PythonOperator(
            task_id = "extract_values",
            provide_context=True,
            python_callable=extract,
            trigger_rule = "all_done"
        )

        # insert into table
        insert_to_table = SnowflakeOperator(
            task_id = "insert_data_into_columns",
            sql = sql_stmts.insert_into_table,
            params = {
                "table_name": curr_table, 
                "col_names" : ", ".join(col_names)
                },
            trigger_rule="all_done"
        )

        list_files>>json_res>>data_points>>insert_to_table 

        # debug= PythonOperator(
        #     task_id="debug",
        #     python_callable=debug
        # )


  