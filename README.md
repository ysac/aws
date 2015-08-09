# AWS

## 概要

よく使うAWS CLIをシェルにした。ちょっとした情報を参照したい場合や、インスタンスの作成、起動、停止、削除などが可能。

## 前提条件

* 鍵ペア名は各自設定
* aws configで環境設定済み
* 下記サイトを参考に.ssh/configを分割
  * http://qiita.com/tumf/items/73e495e1274bc25acf5f

## Usage

```bash:ec2ctl
Usage: ./ec2ctl command [ OPTION ]
  list
  info [ INSTANCE_ID ]
  status [ INSTANCE_ID ]
  public-ip [ INSTANCE_ID ]
  private-ip [ INSTANCE_ID ]
  create NAME_TAG [ SSH_KEY_NAME ]
  start [ INSTANCE_ID | -k keyword | --all ]
  stop [ INSTANCE_ID | -k keyword | --all ]
  terminate INSTANCE_ID
  ssh-config
```
