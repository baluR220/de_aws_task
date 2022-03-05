sleep 30
ssh-keyscan $1 >> $HOME/.ssh/known_hosts
echo DB_DNS_NAME=$(echo $3 | cut -d: -f 1) EC2_IP=$1 > envs.sh
ssh ubuntu@$1 'bash -s' < remote_script.sh > $2/ec2_key.pub
