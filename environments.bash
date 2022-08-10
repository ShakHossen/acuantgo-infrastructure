
# These defaults apply to all environments

default DESIGN_VERSION          "v0.0.69-develop"
default INSTANCE_VERSION        "v0.1.77-develop"
default PROVISIONING_VERSION    "v0.0.30-develop"
default WEBSTORE_VERSION        "v-main-3.14.3"

# Import local settings, if present
[ -f '.env' ] && source '.env'

##### ALL VALUES SET HERE ARE DEFAULTS THAT MAY BE OVERRIDDEN BY DEPLOYMENT PIPELINE #####
default K8S_NAMESPACE           "default"

default SHORT_BRANCH_NAME       "unknown-v0.0"
default DEPLOY_COLOR            "latest"
default K8S_LABEL_DEPLOYMENT    "${SHORT_BRANCH_NAME}-${DEPLOY_COLOR}"

default CONFIG_MAP_NAME         "app-config-${K8S_LABEL_DEPLOYMENT}"
default SECRET_NAME             "app-secret-${K8S_LABEL_DEPLOYMENT}"

default DESIGN_SERVICE          "acuantgo-design"
default INSTANCE_SERVICE        "acuantgo-instance"
default PROVISIONING_SERVICE    "acuantgo-provisioning"
default WEBSTORE_SERVICE        "acuantgo-webstore"

default INSTANCE_PORT           "5005"
default PROVISIONING_PORT       "5003"
default WEBSTORE_PORT           "8443"
default DESIGN_PORT             "8006"

default SERVICE_PORT            "9090"

# Node design studio start script.
default SCRIPT_ENV              "acuant-k8s"

default INSTANCE_SERVICE_URL    "$AWS_ROUTE_53_INSTANCE"

default AWS_REGION              "us-east-1"
default AWS_ACCOUNT             "858475722663"
default AWS_ECR_REGISTRY        "${AWS_ACCOUNT}.dkr.ecr.${AWS_REGION}.amazonaws.com"

default DESIGN_IMAGE_REPO       "hub-design-studio-acuantgo"
default INSTANCE_IMAGE_REPO     "hub-instance-design-studio-acountgo"
default PROVISIONING_IMAGE_REPO "acuantgo-provisioning-service"
default WEBSTORE_IMAGE_REPO     "acuantgo-webstore"

req_env KAFKA_SERVICE_URL
default KAFKA_SERVICE_URL       ""
req_env REDIS_SERVICE_URL
default REDIS_SERVICE_URL       ""
default TWILIO_SERVICE_URL      "https://api.twilio.com/2010-04-01/Accounts/${TWILIO_SERVICE_SID}/Messages.json"

req_env ASSUREID_SERVICE_URL
default ASSUREID_SERVICE_URL     "https://preview.assureid.acuant.net/AssureIDService/"
req_env IDENTITYMIND_SERVICE_URL
default IDENTITYMIND_SERVICE_URL "https://staging.identitymind.com"

default DESIGN_IMAGE            "$AWS_ECR_REGISTRY/$DESIGN_IMAGE_REPO:$DESIGN_VERSION"
default INSTANCE_IMAGE          "$AWS_ECR_REGISTRY/$INSTANCE_IMAGE_REPO:$INSTANCE_VERSION"
default PROVISIONING_IMAGE      "$AWS_ECR_REGISTRY/$PROVISIONING_IMAGE_REPO:$PROVISIONING_VERSION"
default WEBSTORE_IMAGE          "$AWS_ECR_REGISTRY/$WEBSTORE_IMAGE_REPO:$WEBSTORE_VERSION"

# Other misc shared stuff
default BITBUCKET_API_URL               "https://api.bitbucket.org/2.0/repositories"
    
default DESIGN_VALIDATE_USER_TOKEN      "false"
# Note: GIT_REMOTE is a secret.
default GIT_TARGETS_REPO                "acuant/hub-client-targets-acuantgo-dev"
default GIT_TARGETS_BRANCH              "master"

default BITBUCKET_API_URL               "https://api.bitbucket.org/2.0/repositories"
# TODO: Need system user name for this.
default BITBUCKET_API_USR               "alexey_chudinov"

default PROVISIONING_API_DOMAIN         "acuantgo-dev.com"
default PROVISIONING_API_DISABLED       "true"

