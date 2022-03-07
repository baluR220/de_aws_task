#!/usr/bin/env bash

php_conf='../ansible/roles/wordpress-app/templates'
nfs_vars='../ansible/roles/nfs-client/vars'
script_dir=$(dirname "$0")

if ! [ $PUB_KEY ]
then
    pub_key_path=$HOME/.ssh/id_rsa.pub
else
    pub_key_path=$PUB_KEY
fi

if [ -f $pub_key_path ]
then
    cd "$script_dir"/terraform
    TF_VAR_local_pub_key_path=$pub_key_path TF_VAR_db_user=$DB_USER \
    TF_VAR_db_secret=$DB_SECRET terraform $*

    if [ $1 == "destroy" ]
    then
        rm ec2_key.pub
        rm "$php_conf"/wp-config.php.j2
        rm "$nfs_vars"/main.yml
        rm ../ansible/hosts
        rm ../ansible/wordpress.tar.gz
        rm envs.sh
    fi

    if [ $1 == 'apply' ]
    then
        source envs.sh
        curl https://wordpress.org/latest.tar.gz --output ../ansible/wordpress.tar.gz
        SALT="$(curl https://api.wordpress.org/secret-key/1.1/salt/)"

        cp "$php_conf"/wp-config-sample.php "$php_conf"/wp-config.php.j2
        sed -i 's/database_name_here/wp_app/' "$php_conf"/wp-config.php.j2
        sed -i 's/username_here/'$DB_USER'/' "$php_conf"/wp-config.php.j2
        sed -i 's/password_here/'$DB_SECRET'/' "$php_conf"/wp-config.php.j2
        sed -i 's/db_host_here/'$DB_DNS_NAME'/' "$php_conf"/wp-config.php.j2
        echo $SALT >> "$php_conf"/wp-config.php.j2

        cp "$nfs_vars"/main-sample.yml "$nfs_vars"/main.yml
        sed -i 's/nfs_name_here/'$EFS_DNS'/' "$nfs_vars"/main.yml
        
        cp ../ansible/hosts_sample ../ansible/hosts
        sed -i 's/s1_name_here/'$S1_DNS'/' ../ansible/hosts
        sed -i 's/s2_name_here/'$S2_DNS'/' ../ansible/hosts

        scp -r ../ansible ubuntu@$EC2_IP:/home/ubuntu
        ssh ubuntu@$EC2_IP 'sudo apt update && sudo apt install ansible -y; \
        ssh-keyscan "'$S1_DNS'" >> $HOME/.ssh/known_hosts; \
        ssh-keyscan "'$S2_DNS'" >> $HOME/.ssh/known_hosts; \
        cd $HOME/ansible && ansible-playbook site.yml'
    fi
else
    echo "Can not find public key at $pub_key_path, specify path with PUB_KEY env"
fi
