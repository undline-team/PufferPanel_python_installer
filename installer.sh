#!/bin/bash

set -e

PYTHON_VERSION=3.10.14

echo "Installing Python $PYTHON_VERSION"

sudo apt update && sudo apt upgrade -y
sudo apt install -y build-essential zlib1g-dev \
    libncurses5-dev libgdbm-dev libnss3-dev libssl-dev \
    libreadline-dev libffi-dev curl wget libbz2-dev

cd /tmp
wget https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tgz

tar -xf Python-$PYTHON_VERSION.tgz
cd Python-$PYTHON_VERSION

./configure --enable-optimizations
make -j$(nproc)

sudo make altinstall

echo "Installation complete"
python3.10 --version || echo "An unexpected error occurred"
