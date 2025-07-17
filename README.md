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

## License

[Add your license here] 