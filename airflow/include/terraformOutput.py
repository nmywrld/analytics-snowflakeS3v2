import json
import os

absolute_path = os.path.dirname(__file__)
relative_path = "data"
target_file = "terraform_output.json"

full_path = os.path.join(absolute_path, relative_path, target_file)

with open(full_path) as file:
    terraformOutput = json.load(file)

