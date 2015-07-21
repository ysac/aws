#!/bin/sh
#
# aws ec2 instance control script
#

# DEFAULT SETTING
DEFAULT_AMI_ID='ami-cbf90ecb'
DEFAULT_INSTANCE_TYPE='t2.micro'
DEFAULT_SECURITY_GROUP='sg-b06e05d5'


usage() {

  echo "Usage: $0 command [ OPTION ]"
  echo "  id                            : display instance id(s)"
  echo "  info [ INSTANCE_ID ]          : display instance info with json"
  echo "  status [ INSTANCE_ID ]        : display instance status"
  echo "  public-ip [ INSTANCE_ID ]     : dispaly public ip(s)"
  echo "  private-ip [ INSTANCE_ID ]    : display private ip(s)"
  echo "  create SSH_KEY_NAME           : create instance"
  echo "  start [ INSTANCE_ID | --all ] : start instance(s)"
  echo "  stop [ INSTANCE_ID | --all ]  : stop instance(s)"
  echo "  terminate INSTANCE_ID         : terminate instance"

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


get_public_ip() {

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


create_instance() {

  _key_name=$1

  aws ec2 run-instances \
    --count 1 \
    --image-id ${DEFAULT_AMI_ID} \
    --instance-type ${DEFAULT_INSTANCE_TYPE} \
    --security-group-ids ${DEFAULT_SECURITY_GROUP} \
    --key-name ${_key_name}

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


terminate_instance() {

  _instance_id=$1

  check_instance_status "${_instance_id}" "stopped"
  if [ $? -ne 0 ]; then
    return 1
  fi

  aws ec2 terminate-instances \
    --instance-ids ${_instance_id}

  return ${_rc}

}


#
# main
#
arg2=$2

case "$1" in
  "create")
    create_instance ${arg2}
    ;;
  "id")
    get_instance_id
    ;;
  "info")
    get_instance_info ${arg2}
    ;;
  "status")
    get_instance_status ${arg2}
    ;;
  "public-ip")
    get_public_ip ${arg2}
    ;;
  "private-ip")
    get_private_ip ${arg2}
    ;;
  "start")
    start_instances ${arg2}
    ;;
  "stop")
    stop_instances ${arg2}
    ;;
  "terminate")
    terminate_instance ${arg2}
    ;;
  *)
    usage
    exit 1
    ;;
esac

exit $?
