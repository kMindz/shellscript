# shellscript

create new user 

 $: adduser username

add user to sudo group

 $: usermod -aG sudo username

login to user

 $: su - username

clone this repository

$: git clone https://github.com/kMindz/shellscript.git

copy all files to home 

$: cd shellscript

$: cp * ..

now give executalbe permissions

$: chmod +x composer.sh

$: chmod +x explorer.sh

$: chmod + prereqs-ubuntu.sh

Now run

$: ./prereqs-ubuntu.sh

Once completed logout from shell and then login

$: exit

$: su - username

now run 

$: ./composer.sh

$: ./explorer.sh

enter options 1 or 2 (1. if you have fabric-dev-servers, 2. if you have fabric-tools) this will create config.json

to insatll ipfs 

$: chmod +x ipfs-setup.sh

$: ./ipfs-setup.sh install (will install ipfs)

$: ./ipfs-setup.sh init (will initialize ipfs)

$: ./ipfs-setup.sh start (start ipfs cluster)

$: ./ipfs-setup.sh stop (stop ipfs cluster)
