#!/bin/bash
set -ex
if [[ -n $(find $DOMAIN_HOME -maxdepth 0 -empty) ]]; then
cat <<'EOF'> /u01/oracle/properties/domain_security.properties
username=myuser
password=mypassword1
EOF
cat <<'EOF'> /u01/oracle/properties/domain.properties
DOMAIN_NAME=domain1
SSL_ENABLED=false
ADMIN_PORT=7001
ADMIN_SERVER_SSL_PORT=7002
ADMIN_NAME=admin-server
ADMIN_HOST=wlsadmin
MANAGED_SERVER_PORT=8001
MANAGED_SERVER_SSL_PORT=8002
MANAGED_SERVER_NAME_BASE=managed-server
CONFIGURED_MANAGED_SERVER_COUNT=1
CLUSTER_NAME=cluster-1
DEBUG_PORT=8453
DB_PORT=1527
DEBUG_FLAG=true
PRODUCTION_MODE_ENABLED=true
CLUSTER_TYPE=DYNAMIC
JAVA_OPTIONS=-Dweblogic.StdoutDebugEnabled=false
T3_CHANNEL_PORT=30012
T3_PUBLIC_ADDRESS=kubernetes
IMAGE_TAG=domain-home-in-image:12.2.1.3
EOF
/u01/oracle/createWLSDomain.sh
chmod -R g+w $DOMAIN_HOME
rm ${PROPERTIES_FILE_DIR}/*.properties
fi