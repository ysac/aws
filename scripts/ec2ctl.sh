#!/bin/sh
#
# ec2 instance start/stop script
#

DEFAULT_REGION='ap-northwest-1'


usage() {

  echo "Usage: $0 --start | --stop INSTANS_ID"

}


get_instans_status() {

  _instans_id=$1

  # describe-instance-status
  _instans_status=`aws ec2 describe-instance-status \
                   --region ${DEFAULT_REGION} \
                   --instance-ids ${_instans_id} | \
                   jq -r '.InstanceStatuses[].InstanceState.Name'`

  echo "${_instans_status}"

}


check_instans_status() {

  _instans_id=$1
  _check_status=$2

  _instans_status=`get_instans_status`
  if [ "${_instans_status}" != "${_check_status}" ]; then
    echo "ERROR: instans status is not ${_check_status} (${_instans_status})"
    return 1
  fi

  return 0

}


start_instans() {

  _instans_id=$1

  # get_instans_status
  check_instans_status ${_instans_id} "terminate"
  if [ $? -ne 0 ]; then
    return 1
  fi

  # start-instances
  aws ec2 start-instances \
  --region ${DEFAULT_REGION} \
  --instance-ids ${_instans_id}

  return $?

}


stop_instans() {

  _instans_id=$1

  # get_instans_status
  check_instans_status ${_instans_id} "running"
  if [ $? -ne 0 ]; then
    return 1
  fi

  # stop-instances
  aws ec2 stop-instances \
  --region ${DEFAULT_REGION} \
  --instance-ids ${_instans_id}

  return $?

}


#
# main
#
if [ $# -ne 2 ]; then
  usage
  exit 255
fi

instans_id=$2

case "$1" in
  "--start")
    start_instans ${instans_id}
    if [ $? -ne 0 ]; then
      echo "ERROR: start_instans failed"
      exit 1
    fi
    ;;
  "--stop")
    stop_instans ${instans_id}
    if [ $? -ne 0 ]; then
      echo "ERROR: stop_instans failed"
      exit 1
    fi
    ;;
  *)
    usage
    exit 255
    ;;
esac

exit 0
