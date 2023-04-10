# create new package
sui move new blog_demo
# build project
sui move build
# 查看当前活跃地址
sui client active-address

# 查看当前活跃环境
sui client active-env

# 发布合约上链
 sui client publish --gas-budget 100000000

 # 调用合约


 sui client call --gas-budget 100000000 \
 --package  0xe67b9b5651c19ad164a9154c3977173c4ab0aa41c111aea382355ea25d8a3135 \
 --module bolg \
 --function add \
 --args '很搞笑' '大家好'


 sui client call --gas-budget 100000000 \
 --package  0x1d9198fcc76e9c9fad06dcf49cc4815974ab46c495df53dec1d6bcab378b69da \
 --module bolg \
 --function update_title \
 --args 0x0bf1e50d772d87c5c7c7c4351df68071122d2b59f05c36eded38b6680943348b  "我在测试跟新"




