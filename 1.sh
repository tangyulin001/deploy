#!/bin/bash

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
for i in {1..5}
do
sed "s/LIMIT 10000/LIMIT $((${i}*100000))/" ./daemon/main.go > ./daemon/new.go
docker build --network=host -t "mt-${i}" .
wait
echo "LIMIT $((${i}*100000)):" >> output.txt
sleep 1
docker run --rm --net=host --name "mt-${i}" "mt-${i}" >> "output.txt"
wait 
#docker kill "mt-${i}"
#docker rm -f "mt-${i}"
docker rmi "mt-${i}" 
done
sleep 5
cp output.txt "../output/${n}.txt"
sleep 1
cd ../
sudo rm -r Merkle2Test
