# 快速入门Sui Move 并构建一个简单小应用


## 什么是move
- 一种特殊领域的计算机编程语言，俗称智能合约编程语言，语法类似Rust 编程语言
- 代码库  https://github.com/move-language

## 智能合约编程语言能做什么
- Define new asset types
- Read, write, and transfer assets 
- Check and enforce access control policies (权限控制，包含访问权限，操作权限)

## 什么是sui
- 用move智能合约编程语言在上面开发应用的高性能区块链底层系统，一般称为L1
- 优点 高TPS，低GAS ，更适合构建并发高，操作频繁的应用
- 官网 https://sui.io/
- 代码库 https://github.com/MystenLabs/sui
- 学习文档 https://docs.sui.io/

## sui+move可以做什么
- DeFi and Payments   （Swap 线下支付工具  交易所 微信支付 支付宝支付）
- NFT and Gaming （ 发行NFT ，NFT交易市场，构建游戏）
- DID, Governance and Social （ 身份认证 社交软件 类似推特，知乎）
- 目前大家手机里面的App 大部分都可以用Move在Sui在构建一次


## 快速入门Sui Move

### 强类型
- move 是一种强类型的编程语言，所以的数据结构都必须被显式的申明数据类型

### 基础数据类型
- u8
- u16
- u32
- u64
- u128
- u256
- bool
- Move没有小数和负数，需要程序设计的时候自己构建小数或者负数
- 构建小数，首先我们知道小数的定义 是 A/B 不能被整除的场景 ，我们就可以定义一个结构体来表示A/B的场景，
- 负数的话用u8类型举例子   1-127表示负数   128-256表示正数展现应用自行转换一下就行
### 集合数据类型
- address  
- 数组vector 
- 字符串 string 
- hashmap( table ,bag) 
### 自定义数据结构，struct
- 和 C Rust GO的struct一致，C++ Java Swift Javascript面向对象编程语言的类类似

```rust
struct DonutShop has key {
id: UID,
price: u64,
balance: Balance<SUI>
}
```

### 自定义方法
```rust
public entry fun eat_donut(d: Donut) {
let Donut { id } = d;
object::delete(id);
}
```

### init方法
- 只能是私有的
- 会在发布合约的是自动调用一次
- 只有两种形式
```rust
fun init(ctx: &mut TxContext){}
fun init(witness: Struct, ctx: &mut TxContext) {}
```


### 方法访问控制

| 方法签名 | 调用范围          | 返回值  |
| :-----|:--------------|:-----|
| fun call() | 模块内调用         | 可以有  |
| public fun call() | 只能模块能调用       | 可以有  |
| public entry fun call() | 模块能调用，DApp能调用 | 暂时没有 |
| entry fun call() | 只能DApp调用      | 暂时没有 |
| public(friend) fun call() | 指定模块调用        | 可以有  |



### 泛型
- move 支持在调用动态的确定数据类型
```rust

    struct Box_U64<u64> {
        value: u64
    }

     struct Box<T> {
            value: T
     }


    public fun create_box(value: u64): Box<u64> {
        Box<u64>{ value }
    }
    
    public fun create_box<T>(value: T): Box<T> {
        Box<T> { value }
    }
```

## 合约可升级
- Sui Move 已经上链的合约有一个升级规则可以升级合约
- 详细文档 https://docs.sui.io/build/package-upgrades


## 能力
- 理解为内置的基础权限，可以组合出一些常用的功能
- copy - 被修饰的值可以被复制。
- drop - 被修饰的值在作用域结束时可以被丢弃。
- key - 被修饰的值可以作为键值对全局状态进行访问。
- store - 被修饰的值可以被存储到全局状态

### 能力的组合使用
- 只有key 可以实现自定义转移对象规则
- key+store 可以用公共的库自由转移，
- 没有任何能力可以实现闪电贷这种，
- store 简单理解为这种类型的结构体可以作为类型存储在别的结构体里面
- drop 实现move特定的设计模式，比如 见证者模式

## 自定义能力
- 可以自定义一个结构体来当成权限使用

## sui object
- 必须有key 能力，第一个字段必须是id 类型是UID类型
- sui 上的资产都是对象，万物都是对象的意思（every thing is NFT）

```rust 
struct DonutShop has key {
id: UID,
price: u64,
balance: Balance<SUI>
}
```


