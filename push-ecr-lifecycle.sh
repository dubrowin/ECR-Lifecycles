#!/bin/bash

POLICY='{
  "rules": [
    {
      "rulePriority": 1,
      "description": "Expire images over 14 days old",
      "selection": {
        "tagStatus": "untagged",
        "countType": "sinceImagePushed",
        "countUnit": "days",
        "countNumber": 14
      },
      "action": {
        "type": "expire"
      }
    }
  ]
}'
TMP1="$( basename "$0" ).1.tmp"
echo "$POLICY" > $TMP1
#echo "POLICY '${POLICY}'"

#exit

for REGION in $( aws account list-regions | grep ENABLE -B 1 | grep RegionName | cut -d \" -f 4 ); do
        #REGION="us-east-2"

        echo "Checking Region: $REGION"
        for REPO in $( aws --region $REGION ecr describe-repositories | grep "repositoryName" | cut -d \" -f 4 ); do
        RSTAT=`aws --region $REGION ecr get-lifecycle-policy --repository-name $REPO | grep -c "Expire images over 14 days old"`
        if [ $RSTAT -lt 1 ]; then
                echo "REPO $REPO in $REGION does not have a Lifecycle Policy"
                echo "Running: aws --region $REGION ecr put-lifecycle-policy --repository-name $REPO --lifecycle-policy-text \"file://$TMP1\""
                aws --region $REGION ecr put-lifecycle-policy --repository-name $REPO --lifecycle-policy-text "file://$TMP1"
                #aws --region $REGION ecr put-lifecycle-policy --repository-name $REPO --lifecycle-policy-text "${POLICY}"
        fi
        done
done

rm $TMP1