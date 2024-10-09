#!/bin/bash

# Agrega el alias al archivo .bashrc
echo "alias udp='/root/install_udp.sh'" >> ~/.bashrc

# Recarga el archivo .bashrc para que el alias sea efectivo
source ~/.bashrc

msg() {
  local colors="/etc/new-adm-color"
  if [[ ! -e $colors ]]; then
    COLOR[0]='\033[1;37m'
    COLOR[1]='\e[31m'
    COLOR[2]='\e[32m'
    COLOR[3]='\e[33m'
    COLOR[4]='\e[34m'
    COLOR[5]='\e[35m'
    COLOR[6]='\033[1;97m'
    COLOR[7]='\033[1;49;95m'
    COLOR[8]='\033[1;49;96m'
    COLOR[9]='\033[38;5;129m'
    COLOR[10]='\033[38;5;39m'
  else
    local COL=0
    for number in $(cat $colors); do
      case $number in
        1)COLOR[$COL]='\033[1;37m';;
        2)COLOR[$COL]='\e[31m';;
        3)COLOR[$COL]='\e[32m';;
        4)COLOR[$COL]='\e[33m';;
        5)COLOR[$COL]='\e[34m';;
        6)COLOR[$COL]='\e[35m';;
        7)COLOR[$COL]='\033[1;36m';;
        8)COLOR[$COL]='\033[1;49;95m';;
        9)COLOR[$COL]='\033[1;49;96m';;
        10)COLOR[$COL]='\033[38;5;39m';;
      esac
      let COL++
    done
  fi

  NEGRITO='\e[1m'
  SEMCOR='\e[0m'

  case $1 in
    -ne) cor="${COLOR[1]}${NEGRITO}" && echo -ne "${cor}${2}${SEMCOR}" ;;
    -ama) cor="${COLOR[3]}${NEGRITO}" && echo -e "${cor}${2}${SEMCOR}" ;;
    -verm) cor="${COLOR[3]}${NEGRITO}[!] ${COLOR[1]}" && echo -e "${cor}${2}${SEMCOR}" ;;
    -verm2) cor="${COLOR[1]}${NEGRITO}" && echo -e "${cor}${2}${SEMCOR}" ;;
    -aqua) cor="${COLOR[8]}${NEGRITO}" && echo -e "${cor}${2}${SEMCOR}" ;;
    -azu) cor="${COLOR[6]}${NEGRITO}" && echo -e "${cor}${2}${SEMCOR}" ;;
    -verd) cor="${COLOR[2]}${NEGRITO}" && echo -e "${cor}${2}${SEMCOR}" ;;
    -bra) cor="${COLOR[0]}${SEMCOR}" && echo -e "${cor}${2}${SEMCOR}" ;;
    -bar)
      WIDTH=43
      echo -e "${COLOR_AMARILLO_FLUORESCENTE}$(printf '%.0s━' $(seq 1 $WIDTH))${SEMCOR}"
    ;;
    -bar1)
      WIDTH=43
      echo -e "${COLOR_AMARILLO_FLUORESCENTE}$(printf '%.0s━' $(seq 1 $WIDTH))${SEMCOR}"
    ;;
    -bar2)
      echo -e "${COLOR[10]}=====================================================${SEMCOR}"
    ;;
    -bar3)
      echo -e "${COLOR_VERDE_FLUORESCENTE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${SEMCOR}"
    ;;
    -bar4)

      echo -e "${COLOR[5]}•••••••••••••••••••••••••••••••••••••••••••••••${SEMCOR}"
    ;;
    -bar5)
      WIDTH=50
      echo -e "${COLOR_VERDE_FLUORESCENTE}$(printf '%.0s━' $(seq 1 $WIDTH))${SEMCOR}"
    ;;
  esac
}
pausa(){
  echo -ne "\033[1;37m"
  read -p "Presiona Enter para Continuar"
  echo -e "\e[0m"  
}
tittle () {
    clear&&clear
    msg -bar2
    echo -e "     \033[1;44;44m   \033[1;33m=====>>►► mod by manu ◄◄<<=====  \033[0m  \033[0;33m"
    
    
}
info() {
  clear

  tittle
  puerto=$1
  echo -e "\e[1;33m         INSTALADOR UDP CUSTOM | "
  echo -e "\e[1;36m         SOURCE OFICIAL DE Epro Dev Team"
  echo -e "             https://t.me/manu360x"
  echo -e "\e[1;35m         CODIGO REFACTORIZADO POR MAGNU\e[0m"
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
  wget -O /bin/UDP-Custom 'https://raw.githubusercontent.com/joaquin1444/udp/main/udp-amd64.bin' -q --show-progress
  chmod +x /bin/UDP-Custom
  echo -e "\e[1;32mDescarga y configuración del binario completada\e[0m"

  echo -e "\e[1;34mDescargando Config UDPserver"
  wget -O /etc/udp/config.json 'https://raw.githubusercontent.com/joaquin1444/udp/main/config.json' -q --show-progress
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

  declare -A user_ips 

 
  journalctl -u udp-custom.service -f | while read -r line; do
      
      if [[ $line =~ ([0-9]{2}:[0-9]{2}:[0-9]{2}) ]]; then
          time="${BASH_REMATCH[1]}"
      fi

      if [[ $line =~ "Client connected" ]]; then
          if [[ $line =~ \[src:([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+):[0-9]+\] ]]; then
              ip="${BASH_REMATCH[1]}"
          fi
          if [[ $line =~ \[user:([^\]]+)\] ]]; then
              user="${BASH_REMATCH[1]}"
              user_ips["$ip"]="$user"
          fi
          echo -e "\033[32m[Conectado] \033[0m Hora: $time\nIP: $ip\nUsuario: ${user_ips[$ip]}\n"
      fi

      if [[ $line =~ "Client disconnected" ]]; then
          if [[ $line =~ \[src:([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+):[0-9]+\] ]]; then
              ip="${BASH_REMATCH[1]}"
          fi
          user="${user_ips[$ip]}"
          echo -e "\033[31m[Desconectado] \033[0m Hora: $time\nIP: $ip\nUsuario: ${user:-Desconocido}\n"
          unset user_ips["$ip"]
      fi
  done &

  JOURNAL_PID=$!


  read -p "Presiona Enter para detener."


  if ps -p $JOURNAL_PID > /dev/null; then
    kill $JOURNAL_PID
    wait $JOURNAL_PID 2>/dev/null
  fi

  echo "Regresando al menú principal..."
}
function manage_iptables() {
  while true; do
    clear
    tittle "mod by manu"
    echo -e "\e[1;34mReglas actuales en iptables (UDP):\e[0m"
    iptables -t nat -L PREROUTING -n --line-numbers | grep udp
    echo -e "\nSeleccione una acción:"
    echo -e "\e[1;36m  [1] Agregar regla UDP Custom (DonWeb o InetGaming)\e[0m"
    echo -e "\e[1;31m  [2] Eliminar una regla existente para UDP Custom\e[0m"
    echo -e "\e[1;36m  [3] Información sobre configuración de reglas UDP\e[0m"
    echo -e "\e[1;31m  [0] Volver al menú anterior\e[0m"

    read -p "Seleccione una opción: " sub_opcion
    case $sub_opcion in
      1) 
        clear
        echo -e "\e[1;34mSeleccione el tipo de regla a agregar:\e[0m"
        echo -e "\e[1;36m  [1] DonWeb (rango 1:36712 redirigido al puerto 36712)\e[0m"
        echo -e "\e[1;36m  [2] InetGaming (rango 1:65535 redirigido al puerto 36712)\e[0m"
        echo -e "\e[1;36m  [3] DNAT para redirigir tráfico UDP con un rango personalizado\e[0m"
        read -p "Seleccione el tipo de regla: " tipo_regla
        case $tipo_regla in
          1) 
            iptables -t nat -A PREROUTING -p udp --dport 1:36712 -j DNAT --to-destination :36712
            echo -e "\e[1;36mRegla DNAT agregada exitosamente para DonWeb (1:36712 -> :36712).\e[0m"
            ;;
          2) 
            iptables -t nat -A PREROUTING -p udp --dport 1:65535 -j DNAT --to-destination :36712
            echo -e "\e[1;36mRegla DNAT agregada exitosamente para InetGaming (1:65535 -> :36712).\e[0m"
            ;;
          3)
            read -p "Ingrese el rango de puertos de origen (por ejemplo 1000:2000): " rango_puertos
            read -p "Ingrese el puerto de destino (presione Enter para usar 36712 por defecto): " puerto_destino
            puerto_destino=${puerto_destino:-36712}  # Si no se ingresa puerto, usar 36712
            iptables -t nat -A PREROUTING -p udp --dport "$rango_puertos" -j DNAT --to-destination :"$puerto_destino"
            echo -e "\e[1;36mRegla DNAT agregada exitosamente para rango $rango_puertos -> :$puerto_destino.\e[0m"
            ;;
          *) 
            echo -e "\e[1;32mOpción no válida.\e[0m"
            ;;
        esac
        ;;
      2) 
        clear
        echo -e "\e[1;36mReglas actuales en iptables (UDP):\e[0m"
        iptables -t nat -L PREROUTING -n --line-numbers | grep udp
        read -p "Ingrese el número de la regla que desea eliminar (o presione Enter para cancelar): " regla_num
        if [[ -n "$regla_num" ]]; then
          iptables -t nat -D PREROUTING $regla_num
          if [[ $? -eq 0 ]]; then
            echo -e "\e[1;31mRegla número $regla_num eliminada exitosamente.\e[0m"
          else
            echo -e "\e[1;31mNo se pudo eliminar la regla número $regla_num. Verifique que el número sea correcto.\e[0m"
          fi
        else
          echo -e "\e[1;33mNo se ingresó ningún número. No se realizó ninguna acción.\e[0m"
        fi
        echo -e "\e[1;34mReglas actuales en iptables (UDP):\e[0m"
        iptables -t nat -L PREROUTING -n --line-numbers | grep udp
        ;;
      3) 
        clear
        tittle "mod by manu"
        msg -ama "Información sobre configuración de reglas UDP:\n"
        msg -ama "Para el funcionamiento correcto del servicio UDP,\nes obligatorio configurar una regla en iptables."
        msg -ama "Esta regla redirige el tráfico UDP al puerto local"
        msg -ama "donde el servicio está escuchando. Sin esta configuración,\nel tráfico UDP podría no manejarse adecuadamente y causar problemas de conectividad."
        ;;
      0) 
        break
        ;;
      *) 
        echo -e "\e[1;31mOpción no válida.\e[0m"
        ;;
    esac
    pausa
  done
}
while true
do
    if [[ $interrupted -eq 1 ]]; then
        interrupted=0
    else
        clear
        tittle
        msg -bar2
        service_status=$(systemctl is-active udp-custom)
        if [[ "$service_status" == "active" ]]; then
            status_color="\e[1;32m[ ON ]\e[0m" 
        else
            status_color="\e[1;31m[ OFF ]\e[0m"  
        fi
        echo -e "\e[1;36m  [1] Instalar UDP CUSTOM \e[0m $status_color"
        echo -e "\e[1;36m  [2] Reiniciar UDP CUSTOM \e[0m"
        echo -e "\e[1;36m  [3] Detener UDP CUSTOM \e[0m"
        echo -e "\e[1;31m  [4] Remover UDP CUSTOM\e[0m"
        echo -e "\e[1;36m  [5] Info de Proyecto\e[0m"
        echo -e "\e[1;36m  [6] Ver Logs en Tiempo Real de UDP CUSTOM \e[0m"
        echo -e "\e[1;36m  [7] Gestionar reglas iptables para UDP CUSTOM\e[0m"
        echo -e "\e[1;31m  [0] Volver\e[0m"
    fi

    read -p "Seleccione una opción: " opcion
    case $opcion in
        1) download_udpServer;;
        2) systemctl restart udp-custom; echo "UDP CUSTOM reiniciado."; pausa;;
        3) systemctl stop udp-custom; echo "UDP CUSTOM detenido."; pausa;;
        4) remove;;
        5) info;;
        6) watch_logs;;
        7) manage_iptables;;
        0) exit;;
        *) echo -e "\e[1;31mOpción no válida.\e[0m"; pausa;;
    esac
done