#!/usr/bin/env bash

STACK_NAME="blog-jasoniharris"
ROLE=`aws cloudformation describe-stacks --stack-name ${STACK_NAME} --query "Stacks[0].Outputs[?OutputKey=='IAMLambdaServiceRole'].OutputValue" --output text --profile jh-developer --region eu-west-2`
SNS_TOPIC=`aws cloudformation describe-stacks --stack-name ${STACK_NAME} --query "Stacks[0].Outputs[?OutputKey=='SNSTopic'].OutputValue" --output text --profile jh-developer --region eu-west-2`
S3_BUCKET=`aws cloudformation describe-stacks --stack-name ${STACK_NAME} --query "Stacks[0].Outputs[?OutputKey=='S3Bucket'].OutputValue" --output text --profile jh-developer --region eu-west-2`

echo "ROLE is ${ROLE}"
echo "SNS is ${SNS_TOPIC}"
echo "S3_BUCKET is ${S3_BUCKET}"

cd ../

sam build

sam package \
  --template-file template.yaml \
  --output-template-file package.yaml \
  --s3-bucket ${S3_BUCKET} \
  --profile jh-developer \
  --region eu-west-2

sam deploy \
  --template-file package.yaml \
  --stack-name blog-jasoniharris-checker \
  --capabilities CAPABILITY_IAM \
  --parameter-overrides ROLE=$ROLE SNSTOPIC=$SNS_TOPIC \
  --profile jh-developer \
  --region eu-west-2