# MONGODB_URL moved to secrets as not all component values are available in the environment where this script will run.
# default MONGODB_URL                     "mongodb://${MONGODB_USER}:${MONGODB_PASSWORD}@${MONGODB_CLUSTER_URL}/${MONGODB_DATABASE_NAME}"

# for provisioning service
default PROVISIONING_TRUST_STORE        "/truststore/rds-truststore.jks"

default JWT_KEY                         ""
req_env JWT_KEY

# for hub instance service
default SSL_KEY_STORE_PATH              "file:/security/hub-keystore.jks"
default SSL_KEY_STORE_PASSWORD          ""  # Ensure it's included in config map, but leave it blank so `req_env` can verify that it is being specified externally.
req_env SSL_KEY_STORE_PASSWORD
default SSL_TRUST_STORE_PATH            "file:/security/cacerts-zenoo.jks"
default SSL_TRUST_STORE_PASSWORD        ""  # Ensure it's included in config map, but leave it blank so `req_env` can verify that it is being specified externally.
req_env SSL_TRUST_STORE_PASSWORD

# IdentityMind
default IDM_DESIGNSTUDIO_API_URL        "https://${AWS_ROUTE_53_DESIGN}/api/designstudio"
default IDM_DESIGNSTUDIO_USR            "adminacuant"
default IDM_CREDENTIALS_API_STG_URL     "https://go-stg-plugin.acuantgo-stg.com/api/getcredential"
default IDM_CREDENTIALS_API_STG_USR     "acuantgo"
default IDM_CREDENTIALS_API_PRD_URL     "https://go-plugin.acuantgo-prod.com/api/getcredential"
default IDM_CREDENTIALS_API_PRD_USR     "acuantgo"
default IDM_EDNA_US_STG_URL             "https://staging.identitymind.com"
default IDM_EDNA_US_SBX_URL             "https://sandbox.acuant.com"
default IDM_EDNA_US_DMO_URL             "https://demo.acuant.com"
default IDM_EDNA_US_PRD_URL             "https://edna.identitymind.com"
default IDM_EDNA_EU_STG_URL             "https://eu.staging.acuant.com"
default IDM_EDNA_EU_PRD_URL             "https://eu.edna.acuant.com"

# Mixpanel
default MIXPANEL_ID                     "e66fc206fb9a9d85edb642d28ec70b5d"
default MIXPANEL_API_URL                "https://mixpanel.com/api/2.0"
default MIXPANEL_PROJECT_ID             "2496369"
default MIXPANEL_FUNNEL_ID              "15147505"
default MIXPANEL_WORKSPACE_ID           "3037937"
default MIXPANEL_BOOKMARK_ID            "26963284"
default MIXPANEL_FUNNEL_START_DATE      "2021-01-01"

default COOKIE_EXPIRATION               "3600" # Seconds
default COOKIE_SECURE                   "false"
default COOKIE_HTTP_ONLY                "true"
default COOKIE_PUBLIC_KEY               "3676397924423F4528482B4D6251655468576D5A7134743777217A25432A4629"
default COOKIE_SAME_SITE                "none"
default COOKIE_SECURE_PROXY             "true"
    
default ANALYTICS_INTERCOM              "null"
default ANALYTICS_API_URL               "https://go-stg.acuant.com/api/reports"

default CONTAINER_PROTOCOL               "HTTP"

default ENVIRONMENT_NAME                 "dev"
default EKS_WORKER_NODE_GROUP            "eks-worker-node-group"

req_env AWS_TLS_CERTIFICATE_ARN_DESIGN
req_env AWS_ROUTE_53_DESIGN
req_env AWS_TLS_CERTIFICATE_ARN_INSTANCE
req_env AWS_ROUTE_53_INSTANCE
req_env AWS_TLS_CERTIFICATE_ARN_WEBSTORE
req_env AWS_ROUTE_53_WEBSTORE

# ToDo: What are good default values for these placeholders?
default AWS_HOSTED_ZONE ""
default AWS_CLOUDFRONT_CLEANUP_RATE "600000"
default AWS_CLOUDFRONT_CLEANUP_ENABLED true
default AWS_HOSTED_ZONE_ID 1
default AWS_CLOUDFRONT_VIEWER_CERTIFICATE ""
