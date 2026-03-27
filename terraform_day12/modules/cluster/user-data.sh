#!/bin/bash
yum update -y
yum install -y python3

mkdir -p /var/www/html
echo "Hello Winjoy, This is ${app_version}" > /var/www/html/index.html

cd /var/www/html
nohup python3 -m http.server ${server_port} > /var/log/httpserver.log 2>&1 &

# Keep the script alive to ensure nohup starts properly
sleep 2
echo "Server started on port ${server_port}"