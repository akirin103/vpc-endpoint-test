# vpc-endpoint-test

VPCエンドポイントを利用してs3にプライベート接続を行う実験をします。

## 実験方法

1. パブリックサブネット内のサーバからS3へアクセス(インターネット経由)
    ```
    # パブリックサーバへのSSH
    $ ssh ec2-user@<パブリックサーバのpublic-ip>
    # バケット一覧を表示
    $ aws s3 ls --region ap-northeast-1
    > bucketが表示される
    ```

2. プライベートサブネット内のサーバからS3へアクセス(VPCエンドポイント作成前)
    ```
    # プライベートサーバへ多段SSH
    $ ssh -o ProxyCommand='ssh -W %h:%p ec2-user@<パブリックサーバのpublic-ip>' ec2-user@<プライベートサーバのprivate-ip>
    # バケット一覧を表示
    $ aws s3 ls --region ap-northeast-1
    > bucketが表示されない
    ```

3. VPCエンドポイント経由で内のサーバへのアクセス(VPCエンドポイント作成後)
    ```
    # プライベートサーバへ多段SSH
    $ ssh -o ProxyCommand='ssh -W %h:%p ec2-user@<パブリックサーバのpublic-ip>' ec2-user@<プライベートサーバのprivate-ip>
    # バケット一覧を表示
    $ aws s3 ls --region ap-northeast-1
    > bucketが表示される
    ```

## Memo

- `AmazonLinux2`にはデフォルトで`AWS CLI`がインストール済み。
- VPCエンドポイントのGateway型は無料だが、PrivateLink型は時間あたりの課金。
- VPCエンドポイント作成後はルートテーブルの修正が必要。

## 参考

[VPCにいるだけで利用料金がかかってしまうリソース](https://fu3ak1.hatenablog.com/entry/2020/07/02/233639)
