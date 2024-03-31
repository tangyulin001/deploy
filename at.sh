#!/bin/bash

export n=1
git clone https://github.com/HenryRuis/akdTest.git
sleep 3
cd akdTest


#write Dockerfile
if [ ! -f "Dockerfile" ];then
echo '
' >> Cargo.toml
echo '[[bin]]
name = "new"
path = "src/new.rs"' >> Cargo.toml
touch Dockerfile
chmod a+x Dockerfile
echo "FROM rust:latest
WORKDIR /rust/app
COPY . .
RUN mkdir ~/.cargo && \
    echo '[source.crates-io]' > ~/.cargo/config && \
    echo 'registry = \"https://mirrors.ustc.edu.cn/crates.io-index\"' >> ~/.cargo/config
RUN cargo build --bin new --release
CMD [\"./target/release/new\"]" > Dockerfile
fi

#three tests
echo -e "\033[0;32m第一次测试开始...\033[0m"
. ../at_c.sh
if [ $? -eq 0 ]; then
echo -e "\033[0;32m第一次测试完成\033[0m"
echo -e "\033[0;32m第二次测试开始...\033[0m"
n=2
. ../at_c.sh
if [ $? -eq 0 ]; then
echo -e "\033[0;32m第二次测试完成\033[0m"
echo -e "\033[0;32m第三次测试开始...\033[0m"
n=3
. ../at_c.sh
if [ $? -eq 0 ]; then
echo -e "\033[0;32m第三次测试完成\033[0m"
fi
fi
fi
