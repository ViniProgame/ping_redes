#!/bin/bash

# Pede para o usuario a rede e o intervalo
read -p "Digite a rede (ex: 192.168.1): " rede
read -p "Digite o intervalo de IPs (ex: 1-10): " intervalo

# Extrai o inicio e o fim do intervalo	
IFS='-' read -r inicio fim <<< "$intervalo"

# Verfica se o numero é valido
if ! [[ "$inicio" =~ ^[0-9]+$ && "$fim" =~ ^[0-254]+$ ]]; then
    echo "Intervalo inválido. Certifique-se de usar números."
    exit 2
fi

# Armazena o loop de pings em um arquivo txt
arquivo="ping_resultados.txt"

# Criar ou limpar o arquivo de resultados
> "$arquivo"

# Loop para ir pingando a rede no intervalo determinado
for (( i=inicio; i<=fim; i++ )); do
    ip="${rede}.${i}"
    echo "Pingando $ip..."
    ping -c 1 "$ip" &> /dev/null
# Dependendo do que você precisa pode tanto gravar apenas os que estão ativos ou que estão inativos.
    if [ $? -eq 0 ]; then
        echo "$ip está ativo." | tee -a "$arquivo"
    else
        #echo "$ip está inativo." | tee -a "$arquivo"
    fi
done

echo "Resultados salvos em $arquivo."

