- terraform の EC2 は IAM User の AWS_ACCESS_KEY_ID と AWS_SECRET_ACCESS_KEY に基づいて作られる。
- EC2 へのアクセスはそのリージョンに登録された key-pair(.pem)が必要。IAM と EC2 インスタンスとは関係ない。
- IAM User の作り方

  - 以下 Policy を持つ UserGroup を作る
    AmazonSSMFullAccess AWS managed
    TerraformFullAccessToCloudWatch Customer managed
    TerraformFullAccessToEC2 Customer managed
    TerraformFullAccessToELB Customer managed
    TerraformFullAccessToIAM Customer managed
    TerraformFullAccessToRDS Customer managed
    TerraformFullAccessToS3 Customer managed
    TerraformFullAccessToSNS Customer managed
    TerraformSetPermissionLambdaAndAPI Customer managed
  - この UserGroup に新規 User を所有させ、Access Key を付与する。
    　 Application running on an AWS compute service:などを選ぶが、あまり関係ないみたい。
  - Access key と Secret Access key は 1 回しか表示されないので、メモるかメールして残す。

- EC2 ダッシュボードにログインし、Elastic IP を手動で作成。
- EC2 に ssh 接続する ip アドレスを固定するため、以下サイトで localhost のグローバル ip アドレスを確認。
  https://www.cman.jp/network/support/go_access.cgi
- terraform の各ファイルに環境変数を反映させるには、TF_VAR\_ のヘッダを付けて保存し、各 tf ファイルの variable で宣言する。
- .env に Elastic IP と自宅ルーターの global ip を宣言 (255 は仮のアドレス)
  TF_VAR_my_ip=255.255.255.255/32
  TF_VAR_eip=255.255.255.255
- terraform による EC2 デプロイは動作中のコンテナに入り、シェルスクリプト./build_ph1.sh を実行する。デプロイした EC2 インスタンスを維持することで、./destroy.sh で EC2 破棄できるようにするため。
- EC2 を立ち上げたら ctrl+shift+P で.ssh/config を開き、region と pem が一致する Remote Host の id EC2 インスタンスに変更
- 左下の><をクリックし
