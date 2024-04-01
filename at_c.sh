#!/bin/bash

for i in {1..5}
do
sed "s/LIMIT 1000/LIMIT $((${i}*100000))/" ./src/main.rs > ./src/new.rs
docker build --network=host -t "at_${i}" .
echo "" >> ../../output/at_out.txt
echo "第${n}次测试..." >> ../../output/at_out.txt
echo "LIMIT $((${i}*100000)):" >> ../../output/at_out.txt
docker run --rm --net=host --name "at_${i}" "at_${i}" >> ../../output/at_out.txt
docker rmi "at_${i}" 
done

