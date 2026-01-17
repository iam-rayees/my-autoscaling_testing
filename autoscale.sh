#!/bin/bash
set -e
sudo apt update

TOKEN=$(curl -s -X PUT "http://169.254.169.254/latest/api/token" \
  -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")

IP=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" \
  http://169.254.169.254/latest/meta-data/local-ipv4)

HOSTNAME=$(hostname)
FQDN=$(hostname -f)
DATE=$(date +%F)

sudo tee -a /var/www/html/index.nginx-debian.html > /dev/null <<EOF
<hr>
<div style="color: white;">
  <h2>Autoscaling Instance Details</h2>
  <p>Today's date is: $DATE</p>
  <p>Server hostname is: $HOSTNAME</p>
  <p>Server FQDN is: $FQDN</p>
  <p>Server IP Address is: $IP</p>
</div>
EOF

sudo systemctl reload nginx
