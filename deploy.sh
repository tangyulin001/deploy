#!/bin/bash


mkdir work # or any directory you like
cd work
export GOPATH=$PWD
mkdir -p src/github.com/otoolep
cd src/github.com/otoolep/
git clone git@github.com:otoolep/hraftd.git
cd hraftd
git clone https://github.com/hashicorp/raft.git
echo 'replace github.com/hashicorp/raft => ./raft' >> go.mod
go mod tidy
go install
cd ../../../../bin
export PATH=$PATH:$PWD




