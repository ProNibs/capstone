# Overview


## Create Memberlist secret

`kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)" `
