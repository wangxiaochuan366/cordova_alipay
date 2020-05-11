感谢这位大神在Github上开源了这款插件https://github.com/charleyw/cordova-plugin-alipay 本插件在此基础上做了些许修改（从服务端获取签名，调用支付宝）,如果使用者使用客服端生成签名，请参考上方GitHub地址
======

## 最新更新

1. 由于原插件采用客户端签名，不适用于我们的产品，所以改成从服务端获取签名
2. 默认使用自动安装的方法
3. 去除了对URL Scheme的依赖

## 支持的系统

* iOS
* Android

## 自动安装（Cordova > v5.1.1）

	cordova plugin add https://github.com/wangxiaochuan366/cordova_alipay.git --variable PARTNER_ID=[你的商户PID可以在账户中查询] --variable SELLER_ACCOUNT=[你的商户支付宝帐号] --variable PRIVATE_KEY=[你生成的private key]

**注意**：PRIVATE_KEY的值是生成的私钥的**内容**，要求是**PKCS**格式，需要去掉——-BEGIN PRIVAT KEY——-和——-END PRIVATE KEY——-，以及**空格**和**换行**。关于私钥的说明详见下面<a href='#关于私钥'>关于私钥</a>部分

## 使用方法
```
window.alipay.pay(下单后从服务端返回的sign等信息, function(successResults){alert(successResults)}, function(errorResults){alert(errorResults)});
```
**注意**:由于使用的客服端生成签名，所以在调用pay方法之前，先ajax从服务端获取签名，然后在获取的签名放在pay方法里，然后会调出支付宝

### 参数说明


`successResults`和`errorResults`分别是成功和失败之后支付宝SDK返回的结果，类似如下内容

```
// 成功
{
	resultStatus: "9000",
	memo: "",
	result: "partner=\"XXXX\"&seller_id=\"XXXX\"&out_trade_no=\"XXXXX\"..."	
}
```
```
// 用户取消
{
	memo: "用户中途取消", 
	resultStatus: "6001", 
	result: ""	
}
```

* resultStatus的含义请参照这个官方文档：[客户端返回码](https://doc.open.alipay.com/doc2/detail?treeId=59&articleId=103671&docType=1)
* memo：一般是一些纯中文的解释，出错的时候会有内容。
* result: 是所有支付请求参数的拼接起来的字符串。

### 关于私钥
这里用的私钥一定是**PKCS**格式的，详细生成步骤请参照官方文档：[RSA私钥及公钥生成](https://doc.open.alipay.com/doc2/detail.htm?spm=0.0.0.0.WSkmo8&treeId=58&articleId=103242&docType=1)  

文档中描述的这一步：`OpenSSL> pkcs8 -topk8 -inform PEM -in rsa_private_key.pem -outform PEM -nocrypt`会将生成的私钥**打印到屏幕上**，记得复制下来。


