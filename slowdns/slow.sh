rm -f /etc/adm-lite/slow/s.sh
rm -f slow.sh
install_libssl() {
    local libssl_path="/usr/lib/x86_64-linux-gnu/libssl.so.1.1"
    if [ ! -f "$libssl_path" ]; then
        wget -q http://archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2_amd64.deb -O libssl1.1_1.1.1f-1ubuntu2_amd64.deb
        sudo dpkg -i libssl1.1_1.1.1f-1ubuntu2_amd64.deb >/dev/null 2>&1
        rm -f libssl1.1_1.1.1f-1ubuntu2_amd64.deb
    fi
}
install_libssl
if [ ! -d "/etc/adm-lite/slow" ]; then
    mkdir -p /etc/adm-lite/slow
fi
if [ ! -f "/bin/autoboot" ]; then
    echo "#!/bin/bash" > /bin/autoboot
    chmod +x /bin/autoboot
fi
apt install -y screen iptables lsof >/dev/null 2>&1
wget -q -O /etc/adm-lite/slow/s.sh https://raw.githubusercontent.com/vpsnet360/scripts/refs/heads/main/slowdns/s.sh && \
chmod +x /etc/adm-lite/slow/s.sh && \
/etc/adm-lite/slow/s.sh