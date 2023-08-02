resource "snowflake_sequence" "this" {
  database = snowflake_database.db.name
  schema   = snowflake_schema.schema.name
  name     = "counter"
}


resource "snowflake_table" "test1" {
  for_each = local.prefix_mapping
  database = snowflake_database.db.name
  schema   = snowflake_schema.schema.name
  name     = upper(each.value.table_name)
  comment  = "TEST TABLE(s)"

  column {
    name     = "test_col1"
    type     = "int"
    nullable = true

    default {
      sequence = snowflake_sequence.this.fully_qualified_name
    }

  }

  dynamic column {
    for_each = each.value.table_cols
    content {
      name     = upper(column.key)
      type     = column.value
      nullable = true
    }
  
  }


}

# resource "snowflake_table" "test1" {
#   count = "${length(local.prefix_mapping)}"
#   database = snowflake_database.db.name
#   schema   = snowflake_schema.schema.name
#   name     = lookup(element(keys(local.prefix_mapping), count.index), "table_name")
#   comment  = "TEST TABLE"

#   column {
#     name     = "test_col1"
#     type     = "int"
#     nullable = true

#     default {
#       sequence = snowflake_sequence.sequence.fully_qualified_name
#     }

#   }

#   dynamic column {
#     for_each = each.value.column

#     count    = "${length(lookup(element(keys(local.prefix_mapping), count.index), "table_cols"))}"
#     name     = "${element(keys(lookup(element(keys(local.prefix_mapping), count.index), "table_cols")),count.index)}"
#     type     = "NUMBER(38,0)"
#     nullable = true
#   }


# }