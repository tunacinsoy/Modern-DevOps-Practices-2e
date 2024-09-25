import os
import datetime
from flask import Flask

# Print statement will also appear in console, when we set this value to 1
os.environ['PYTHONUNBUFFERED'] = '1'

app = Flask(__name__)

@app.route('/')
def current_time():
  ct = datetime.datetime.now()
  print('Output is getting generated...')
  return 'The current time is : {}!\n'.format(ct)
