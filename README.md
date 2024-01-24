For the pipeline to work correctly you need:
1. Docker must be installed on the host with jankens.
2. Plugins must be installed in jankens: Docker Pipeline, Docker, Kubernetes CLI, Kubernetes, Kubernetes Credentials.
3. It is necessary to create Credentials for DockerHub and Kubernetes.
4. On the host with jankens, you must add the entry ‘ip-address_kubernetes wcg.local’ to the /etc/hosts file
