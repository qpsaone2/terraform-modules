#!/bin/bash
# user-data.sh.tpl

# 웹 서버 설치 및 설정 (Apache2 설치)
echo "Installing Apache2 Web Server..."
sudo apt-get update -y
sudo apt-get install apache2 -y

# Apache2의 기본 웹 루트인 /var/www/html 디렉토리가 Apache2 설치 전에 없었다면 생성
echo "Ensuring /var/www/html directory exists..."
sudo mkdir -p /var/www/html

# 인덱스 페이지 생성 및 동적 데이터 주입
cat > /var/www/html/index.html <<EOF
<!DOCTYPE html>
<html>
<head>
    <title>VM Info</title>
    <style>
        body { font-family: sans-serif; background-color: #f0f0f0; padding: 20px; }
        .container { background-color: #fff; padding: 30px; border-radius: 8px; box-shadow: 0 4px 8px rgba(0,0,0,0.1); }
        h1 { color: #333; }
        p { color: #555; }
        strong { color: #007bff; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Hello from Terraform-managed Single VM!</h1>
        <p>This VM is named: <strong>${vm_name}</strong></p>
        <p>Web Server Port: <strong>${web_server_port}</strong></p>
        <p>Deployed with Module Version: <strong>${module_version}</strong></p>
    </div>
</body>
</html>
EOF

# Apache2 서비스 재시작
echo "Restarting Apache2 service..."
sudo systemctl restart apache2
sudo systemctl enable apache2 # VM 재부팅 시 자동 시작 설정

echo "Web server (Apache2) started on port ${web_server_port}."