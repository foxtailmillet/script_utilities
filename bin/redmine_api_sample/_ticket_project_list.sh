#!/bin/bash

function read_api () {
  project_id="$1"
  query="$2"
  RESULT=$(curl -s -X GET -H "X-Redmine-API-key:${API_ACCESS_KEY}" "${REDMINE_HOST}/projects/${project_id}/issues.json${query}")
  echo "$RESULT"
}

function filter_result () {
  result="$1"
  echo $result | jq ".issues[] |
  {ticket_id: .id,
   tracker_id: .tracker.id,
   tracker_name: .tracker.name,
   status_id: .status.id,
   status_name: .status.name,
   priority_id: .priority.id,
   priority_name: .priority.name,
   subject: .subject
 }"
}

# スクリプトの存在するディレクトリに移動
CURRENT=$(cd $(dirname $0);pwd)
cd $CURRENT

#  変数定義を読み込み
. ./env.sh

# 絞り込み条件を指定
PROJECT_ID="$1"
QUERY="$2" # 1:open, 2:in progress, 3:resolved, 4:feedback, 5:completed, 6:rejected 

# チケット一覧を取得
RESULT=$(read_api "$PROJECT_ID" "$QUERY")
filter_result "$RESULT"