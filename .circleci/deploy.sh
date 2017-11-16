#!/bin/bash

set -ex
set -o pipefail

echo "Declaring environment variables"

declare_env_variables() {
  DEPLOYMENT_ENVIRONMENT="staging"
  CIRCLE_PROJECT_REPONAME="test-pipeline"
  PROJECT="VOF-tracker"
  PACKER_IMG_TAG=""

  if [ "$CIRCLE_BRANCH" == 'master' ]; then
    DEPLOYMENT_ENVIRONMENT="production"
  fi

  EMOJIS=(":celebrate:"  ":party_dinosaur:"  ":andela:" ":aw-yeah:" ":carlton-dance:" ":partyparrot:" ":dancing-penguin:" ":aww-yeah-remix:" )
  RANDOM=$$$(date +%s)
  EMOJI=${EMOJIS[$RANDOM % ${#EMOJIS[@]} ]}
  COMMIT_LINK="https://github.com/scott45/${CIRCLE_PROJECT_REPONAME}/commit/${CIRCLE_BUILD_NUM}"
  DEPLOYMENT_TEXT="Tag: ${PACKER_IMG_TAG} has just been deployed as the latest ${PROJECT} in ${DEPLOYMENT_ENVIRONMENT}  $COMMIT_LINK "
  SLACK_DEPLOYMENT_TEXT="Tag: <$COMMIT_LINK|${IMG_TAG}> has just been deployed to *${PROJECT}* in *${DEPLOYMENT_ENVIRONMENT}* ${EMOJI}"
  DEPLOYMENT_CHANNEL="vof-devops"

  TF_VAR_state_path="staging-state/terraform.tfstate"
  RESERVED_IP=""
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
    cd /home/circleci/vof-repo/packer
    packer build packer.json 2>&1 | tee packer_ouput.log
}

echo "Filtering new packer image name"

sort_and_pick_out_packer_built_image_name() {
    PACKER_IMG_TAG="$(grep 'A disk image was created' /home/circleci/vof-repo/packer/packer_output.log | cut -d':' -f3)" 
}

echo "Initializing terraform"

Initialise_terraform() {
    cd /home/circleci/vof-repo/vof
    terraform init -backend-config="path=$TF_VAR_state_path" -var="env_name=${DEPLOYMENT_ENVIRONMENT}" -var="vof_disk_image=${PACKER_IMG_TAG}" -var="reserved_env_ip=${RESERVED_IP}"
}

echo "Building infrastructure"

build_infrastructure() {
    terraform apply -var="state_path=$TF_VAR_state_path" -var="env_name=${DEPLOYMENT_ENVIRONMENT}" -var="vof_disk_image=${PACKER_IMG_TAG}" -var="reserved_env_ip=${RESERVED_IP}"
}

echo "Deploying to ${DEPLOYMENT_ENVIRONMENT}"
deploy_to_environment() {
    :
}

echo "Turning off error checking"

turn_off_error_checking() {
    set +e
}

echo " Collecting deployment logs"

saving_deployment_logs() {
    :
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
  sort_and_pick_out_packer_built_image_name
  Initialise_terraform
  build_infrastructure
  deploy_to_environment
  turn_off_error_checking
  saving_deployment_logs
  notify_vof_team_via_slack

}

main "$@"


