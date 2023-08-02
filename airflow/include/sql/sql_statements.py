list_stage_items = """
    LIST @{{ params.stage_name }}
"""

get_json_content = """
    SELECT $1 from @{{ params.file_path }}
"""

get_table_cols = """
    SELECT *
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = '{{ params.table_name }}'
"""

insert_into_table = """
    INSERT INTO {{ params.table_name }} ({{ params.col_names }})
    VALUES ({{ ti.xcom_pull(task_ids="extract_values", dag_id="transform_data", key="extracted_data") }})
"""
    # VALUES ({{ params.values }})

# VALUES ({{ TaskInstance.xcom_pull(self=TaskInstance, task_ids="extract_values", dag_id="transform_data", key="extracted_data") }})