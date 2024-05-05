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
 --package  0xfc4a00b76cc1a3cf0f1211b9c4679513652b3a57d200b89ea95d582e4868d243 \
 --module bolg \
 --function add \
 --args '很搞笑' '大家好'


 sui client call --gas-budget 100000000 \
 --package  0xfc4a00b76cc1a3cf0f1211b9c4679513652b3a57d200b89ea95d582e4868d243 \
 --module bolg \
 --function update_title \
 --args 0xbc5d7d6f8d947069758ab0af1ada13b3978ab1c2b0a3b48daa6a42a519321624  "我在测试跟新"




