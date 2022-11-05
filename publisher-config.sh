#!/bin/bash

#-----Códigos ANSI para cores no terminal-------

TAB='\t'
RED='\033[0;31m'    #error
CYAN='\033[0;36m'   #info
GREEN='\033[0;32m'  #success
YELLOW='\033[1;33m' #warn
NO_COLOR='\033[0m'
echo -e "${NO_COLOR}" &> /dev/null

#-----Funções para padronizar mensagens-------

TrybeInfo()
{
    echo -e "${CYAN}INFO>>${TAB}${NO_COLOR}$1${NO_COLOR}"
}

TrybeSuccess()
{
    echo -e "${GREEN}OK<3${TAB}${NO_COLOR}$1${NO_COLOR}"
}

TrybeWarn()
{
    echo -e "${YELLOW}WARN##${TAB}${NO_COLOR}$1${NO_COLOR}"
}

TrybeError()
{
    echo -e "${RED}ERROR!!${TAB}${NO_COLOR}$1${NO_COLOR}"
}

#-----Mensagem de boas-vindas-------

echo 
TrybeInfo "Iniciando instalação do ${GREEN}trybe-publisher${NO_COLOR}"


#-----Instalação trybe-publisher-------

chmod +x trybe-publisher
INSTALATION_DIR="/usr/local/bin"
CP_RESULT=$(sudo cp -p ./trybe-publisher ${INSTALATION_DIR} && echo ok)
[[ "$CP_RESULT" != "ok" ]] && \
    sudo mkdir $INSTALATION_DIR && \
    sudo cp -p ./trybe-publisher $INSTALATION_DIR

TrybeInfo "Ferramenta ${GREEN}trybe-publisher${NO_COLOR} adicionada a ${CYAN}${INSTALATION_DIR}${NO_COLOR}"


#-----Instalação git-filter-repo-------

if ! [[ -x $(command -v git-filter-repo) ]];
then 
    echo 
    TrybeWarn "A dependência ${YELLOW}git-filter-repo${NO_COLOR} não está instalada."
    read -p "Você deseja executar o script de instalação do git-filter-repo? (S/n)" -n 1 -r
    echo 
    if [[ $REPLY =~ ^[Nn]$ ]]
    then
        echo
        TrybeWarn "A dependência ${YELLOW}git-filter-repo${NO_COLOR} NÃO foi instalada!"
        TrybeWarn "Você precisa fazer essa instalação manualmente antes de executar o ${YELLOW}trybe-publisher"
        echo
    else
        TrybeInfo "Instalando ${CYAN}git-filter-repo${NO_COLOR} ..."
        git clone git@github.com:newren/git-filter-repo.git --quiet
        sudo mv ./git-filter-repo/git-filter-repo $INSTALATION_DIR && rm -rf ./git-filter-repo
        TrybeSuccess "Dependência ${GREEN}git-filter-repo${NO_COLOR} instalada com sucesso!"
        echo
    fi
fi

#-----Instalação auto-complete-------

SHELL_NAME=${SHELL##*\/}

if [[ $SHELL_NAME == "fish" ]]
then
    FISH_COMPLETIONS_PATH=$HOME/.config/fish/completions/trybe-publisher.fish
    
    CP_RESULT=$(cp ./auto-completion.fish "$FISH_COMPLETIONS_PATH" && echo ok)
    
    if [[ "$CP_RESULT" == "ok" ]]
    then
        fish -c source "$FISH_COMPLETIONS_PATH"
        TrybeSuccess "Arquivo de auto-complete para o shell fish instalado em ${NO_COLOR}${FISH_COMPLETIONS_PATH}"
    else
        echo -e "${RED}Falha na instalação do arquivo de auto-complete para o shell fish em ${NO_COLOR}${FISH_COMPLETIONS_PATH}"
        echo "A funcionalidade de auto-complete não funcionará neste shell."
        echo
        echo "O restante do fluxo deve funcionar,"
        echo -e "mas ${RED}avise alguém do time de instrução"
        echo -e "sobre essa mensagem de erro.${NO_COLOR}"
    fi
else
    BASH_COMP_DIR="/etc/bash_completion.d"
    if [[ ! -d $BASH_COMP_DIR ]] ; then
        sudo mkdir $BASH_COMP_DIR
    fi

    sudo cp ./auto-completion.sh $BASH_COMP_DIR/trybe-publisher

    # shellcheck disable=SC1091
    source $BASH_COMP_DIR/trybe-publisher
    
    case "${SHELL_NAME}"
        in
            zsh) SHELL_CONFIG="$HOME/.zshrc";;
            bash) SHELL_CONFIG="$HOME/.bashrc";;
            csh) SHELL_CONFIG="$HOME/.cshrc";;
            tcsh) SHELL_CONFIG="$HOME/.tcshrc";;
            *) SHELL_CONFIG="not-found";;
    esac

    SOURCE_COMMENT="\n# Necessário para auto-complete do comando trybe-publisher"
    SOURCE_COMMAND="source ${BASH_COMP_DIR}/trybe-publisher"
    if [[ $SHELL_CONFIG == "not-found" ]]
    then 
        echo -e "${YELLOW}A funcionalidade de auto-complete"
        echo "não funcionará porque nenhum Shell" 
        echo "conhecido foi encontrado."
        echo
        echo "O restante do fluxo deve funcionar,"
        echo -e "mas ${RED}avise alguém do time de instrução"
        echo -e "sobre essa mensagem de erro.${NO_COLOR}"
    else
        if grep -Fxq "$SOURCE_COMMAND" $SHELL_CONFIG
        then
            TrybeInfo "Comando para auto-complete encontrado em ${CYAN}${SHELL_CONFIG}"
        else
            TrybeWarn "Para o auto-complete funcionar corretamente, é necessário inserir a linha abaixo no arquivo de configuração do seu Shell."
            echo 
            echo -e "${CYAN}${TAB}${SOURCE_COMMAND}${NO_COLOR}"
            echo 
            read -p "Você deseja inserir essa linha no arquivo '${SHELL_CONFIG}'? (S/n)" -n 1 -r
            echo
            if [[ ! $REPLY =~ ^[Nn]$ ]]
            then
                TrybeInfo "Linha adicionada ao arquivo ${CYAN}${SHELL_CONFIG}"
                echo -e "$SOURCE_COMMENT" >> $SHELL_CONFIG
                echo "$SOURCE_COMMAND" >> $SHELL_CONFIG
            else
                TrybeWarn "Funcionalidade de auto-complete não foi configurada adequadamente"
            fi
        fi
    fi
fi

echo 
echo -e "${GREEN}* * * * * * * * * * * * * * * * * * * * * * * *${NO_COLOR}"
TrybeSuccess "Instalação ${GREEN}trybe-publisher${NO_COLOR} finalizada!"
echo -e "${GREEN}* * * * * * * * * * * * * * * * * * * * * * * *${NO_COLOR}"