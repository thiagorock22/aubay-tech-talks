#!/bin/bash

setsid /run.sh > /dev/null &

sleep 20

echo "Running setup script "

# Create prometheus datasource
curl -X POST http://admin:admin@localhost:3000/api/datasources \
    -u "admin:admin" \
    -H "Accept: application/json" \
    -H "Content-Type: application/json" \
    -d '{ "name": "prometheus", "uid":"prom-data", "type": "prometheus", "access": "proxy", "url": "http://prometheus:9090", "basicAuth": true, "isDefault":true}' \

# Import dashboards
json=$(<basic_dash.json)
payload="{\"dashboard\": $json, \"overwrite\": true}"

curl -X POST http://admin:admin@localhost:3000/api/dashboards/import \
    -u "admin:admin" \
    -H "Accept: application/json" \
    -H "Content-Type: application/json" \
    -d "$payload"

json=$(<adv_dash.json)
payload="{\"dashboard\": $json, \"overwrite\": true}"

curl -X POST http://admin:admin@localhost:3000/api/dashboards/import \
    -u "admin:admin" \
    -H "Accept: application/json" \
    -H "Content-Type: application/json" \
    -d "$payload"
    
# Put the dash as home
curl -X PUT http://admin:admin@localhost:3000/api/org/preferences \
    -u "admin:admin" \
    -H "Accept: application/json" \
    -H "Content-Type: application/json" \
    -d '{"homeDashboardUID":"adv-dash"}'