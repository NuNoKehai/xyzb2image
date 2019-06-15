#!/bin/bash

dir_main=`dirname $0`

#echo $file_init $file_fin

ruby -I ${dir_main} ${dir_main}/run.rb $@
