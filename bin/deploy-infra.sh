#!/bin/bash

branch=$1
stack="blog-jasoniharris"
template_validate="file://../src/infra.json"
template="../src/infra.json"
profile="jh-developer"


if [ "$branch" = "develop"  ]; then
    echo "Branch is develop"
    aws cloudformation validate-template --template-body ${template_validate} --region "eu-west-2" --profile ${profile} 
    else
    echo "Branch is master"
    echo "Stack name is ${stack}"
    aws cloudformation deploy \
    --template-file ${template} \
    --stack-name ${stack} \
    --capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM CAPABILITY_AUTO_EXPAND \
    --no-fail-on-empty-changeset \
    --region "eu-west-2" \
    --profile ${profile}
fi