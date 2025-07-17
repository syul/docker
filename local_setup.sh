openssl rand -base64 756 > ${PWD}/rs_keyfile
chmod 0400 ${PWD}/rs_keyfile
chown 999:999 ${PWD}/rs_keyfile

mkdir --parents data/mongo_1_data
mkdir --parents data/mongo_1_config
mkdir --parents data/mongo_2_data
mkdir --parents data/mongo_2_config
mkdir --parents data/mongo_3_data
mkdir --parents data/mongo_3_config
mkdir --parents data/rabbit_mq_data
mkdir --parents data/rabbit_mq_logs
mkdir --parents data/postgres
mkdir --parents data/redis_data_master
mkdir --parents data/redis_data_slave