#!/bin/bash

#the content of one test
for i in {1..5}
do
sed "s/LIMIT 10000/LIMIT $((${i}*100000))/" ./daemon/main.go > ./daemon/new.go
docker build --network=host -t "mt-${i}" .
sleep 30s
echo "" >> ../../output/mt-out.txt
echo "第${n}次测试..." >> ../../output/mt-out.txt
echo "LIMIT $((${i}*100000)):" >> ../../output/mt-out.txt
sleep 1
docker run --rm --net=host --name "mt-${i}" "mt-${i}" >> ../../output/mt-out.txt
sleep 10s
docker rmi "mt-${i}" 
done

