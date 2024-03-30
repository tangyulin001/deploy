#!/bin/bash

for i in {1..5}
do
sed "s/LIMIT 10000/LIMIT $((${i}*100000))/" ./daemon/main.go > ./daemon/new.go
docker build --network=host -t "mt-${i}" .
sleep 30s
echo "LIMIT $((${i}*100000)):" >> ../../mt-out-2and3.txt
sleep 1
docker run --rm --net=host --name "mt-${i}" "mt-${i}" >> ../../mt-out-2and3.txt
sleep 10s
docker rmi "mt-${i}" 
done

