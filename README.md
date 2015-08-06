# AWS

## 概要

よく使うAWS CLIをシェルにした。ちょっとした情報を参照したい場合や、インスタンスの作成、起動、停止、削除などが可能。

## 前提条件

* aws configで環境設定しておくこと

## Usage

```bash:ec2ctl
$ ./ec2ctl
Usage: ./ec2ctl command [ OPTION ]
  list
  info [ INSTANCE_ID ]
  status [ INSTANCE_ID ]
  public-ip [ INSTANCE_ID ]
  private-ip [ INSTANCE_ID ]
  create SSH_KEY_NAME
  start [ INSTANCE_ID | -k keyword | --all ]
  stop [ INSTANCE_ID | -k keyword | --all ]
  terminate  INSTANCE_ID
```
