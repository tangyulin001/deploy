#!/bin/bash

#the content of one test
for i in {1..5}
do
sed "s/LIMIT 10000/LIMIT $((${i}*100000))/" ./daemon/main.go > ./daemon/new.go
docker build --network=host -t "mt_${i}" .
echo "" >> ../../output/mt_out.txt
echo "第${n}次测试..." >> ../../output/mt_out.txt
echo "LIMIT $((${i}*100000)):" >> ../../output/mt_out.txt
docker run --rm --net=host --name "mt_${i}" "mt_${i}" >> ../../output/mt_out.txt
docker rmi "mt_${i}" 
done

