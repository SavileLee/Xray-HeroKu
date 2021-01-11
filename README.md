# XRay HeroKu

## 概述

用于在 Heroku 上部署 XRay VMESS或者VLESS+Websocket。

WEB页面通过caddy部署，可自定义网页内容。

支持存储自定义文件,目录及账号密码均为UUID,客户端务必使用TLS连接

**Heroku 为我们提供了免费的容器服务，我们不应该滥用它，所以本项目不宜做为长期翻墙使用。**


## 镜像

本镜像不会因为大量占用资源而被封号（骗你的）。

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://dashboard.heroku.com/new?template=https%3A%2F%2Fgithub.com%2FSavileLee%2FXray-HeroKu)

## 服务端

点击上面紫色`Deploy to Heroku`，会跳转到heroku app创建页面，填上app的名字、选择节点、按需修改部分参数和UUID后，点击下面deploy创建app即可开始部署，默认部署时自动安装 XRay 最新版本。

如出现错误，可以多尝试几次，待部署完成后页面底部会显示Your app was successfully deployed

* 点击Manage App可在Settings下的Config Vars项查看和重新设置参数
* 点击Open app跳转[欢迎页面](/etc/IndexPage.md)域名即为heroku分配域名，格式为`appname.herokuapp.com`
* 默认WS路径为$UUID-[vmess|vless]格式

## 客户端
* **务必替换所有的`appname.herokuapp.com`为heroku分配的项目域名**
* **务必替换所有的`068749e2-0947-4efa-8bb3-50d267a5e5ce`为部署时设置的UUID**
<details>
<summary>xray配置</summary>

```bash
* 客户端下载：https://github.com/XTLS/Xray-core/releases
* 代理协议：vless 或 vmess
* 地址：appname.herokuapp.com
* 端口：443
* 默认UUID：068749e2-0947-4efa-8bb3-50d267a5e5ce
* 加密：none
* 传输协议：ws
* 伪装类型：none
* 路径：/068749e2-0947-4efa-8bb3-50d267a5e5ce-vless // 默认vless使用/$UUID-vless，vmess使用/$UUID-vmess
* 底层传输安全：tls
```
</details> 
    
<details>
<summary>UUID生成</summary>

```bash
`UUID` > `UUID，供用户连接时验证身份使用，可以使用UUID在线生成工具生成`。
```
</details>

<details>
<summary>cloudflare workers example</summary>

```js
const SingleDay = 'appname.herokuapp.com'
const DoubleDay = 'appname.herokuapp.com'
addEventListener(
    "fetch",event => {
    
        let nd = new Date();
        if (nd.getDate()%2) {
            host = SingleDay
        } else {
            host = DoubleDay
        }
        
        let url=new URL(event.request.url);
        url.hostname=host;
        let request=new Request(url,event.request);
        event. respondWith(
            fetch(request)
        )
    }
)
```
</details>
  

**出于安全考量，除非使用 CDN，否则请不要使用自定义域名，而使用 Heroku 分配的二级域名，以实现 XRay Websocket + TLS。**
