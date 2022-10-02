# ASP

- [ASP](#asp)
  - [简介](#简介)
  - [部署](#部署)
      - [docker-cli](#docker-cli)
      - [docker-compose](#docker-compose)
  - [参数说明](#参数说明)
  - [文件权限说明](#文件权限说明)
  - [PUID GUID 说明](#puid-guid-说明)
  - [添加站点及签到方式](#添加站点及签到方式)

## 简介

ASP全称Automatically set permissions，用于自动设置文件夹和文件的权限，初衷是为影视自动化而设计的

## 部署

#### docker-cli

```bash
docker run -itd \
  --name=asp \
  --restart always \
  -e TZ=Asia/Shanghai \
  -e PGID=1000 \
  -e PUID=1000 \
  -e PT_QIANDAO=true \
  -e IYUU_API= \
  -e SET_PM=true \
  -e CFVR=755 \
  -e SMTP=false \
  -e FROM_EMAIL=test@test.com \
  -e MAILER_HOST=smtp.test.com:25 \
  -e TO_EMAIL=test@test.com \
  -e MAILER_USER=test@test.com \
  -e MAILER_PASSWORD=test \
  -e TLS=yes
  -v /path:/00-asp \
  -v /path:/01-asp \
  -v /path:/02-asp \
  -v /path:/03-asp \
  -v /log:/app/log \
  -v /pt_qiandao:/app/pt_qiandao \
  ddsderek/asp:latest
```

#### docker-compose

```yaml
version: '3.3'
services:
    asp:
        container_name: asp
        restart: always
        environment:
            - TZ=Asia/Shanghai
            - PGID=1000
            - PUID=1000
            - PT_QIANDAO=true
            - IYUU_API=
            - SET_PM=true
            - CFVR=755
            - SMTP=false
            - FROM_EMAIL=test@test.com
            - MAILER_HOST=smtp.test.com:25
            - TO_EMAIL=test@test.com
            - MAILER_USER=test@test.com
            - MAILER_PASSWORD=test
            - TLS=yes
        volumes:
            - '/path:/00-asp'
            - '/path:/01-asp'
            - '/path:/02-asp'
            - '/path:/03-asp'
            - '/log:/app/log'
            - '/pt_qiandao:/app/pt_qiandao'
        image: 'ddsderek/asp:latest'
```

## 参数说明

|               Parameter               |                           Function                           |
| :-----------------------------------: | :----------------------------------------------------------: |
|          ```-e PGID=1000```           | 对于 GroupID - 请参阅下面的[说明](https://github.com/DDS-Derek/ASP#puid-guid-%E8%AF%B4%E6%98%8E) |
|          ```-e PUID=1000```           | 对于 UserID - 请参阅下面的说明[说明](https://github.com/DDS-Derek/ASP#puid-guid-%E8%AF%B4%E6%98%8E) |
|       ```-e TZ=Asia/Shanghai```       |                             时区                             |
|       ```-e PT_QIANDAO=true```       |                             是否开启PT自动签到                             |
|       ```-e IYUU_API=```       |                             IYUU通知API密钥，用于PT站签到通知                             |
|       ```-e SET_PM=true```       |                             是否开启自动设置权限                             |
|          ```-e CFVR=755 ```           | 对于文件权限 - 请参阅下面的说明[说明](https://github.com/DDS-Derek/ASP#%E6%96%87%E4%BB%B6%E6%9D%83%E9%99%90%E8%AF%B4%E6%98%8E) |
|          ```-e SMTP=false```          |                         是否开启SMTP                         |
|   ```-e FROM_EMAIL=test@test.com```   |                         SMTP发送邮箱                         |
| ```-e MAILER_HOST=smtp.test.com:25``` |                        SMTP服务器地址                        |
|    ```-e TO_EMAIL=test@test.com```    |                           接收邮箱                           |
|  ```-e MAILER_USER=test@test.com```   |                         SMTP认证用户                         |
|     ```-e MAILER_PASSWORD=test```     |                         SMTP认证密码                         |
|           ```-e TLS=yes```            |                           是否TLS                            |
|           ```-v /00-asp```            | 设置权限目录，只需要把要设置权限的目录映射到此目录，就可以定时自动设置权限 |
|           ```-v /01-asp```            | 设置权限目录，只需要把要设置权限的目录映射到此目录，就可以定时自动设置权限 |
|           ```-v /02-asp```            | 设置权限目录，只需要把要设置权限的目录映射到此目录，就可以定时自动设置权限 |
|           ```-v /03-asp```            | 设置权限目录，只需要把要设置权限的目录映射到此目录，就可以定时自动设置权限 |
|             ```-v /app/log```             |                           log目录                            |
|             ```-v /app/pt_qiandao```             |                           PT签到配置文件目录，[具体配置](#添加站点及签到方式)                            |

## 文件权限说明

- 444：用 r--r--r-- 表示，文件所属者、文件所属组和其他人只有读取权限
- 600：用 rw------- 表示，文件所属者有读取和写入权限，文件所属组和其他人无权限
- 644：用 rw-r--r-- 表示，文件所属者有读取和写入权限，文件所属组和其他人只有读取权限
- 666：用 rw-rw-rw- 表示，文件所属者、文件所属组和其他人有读取和写入权限
- 700：用 rwx------ 表示，文件所属者有全部权限，文件所属组和其他人无权限
- 744：用 rwxr--r-- 表示，文件所属者有全部权限，文件所属组和其他人有读取权限
- 755：用 rwxr-xr-x 表示，文件所属者有全部权限，文件所属组和其他人有读取和执行权限
- 777：用 rwxrwxrwx 表示，文件所属者、文件所属组和其他人有全部权限

## PUID GUID 说明

当在主机操作系统和容器之间使用卷（`-v`标志）权限问题时，我们通过允许您指定用户`PUID`和组来避免这个问题`PGID`。

确保主机上的任何卷目录都归您指定的同一用户所有，并且任何权限问题都会像魔术一样消失。

在这种情况下`PUID=1000`，`PGID=1000`找到你的用途`id user`如下：

```
  $ id username
    uid=1000(dockeruser) gid=1000(dockergroup) groups=1000(dockergroup)
```

## 添加站点及签到方式
在site.json文件中自行根据站点特性以及签到需求选择以下签到方式添加站点</br>
通用签到方式:
```
{
    "site": "站点名称",
    "url": "站点地址",
    "cookie": "站点cookie"
}
```
签到方式1:
```
{
    "site": "站点名称",
    "url": "域名/attendance.php",
    "referer": "域名/index.php",
    "cookie": "站点cookie"
}
```
签到方式例2:
```
{
    "site": "站点名称",
    "url": "域名/signin.php",
    "referer": "域名/index.php",
    "cookie": "站点cookie"
}
```
签到方式3:
```
{
    "site": "站点名称",
    "url": "域名/attendance.php",
    "cookie": "站点cookie"
}
```
签到方式4:
```
{
    "site": "站点名称",
    "url": "域名/sign_in.php",
    "referer": "域名/faq.php",
    "action": "sign_in",
    "cookie": "站点cookie"
}
```
签到方式5:
```
{
    "site": "站点名称",
    "url": "域名/attendance-ajax.php",
    "cookie": "站点cookie"
}
```
<h2>已知站点的签到方式</h2>
通用签到方式站点:KeepFrds、SouLvoice、HDAI、HDBD、PTMSG、HDFANS、CCF、DIC、U2、MTEAM、GPW、HUIJVTT[貌似已关闭站点]</br></br>
签到方式1站点:PTHOME</br></br>
签到方式2站点:HAIDAN</br></br>
签到方式3站点:Lemonhd、HDATMOS、HDZONE、HDTIME、3WMG</br></br>
签到方式4站点:HDAREA</br></br>
签到方式5站点:PterClub</br></br>