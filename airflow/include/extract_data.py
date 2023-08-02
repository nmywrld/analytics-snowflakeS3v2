# from prefixMapping import jsonTest
# function to extract values of keys we are interested in 

def json_extract_selected(obj, keys = list):
    """Recursively fetch values from nested JSON."""
    res = []

    def extract(obj, key, res):
        """Recursively search for values of key in JSON tree."""
        if isinstance(obj, dict):
            for k, v in obj.items():
                if isinstance(v, (dict, list)):
                    extract(v, key, res)
                elif k == key:
                    # print("------------")
                    # print (f"found {k}")
                    # print (f"{v}")
                    # print("------------")
                    res.append(v)
                    return res
                
        elif isinstance(obj, list):
            for item in obj:
                extract(item, key, res)

    for key in keys:
        extract(obj, key, res)
        # print(key)

    return res

x = {
    "location": {
       "state_city": "MA-Lexington",
       "zip": "40503"
    },
    "sale_date": "2017-3-5",
    "price": "275836"
}

x = json_extract_selected(x, [
    "state_city",
    "zip"        ,
    "sale_date"  ,
    "price"      ])

print(", ".join(x))







## function to extract all values in key:value pairs 
## assumptions
    ## we are interested in all values (that are not keys) in json object in stage
    ## we want to separete 

def json_extract_all(json_dict):
    # json_dict is a python variable that has been converted from a json object to a dictionary (via json.load())

    """Recursively fetch values from nested JSON."""
    arr = [[],[]] # arr[0] is for raw values, arr[1] is for list

    def extract(obj, res, curr_key=None):
        """Recursively search for values of key in JSON tree."""
        
        # if the obj is a dict we loop through it
        if isinstance(obj, dict):
            for key, value in obj.items():

                # if value is a obj, we call recursively
                if isinstance(value, (dict, list, tuple)):
                    extract(value, res, key)

                # if item is just a value, we append to arr[0]
                else:
                    res[0].append(value)
        
        # else if the obj is a list we loop through it  
        elif isinstance(obj, (list, tuple)):
            for item in obj:
                
                # if item is dict, we call recursively
                if isinstance(item, (dict, list, tuple)):
                    extract(item, res, key)

                # if item is just a value, we append the whole list to arr[1] as key:value
                else:
                    curr_data = {key: obj}
                    res[1].append(curr_data)
                    break
        
        return res

    values = extract(json_dict, arr)
    
    return values
    # values is a list of values extracted from json object 

