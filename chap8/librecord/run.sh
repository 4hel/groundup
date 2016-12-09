#!/bin/bash

LD_LIBRARY_PATH=.
export LD_LIBRARY_PATH

./write-records

head -n 1 test.dat

