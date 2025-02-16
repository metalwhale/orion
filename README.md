# orion
An experimental Kubernetes API client written in Gleam, named after the constellation used for ocean navigation.

## Local development
1. Start a minikube cluster:
    ```bash
    minikube -p ${MINIKUBE_CLUSTER_NAME} start --apiserver-port ${KUBERNETES_SERVICE_PORT_HTTPS}
    ```
    For example:
    ```bash
    minikube -p orion start --apiserver-port 8443
    ```
    You can change the profile (*orion*) and the API server port  ([default as *8443*](https://minikube.sigs.k8s.io/docs/commands/start/#options)) to your preferred values.

2. Change to [`deployment-local`](./deployment-local/) directory:
    ```bash
    cd ./deployment-local/
    ```

3. Create a Docker Compose `.env` file and populate its environment variables with the appropriate values:
    ```bash
    cp local.env .env
    vi .env
    ```
    - `MINIKUBE_CLUSTER_NAME`: The profile created in Step 1 above
    - `KUBERNETES_SERVICE_HOST`: Achieved by running
        ```bash
        minikube -p ${MINIKUBE_CLUSTER_NAME} ip
        ```
    - `KUBERNETES_SERVICE_PORT_HTTPS`: The API server port specified in Step 1 above

4. Start and get inside the container:
    ```bash
    docker compose up --build --remove-orphans -d
    docker compose exec orion bash
    ```

## Kudos
This hobby project is heavily inspired by the following awesome resources:
- [Practical Guide to Kubernetes API](https://blog.kubesimplify.com/practical-guide-to-kubernetes-api)
- [How To Call Kubernetes API using Simple HTTP Client](https://iximiuz.com/en/posts/kubernetes-api-call-simple-http-client/)
- [Writing Kubernetes Operators with Python](https://www.spectrocloud.com/blog/writing-kubernetes-operators-with-python)
