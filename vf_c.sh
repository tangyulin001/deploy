#!/bin/bash

for i in {1..5}
do
sed "s/LIMIT 100000/LIMIT $((${i}*100000))/" ./daemon/test_hmst.go > ./daemon/new.go
docker build --network=host -t "vf-${i}" .
sleep 5
echo "" >> ../../vf-out.txt
echo "第${n}次测试..." >> ../../vf-out.txt
echo "LIMIT $((${i}*100000)):" >> ../../vf-out.txt
sleep 1
docker run --rm --net=host --name "vf-${i}" "vf-${i}" >> ../../vf-out.txt
sleep 5 
docker rmi "vf-${i}" 
done

