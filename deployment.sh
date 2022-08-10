#!/usr/bin/env bash
##
##  Acuant Go Deployment Utility
##
##  usage:
##    ./deployment.sh qa
##
##  Parameters:
##  $1  - the environment name [local, dev, qa, staging, prod]
##

# create output directory
if [ -z "$EKS_TARGET_DIR" ]
then
    EKS_TARGET_DIR="target";
fi
mkdir -p "${EKS_TARGET_DIR}"

#Config map ENV template file name definition, this is used by the default function in acuant-cli/* to generate the config map template
CONFIG_MAP_TEMPLATE="${EKS_TARGET_DIR}/config-map-template.yaml"
cat "services/config-map.yml" > "${CONFIG_MAP_TEMPLATE}"
echo "" >> "${CONFIG_MAP_TEMPLATE}"

source acuant-cli/acuant-cli-hax.sh
source environments.bash

# function to allow service definition, invoked in services/index.bash
service(){
    SERVICE_NAME="$1"
    EKS_SOURCE_DIR="services/${SERVICE_NAME}/yaml"
    EKS_TARGET_FILE="${EKS_TARGET_DIR}/${SERVICE_NAME}.yaml"

    # clear any existing file...
    echo "# Service definition for '$SERVICE_NAME' " > "${EKS_TARGET_FILE}"

    # append each required file to the yaml
    shift
    while [ -n "$1" ]; do
        cat ${EKS_SOURCE_DIR}/${1}.y* | envsubst >> "${EKS_TARGET_FILE}"
        shift
    done

    info "service '$SERVICE_NAME' defined: ${EKS_TARGET_FILE}"
    #cat "${EKS_TARGET_FILE}"
}

#function to generate config_map.yml file common to all services, invoked in service/index.bash
generate_config_map() {
    CONFIG_MAP_FILE="${EKS_TARGET_DIR}/config-map.yml"
    cat ${CONFIG_MAP_TEMPLATE} | envsubst > "${CONFIG_MAP_FILE}"
    rm ${CONFIG_MAP_TEMPLATE}
}

# actually invoke the list of services and required files
source services/index.bash
