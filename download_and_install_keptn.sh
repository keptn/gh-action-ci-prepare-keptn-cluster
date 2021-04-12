#!/bin/bash

wget "https://github.com/keptn/keptn/releases/download/${KEPTN_VERSION}/keptn-${KEPTN_VERSION}-linux-amd64.tar.gz" -O "${HOME}/downloads/keptn-cli.tar.gz"
tar -zxvf ${HOME}/downloads/keptn-cli.tar.gz
sudo mv keptn-*-linux-amd64 /usr/local/bin/keptn

