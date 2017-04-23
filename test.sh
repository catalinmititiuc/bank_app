#!/bin/bash

declare -a json=('{"sender":1, "receiver":2, "timestamp":"17:00 05/05/2016", "sum":700}' 
				 '{"sender":1, "receiver":2, "timestamp":"17:01 05/05/2016", "sum":800}'
				 '{"sender":1, "receiver":2, "timestamp":"17:02 05/05/2016", "sum":900}'
				 '{"sender":2, "receiver":3, "timestamp":"10:05 07/03/2016", "sum":200}'
				 '{"sender":2, "receiver":4, "timestamp":"11:10 05/04/2016", "sum":600}'
				 '{"sender":1, "receiver":3, "timestamp":"12:15 05/01/2016", "sum":700}'
				 '{"sender":3, "receiver":1, "timestamp":"00:16 05/02/2016", "sum":500}'
				 '{"sender":4, "receiver":1, "timestamp":"13:17 05/06/2016", "sum":100}'
				 '{"sender":2, "receiver":1, "timestamp":"16:18 05/06/2016", "sum":300}'
				 '{"sender":2, "receiver":1, "timestamp":"19:12 05/07/2016", "sum":200}'
				 '{"sender":1, "receiver":2, "timestamp":"21:15 05/05/2016", "sum":400}'
				 '{"sender":3, "receiver":2, "timestamp":"20:11 14/05/2016", "sum":600}'
				 '{"sender":4, "receiver":2, "timestamp":"23:56 05/05/2016", "sum":700}'
				 '{"sender":1, "receiver":3, "timestamp":"10:35 05/05/2016", "sum":300}'
				 '{"sender":1, "receiver":4, "timestamp":"06:36 05/05/2016", "sum":200}'
				 '{"sender":1, "receiver":5, "timestamp":"01:26 05/05/2016", "sum":700}'
				 '{"sender":5, "receiver":2, "timestamp":"04:19 05/05/2016", "sum":900}'
				 '{"sender":5, "receiver":1, "timestamp":"12:38 05/11/2016", "sum":800}'
				 '{"sender":3, "receiver":5, "timestamp":"17:59 05/05/2016", "sum":300}'
				 '{"sender":4, "receiver":5, "timestamp":"15:51 14/05/2016", "sum":200}'
				 '{"sender":1, "receiver":2, "timestamp":"13:27 05/05/2016", "sum":300}'
				 '{"sender":3, "receiver":4, "timestamp":"09:29 05/11/2016", "sum":700}'
				 '{"sender":3, "receiver":1, "timestamp":"10:30 05/05/2016", "sum":100}'
				 '{"sender":2, "receiver":1, "timestamp":"12:30 14/05/2016", "sum":900}'
				 '{"sender":1, "receiver":2, "timestamp":"15:11 05/05/2016", "sum":400}'
				 '{"sender":5, "receiver":4, "timestamp":"06:14 05/11/2016", "sum":700}'
				 '{"sender":4, "receiver":2, "timestamp":"08:18 14/05/2016", "sum":500}'
				 '{"sender":2, "receiver":2, "timestamp":"03:22 05/05/2016", "sum":600}'
				 '{"sender":1, "receiver":4, "timestamp":"02:35 14/05/2016", "sum":400}'
				 '{"sender":5, "receiver":3, "timestamp":"01:02 05/05/2016", "sum":100}'
				 '{"sender":2, "receiver":6, "timestamp":"12:02 12/04/2016", "sum":200}'
				 '{"sender":1, "receiver":6, "timestamp":"14:16 12/04/2016", "sum":400}'
				 '{"sender":3, "receiver":6, "timestamp":"02:02 12/04/2016", "sum":600}'
				 '{"sender":6, "receiver":4, "timestamp":"15:02 05/05/2016", "sum":300}'
				 '{"sender":6, "receiver":5, "timestamp":"16:02 05/05/2016", "sum":100}'
				 '{"sender":2, "receiver":1, "timestamp":"01:05 05/05/2016", "sum":400}'
				 '{"sender":1, "receiver":3, "timestamp":"00:02 05/05/2016", "sum":100}'
				 '{"sender":2, "receiver":3, "timestamp":"01:09 05/05/2016", "sum":200}'
				 '{"sender":6, "receiver":1, "timestamp":"00:02 12/04/2016", "sum":300}'
				 '{"sender":3, "receiver":2, "timestamp":"14:11 05/05/2016", "sum":100}'
				 '{"sender":4, "receiver":5, "timestamp":"13:15 05/05/2016", "sum":600}'
				 '{"sender":1, "receiver":4, "timestamp":"12:17 05/05/2016", "sum":200}'
				 '{"sender":3, "receiver":6, "timestamp":"01:22 12/04/2016", "sum":300}'
				 '{"sender":1, "receiver":7, "timestamp":"00:58 05/05/2016", "sum":500}'
				 '{"sender":2, "receiver":7, "timestamp":"01:35 05/05/2016", "sum":500}'
				 '{"sender":3, "receiver":7, "timestamp":"01:14 05/05/2016", "sum":500}'
				 '{"sender":4, "receiver":7, "timestamp":"23:18 05/05/2016", "sum":500}'
				 '{"sender":5, "receiver":7, "timestamp":"00:02 05/05/2016", "sum":500}'
				 '{"sender":6, "receiver":7, "timestamp":"20:02 05/05/2016", "sum":500}'
				 '{"sender":7, "receiver":2, "timestamp":"16:02 05/05/2016", "sum":500}')

## insert into DB
for i in ${!json[*]}
do
	curl -i -H "Content-Type: application/json" -X POST -d "${json[$i]}" http://127.0.0.1:5000/transactions/ > /dev/null 2>&1
	echo "${json[$i]}"
done

## GET list transactions
curl "http://127.0.0.1:5000/transactions/?user=7&day=05%2F05%2F2016&threshold=300" > transactions1.html
curl "http://127.0.0.1:5000/transactions/?user=2&day=05%2F05%2F2016&threshold=200" > transactions2.html
curl "http://127.0.0.1:5000/transactions/?user=6&day=12%2F04%2F2016&threshold=100" > transactions3.html

## GET balance
curl "http://127.0.0.1:5000/balance/?user=2&since=01%2F01%2F2016&until=20%2F12%2F2016" > balance1.html
curl "http://127.0.0.1:5000/balance/?user=7&since=01%2F01%2F2016&until=20%2F12%2F2016" > balance2.html
curl "http://127.0.0.1:5000/balance/?user=5&since=14%2F02%2F2016&until=30%2F09%2F2016" > balance3.html
