#!/bin/bash

# Definición de colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función para instalar Docker
install_docker() {
    echo -e "${BLUE}Iniciando la instalación de Docker...${NC}"
    sudo apt update
    sudo apt install curl -y

    echo -e "${GREEN}Instalación de docker docker${NC}"
    sudo curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
    echo -e "${GREEN}Instalación de Docker completada${NC}"
    echo -e "${GREEN}Una vez reiniciado ejecuta el script y sigue con los siguientes pasos${NC}"
    sleep 10
    sudo reboot
}

# Función para instalar Docker Compose
install_docker_compose() {
    echo -e "${BLUE}Iniciando la instalación de Docker Compose...${NC}"
    sudo curl -L "https://github.com/docker/compose/releases/download/$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d\" -f4)/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    echo -e "${GREEN}Instalación de Docker Compose completada.${NC}"
}

# Función para instalar el contenedor Portainer
install_portainer() {
    echo -e "${BLUE}Iniciando la instalación del contenedor Portainer...${NC}"
    docker volume create portainer_data
    docker run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest 
    echo -e "${GREEN}Instalación del contenedor Portainer completada. Accede a Portainer en https://direccion_ip:9443${NC}"
}

# Funcion para ver la direccion IP
show_ip() {
 echo -e "${BLUE}Buscando y mostrando la dirección IP...${NC}"
    
    # Busca la primera IP que no sea localhost y que comience con 192.168
    ip_address=$(ip -4 addr | grep -oP '(?<=inet\s)\192\.168\.[0-9]{1,3}\.[0-9]{1,3}' | head -n 1)
    
    if [ -z "$ip_address" ]; then
        # Si no se encuentra una IP 192.168.x.x, busca cualquier IP que no sea localhost
        ip_address=$(ip -4 addr | grep -v '127.0.0.1' | grep -oP '(?<=inet\s)[0-9]{1,3}(\.[0-9]{1,3}){3}' | head -n 1)
    fi
    
    if [ -n "$ip_address" ]; then
        echo -e "${GREEN}Tu dirección IP es: ${ip_address}${NC}"
    else
        echo -e "${RED}No se pudo encontrar una dirección IP válida.${NC}"
    fi
    
    # Mostrar todas las interfaces y sus IPs para referencia
    echo -e "${YELLOW}Todas las interfaces de red:${NC}"
    ip -4 addr | grep -oP '(?<=inet\s)[0-9]{1,3}(\.[0-9]{1,3}){3}' | sed 's/^/  /'
}



# Menú principal
while true; do
    echo -e "${YELLOW}----------------------------------------${NC}"
    echo -e "${YELLOW}Selecciona una opción:${NC}"
    echo -e "${GREEN}1. Instalación de Docker${NC}"
    echo -e "${GREEN}2. Instalación de Docker Compose${NC}"
    echo -e "${GREEN}3. Instalación del contenedor Portainer${NC}"
     echo -e "${GREEN}4. Mostrar dirección IP${NC}"
    echo -e "${RED}5. Salir${NC}"
    echo -e "${YELLOW}----------------------------------------${NC}"

    read -p "Introduce el número de la opción deseada: " opcion

    case $opcion in
        1)
            install_docker
            ;;
        2)
            install_docker_compose
            ;;
        3)
            install_portainer
            ;;
        4)
            show_ip
            ;;
        5)
            echo -e "${GREEN}Saliendo del menú. ¡Hasta luego!${NC}"
            break
            ;;
        *)
            echo -e "${RED}Opción inválida. Por favor, selecciona una opción del 1 al 5.${NC}"
            ;;
    esac
done
