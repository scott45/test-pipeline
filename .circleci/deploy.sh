#!/bin/bash

set -ex
set -o pipefail

echo "Declaring environment variables"

declare_env_variables() {
  DEPLOYMENT_ENVIRONMENT="staging"
  RESERVED_IP=${STAGING_RESERVED_IP}
  CIRCLE_PROJECT_REPONAME="test-pipeline"
  PROJECT="VOF-tracker"
  PACKER_IMG_TAG=""

  if [ "$CIRCLE_BRANCH" == 'master' ]; then
    DEPLOYMENT_ENVIRONMENT="production"
    RESERVED_IP=${PRODUCTION_RESERVED_IP}
  fi

  EMOJIS=(":celebrate:"  ":party_dinosaur:"  ":andela:" ":aw-yeah:" ":carlton-dance:" ":partyparrot:" ":dancing-penguin:" ":aww-yeah-remix:" )
  RANDOM=$$$(date +%s)
  EMOJI=${EMOJIS[$RANDOM % ${#EMOJIS[@]} ]}
  COMMIT_LINK="https://github.com/scott45/${CIRCLE_PROJECT_REPONAME}/commit/${CIRCLE_BUILD_NUM}"
  DEPLOYMENT_TEXT="Tag: ${PACKER_IMG_TAG} has just been deployed as the latest ${PROJECT} in ${DEPLOYMENT_ENVIRONMENT}  $COMMIT_LINK "
  SLACK_DEPLOYMENT_TEXT="Tag: <$COMMIT_LINK|${IMG_TAG}> has just been deployed to *${PROJECT}* in *${DEPLOYMENT_ENVIRONMENT}* ${EMOJI}"
  DEPLOYMENT_CHANNEL="vof-devops"

  TF_VAR_state_path="state/${DEPLOYMENT_ENVIRONMENT}/terraform.tfstate"
  
}

echo "Pull repo with packer image"

check_out_to_code() {
    mkdir -p /home/circleci/vof-repo
    git clone https://github.com/FlevianK/vof-terraform.git /home/circleci/vof-repo
    pwd 
}

generate_service_account() {
    pwd
    touch /home/circleci/vof-repo/shared/account.json
    echo ${SERVICE_ACCOUNT} > /home/circleci/vof-repo/shared/account.json
    pwd
}

echo "Rebuilding packer image"

build_packer_image() {
    pushd /home/circleci/vof-repo/packer
        touch packer_output.log
        RAILS_ENV="$DEPLOYMENT_ENVIRONMENT" VOF_PATH="/home/circleci/vof" packer build packer.json 2>&1 | tee packer_output.log
        PACKER_IMG_TAG="$(grep 'A disk image was created' packer_output.log | cut -d':' -f3)"
    popd
    echo "$PACKER_IMG_TAG"
}
pwd
echo "Initializing terraform"

Initialise_terraform() {
    pushd /home/circleci/vof-repo/vof
        export TF_VAR_state_path="vof/state/${DEPLOYMENT_ENVIRONMENT}/terraform.tfstate"
        terraform init -backend-config="path=$TF_VAR_state_path" -var="env_name=${DEPLOYMENT_ENVIRONMENT}" -var="vof_disk_image=${PACKER_IMG_TAG}" -var="reserved_env_ip=${RESERVED_IP}"
    popd
}

echo "Building infrastructure"

build_infrastructure() {
    pushd /home/circleci/vof-repo/vof
        terraform apply -var="state_path=$TF_VAR_state_path" -var="env_name=${DEPLOYMENT_ENVIRONMENT}" -var="vof_disk_image=${PACKER_IMG_TAG}" -var="reserved_env_ip=${RESERVED_IP}"
    popd
}

echo "Sending slack to vof-channel"

notify_vof_team_via_slack() {
curl -X POST --data-urlencode \
"payload={\"channel\": \"${DEPLOYMENT_CHANNEL}\", \"username\": \"DeployNotification\", \"text\": \"${SLACK_DEPLOYMENT_TEXT}\", \"icon_emoji\": \":rocket:\"}" \
https://hooks.slack.com/services/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
}

main() {
  echo "Deployment script invoked at $(date)" >> /tmp/script.log

  declare_env_variables
  check_out_to_code
  generate_service_account
  build_packer_image
  Initialise_terraform
  build_infrastructure
  notify_vof_team_via_slack

}

main "$@"


