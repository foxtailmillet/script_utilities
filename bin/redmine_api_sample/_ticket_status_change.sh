#!/bin/bash

function update_api () {
  issue_id="$1"
  status_id="$2"
  notes="$3"

  ACCEPT="Accept: application/json"
  CONTENT_TYPE="Content-Type: application/json"
  REDMINE_API_KEY="X-Redmine-API-key:${API_ACCESS_KEY}"
  URL="${REDMINE_HOST}/issues/${issue_id}.json"

  param_json="
  {\"issue\":
    {\"status_id\":\"${status_id}\",
     \"notes\":\"${notes}\"}
  }"
  RESULT=$(curl -s -X PUT -d "$param_json" -H "$ACCEPT" -H "$CONTENT_TYPE" -H "$REDMINE_API_KEY" "$URL")
  echo "$RESULT"
}

# スクリプトの存在するディレクトリに移動
CURRENT=$(cd $(dirname $0);pwd)
cd $CURRENT

#  変数定義を読み込み
. ./env.sh

# 絞り込み条件を指定
ISSUE_ID="$1"

if [ -n "$ISSUE_ID" ]; then
  STATUS_ID="$2" # 1:open, 2:in progress, 3:resolved, 4:feedback, 5:completed, 6:rejected 
  NOTES="$3"

  # チケットを更新
  update_api "$ISSUE_ID" "$STATUS_ID" "$NOTES"

else
  echo "first argument [ISSUE ID] is required."
fi

