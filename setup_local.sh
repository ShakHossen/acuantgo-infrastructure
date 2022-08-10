#!/bin/bash
echo '#Local Environment variables' > .env
echo 'export K8S_NAMESPACE="acuant-go"' >> .env
echo 'export HOST_MACHINE_DNS_NAME="host.docker.internal"' >> .env
echo 'export MONGODB_DATABASE_NAME="acuantGoProvisioningDB"' >> .env
echo 'export MONGODB_URL="mongodb://${HOST_MACHINE_DNS_NAME}/${MONGODB_DATABASE_NAME}"' >> .env
echo 'export AWS_ECR_REGISTRY="localhost:5001"' >> .env
echo 'export KAFKA_SERVICE_URL="host.docker.internal:9092"' >> .env  # should this be 9092 for testing?
echo 'export REDIS_SERVICE_URL="host.docker.internal:6379"' >> .env
echo 'export ASSUREID_SERVICE_URL=1.1.1.1' >> .env
echo 'export IDENTITYMIND_SERVICE_URL=1.1.1.1' >> .env
echo 'export AWS_TLS_CERTIFICATE_ARN_DESIGN="default"' >> .env
echo 'export AWS_ROUTE_53_DESIGN="default-host-design"' >> .env
echo 'export AWS_TLS_CERTIFICATE_ARN_INSTANCE="default"' >> .env
echo 'export AWS_ROUTE_53_INSTANCE="default-host-instance"' >> .env
echo 'export AWS_TLS_CERTIFICATE_ARN_WEBSTORE="default"' >> .env
echo 'export AWS_ROUTE_53_WEBSTORE="default-host-webstore"' >> .env

cat <<- EOF >> .env
export AWS_REGION="us-west-2"
export AWS_HOSTED_ZONE="acuantgo-qa.com"
export AWS_HOSTED_ZONE_ID="Z08166051ZOOKT5QKBB09"
export AWS_CLOUDFRONT_VIEWER_CERTIFICATE="arn:aws:acm:us-east-1:858475722663:certificate/9243d124-0a2b-4940-8543-7e92997fb692"
export AWS_CLOUDFRONT_CLEANUP_RATE="30000"
#
# Need to change this for non-containerized execution because build process moves truststore when building containerized provisioning service, and default k8s configuration is set up to find it in the new location.
PROVISIONING_TRUST_STORE="src/main/resources/truststore/rds-truststore.jks"
#
# (Script?) Retrieve the following from AWS secrets, decode base64 values, and add manually to local
# run configurations (different applications require different subsets of these values).
# API_PASSWORD
# API_USER
# AWS_PROVISION_ACCESS_KEY
# AWS_PROVISION_SECRET_KEY
# IDENTITYMIND_KEY
# IDENTITYMIND_USER
# IDM_*  (multiple; needed for hub instance and design studio)
# JWT_KEY
# MIXPANEL_API_SECRET
# REDIS_SERVICE_PASSWORD
# SERVER_SECURITY_TRUST_STORE_PASSWORD
# SSL_KEY_STORE_PASSWORD
# SSL_TRUST_STORE_PASSWORD
# TWILIO_SERVICE_AUTH_TOKEN
# TWILIO_SERVICE_MESSAGING_SID
# TWILIO_SERVICE_SID
EOF
