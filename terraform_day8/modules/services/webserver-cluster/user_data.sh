#!/bin/bash
apt-get update -y
apt-get install -y apache2

# Switch Apache to port 8080
sed -i 's/^Listen 80/Listen 8080/' /etc/apache2/ports.conf
sed -i 's/<VirtualHost \*:80>/<VirtualHost *:8080>/' /etc/apache2/sites-enabled/000-default.conf

# Create the custom HTML page
cat > /var/www/html/index.html << EOF
<!DOCTYPE html>
<html>
  <head><title>${cluster_name}</title></head>
  <body style="font-family: Arial, sans-serif; text-align: center; padding: 50px;">
    <h1>${cluster_name}</h1>
    <p><strong>Day 8:</strong> Terraform Modules</p>
    <p><strong>Instance:</strong> $(curl -s http://169.254.169.254/latest/meta-data/instance-id)</p>
    <p><strong>AZ:</strong> $(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)</p>
    <p><strong>Timestamp:</strong> $(date)</p>
  </body>
</html>
EOF

systemctl enable apache2
systemctl restart apache2