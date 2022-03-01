#!/usr/bin/env bash

if ! [ $PUB_KEY ]
then
    pub_key_path=$HOME/.ssh/id_rsa.pub
else
    pub_key_path=$PUB_KEY
fi

if [ -f $pub_key_path ]
then
    cd terraform
    TF_VAR_pub_key_path=$pub_key_path terraform apply
else
    echo "Can't find public key at $pub_key_path"
fi
