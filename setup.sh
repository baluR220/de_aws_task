#!/usr/bin/env bash

php_conf='../ansible/roles/wordpress-app/files'

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
        rm "$php_conf"/wp-config.php
        rm ../ansible/wordpress.tar.gz
        rm envs.sh
    fi

    if [ $1 == 'apply' ]
    then
        source envs.sh
        curl https://wordpress.org/latest.tar.gz --output ../ansible/wordpress.tar.gz
        SALT="$(curl https://api.wordpress.org/secret-key/1.1/salt/)"
        cp "$php_conf"/wp-config-sample.php "$php_conf"/wp-config.php
        sed -i 's/database_name_here/wp_app/' "$php_conf"/wp-config.php
        sed -i 's/username_here/'$DB_USER'/' "$php_conf"/wp-config.php
        sed -i 's/password_here/'$DB_SECRET'/' "$php_conf"/wp-config.php
        sed -i 's/db_host_here/'$DB_DNS_NAME'/' "$php_conf"/wp-config.php
        echo $SALT >> "$php_conf"/templates/wp-config.php

        scp -r ../ansible ubuntu@$EC2_IP:/home/ubuntu
        ssh ubuntu@$EC2_IP 'sudo apt update && sudo apt install ansible -y;'
    fi
else
    echo "Can not find public key at $pub_key_path, specify path with PUB_KEY env"
fi
