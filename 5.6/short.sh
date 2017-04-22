#!/bin/bash


while true; do
  mysql -utest -ptest -h 10.10.1.36 -P 3307 -e "select 1;" 2>/dev/null  >/dev/null
  if [ $? -ne 0 ]; then
    /opt/stamp
    break;
  fi
done
