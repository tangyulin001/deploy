#!/bin/bash

export n=1
./1.sh
if [ $? -eq 0 ]; then
echo -e "\033[0;32m第一次测试完成\033[0m"
n=2
./1.sh
if [ $? -eq 0 ]; then
echo -e "\033[0;32m第二次测试完成\033[0m"
n=3
./1.sh
if [ $? -eq 0 ]; then
echo -e "\033[0;32m第三次测试完成\033[0m"
fi
fi
fi


