#!/bin/bash

cat > /usr/local/bin/yijian << 'EOF2'
#!/bin/bash

function display_menu {
    echo "请选择要安装的工具："
    echo "1. 一键安装v2ray（台式机64位）"
    echo "2. 一键安装tinyfecvpn（台式机64位）"
    echo "3. 下载解压udp2raw（台式机64位）"
    echo "4. 下载解压tinyPortmap（台式机64位）"
    echo "5. 添加v2ray配置文件config"
    echo "按 Ctrl+C 退出。"
    echo "请输入数字(1-5)："
}

function generate_v2ray_config {
    local ip="$1"
    cat << EOF
{
  "inbounds": [
    {
      "listen": "${ip}",
      "port": 1136,
      "protocol": "shadowsocks",
      "settings": {
        "network": "tcp,udp",
        "method": "chacha20-ietf-poly1305",
        "password": "1136"
      }
    },
    {
      "listen": "${ip}",
      "port": 55555,
      "protocol": "shadowsocks",
      "settings": {
        "network": "tcp,udp",
        "method": "aes-128-cfb",
        "password": "w."
      }
    },
    {
      "listen": "${ip}",
      "port": 1,
      "protocol": "shadowsocks",
      "settings": {
        "network": "tcp,udp",
        "method": "aes-256-cfb",
        "password": "&6a%T"
      }
    },
    {
      "listen": "${ip}",
      "port": 2203,
      "protocol": "shadowsocks",
      "settings": {
        "network": "tcp,udp",
        "method": "aes-128-cfb",
        "password": "2203"
      }
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom",
      "settings": {}
    }
  ]
}
EOF
}

while true; do
    display_menu
    read choice

    case $choice in
        1)
            wget --no-check-certificate https://github.com/felix-fly/v2ray-openwrt/releases/download/4.31.0/v2ray-linux-amd64.tar.gz &&
            tar -zxvf v2ray-linux-amd64.tar.gz &&
            mv v2ray /usr/bin/v2ray -f &&
            rm v2ray-linux-amd64.tar.gz -f
            ;;
        2)
            wget --no-check-certificate https://github.com/wangyu-/tinyfecVPN/releases/download/20230206.0/tinyvpn_binaries.tar.gz
            tar -zxvf tinyvpn_binaries.tar.gz
            mv tinyvpn_amd64 /usr/bin/tinyvpn -f
            rm tinyvpn_* version.txt -f
            ;;
        3)
            wget --no-check-certificate https://github.com/wangyu-/udp2raw/releases/download/20230206.0/udp2raw_binaries.tar.gz
            tar -zxvf udp2raw_binaries.tar.gz
            mv udp2raw_amd64 /usr/bin/udp2raw -f
            rm udp2raw* version.txt -f
            ;;
        4)
            wget --no-check-certificate https://github.com/wangyu-/tinyPortMapper/releases/download/20200818.0/tinymapper_binaries.tar.gz
            tar -zxvf tinymapper_binaries.tar.gz
            mv tinymapper_amd64 /usr/bin/tinymapper -f
            rm tinymapper_* -f
            ;;
        5)
            echo "需要监听的IP地址（默认0.0.0.0）："
            read listen_ip
            if [ -z "${listen_ip}" ]; then
                listen_ip="0.0.0.0"
            fi

            echo "配置文件生成路径（默认/etc/v2ray/config.json）："
            read config_path
            if [ -z "${config_path}" ]; then
                config_path="/etc/v2ray/config.json"
            elif [ -d "${config_path}" ]; then
                config_path="${config_path%/}/config.json"
            fi

            mkdir -p "$(dirname "${config_path}")"
            generate_v2ray_config "${listen_ip}" > "${config_path}"
            echo "配置文件已生成：${config_path}"
            ;;
        *)
            echo "输入错误，请输入1-5的数字。"
            ;;
    esac
    echo ""
done
EOL


EOF2
chmod +x /usr/local/bin/yijian

# 获取脚本所在路径
script_path="$(readlink -f "$0")"

# 删除脚本自身
rm -f "$script_path"
clear
bash /usr/local/bin/yijian
