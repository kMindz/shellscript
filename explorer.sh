#!/bin/bash
    sudo apt-get update
    sudo apt-get install postgresql postgresql-contrib
    sudo apt-get install jq
    git clone https://github.com/kMindz/blockchain-explorer.git
    cd blockchain-explorer/app/persistence/fabric/postgreSQL/db
    ./createdb.sh
    cd
     cd blockchain-explorer
     npm install
     cd client
     npm install
     npm run build
cd
echo "enter config type 1) fabric-de-server 2) fabric-tools"
echo "enter option as 1 or 2"
read options

if [ $options == 1 ]; then
cd ./blockchain-explorer/app/platform/fabric
cp fabric-dev-servers.json  config.json
echo "fabric-dev-servers copied to config.json"
else
cd ./blockchain-explorer/app/platform/fabric
 cp  fabric-tools.json  config.json
echo "fabric-tools copied to config.json"

fi
