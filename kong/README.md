# 安装 [Kong](https://docs.konghq.com/gateway/latest/install/docker/) [Konga](https://github.com/pantsel/konga)

## 启动

```bash
# 在此目录下执行
docker-compose up -d

# 查看状态
docker-compose ps

# 查看服务容器的输出内容
docker-compose logs

# 删除所有（停止状态的）服务容器
docker-compose rm
# 其实这里只会删除 kong-migration 和 konga-prepare 这两个服务容器（因为这两个容器只需要临时执行一下，因此部署完了之后，还是删掉为好）
# 当然可以直接使用 docker 命令直接删除这两个容器
# docker rm kong-kong-migration-1 kong-konga-prepare-1

# 如果需要停止所有启动的容器，并删除所有容器以及网络时
docker-compose down
```

### 访问 kong

浏览器访问 `{YOUR_SERVER_IP}:8002`

### 访问 konga

浏览器访问 `{YOUR_SERVER_IP}:1337` 后会首先要注册一个管理员账号，注册完之后登录进去，会自动要求创建一个连接 `Name` 可以随便填，`Kong Admin URL` 需要填写 `http://kong:8001`（这里的 `kong` 指的是 `docker-compose.yml` 文件中的 `kong` 服务名称）

### 关于 `kong` service 状态为 unhealthy

通过 `docker ps` 即可查看到 `kong-kong-1` 容器的状态为 `unhealthy`

问题描述：因为在启动 `kong` 服务时，使用了 `curl 'http://kong:8001'` 去做健康检查，然而 `kong` 服务容器默认是没有 `curl` 软件的，因此我们只需要进入容器进行安装 `curl` 即可。 

解决方案：

- 以 root 身份进入容器

```shell
docker-compose exec -u 0 -it kong bash
```

- 安装 curl

```shell
apt-get update && apt-get install curl
```

- 检查是否正常

```shell
curl 'http://kong:8001'
```