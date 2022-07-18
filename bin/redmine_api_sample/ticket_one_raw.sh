#!/bin/bash

# スクリプトの存在するディレクトリに移動
CURRENT=$(cd $(dirname $0);pwd)
cd $CURRENT

#  変数定義を読み込み
. ./env.sh

# 絞り込み条件を指定
ID="$1" 

# チケット一覧を取得
bash _ticket_one.sh "$ID" "raw"
