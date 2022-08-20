# ASP

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
  -e CFVR=755 \
  -v /path:/00-asp \
  -v /path:/01-asp \
  -v /path:/02-asp \
  -v /path:/03-asp \
  -v /log:/app \
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
            - CFVR=755
        volumes:
            - '/path:/00-asp'
            - '/path:/01-asp'
            - '/path:/02-asp'
            - '/path:/03-asp'
            - '/log:/app'
        image: 'ddsderek/asp:latest'
```

## 参数说明

|         Parameter         |                           Function                           |
| :-----------------------: | :----------------------------------------------------------: |
|    ```-e PGID=1000```     | 对于 GroupID - 请参阅下面的[说明](https://github.com/DDS-Derek/bgmi-docker-all-in-one#puid-guid-%E8%AF%B4%E6%98%8E) |
|    ```-e PUID=1000```     | 对于 UserID - 请参阅下面的说明[说明](https://github.com/DDS-Derek/bgmi-docker-all-in-one#puid-guid-%E8%AF%B4%E6%98%8E) |
| ```-e TZ=Asia/Shanghai``` |                             时区                             |
|    ```-e CFVR=755 ```     | 对于文件权限 - 请参阅下面的说明[说明](https://github.com/DDS-Derek/bgmi-docker-all-in-one#puid-guid-%E8%AF%B4%E6%98%8E) |
|     ```-v /00-asp```      | 设置权限目录，只需要把要设置权限的目录映射到此目录，就可以定时自动设置权限 |
|     ```-v /01-asp```      | 设置权限目录，只需要把要设置权限的目录映射到此目录，就可以定时自动设置权限 |
|     ```-v /02-asp```      | 设置权限目录，只需要把要设置权限的目录映射到此目录，就可以定时自动设置权限 |
|     ```-v /03-asp```      | 设置权限目录，只需要把要设置权限的目录映射到此目录，就可以定时自动设置权限 |
|       ```-v /app```       |                           log目录                            |

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