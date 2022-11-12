#!/bin/sh
registration_url="https://api.github.com/repos/${git_owner}/${git_repository}/actions/runners/registration-token"
echo "Requesting registration URL at '${registration_url}'"

payload=$(curl -sX POST -H "Authorization: token ${git_persoal_access_token}" ${registration_url})
export RUNNER_TOKEN=$(echo $payload | jq .token --raw-output)

./config.sh \
    --name Runner-${git_repository} \
    --token ${RUNNER_TOKEN} \
    --url https://github.com/${git_owner}/${git_repository} \
    --work . \
    --labels myrunner \
    --unattended \
    --replace

remove() {
    ./config.sh remove --unattended --token "${RUNNER_TOKEN}"
}

trap 'remove; exit 130' INT
trap 'remove; exit 143' TERM

./bin/runsvc.sh

wait $!
