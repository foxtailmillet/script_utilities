#!/bin/bash

function read_one_api () {
  id="$1"
  RESULT=$(curl -s -X GET -H "X-Redmine-API-key:${API_ACCESS_KEY}" "${REDMINE_HOST}/issues/${id}.json")
  echo "$RESULT"
}

function filter_result () {
  result="$1"
  echo $result | jq ".issue |
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
ID="$1" 

if [ -n "$ID" ]; then
  # チケット一覧を取得
  RESULT=$(read_one_api "$ID")

  if [ "raw" == "$2" ]; then
    echo "$RESULT"
  else
    filter_result "$RESULT"
  fi
else 
  echo "first argument [ISSUE ID] is required."
fi


