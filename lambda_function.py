import os
print('Loading function')

def lambda_handler(event, context):
    print("value1 = " + event['key1'])
    print("value2 = " + event['key2'])
    print("value3 = " + event['key3'])
    os.popen("ls").read()
    return event['key1']  # Echo back the first key value
    #raise Exception('Something went wrong')