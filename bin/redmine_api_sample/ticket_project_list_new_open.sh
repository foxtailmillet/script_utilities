#!/bin/bash

# スクリプトの存在するディレクトリに移動
CURRENT=$(cd $(dirname $0);pwd)
cd $CURRENT

# 絞り込み条件を指定
PROJECT_ID="sample-site"
QUERY="?status_id=1" # 1:open, 2:in progress, 3:resolved, 4:feedback, 5:completed, 6:rejected 

# チケット一覧を取得
bash _ticket_project_list.sh "$PROJECT_ID" "$QUERY"
