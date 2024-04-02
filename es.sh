#!/bin/bash

export n=1

. ./utils

cd Vedrfolnir

#write Dockerfile
if [ ! -f "Dockerfile" ];then
infoln "no Dockerfile,create Dockerfile..."
touch Dockerfile
chmod a+x Dockerfile
echo 'FROM golang:latest
WORKDIR /go/src/app
ENV GOPROXY=https://goproxy.cn
COPY . .
RUN go run ./daemon/new2.go > out.txt
CMD ["cat","out.txt"]' > Dockerfile
else 
infoln "Dockerfile already exists"
fi 

if [ $? -eq 0 ]; then
successln "Dockerfile creates successfully."
fi

#three tests
infoln "the first test is running..."
. ../es_c.sh
if [ $? -eq 0 ]; then
successln "the first test completes."
infoln "the second test is running..."
n=2
. ../es_c.sh
if [ $? -eq 0 ]; then
successln "the second test completes."
infoln "the third test is running..."
n=3
. ../es_c.sh
if [ $? -eq 0 ]; then
successln "the third test completes."
else
fatalln "the third test failed."
fi
else
fatalln "the second test failed."
fi
else 
fatalln "the first test failed."
fi


