# ELK

## 先启动 ELK

在 elk 目录下执行

```shell
make up
```

## 启动 filebeat

因为有时候不一定会需要启动 filebeat，且需要导入到 elk 的内容不一定是日志，所以我将 filebeat 的启动单独拎出来了。
如果启动了 filebeat，我默认的是会将 `elk/filebeat/logs` 目录下所有的 `*.log` 文件中的内容导入到 elk 中，如果
你需要导入其他内容，可以自行修改 `elk/filebeat/config/filebeat.yml` 配置文件和 `docker-filebeat.yml` 文件。

启动 filebeat 的命令如下：

```shell
make fb-up
```

> 只需要在 `elk/filebeat/logs` 目录下，创建任何的 `*.log` 文件，然后启动 filebeat，就可以将文件中的内容导入到 elk 中。

当然，完全可以通过下载 filebeat 的二进制文件，然后直接启动。

[Filebeat 7.9.3 官方下载地址](https://www.elastic.co/cn/downloads/past-releases/filebeat-7-9-3/)，下载完毕之后，进行解压，目录下会有 `filebeat` 二进制文件，然后执行：

```shell
./filebeat -e -c filebeat.yml
```

通过 kibana 去查看 filebeat 导入的内容，可以 [点击这里，有教程](./filebeat) 来查看。