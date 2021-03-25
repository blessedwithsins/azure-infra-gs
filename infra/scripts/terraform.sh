#!/usr/bin/env bash
#
#  Purpose: Terraform Wrapper Script for deploying terraform templates.
#  Usage:
#    terraform.sh show

# https://elrey.casa/bash/scripting/harden
set -${-//[sc]/}eu${DEBUG+xv}o pipefail


###############################
## FUNCTIONS                 ##
###############################

function terraform_stuff() {

  terraform_action="${1}"
  terraform_folder=$PWD

  plan_file="${terraform_folder}/main.plan"
  state_file="${terraform_folder}/main.tfstate"

  case "${terraform_action}" in

    init)
      extra_args=("-backend-config storage_account_name=${TF_VAR_remote_state_account} -backend-config container_name=${TF_VAR_remote_state_container}"  "${terraform_folder}/")
      # extra_args=("-backend-config storage_account_name=${TF_VAR_remote_state_account} -backend-config container_name=${TF_VAR_remote_state_container} -plugin-dir=${terraform_folder}/providers"  "${terraform_folder}/")
      ;;

    plan)
      extra_args=("-var-file" "custom.tfvars" "-out" "${plan_file}" "${terraform_folder}/")
      ;;

    apply)
      extra_args=("-var-file" "custom.tfvars" "-auto-approve" "-state" "${state_file}")
      ;;

    apply-plan)
      extra_args=("-state" "${state_file}" "${plan_file}")
      ;;

    output)
      extra_args=("-state" "${state_file}")
      set +u
      if [[ -z "${2}" ]]; then
        extra_args+=()
      elif [[ -n "${2}" ]]; then
        extra_args+=("${2}")
      fi
      set -u
      ;;

    destroy)
      extra_args=("-auto-approve" "-state" "${state_file}" "${terraform_folder}/")
      ;;

    *)
      extra_args=()
      ;;

  esac

  terraform ${terraform_action} ${extra_args[@]}
}

function main() {

  if [[ $# -lt 1 ]]; then
    printf 'Please enter at one terraform directive: %s %s \n' "${0}" "<show|run|results|remove>"
    exit 1
  fi

  if [[ "${1}" == "clean" ]] || [[ "${1}" == "cleanup" ]]; then

    steps_array=('init' 'clean')
    for step in "${steps_array[@]}"; do
      if [[ "${step}" == "clean" ]]; then
        terraform workspace select default
        terraform workspace delete --force $TF_VAR_workspace
      else
        terraform_stuff "${step}"
      fi
    done

  elif [[ "${1}" == "show" ]]; then
    steps_array=('init' 'workspace' 'plan')

    for step in "${steps_array[@]}"; do
      if [[ "${step}" == "workspace" ]]; then
        terraform workspace new $TF_VAR_workspace || terraform workspace select $TF_VAR_workspace
      else
        terraform_stuff "${step}"
      fi
    done

  elif [[ "${1}" == "run" ]]; then
    steps_array=('init' 'workspace' 'plan' 'apply')

    for step in "${steps_array[@]}"; do
      if [[ "${step}" == "workspace" ]]; then
        terraform workspace new $TF_VAR_workspace || terraform workspace select $TF_VAR_workspace
      else
        terraform_stuff "${step}"
      fi
    done

  elif [[ "${1}" == "results" ]]; then
    steps_array=('init' 'workspace' 'output')

    for step in "${steps_array[@]}"; do
      if [[ "${step}" == "workspace" ]]; then
        terraform workspace new $TF_VAR_workspace || terraform workspace select $TF_VAR_workspace
      else
        terraform_stuff "${step}"
      fi
    done

  elif [[ "${1}" == "remove" ]]; then
    steps_array=('init' 'workspace' 'destroy')

    for step in "${steps_array[@]}"; do
      if [[ "${step}" == "workspace" ]]; then
        terraform workspace new $TF_VAR_workspace || terraform workspace select $TF_VAR_workspace
      else
        terraform_stuff "${step}"
      fi
    done

  elif [[ "${1}" == "help" ]]; then

  printf 'Please enter one ACTION=%s \n' "<show|run|results|remove>"

  else
    terraform_stuff "${@}"
  fi
}

# https://blog.elreydetoda.site/cool-shell-tricks/#bashscriptingbashsmain
if [[ "${0}" = "${BASH_SOURCE[0]}" ]]; then
  main "${@}"
fi
