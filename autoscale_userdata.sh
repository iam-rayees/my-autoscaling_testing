#!/bin/bash
set -euxo pipefail
apt-get update -y

# Append CSS only if not already present
if ! grep -q ".server-info" /var/www/html/style.css; then
  cat << 'EOF' >> /var/www/html/style.css

/* Server info panel */
.server-info {
  min-width: 320px;
  max-width: 380px;
  background: #1f1f1f;
  padding: 20px 24px;
  border-radius: 12px;
  color: #fff;
  box-shadow: 0 10px 25px rgba(0,0,0,0.3);
  position: sticky;
  top: 20px;
}

.server-info h3 {
  margin: 10px 0;
  font-weight: 500;
  font-size: 16px;
}
EOF
fi

# Get IMDSv2 token
TOKEN=$(curl -s -X PUT "http://169.254.169.254/latest/api/token" \
  -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")

AZ=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" \
  http://169.254.169.254/latest/meta-data/placement/availability-zone)

IP=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" \
  http://169.254.169.254/latest/meta-data/local-ipv4)

HOSTNAME=$(hostname)

FQDN=$(hostname -f)

DATE=$(date +%F)

sed -i "s|<body>|<body><div class=\"server-info\">\
<h3>Today's date: ${DATE}</h3>\
<h3>Hostname: ${HOSTNAME}</h3>\
<h3>Availability Zone: ${AZ}</h3>\
<h3>Private IP: ${IP}</h3>\
<h3>Server FQDN: ${FQDN}</h3>\
</div>|" /var/www/html/index.nginx-debian.html

systemctl restart nginx
systemctl enable nginx
