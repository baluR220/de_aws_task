#!/bin/bash

if ! [ -f ~/.ssh/id_rsa.pub ]
then
    ssh-keygen -b 2048 -t rsa -f ~/.ssh/id_rsa -q -N ""
fi

cat ~/.ssh/id_rsa.pub
