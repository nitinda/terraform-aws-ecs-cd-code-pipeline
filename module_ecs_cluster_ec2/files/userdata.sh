#!/bin/bash
cat <<'EOF' >> /etc/ecs/ecs.config
ECS_CLUSTER=${ECS_CLUSTER_NAME}
ECS_BACKEND_HOST=
ECS_LOGLEVEL=error
ECS_ENABLE_SPOT_INSTANCE_DRAINING=true
EOF

#verify that the agent is running
curl -s http://localhost:51678/v1/metadata

# Install SSM Agent
yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm ec2-instance-connect nfs-utils bind-utils

# updates
yum -y update
yum -y install jq nvme-cli
easy_install pip
pip install --upgrade awscli