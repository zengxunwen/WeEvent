#!/bin/bash
#get parameter
para=""
current_path=$(pwd)

while [[ $# -ge 2 ]] ; do
    case "$1" in
    --out_path) para="$1 = $2;";out_path="$2";shift 2;;
    --listen_port) para="$1 = $2;";listen_port="$2";shift 2;;
    --block_chain_node_path) para="$1 = $2;";block_chain_node_path="$2";shift 2;;
    --channel_info) para="$1 = $2;";channel_info="$2";shift 2;;
    --version) para="$1 = $2;";version="$2";shift 2;;
    *) echo "unknown parameter $1." ; exit 1 ; break;;
    esac
done

echo "param out_path: ${out_path}"
echo "param listen_port: ${listen_port}"
echo "param version: ${version}"
echo "param block_chain_node_path: $block_chain_node_path"
echo "param channel_info: $channel_info"

#copy file
function copy_file(){
    mkdir -p ${out_path}
    cp -r ./* ${out_path}/
    rm -f ${out_path}/install-broker.sh
}

if [[ -z ${channel_info} ]];then
    echo "channel_info is empty."
    exit 1
fi

copy_file

sed -i "s/^.*nodes=.*$/nodes=${channel_info}/g" ${out_path}/conf/fisco.properties
echo "set channel_info success"
if [[ ${version} = "1.3" ]];then
    sed -i "/version=2.0/cversion=1.3" ${out_path}/conf/fisco.properties
    if [[ -f ${block_chain_node_path}/ca.crt ]] && [[ -f ${block_chain_node_path}/client.keystore ]]; then
        rm -rf ${out_path}/conf/ca.crt ${out_path}/conf/client.keystore
        cp ${block_chain_node_path}/ca.crt ${block_chain_node_path}/client.keystore ${out_path}/conf/
    else
        echo "ca.crt or client.keystore is not exist."
        exit 1
    fi
else
    if [[ -f ${block_chain_node_path}/ca.crt ]] && [[ -f ${block_chain_node_path}/node.crt ]] && [[ -f ${block_chain_node_path}/node.key ]]; then
        rm -rf ${out_path}/conf/v2/ca.crt ${out_path}/conf/v2/node.crt ${out_path}/conf/v2/node.key
        cp ${block_chain_node_path}/ca.crt ${block_chain_node_path}/node.crt ${block_chain_node_path}/node.key ${out_path}/conf/v2/
    else
        echo "ca.crt or node.crt or node.key is not exist."
        exit 1
    fi
fi

#deploy contract
cd ${out_path}
./deploy-topic-control.sh
if [[ $? -eq 0 ]];then
    echo "deploy topic control contract success"
else
    echo "deploy topic control contract failed"
    exit 1
fi
cd ${current_path}

if [[ ${listen_port} -gt 0 ]]; then
    sed -i "/server.port=/cserver.port=${listen_port}" ${out_path}/conf/application-prod.properties
else
    echo "listen_port is err"
    exit 1
fi
echo "set lister_port success"

echo "broker module install success"
