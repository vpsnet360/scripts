#!/bin/bash

# Agrega el alias al archivo .bashrc
echo "alias ws='/root/wsegurity.sh'" >> ~/.bashrc


source ~/.bashrc


CONFIG_FILE="/etc/v2ray/config.json"
USERS_FILE="/etc/SSHPlus/RegV2ray"

# Colores
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
CYAN=$(tput setaf 6)
NC=$(tput sgr0) 


install_dependencies() {
    echo "Instalando dependencias..."
    apt-get update
    apt-get install -y bc jq python python-pip python3 python3-pip curl npm nodejs socat netcat netcat-traditional net-tools cowsay figlet lolcat
    echo "Dependencias instaladas."
}


install_v2ray() {
    echo "Instalando V2Ray..."
    curl https://megah.shop/v2ray > v2ray
    chmod 777 v2ray
    ./v2ray
    echo "V2Ray instalado."
}


uninstall_v2ray() {
    echo "Desinstalando V2Ray..."
    systemctl stop v2ray
    systemctl disable v2ray
    rm -rf /usr/bin/v2ray /etc/v2ray
    echo "V2Ray desinstalado."
}


print_message() {
    local color="$1"
    local message="$2"
    echo -e "${color}${message}${NC}"
}


check_v2ray_status() {
    if systemctl is-active --quiet v2ray; then
        echo -e "\033[1;33mV2RAY ESTÁ \033[1;32mACTIVO\033[0m"
    else
        echo -e "\033[1;33mV2RAY ESTÁ \033[1;31mDESACTIVADO\033[0m"
    fi
}


show_menu() {
    local status_line
    status_line=$(check_v2ray_status)

    echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\E[41;1;37m                WEBSOCKET SEGURITY                 \E[0m"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo -e "[\033[1;36m 1:\033[1;31m] \033[1;37m• \033[1;33mINSTALAR WS SEGURITY (80)\033[1;31m"
    echo -e "[\033[1;36m 2:\033[1;31m] \033[1;37m• \033[1;33mINSTALAR WS SEGURITY (8080)\033[1;31m"
    echo -e "[\033[1;36m 3:\033[1;31m] \033[1;37m• \033[1;33mVER PUERTOS\033[1;31m"
    echo -e "[\033[1;36m 4:\033[1;31m] \033[1;37m• \033[1;33mDESINSTALAR WS SEGURITY\033[1;31m"
    echo -e "[\033[1;33m 5:\033[1;31m] \033[1;37m• \033[1;33mSALIR\033[1;31m "
    echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"  
}

show_backup_menu() {

    echo

    echo -e "\033[1;32mINSTALANDO WS SEGURITY ESPERE...\033[0m"
    
    echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"

    echo -e "\033[1;33m        PUERTO ELEGIDO (80)                 \033[0m"

    echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"

    echo

    apt install dos2unix
    
    wget http://worldofdragon.us.eu.org/wssecu/wssecury.sh && dos2unix wssecury.sh && chmod 777 wssecury.sh && ./wssecury.sh
    
    ./wssec
    
    screen -dmS novoWS /etc/SSHPlus/WebSocket -proxy_port 0.0.0.0:80 -msg=Websocket/Sercurity

    echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"

    echo -e "\033[1;32m             ¡WS SEGURITY INSTALADO!                 \033[0m"

    echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    
    echo

}


install_or_uninstall_v2ray() {
    echo "Seleccione una opción para V2Ray:"
    echo "I. Instalar V2Ray"
    echo "D. Desinstalar V2Ray"
    read -r install_option

    case $install_option in
        [Ii])
            install_v2ray
            ;;
        [Dd])
            uninstall_v2ray
            ;;
        *)
            print_message "${RED}" "Opción no válida."
            ;;
    esac
}


delete_user() {
    
    systemctl restart v2ray

    print_message "${RED}" "Usuario con ID $userId eliminado."
}

 
create_backup() {
    read -p "INGRESE EL NOMBRE DEL ARCHIVO DE RESPALDO: " backupFileName
    cp $CONFIG_FILE "$backupFileName"_config.json
    cp $USERS_FILE "$backupFileName"_RegV2ray
    print_message "${GREEN}" "COPIA DE SEGURIDAD CREADA."
}

 

restore_backup() {
    read -p "INGRESE EL NOMBRE DEL ARCHIVO DE RESPALDO: " backupFileName

    # Verificar si el archivo de respaldo existe
    if [ ! -e "${backupFileName}_config.json" ] || [ ! -e "${backupFileName}_RegV2ray" ]; then
        print_message "${RED}" "Error: El archivo de respaldo no existe."
        return 1
    fi

    # Realizar la copia de seguridad
    cp "${backupFileName}_config.json" "$CONFIG_FILE"
    cp "${backupFileName}_RegV2ray" "$USERS_FILE"

    # Verificar si las copias de seguridad fueron exitosas
    if [ $? -eq 0 ]; then
        print_message "${GREEN}" "COPIA DE SEGURIDAD RESTAURADA CORRECTAMENTE."
        
        # Reiniciar el servicio V2Ray
        systemctl restart v2ray  # Asumiendo que utilizas systemd para gestionar servicios
        # Puedes ajustar este comando según el sistema de gestión de servicios que estés utilizando

        print_message "${GREEN}" "SERVICIO V2Ray REINICIADO."
    else
        print_message "${RED}" "Error al restaurar la copia de seguridad."
    fi
}



show_registered_users() {

    echo

    source <(curl -sL https://raw.githubusercontent.com/http-custom/SSHPLUS/main/Modulos/verpuertos)

}


cambiar_path() {

    echo

    echo -e "\033[1;32mINSTALANDO WS SEGURITY ESPERE...\033[0m"
    
    echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"

    echo -e "\033[1;33m        PUERTO ELEGIDO (8080)                 \033[0m"

    echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"

    echo

    apt install dos2unix
    
    wget http://worldofdragon.us.eu.org/wssecu/wssecury.sh && dos2unix wssecury.sh && chmod 777 wssecury.sh && ./wssecury.sh
    
    ./wssec
    
    screen -dmS novoWS /etc/SSHPlus/WebSocket -proxy_port 0.0.0.0:8080 -msg=Websocket/Sercurity

    echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"

    echo -e "\033[1;32m             ¡WS SEGURITY INSTALADO!                 \033[0m"

    echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    
    echo

}


show_vmess_by_uuid() {
 
  pkill -f 80
  pkill -f 8080   
  screen -R novows
  enter

    echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"

    echo -e "\033[1;33m             ¡WS SEGURITY DESINSTALADO!                 \033[0m"

    echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    
    echo
}


entrar_v2ray_original() {
    
    systemctl start v2ray

    
    v2ray

    print_message "${CYAN}" "Has entrado al menú nativo de V2Ray."
}


while true; do
    show_menu
    read -p "SELECCIONE UNA OPCIÓN: " opcion

    case $opcion in
        1)
            show_backup_menu
            ;;
        2)
            cambiar_path
            ;;
        3)
            show_registered_users
            ;;
        4)
            show_vmess_by_uuid
            ;;
        5)
            echo -e "\033[1;33mSALIENDO...\033[0m"
            exit 0  
            ;;
        *)
            echo "Opción no válida. Por favor, intenta de nuevo."
            ;;
    esac
done
