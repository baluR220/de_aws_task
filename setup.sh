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
    TF_VAR_local_pub_key_path=$pub_key_path TF_VAR_db_user=$DB_USER \
    TF_VAR_db_secret=$DB_SECRET terraform $*
    if [ $1 == "destroy" ]
    then
        rm ec2_key.pub
    fi
else
    echo "Can't find public key at $pub_key_path, specify path with PUB_KEY env"
fi
