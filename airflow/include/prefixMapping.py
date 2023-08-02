import json
import os

absolute_path = os.path.dirname(__file__)
relative_path = "data"
target_file = "prefix_mapping.json"

full_path = os.path.join(absolute_path, relative_path, target_file)

with open(full_path) as file:
    prefixMapping = json.load(file)
# absolute_path = os.path.dirname(__file__)
# relative_path = "data"
# target_file = "jsonTest.json"

# full_path = os.path.join(absolute_path, relative_path, target_file)

# with open(full_path) as file:
#     jsonTest = json.load(file)

