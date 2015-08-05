# AWS

## 概要

よく使うAWS CLIをシェルにした。ちょっとした情報を参照したい場合や、インスタンスの作成、起動、停止、削除などが可能。

## 前提条件

* aws configで環境設定しておくこと

## Usage

```bash:ec2ctl
Usage: ./ec2ctl command [ OPTION ]
  list                          : display instance info
  info [ INSTANCE_ID ]          : display instance info with json
  status [ INSTANCE_ID ]        : display instance status
  public-ip [ INSTANCE_ID ]     : dispaly public ip(s)
  private-ip [ INSTANCE_ID ]    : display private ip(s)
  create SSH_KEY_NAME           : create instance
  start [ INSTANCE_ID | --all ] : start instance(s)
  stop [ INSTANCE_ID | --all ]  : stop instance(s)
  terminate INSTANCE_ID         : terminate instance
```
