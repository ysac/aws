#!/bin/sh
#
# aws ec2 instance control script
#


usage() {

  echo "Usage: $0 command [ OPTION ]"
  echo "  id                            : display instance id(s)"
  echo "  info [ INSTANCE_ID ]          : display instance info with json"
  echo "  status [ INSTANCE_ID ]        : display instance status"
  echo "  global-ip [ INSTANCE_ID ]     : dispaly global ip(s)"
  echo "  private-ip [ INSTANCE_ID ]    : display private ip(s)"
  echo "  start [ INSTANCE_ID | --all ] : start instance(s)"
  echo "  stop [ INSTANCE_ID | --all ]  : stop instance(s)"

}


get_instance_info() {

  _instance_id=$1

  if [ -n "${_instance_id}" ]; then
    aws ec2 describe-instances \
      --instance-ids ${_instance_id}
  else
    aws ec2 describe-instances
  fi

}


get_instance_id() {

  aws ec2 describe-instances | \
    jq -r '.Reservations[].Instances[].InstanceId'

}


get_instance_status() {

  _instance_id=$1

  if [ -n "${_instance_id}" ]; then
    aws ec2 describe-instances \
      --instance-ids ${_instance_id} | \
      jq -r '.Reservations[].Instances[].State.Name'
  else
    aws ec2 describe-instances | \
      jq -r '.Reservations[].Instances[] | "\(.InstanceId): \(.State.Name)"'
  fi

}


get_global_ip() {

  _instance_id=$1

  if [ -n "${_instance_id}" ]; then
    aws ec2 describe-instances \
      --instance-ids ${_instance_id} | \
      jq -r '.Reservations[].Instances[].PublicIpAddress'
  else
    aws ec2 describe-instances | \
      jq -r '.Reservations[].Instances[] | "\(.InstanceId): \(.PublicIpAddress)"'
  fi

}


get_private_ip() {

  _instance_id=$1

  if [ -n "${_instance_id}" ]; then
    aws ec2 describe-instances \
      --instance-ids ${_instance_id} | \
      jq -r '.Reservations[].Instances[].PrivateIpAddress'
  else
    aws ec2 describe-instances | \
      jq -r '.Reservations[].Instances[] | "\(.InstanceId): \(.PrivateIpAddress)"'
  fi

}


check_instance_status() {

  _instance_id=$1
  _check_status=$2

  if [ -z "${_instance_id}" ]; then
    echo "WARN: instance-id is null"
    return 1
  fi

  if [ -z "${_check_status}" ]; then
    echo "WARN: check status is null"
    return 1
  fi

  _instance_status=`get_instance_status ${_instance_id}`
  if [ "${_instance_status}" != "${_check_status}" ]; then
    echo "WARN: ${_instance_id} status is not ${_check_status} (${_instance_status})"
    return 1
  fi

  return 0

}


start_instance() {

  _instance_id=$1

  aws ec2 start-instances \
    --instance-ids ${_instance_id}

}

start_instances() {

  _instance_id=$1
  _rc=0

  if [ "${_instance_id}" = "--all" ]; then
    for _id in `get_instance_id`
    do
      check_instance_status "${_id}" "stopped"
      if [ $? -ne 0 ]; then
        _rc=`expr ${_rc} + 1`
        continue
      fi

      start_instance ${_id}
    done
  else
    check_instance_status "${_instance_id}" "stopped"
    if [ $? -ne 0 ]; then
      return 1
    fi

    start_instance ${_instance_id}
  fi

  return ${_rc}

}


stop_instance() {

  _instance_id=$1

  aws ec2 stop-instances \
    --instance-ids ${_instance_id}

}


stop_instances() {

  _instance_id=$1
  _rc=0

  if [ "${_instance_id}" = "--all" ]; then
    for _id in `get_instance_id`
    do
      check_instance_status "${_id}" "running"
      if [ $? -ne 0 ]; then
        _rc=`expr ${_rc} + 1`
        continue
      fi

      stop_instance ${_id}
    done
  else
    check_instance_status "${_instance_id}" "running"
    if [ $? -ne 0 ]; then
      return 1
    fi

    stop_instance ${_instance_id}
  fi

  return ${_rc}

}


#
# main
#
instance_id=$2

case "$1" in
  "id")
    get_instance_id
    ;;
  "info")
    get_instance_info ${instance_id}
    ;;
  "status")
    get_instance_status ${instance_id}
    ;;
  "global-ip")
    get_global_ip ${instance_id}
    ;;
  "private-ip")
    get_private_ip ${instance_id}
    ;;
  "start")
    start_instances ${instance_id}
    ;;
  "stop")
    stop_instances ${instance_id}
    ;;
  *)
    usage
    exit 1
    ;;
esac

exit $?
