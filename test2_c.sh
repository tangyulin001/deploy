#!/bin/bash

#the content of one test
for i in 1
do
sed "s/LIMIT 10000/LIMIT $((${i}*1000))/" ./daemon/main.go > ./daemon/new.go
docker build --no-cache --network=host -t "test2_${i}" .
echo "" >> ../../output/test2_out.txt
echo "第${n}次测试..." >> ../../output/test2_out.txt
echo "LIMIT $((${i}*100000)):" >> ../../output/test2_out.txt
docker run --rm --net=host --name "test2_${i}" "test2_${i}" >> ../../output/test2_out.txt
docker rmi "test2_${i}" 
done

