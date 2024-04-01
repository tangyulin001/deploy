#!/bin/bash

#the content of one test
for i in 1
do
sed "s/LIMIT 10000/LIMIT $((${i}*1000))/" ./daemon/main.go > ./daemon/new.go
docker build --network=host -t "test_${i}" .
echo "" >> ../../output/test_out.txt
echo "第${n}次测试..." >> ../../output/test_out.txt
echo "LIMIT $((${i}*100000)):" >> ../../output/test_out.txt
docker run --rm --net=host --name "test_${i}" "test_${i}" >> ../../output/test_out.txt
docker rmi "test_${i}" 
done

