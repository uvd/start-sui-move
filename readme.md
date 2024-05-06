# 快速入门Move 并构建一个简单小应用


## 什么是Move
- 一种特殊领域的计算机编程语言，俗称智能合约编程语言，语法类似Rust 编程语言
- 真正面向资产编程，一个token是资产，一篇文章也是资产，一条日志也是资产
- 书籍 https://move-book.com/
- 书籍 https://examples.sui.io/
- 书籍 https://docs.sui.io/guides/developer/sui-101
- 书籍+视频 https://github.com/sui-foundation/sui-move-intro-course


## 智能合约编程语言能做什么
- Define new asset types
- Read, write, and transfer assets 
- Check and enforce access control policies (权限控制，包含访问权限，操作权限)

## 什么是Sui

- 用move智能合约编程语言在上面开发应用的高性能区块链底层系统，是L1
- 优点 高TPS，低GAS ，更适合构建并发高，操作频繁的应用
- 创新共识  需要全局共识才共识，A给B转账本身不需要全局共识，极大提高了TPS   [详细介绍](https://docs.sui.io/concepts/sui-architecture/consensus)
- 可以无限水平扩容
- 快速了解Sui如何工作 https://docs.sui.io/learn/how-sui-works
- 经济模型 https://docs.sui.io/concepts/tokenomics
- 官网 https://sui.io/
- 代码库 https://github.com/MystenLabs/sui
- 学习文档 https://docs.sui.io/

## Sui + Move可以做什么
- DeFi and Payments   （Swap 线下支付工具  交易所 微信支付 支付宝支付）
- NFT and Gaming （ 发行NFT ，NFT交易市场，构建游戏）
- DID, Governance and Social （ 身份认证 社交软件 类似推特，知乎）
- 目前大家手机里面的App 大部分都可以用Move在Sui在构建一次


## 快速入门Move

### 强类型
- Move 是一种强类型的编程语言，所有的数据结构都必须被显式的申明数据类型

### 基础数据类型
- `u8`
- `u16`
- `u32`
- `u64`
- `u128`
- `u256`
- `bool`

```move
   fun main() {
        // define empty variable, set value later
        let a: u8;
        a = 10;

        // define variable, set type
        let a: u64 = 10;

        // finally simple assignment
        let a = 10;

        // simple assignment with defined value type
        let a = 10u128;

        // in function calls or expressions you can use ints as constant values
        if (a < 10) {};

        // or like this, with type
        if (a < 10u8) {}; // usually you don't need to specify type
    }
```

- `Move`没有小数和负数，需要程序设计的时候自己构建小数或者负数
- 构建小数，首先我们知道小数的定义 是 A/B 不能被整除的场景 ，我们就可以定义一个结构体来表示A/B的场景 [详细代码](https://github.com/MystenLabs/sui/blob/main/crates/sui-framework/packages/move-stdlib/sources/fixed_point32.move)

```rust
 public fun create_from_rational(numerator: u64, denominator: u64): FixedPoint32 {
        let scaled_numerator = (numerator as u128) << 64;
        let scaled_denominator = (denominator as u128) << 32;
        assert!(scaled_denominator != 0, EDENOMINATOR);
        let quotient = scaled_numerator / scaled_denominator;
    
        FixedPoint32 { value: (quotient as u64) }
    }

```

- 负数的话用u8类型举例子   1-127表示负数   128-256表示正数展现应用自行转换一下就行
### 集合数据类型
- `address ` 
- 数组`vector` 
- 字符串 `string` 
- hashmap( `table` ,`bag`) 
### 自定义数据结构，struct
- 和 C Rust GO的struct一致，C++ Java Swift Javascript面向对象编程语言的类类似

```rust
public struct DonutShop has key {
    id: UID,
    price: u64,
    balance: Balance<SUI>
}
```

### 常量
```rust
const MAX : u64 = 100;
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
```move
module examples::one_timer {
    use sui::transfer;
    use sui::object::{Self, UID};
    use sui::tx_context::{Self, TxContext};

    public struct CreatorCapability has key {
        id: UID
    }

    fun init(ctx: &mut TxContext) {
        transfer::transfer(CreatorCapability {
            id: object::new(ctx),
        }, tx_context::sender(ctx))
    }
}
```


### 方法访问控制

| 方法签名                       | 调用范围          | 返回值  |
|:---------------------------|:--------------|:-----|
| fun call()                 | 模块内调用         | 可以有  |
| public fun call()          | 只能模块能调用       | 可以有  |
| public entry fun call()    | 模块能调用，DApp能调用 | 暂时没有 |
| entry fun call()           | 只能DApp调用      | 暂时没有 |
| public(package) fun call() | 当前模块调用        | 可以有  |


### 泛型
- move 支持在调用动态的确定数据类型
```rust

    public struct Box_U64 {
        value: u64
    }

    public struct Box<T> {
         value: T
     }


    public fun create_box(value: u64): Box<u64> {
        Box<u64>{ value }
    }
    
    public fun create_box<T>(value: T): Box<T> {
        Box<T> { value }
    }
```




## 能力
- 理解为内置的基础权限，可以组合出一些常用的功能 
```rust 
struct T has key {}
struct T has key,store {}
struct T has copy,drop {}
```
- `copy`  被修饰的值可以被复制。
- `drop`  被修饰的值在作用域结束时可以被丢弃。
- `key`   被修饰的值可以作为键值对全局状态进行访问。
- `store`  被修饰的值可以被存储到全局状态

### 能力的组合使用
- 只有`key` 可以自定义转移对象所有权,比如实现不可转移的资产，不可转移的身份信息 [例子](https://examples.sui.io/basics/custom-transfer.html)
- `key`+`store` 可以拥有者可以自由转移对象所有权，token这种资产 [例子](https://examples.sui.io/basics/transfer.html)
- `store` 简单理解为这种类型的结构体可以作为类型存储在别的结构体里面
- `drop` 实现`Move`特定的设计模式，比如 [见证者模式](https://examples.sui.io/patterns/witness.html)
- 没有任何能力可以直接实现[闪电贷]( https://github.com/MystenLabs/sui/blob/main/sui_programmability/examples/defi/sources/flash_lender.move )这种其他合约语言非常难实现的合约


## 自定义能力
- 可以自定义一个结构体来当成权限使用 
```move
module examples::item {
    use sui::transfer;
    use sui::object::{Self, UID};
    use std::string::{Self, String};
    use sui::tx_context::{Self, TxContext};

    public struct AdminCap has key { id: UID }
    
    public struct Item has key, store { id: UID, name: String }
    
    fun init(ctx: &mut TxContext) {
        transfer::transfer(AdminCap {
            id: object::new(ctx)
        }, tx_context::sender(ctx))
    }

   
    public entry fun create_and_send(
        _: &AdminCap, name: vector<u8>, to: address, ctx: &mut TxContext
    ) {
        transfer::transfer(Item {
            id: object::new(ctx),
            name: string::utf8(name)
        }, to)
    }
}
```
- 例子 https://examples.sui.io/patterns/capability.html

## sui object
- 必须有`key` 能力，第一个字段必须是id 类型是UID类型
- sui 上的资产都是对象，万物都是对象的意思（every thing is NFT）
- 详细教程 https://docs.sui.io/concepts/object-model

```rust 
public  struct DonutShop has key {
    id: UID,
    price: u64,
    balance: Balance<SUI>
}
```


## 对象所有权
- `Sui` 维护了一个全局的 `map<id,object>`的结构，所有的对象都是全局存储的
- 有一个字段会标明每一个对象都是谁在拥有
- 对象被某一个具体的钱包地址拥有
- 对象被全局共享，所以人拥有
- 对象是个常量，不可修改的状态权限共享
- 对象拥有者可以使用这对象，包含读取，修改，转移拥有权等
- 如何改变对象所有权限 参考 `Sui Framework` [transfer](https://github.com/MystenLabs/sui/blob/main/crates/sui-framework/packages/sui-framework/sources/transfer.move)

## 合约可升级
- `Move` 已经上链的合约有一个升级规则可以升级合约
- 详细文档 https://docs.sui.io/concepts/sui-move-concepts/packages/upgrade

## Sui Framework
- 是`Move` 的标准库，内置了一些常用的包，比如对标以太坊ERC20，NFT标准
- 复杂数据类型，容器类
- 密码学学相关的库，零知识证明（ZKP）
- `Move` 和 虚拟机交互的库
- 代码库 https://github.com/MystenLabs/sui/tree/main/crates/sui-framework

## Move by Example 
-  Sui 官方维护了一本非常好的例子的书和很多Move的例子代码库
-  https://examples.sui.io/  	
-  https://github.com/MystenLabs/sui/tree/main/sui_programmability/examples

## RPC
- 其他编程语言和`Sui`公链，`Move`智能合约交互的通用接口，就是服务的后端接口
- 详细文档 https://docs.sui.io/references/sui-api

## SDK 和 RPC交互
- [typescript](https://sdk.mystenlabs.com/typescript)
- [dapp kit](https://sdk.mystenlabs.com/dapp-kit)


#  接下来现场coding环节 并完整的演示如何上链并且查看数据

## 安装和使用 Sui CLI 
- https://docs.sui.io/guides/developer/getting-started/sui-install
- https://github.com/MystenLabs/sui/releases

## 网络选择 
- 本地网络
- 开发网
- 测试网


### 测试网RPC选择
- https://fullnode.testnet.sui.io/
- [RPC](https://github.com/move-cn/awesome-sui#rpc)





## 一个简单bolg的完整例子

```move
module blog_demo::bolg {
    use sui::object::UID;
    use std::string::String;
    use sui::tx_context::{TxContext};
    use sui::object;
    use sui::transfer;

    public struct Blog has key {
        id: UID,
        title: String,
        content: String
    }

    public struct TimeEvent has copy,drop{
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
- 需要理解如何把写好的程序发布到链上
- 需要理解如何把数据展现给前端 - （RPC）发起HTTP调用
- 需要理解如果用`Move`做权限控制
- 用户需要支付一定的费用（GAS）

## 水龙头
- [官方](https://docs.sui.io/guides/developer/getting-started/get-coins)
- [钱包
- [getsui](https://github.com/uvd/sui-faucet)
- [discord](https://discord.gg/sui)

## 浏览器  
- 查看交易信息，对象信息，地址信息等
- https://suivision.xyz/
- https://suiscan.xyz/


## sui 官方钱包
- 用户管理资产，转账，交易签名等
- 下载地址 https://chrome.google.com/webstore/detail/sui-wallet/opcgpfmipidbgpenhmajoajpbobppdil


## dapp kit 
- https://sdk.mystenlabs.com/dapp-kit/create-dapp


## 对Move未来的展望
- 起于区块链，不止于区块链
- Sui能真正把Move构建的应用带入日常生活中各个领域，真正实现下一个10亿用户级别的应用

## Sui Foundation
- 官网 https://sui.io/
- 推特 https://twitter.com/suifoundation


## 关注我们
- 推特 https://twitter.com/SuiNetwork
- 官方中文支持Telegram [Sui中文](https://t.me/sui_dev_cn)  [move中文](https://t.me/move_cn)
- 官方社群支持 https://linktr.ee/sui_apac






