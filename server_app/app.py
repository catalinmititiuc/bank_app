import os
import time
from flask import Flask, redirect, url_for, request, render_template
from pymongo import MongoClient

app = Flask(__name__)

client = MongoClient(
    os.environ['DB_PORT_27017_TCP_ADDR'],
    27017)
db = client.tododb


@app.route('/')
def main_page():

    _items = db.tododb.find().limit(50)
    items = [item for item in _items]

    for item in items:
        time_info = time.localtime(item['timestamp'])
        clock = "%02d" % (time_info[3],) + ":" + "%02d" % (time_info[4],)
        date = "%02d" % (time_info[2],) + "/" + "%02d" % (time_info[1],) + "/" + "%02d" % (time_info[0],)
        item['timestamp'] = clock + " " + date

    return render_template('index.html', items=items)


@app.route('/drop_db/', methods=['POST'])
def drop_db():
    client.drop_database("tododb")

    return redirect(url_for('main_page'))

@app.route('/transactions/', methods=['POST'])
def transactions():
    
    if request.headers['Content-Type'] == 'application/json':
        request.get_json()
        timestamp = str(request.json['timestamp'])
        unix_timestamp = int(time.mktime(time.strptime(timestamp, '%H:%M %d/%m/%Y')))
        sender_user = int(request.json['sender'])

        db.tododb.create_index([("sender", 1), ("timestamp", 1)])
        _items = db.tododb.find({'sender':sender_user, 'timestamp':unix_timestamp})
        items = [item for item in _items]

        if len(items) == 0:
            item_doc = {
                'sender': int(request.json['sender']),
                'receiver': int(request.json['receiver']),
                'timestamp': unix_timestamp,
                'sum': int(request.json['sum'])
            }
            
            db.tododb.insert_one(item_doc)
    else:
        timestamp = request.form['timestamp']
        unix_timestamp = int(time.mktime(time.strptime(timestamp, '%H:%M %d/%m/%Y')))
        sender_user = int(request.form['sender'])

        db.tododb.create_index([("sender", 1), ("timestamp", 1)])
        _items = db.tododb.find({'sender':sender_user, 'timestamp':unix_timestamp})
        items = [item for item in _items]

        if len(items) == 0:
            item_doc = {
                'sender': int(request.form['sender']),
                'receiver': int(request.form['receiver']),
                'timestamp': unix_timestamp,
                'sum': int(request.form['sum'])
            }
            
            db.tododb.insert_one(item_doc)

    return redirect(url_for('main_page'))


@app.route('/transactions/', methods=['GET'])
def transactions2():

    user = int(request.args.get('user'))
    day = int(time.mktime(time.strptime(request.args.get('day'), '%d/%m/%Y')))
    threshold = int(request.args.get('threshold'))

    db.tododb.create_index([("sender", 1), ("timestamp", 1), ("sum", 1)])
    _items = db.tododb.find({'sender':user, 'timestamp':{"$gte": day, "$lt": day + 24*60*60-1}, 'sum':{"$gt": threshold}})
    #print db.tododb.find({'sender':user, 'timestamp':{"$gte": day, "$lt": day + 24*60*60-1}, 'sum':{"$gt": threshold}}).explain()['executionStats']
    items = [item for item in _items]

    db.tododb.create_index([("sender", 1), ("timestamp", 1), ("sum", 1)])
    _items = db.tododb.find({'receiver':user, 'timestamp':{"$gte": day, "$lt": day + 24*60*60-1}, 'sum':{"$gt": threshold}})
    recv = [item for item in _items]

    items += recv

    for item in items:
        time_info = time.localtime(item['timestamp'])
        clock = "%02d" % (time_info[3],) + ":" + "%02d" % (time_info[4],)
        date = "%02d" % (time_info[2],) + "/" + "%02d" % (time_info[1],) + "/" + "%02d" % (time_info[0],)
        item['timestamp'] = clock + " " + date

    return render_template('transactions.html', items=items, user=user, threshold=threshold, day=request.args.get('day'))


@app.route('/balance/', methods=['GET'])
def balance():

    user = int(request.args.get('user'))
    since = int(time.mktime(time.strptime(request.args.get('since'), '%d/%m/%Y')))
    until = int(time.mktime(time.strptime(request.args.get('until'), '%d/%m/%Y')))

    balance = 0
    db.tododb.create_index([("sender", 1), ("timestamp", 1)])
    _items = db.tododb.find({'sender':user, 'timestamp':{"$gte": since, "$lt": until + 24*60*60-1}})
    items = [item for item in _items]
    
    for item in items:
        balance -= item['sum']

    db.tododb.create_index([("sender", 1), ("timestamp", 1)])
    _items = db.tododb.find({'receiver':user, 'timestamp':{"$gte": since, "$lt": until + 24*60*60-1}})
    items = [item for item in _items]

    for item in items:
        balance += item['sum']

    items = [balance, user, request.args.get('since'), request.args.get('until')]

    return render_template('balance.html', items=items)

if __name__ == "__main__":
    app.run(host='0.0.0.0', debug=True)
