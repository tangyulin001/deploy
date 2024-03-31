#!/bin/bash

#the content of one test
for i in {1..5}
do
sed "s/LIMIT 100000/LIMIT $((${i}*100000))/" ./daemon/test_hmst.go > ./daemon/new.go
docker build --network=host -t "vf-${i}" .
sleep 5
echo "" >> ../../output/vf-out.txt
echo "第${n}次测试..." >> ../../output/vf-out.txt
echo "LIMIT $((${i}*100000)):" >> ../../output/vf-out.txt
sleep 1
docker run --rm --net=host --name "vf-${i}" "vf-${i}" >> ../../output/vf-out.txt
sleep 5 
docker rmi "vf-${i}" 
done

