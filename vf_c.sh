#!/bin/bash

#the content of one test
for i in {1..5}
do
sed "s/LIMIT 100000/LIMIT $((${i}*100000))/" ./daemon/test_hmst.go > ./daemon/new.go
docker build --network=host -t "vf_${i}" .
echo "" >> ../../output/vf_out.txt
echo "第${n}次测试..." >> ../../output/vf_out.txt
echo "LIMIT $((${i}*100000)):" >> ../../output/vf_out.txt
docker run --rm --net=host --name "vf_${i}" "vf_${i}" >> ../../output/vf_out.txt 
docker rmi "vf_${i}" 
done

