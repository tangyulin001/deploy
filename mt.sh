#!/bin/bash

export n=2
git clone https://github.com/HenryRuis/Merkle2Test.git
sleep 3
cd Merkle2Test
touch Dockerfile
chmod a+x Dockerfile
echo 'FROM golang:latest
WORKDIR /go/src/app
ENV GOPROXY=https://goproxy.cn
COPY . .
RUN go run ./daemon/new.go > out.txt
CMD ["cat","out.txt"]' > Dockerfile

echo -e "\033[0;32m第二次测试开始...\033[0m"
. ../mt_c.sh
if [ $? -eq 0 ]; then
echo -e "\033[0;32m第二次测试完成\033[0m"
echo -e "\033[0;32m第三次测试开始...\033[0m"
n=3
. ../mt_c.sh
if [ $? -eq 0 ]; then
echo -e "\033[0;32m第三次测试完成\033[0m"
fi
fi


