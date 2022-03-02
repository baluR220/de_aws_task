sleep 30
ssh-keyscan $1 >> $HOME/.ssh/known_hosts
scp -r ../ansible ubuntu@$1:/home/ubuntu
ssh ubuntu@$1 'bash -s' < remote_script.sh > $2/ec2_key.pub
