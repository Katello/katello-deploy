#!/usr/bin/env bats
# vim: ft=sh:sw=2:et

set -o pipefail

load os_helper
load foreman_helper
load fixtures/content

@test "remove subscription manager" {
  if [ -e "/etc/rhsm/ca/candlepin-local.pem" ]; then
    rpm -e `rpm -qf /etc/rhsm/ca/candlepin-local.pem`
  fi

  cleanSubscriptionManager
  tPackageRemove subscription-manager
}

@test "disable puppet agent to prevent checkin from registering host to another org" {
  systemctl is-active puppet || skip "Puppet is not active"
  systemctl stop puppet
}

@test "delete host if present" {
  hammer host delete --name=$HOSTNAME || echo "Could not delete host"
}

@test "register with global registration with activation key" {
  run yum erase -y 'katello-ca-consumer-*'
  echo "rc=${status}"
  echo "${output}"

  registration_command=$(curl https://admin:changeme@$HOSTNAME/api/registration_commands -X POST -H 'Content-Type: application/json' -d '"activation_key":"${ACTIVATION_KEY}","organization":"${ORGANIZATION_LABEL}"' | ruby -e "require 'json'; puts JSON.load(ARGF.read)['registration_command']")
  $registration_command
}

@test "check content host is registered" {
  hammer host info --name $HOSTNAME
}

@test "enable content view repo" {
  subscription-manager repos --enable="${ORGANIZATION_LABEL}_${PRODUCT_LABEL}_${YUM_REPOSITORY_LABEL}" | grep -q "is enabled for this system"
}

@test "install katello-host-tools" {
  tPackageInstall katello-host-tools && tPackageExists katello-host-tools
}

@test "install package locally" {
  run yum -y remove walrus
  tPackageInstall walrus-0.71 && tPackageExists walrus-0.71
}

@test "check available errata" {
  local next_wait_time=0
  until hammer host errata list --host $HOSTNAME | grep 'RHEA-2012:0055'; do
    if [ $next_wait_time -eq 14 ]; then
      # make one last try, also makes the error nice
      hammer host errata list --host $HOSTNAME | grep 'RHEA-2012:0055'
    fi
    sleep $(( next_wait_time++ ))
  done
}

@test "try fetching container content" {
  tPackageExists podman || tPackageInstall podman
  podman login $HOSTNAME -u admin -p changeme
  CONTAINER_PULL_LABEL=`echo "${ORGANIZATION_LABEL}-${PRODUCT_LABEL}-${CONTAINER_REPOSITORY_LABEL}"| tr '[:upper:]' '[:lower:]'`
  podman pull "${HOSTNAME}/${CONTAINER_PULL_LABEL}"
}

@test "cleanup subscription-manager after content tests" {
  cleanSubscriptionManager
}