## 对象所以权
- sui 维护了一个全局的 map<id,object>的结构，所有的对象都是全局存储的
- 有一个字段会标明每一个对象都是谁在拥有
- 对象被某一个具体的钱包地址拥有
- 对象被全局共享，所以人拥有
- 对象是个常量，不可修改的状态权限共享
- 对象拥有者可以使用这对象，包含读取，修改，转移拥有权等
- 如何改变对象所有权限 参考 Sui Framework

## Sui Framework
- 是Sui Move 的标准库，内置了一些常用的包，比如对标以太坊ERC20，NFT标准
- 复杂数据类型，容器类
- 密码学学相关的库
- Sui Move 和 虚拟机交互的库
- 代码库 https://github.com/MystenLabs/sui/tree/main/crates/sui-framework

## Sui Move by Example 
-  Sui 官方维护了一本非常好的例子的书和很多Sui Move的例子代码库
-  https://examples.sui.io/  	
-  https://github.com/MystenLabs/sui/tree/main/sui_programmability/examples

## JSON RPC
- 其他编程语言和Sui公链，Move智能合约交互的通用接口，就是服务的后端接口


#  接下来现场coding环节 并完整的演示如何上链并且查看数据
## 一个简单bolg的完整例子

```move
module blog_demo::bolg {
    use sui::object::UID;
    use std::string::String;
    use sui::tx_context::{TxContext};
    use sui::object;
    use sui::transfer;

    struct Blog has key {
        id: UID,
        title: String,
        content: String
    }

    struct TimeEvent has copy,drop{
        time:u64
    }

    // add blog
    public entry fun add(title: String, content: String, ctx: &mut TxContext) {
        let blog = Blog {
            id: object::new(ctx),
            title,
            content
        };
        transfer::share_object(blog);
    }

    // update title
    public entry fun update_title(blog: &mut Blog, title: String) {
        blog.title = title
    }

    // delete blog
    public entry fun delete_bolg(blog:Blog){
        let Blog{id,title:_,content:_} = blog;
        object::delete(id);
    }
}

```

## 对比传统构建应用的方式
- 不在需要传统的数据库存储数据
- 依然需要前端（比如网页，APP，PC）
- 需要理解如何把写好的程序发布到具体的公链 - 创建数据库表结构
- 需要理解如何把数据展现给前端 - （RPC）发起HTTP调用
- 需要理解如果用Move做权限控制
- 用户需要支付一定的费用（GAS）



## 浏览器  
- 查看交易信息，对象信息，地址信息等
- https://explorer.sui.io/

## sui 官方钱包
- 用户管理资产，转账，交易签名等
- 下载地址 https://chrome.google.com/webstore/detail/sui-wallet/opcgpfmipidbgpenhmajoajpbobppdil

## 目前Sui已经开启主网系列Event
- mainnet 系列 event，详细关注 https://twitter.com/SuiNetwork
- 上线永久测试网 已经在3月29号完成  https://sui.io/resources-sui/announcing-permanent-testnet/
- Sui Builder House https://blog.suifoundation.org/announcing-the-2023-sui-builder-house-world-tour/
- 香港的build house + demo day   https://medium.com/sui-network-cn
- 大使计划 https://ambassadors.sui.io/
- 上线 mainnet  预计今年这个季度完成

## 对Move未来的展望
- 起于区块链，不止于区块链
- 希望sui能真正把move带入日常生活中各个领域

## Sui Foundation
- The Sui Foundation is an independent organization that grows and cultivates long-term value in the Sui ecosystem. Importantly, the Sui Foundation supports creating products that enable individuals and creators to have unprecedented ownership over their data and content
- 官网 https://suifoundation.org/
- 推特 https://twitter.com/suifoundation


## 关注我们
- 官方支持中文微信群  ![wechat_group_cn.jpg](images%2Fwechat_group_cn.jpg)[]
- 官方中文支持Telegram  https://t.me/+U6IlwHdAeSRhYzc1
- 官方社群支持 https://linktr.ee/sui_apac



## 联系我 UVD Sui技术大使
- https://twitter.com/wangtxxl
- https://t.me/wangtxxl
- 微信 ![uvd_weichat.jpg](images%2Fuvd_weichat.jpg)





