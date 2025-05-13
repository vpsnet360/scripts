#!/bin/bash
rm -rf installdrop.sh
    echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo -e "\E[41;1;37m                MINI INSTALADOR DROPBEAR 2019                 \E[0m"
    echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
wget -q http://archive.ubuntu.com/ubuntu/pool/universe/d/dropbear/dropbear-bin_2019.78-2build1_amd64.deb 

chmod +x dropbear-bin_2019.78-2build1_amd64.deb 

dpkg -i dropbear-bin_2019.78-2build1_amd64.deb
rm -rf dropbear-bin_2019.78-2build1_amd64.deb
echo "PAQUETE DE SSH-2.0-DROPBEAR_2019.78 INSTALADO"
read -p "\033[1;37m INGRESE PUERTO :" port
cat <<EOF >/etc/default/dropbear
NO_START=0
DROPBEAR_EXTRA_ARGS=" -p $port "
DROPBEAR_RECEIVE_WINDOW=65536
DROPBEAR_BANNER=""
EOF
echo "DROPBEAR CONFIGURADO OK"
service dropbear restart
echo "/bin/false" >> /etc/shells
ufw allow $port
    echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo -e "\E[41;1;37m                ¡INSTALACIÓN COMPLETA!                 \E[0m"
    echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"