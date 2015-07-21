# AWS

## 概要

AWS CLIを少しだけ使いやすくしたコマンド。引数は最小限にしたつもり。その代わり、基本動作はデフォルトのパラメータに従う。

## 利用方法

```bash:ec2ctl
Usage: ./ec2ctl command [ OPTION ]
  id                            : display instance id(s)
  info [ INSTANCE_ID ]          : display instance info with json
  status [ INSTANCE_ID ]        : display instance status
  public-ip [ INSTANCE_ID ]     : dispaly public ip(s)
  private-ip [ INSTANCE_ID ]    : display private ip(s)
  create SSH_KEY_NAME           : create instance
  start [ INSTANCE_ID | --all ] : start instance(s)
  stop [ INSTANCE_ID | --all ]  : stop instance(s)
  terminate INSTANCE_ID         : terminate instance
```
