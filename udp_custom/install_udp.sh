#!/bin/bash

# Agrega el alias al archivo .bashrc
echo "alias udp='/root/udp.sh'" >> ~/.bashrc


source ~/.bashrc



pausa(){
  echo -ne "\033[1;37m"
  read -p "Presiona Enter para Continuar"
  echo -e "\e[0m"  
}

info() {
  puerto=$1
  echo -e "\e[1;33m         INSTALADOR UDP CUSTOM | "
  echo -e "\e[1;36m         SOURCE OFICIAL DE Epro Dev Team"
  echo -e "             https://t.me/ePro_Dev_Team"
  echo -e "\e[1;35m         CODIGO REFACTORIZADO POR JOAQUIN\e[0m"
  [[ -z ${puerto} ]] || add.user ${puerto}
  pausa
  clear
}

[[ ! -d /etc/udp ]] && mkdir -p /etc/udp

make_service(){
  cat <<EOF > /etc/systemd/system/udp-custom.service
[Unit]
Description=udp-custom by ePro Dev. Team

[Service]
User=root
Type=simple
ExecStart=/bin/UDP-Custom server --config /etc/udp/config.json
WorkingDirectory=/etc/udp/
Restart=always
RestartSec=2s

[Install]
WantedBy=default.target
EOF

  systemctl daemon-reload
  systemctl start udp-custom
  systemctl enable udp-custom
  systemctl start udp-custom
}

download_udpServer(){
  echo -e "\e[1;34mDescargando binario UDPserver V 1.2"
  wget -O /bin/UDP-Custom 'https://raw.githubusercontent.com/vpsnet360/scripts/main/udp_custom/udp-amd64.bin' -q --show-progress
  chmod +x /bin/UDP-Custom
  echo -e "\e[1;32mDescarga y configuración del binario completada\e[0m"

  echo -e "\e[1;34mDescargando Config UDPserver"
  wget -O /etc/udp/config.json 'https://raw.githubusercontent.com/vpsnet360/scripts/main/udp_custom/config.json' -q --show-progress
  chmod 644 /etc/udp/config.json
  echo -e "\e[1;32mDescarga y configuración del archivo de configuración completada\e[0m"

  make_service
}
limpiar_tmp() {
    sudo find /tmp -type f -delete

}

limpiar_tmp

remove(){
  echo "Removiendo UDP CUSTOM..."
  systemctl stop udp-custom
  systemctl disable udp-custom
  rm /bin/UDP-Custom
  rm /etc/udp/config.json
  rm /etc/systemd/system/udp-custom.service
  systemctl daemon-reload
  echo "Servicio y archivos de UDPserver removidos correctamente."
  pausa
}

watch_logs() {
  clear
    echo -e "\e[34mMostrando logs en tiempo real de UDP CUSTOM. Presiona Enter para volver al menú.\e[0m"

    journalctl -u udp-custom.service -f & 
    JOURNAL_PID=$!

    read -p "Presiona Enter para detener."

    kill $JOURNAL_PID

    wait $JOURNAL_PID 2>/dev/null

    echo "Regresando al menú principal..."
}


while true
do
    if [[ $interrupted -eq 1 ]]; then
        interrupted=0
    else
        clear
        echo -e "\e[0m\e[1;33m      BINARIO OFICIAL DE Epro Dev Team 1.2"
        echo -e "\e[0m\e[1;34m         INSTALADOR UDP CUSTOM | JOAQUIN MOD"
        service_status=$(systemctl is-active udp-custom)
        if [[ "$service_status" == "active" ]]; then
            status_color="\e[1;32m[ ON ]\e[0m" 
        else
            status_color="\e[1;31m[ OFF ]\e[0m"  
        fi
        echo -e "\e[1;36m  [1] Instalar UDP CUSTOM \e[0m $status_color"
        echo -e "\e[1;34m  [2] Reiniciar UDP CUSTOM \e[0m"
        echo -e "\e[1;34m  [3] Detener UDP CUSTOM \e[0m"
        echo -e "\e[1;31m  [4] Remover UDP CUSTOM\e[0m"
        echo -e "\e[1;34m  [5] Info de Proyecto\e[0m"
        echo -e "\e[1;34m  [6] Ver Logs en Tiempo Real de UDP CUSTOM \e[0m"
        echo -e "\e[1;30m  [0] Volver\e[0m"
    fi

    read -p "Seleccione una opción: " opcion
    case $opcion in
        1) download_udpServer;;
        2) systemctl restart udp-custom; echo "UDP CUSTOM reiniciado."; pausa;;
        3) systemctl stop udp-custom; echo "UDP CUSTOM detenido."; pausa;;
        4) remove;;
        5) info;;
        6) watch_logs;;
        0) exit;;
        *) echo -e "\e[1;31mOpción no válida.\e[0m"; pausa;;
    esac
done
