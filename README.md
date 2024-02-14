# ballerina-training-content

## Prerequisites

- Install [Ballerina](https://ballerina.io/downloads/)
- Install [VSCode](https://code.visualstudio.com/download)
- Install [Ballerina VSCode Plugin](https://marketplace.visualstudio.com/items?itemName=wso2.ballerina)
- Install [Docker](https://www.docker.com/products/docker-desktop)
  - Alternatively, install [Rancher Desktop](https://rancherdesktop.io/) which includes Docker and Kubernetes

## Setup

- Clone this repository
- Open the repository in VSCode
- Run docker
- Open a terminal in VSCode and run the following service to start the MySQL server

    ```bash
    docker-compose up
    ```

- Create a new file called `Config.toml` in the root directory of the project
- Add the following configuration to the `Config.toml` file

    ```toml
    [graphql_bank]
    host="localhost"
    username="root"
    password="root"
    databaseName="gq_bank_test"
    port=3307
    ```

- Open a terminal in VSCode and run the following command to start the Ballerina service

    ```bash
    bal run graphql-bank
    ```
