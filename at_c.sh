#!/bin/bash

for i in {1..5}
do
sed "s/LIMIT 1000/LIMIT $((${i}*10))/" ./src/main.rs > ./src/new.rs
docker build --network=host -t "at-${i}" .
#sleep 30s
echo "" >> ../../output/at-out.txt
echo "第${n}次测试..." >> ../../output/at-out.txt
echo "LIMIT $((${i}*100000)):" >> ../../output/at-out.txt
sleep 1
docker run --rm --net=host --name "at-${i}" "at-${i}" >> ../../output/at-out.txt
#sleep 10s
docker rmi "at-${i}" 
done

