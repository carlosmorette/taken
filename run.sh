#1/bin/bash

# Verifica se o argumento foi passado
if [ -z "$1" ]; then
    echo "Por favor, forneça o ambiente (local ou container) como argumento."
    exit 1
fi

ENVIRONMENT=$1

if [[ "$ENVIRONMENT" == "container" ]]; then
    export POSTGRES_HOST="postgres"
    echo "Ambiente configurado para container."
elif [[ "$ENVIRONMENT" == "local" ]]; then
    export POSTGRES_HOST="localhost"
    echo "Ambiente configurado para local."
else
    echo "Opção inválida. Por favor, forneça 'local' ou 'container'."
    exit 1
fi

iex -S mix phx.server