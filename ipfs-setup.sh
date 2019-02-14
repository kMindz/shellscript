#!/bin/bash

function printHelp () {
    echo "options are:"
    echo "install"
    echo "init"
    echo "start"
    echo "stop"

}

function install () {
    sudo apt-get update
    sudo apt-get install golang-go -y
    wget https://dist.ipfs.io/go-ipfs/v0.4.13/go-ipfs_v0.4.13_linux-amd64.tar.gz
    tar xvfz go-ipfs_v0.4.13_linux-amd64.tar.gz
    sudo mv go-ipfs/ipfs /usr/local/bin/ipfs
    curl -O https://storage.googleapis.com/golang/go1.9.3.linux-amd64.tar.gz
    tar -xvf go1.9.3.linux-amd64.tar.gz
    sudo chown -R root:root ./go
    sudo mv go /usr/local
    export GOPATH=$HOME/go
    export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin
    source ~/.profile

}

PUBLIC_IP=$2
function init () {


    # echo " Enter your localhost or Loopback IP"
    ipadd=127.0.0.1
    echo $ipadd
    # echo "Enter your Public_IP:PORT"
    # PUBLIC_IP=$1
    echo $PUBLIC_IP
    if [ -d ~/.ipfs1 ] && [ -d ~/.ipfs2 ]; then
        echo "Cleaning your existing config....!"
        sudo rm -rf ~/.ipfs1
        sudo rm -rf ~/.ipfs2
        sudo rm -rf ~/.ipfs
            else
               echo "No previous config"

    fi

    output1=$(IPFS_PATH=~/.ipfs1 ipfs init)
    SUBSTRING1=$(echo $output1| cut -d':' -f 2)
    SUBSTRING1=$(echo $SUBSTRING1| cut -d' ' -f 1)
    echo peer identity1 $SUBSTRING1
    output2=$(IPFS_PATH=~/.ipfs2 ipfs init)
    SUBSTRING2=$(echo $output2| cut -d':' -f 2)
    SUBSTRING2=$(echo $SUBSTRING2| cut -d' ' -f 1)
    echo "peer identity2 $SUBSTRING2"
    if [ ! -d ~/src ]; then
    echo "creating directory src in /home"
    mkdir ~/src
    else 
    echo "directory exist"
    fi
    export GOPATH=~/src
    go get -u github.com/Kubuxu/go-ipfs-swarm-key-gen/ipfs-swarm-key-gen
    sudo cp $HOME/src/bin/ipfs-swarm-key-gen /usr/local/bin/
    ipfs-swarm-key-gen > ~/.ipfs1/swarm.key
    cp  ~/.ipfs1/swarm.key  ~/.ipfs2/
    IPFS_PATH=~/.ipfs1 ipfs bootstrap rm --all
    IPFS_PATH=~/.ipfs2 ipfs bootstrap rm --all
    IPFS_PATH=~/.ipfs1 ipfs config --json API.HTTPHeaders.Access-Control-Allow-Origin '["http://'$PUBLIC_IP'"]'
    IPFS_PATH=~/.ipfs2 ipfs config --json API.HTTPHeaders.Access-Control-Allow-Origin '["http://'$PUBLIC_IP'"]'    
    IPFS_PATH=~/.ipfs1 ipfs bootstrap add /ip4/$ipadd/tcp/4001/ipfs/$SUBSTRING1
    IPFS_PATH=~/.ipfs2 ipfs bootstrap add /ip4/$ipadd/tcp/4002/ipfs/$SUBSTRING1
    IPFS_PATH=~/.ipfs1 ipfs bootstrap add /ip4/$ipadd/tcp/4001/ipfs/$SUBSTRING2
    IPFS_PATH=~/.ipfs2 ipfs bootstrap add /ip4/$ipadd/tcp/4002/ipfs/$SUBSTRING2
    sed -i 's/5001/5002/g' ~/.ipfs2/config
    sed -i 's/8080/8081/g' ~/.ipfs2/config
    sed -i 's/4001/4002/g' ~/.ipfs2/config
    sed -i '10s/127.0.0.1/0.0.0.0/' ~/.ipfs1/config
    sed -i '12s/127.0.0.1/0.0.0.0/' ~/.ipfs1/config
    sed -i '10s/127.0.0.1/0.0.0.0/' ~/.ipfs2/config    
    sed -i '12s/127.0.0.1/0.0.0.0/' ~/.ipfs2/config
    
    echo "Done initializing......"
}

function start () {

    export LIBP2P_FORCE_PNET=1 && IPFS_PATH=~/.ipfs1 ipfs daemon >> ipfs1_logs.txt &
    export LIBP2P_FORCE_PNET=1 && IPFS_PATH=~/.ipfs2 ipfs daemon >> ipfs2_logs.txt &
}
function stop () {

    IPFS_PATH=~/.ipfs1 ipfs shutdown
    IPFS_PATH=~/.ipfs2 ipfs shutdown

}

if [ "$1" = "-m" ];then # supports old usage, muscle memory is powerful!
    shift
fi
MODE=$1;shift

if [ "${MODE}" == "install" ]; then
  install
elif [ "${MODE}" == "init" ]; then ## Clear the network
  init
elif [ "${MODE}" == "start" ]; then ## Generate Artifacts
    start
elif [ "${MODE}" == "stop" ]; then ## Restart the network
  stop
else
  printHelp
  exit 1
fi
