#!/bin/bash

# スクリプトの存在するディレクトリに移動
CURRENT=$(cd $(dirname $0);pwd)
cd $CURRENT

#  変数定義を読み込み
. ./env.sh

# 絞り込み条件を指定
ISSUE_ID="$1"

STATUS_ID="5" # 1:open, 2:in progress, 3:resolved, 4:feedback, 5:completed, 6:rejected 
NOTES="テスト チケット更新。\\r\\n チケットステータスを「5: 完了」に変更して、このコメントを追加。"

# チケットを更新
bash ./_ticket_status_change.sh "$ISSUE_ID" "$STATUS_ID" "$NOTES"

# チケット更新結果を表示
echo "=========== completed ================"
bash ./ticket_project_list_completed.sh
echo "=========== in progress ================"
bash ./ticket_project_list_in_progress.sh
echo "=========== new open ================"
bash ./ticket_project_list_new_open.sh

