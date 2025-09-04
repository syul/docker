# Docker Development Environment

This repository contains a Docker-based development environment that sets up multiple services for your application infrastructure.

## Services Included

- **MongoDB** (3-node replica set)
- **RabbitMQ**
- **PostgreSQL**
- **Redis** (Master-Slave configuration)

## Prerequisites

- Docker
- Docker Compose
- OpenSSL (for generating MongoDB replica set keyfile)

## Directory Structure

```
.
├── data/                      # Persistent data storage
│   ├── mongo_1_data/         # MongoDB node 1 data
│   ├── mongo_1_config/       # MongoDB node 1 configuration
│   ├── mongo_2_data/         # MongoDB node 2 data
│   ├── mongo_2_config/       # MongoDB node 2 configuration
│   ├── mongo_3_data/         # MongoDB node 3 data
│   ├── mongo_3_config/       # MongoDB node 3 configuration
│   ├── rabbit_mq_data/       # RabbitMQ data
│   ├── rabbit_mq_logs/       # RabbitMQ logs
│   ├── postgres/             # PostgreSQL data
│   ├── redis_data_master/    # Redis master node data
│   └── redis_data_slave/     # Redis slave node data
├── docker-compose.yaml        # Docker services configuration
├── local_setup.sh            # Setup script for data directories
└── rs_keyfile                # MongoDB replica set keyfile
```

## Getting Started

1. Clone this repository:
   ```bash
   git clone <repository-url>
   cd docker
   ```

2. Run the setup script to create necessary directories and generate the MongoDB keyfile:
   ```bash
   chmod +x local_setup.sh
   sudo ./local_setup.sh
   ```

3. Start the services:
   ```bash
   docker-compose up -d
   ```

4. To stop the services:
   ```bash
   docker-compose down
   ```

## Security Notes

- The MongoDB replica set uses authentication with a keyfile (`rs_keyfile`)
- The keyfile is automatically generated during setup with proper permissions (0400)
- Make sure to never commit sensitive data or credentials to version control

## Data Persistence

All service data is persisted in the `data/` directory. Each service has its own dedicated data directory to maintain state between container restarts.

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a new Pull Request

## Mongo data base setup

[MongoDB](https://www.mongodb.com/) is used to store application artifacts

### Docker compose

In docker compose there are several sections, responsible for cluster deployment. Each section spins up standalone [MongoDB](https://www.mongodb.com/) node.

#### mongo1

```yaml
  mongo1:
    container_name: mongo1
    image: mongo:7.0
    command: ["--replSet", "rs0", "--bind_ip_all", "--port", "27017", "--keyFile", "/etc/mongodb/pki/keyfile"]
    restart: always
    ports:
      - 27017:27017
    networks:
      cluster_network:
        ipv4_address: 111.222.32.2
    volumes:
      - ${PWD}/rs_keyfile:/etc/mongodb/pki/keyfile
      - mongo_1_data:/data/db
      - mongo_1_config:/data/configdb
    environment:
      MONGO_INITDB_ROOT_USERNAME: root
      MONGO_INITDB_ROOT_PASSWORD: example

```

#### mongo2

```yaml
  mongo2:
    image: mongo:7.0
    container_name: mongo2
    command: ["--replSet", "rs0" ,"--bind_ip_all", "--port", "27018","--keyFile", "/etc/mongodb/pki/keyfile"]
    restart: always
    ports:
      - 27018:27018
    networks:
      cluster_network:
        ipv4_address: 111.222.32.3
    volumes:
      - ${PWD}/rs_keyfile:/etc/mongodb/pki/keyfile
      - mongo_2_data:/data/db
      - mongo_2_config:/data/configdb
    environment:
      MONGO_INITDB_ROOT_USERNAME: root
      MONGO_INITDB_ROOT_PASSWORD: example
```

#### mongo3

```yaml
  mongo3:
    image: mongo:7.0
    container_name: mongo3
    command: ["--replSet", "rs0" ,"--bind_ip_all", "--port", "27019","--keyFile", "/etc/mongodb/pki/keyfile"]
    restart: always
    ports:
      - 27019:27019
    networks:
      cluster_network:
        ipv4_address: 111.222.32.4
    volumes:
      - ${PWD}/rs_keyfile:/etc/mongodb/pki/keyfile
      - mongo_3_data:/data/db
      - mongo_3_config:/data/configdb
    environment:
      MONGO_INITDB_ROOT_USERNAME: root
      MONGO_INITDB_ROOT_PASSWORD: example

```

There is no big difference between those section, but there are some crucial properties required to pay attention to.
* service name - mongo1/mongo2/mongo3 these names will be used in connection string to the data base.
* ipv4_address - static api address for each node

In order to make each node discoverable by service name, it is required to update local `/etc/hosts` file. Follow the example:

For developers, who prefer linux to use:

```bash
    111.222.32.2 mongo1
    111.222.32.3 mongo2
    111.222.32.4 mongo3
```

For Windows and MacOs users:

```bash
    127.0.0.1 mongo1
    127.0.0.1 mongo2
    127.0.0.1 mongo3
```

Everything is ready to start replica set cluster. To do so run following command:

```bash
    docker compose up -d mongo1 mongo2 mongo3
```

Stand by until images are pulled and everything starts. Next step is to initialize replica set. It requires several steps.

Get docker container shell, where primary node runs. Assume, that primary node is running inside container with name `mongo1`. Execute following command. 

```bash
    docker exec -it mongo1 bash
```

If everything is ok, container shell must be available. Next step is to connect to the data base in order to initialize replica set. 

```bash
    mongosh -u root -p example
```

When connection establishes, run replica set initialization command:

```javascript
  rs.initiate(
    { _id: "rs0",
        version: 1,
        members: [
        { _id: 0, host: "mongo1:27017" },
        { _id: 1, host: "mongo2:27018" },
        { _id: 2, host: "mongo3:27019" }
      ]
    }
  );
```

After the execution check replica set status

```javascript
    rs.status()
```
Close connection to the database and exit from shell. For that moment replica set is up and running and ready to accept the connections.

### Connection

In order to communicate with data base it is strongly recommended to use official graphical tool [MongoDB Compass](https://www.mongodb.com/products/tools/compass). Download latest binaries and install them locally. In order to connect to the database use following connection string.

```bash
    mongodb://root:example@localhost:27017,localhost:27018,localhost:27019/?replicaSet=rs0&authSource=admin
```

If everything was done according to the instruction above - connection must be established.

## License

[Add your license here] 
