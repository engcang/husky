#!/bin/bash
sudo apt-get update

# fuzzy, cvxpy, cvxopt
sudo apt-get -y install python-pip
sudo pip install -U numpy
cd ~/
sudo apt-get -y install python-scipy python-cvxopt
git clone https://github.com/scikit-fuzzy/scikit-fuzzy
cd scikit-fuzzy/
sudo pip install -e .
cd ~/
git clone https://github.com/cvxgrp/cvxpy
cd cvxpy
sudo python setup.py install
sudo pip install multiprocess
sudo pip install fastcache
