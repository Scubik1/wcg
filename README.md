# Здание по развёртыванию приложения в K8S, используя Jenkins, в котором необходимо сделать следующее:
1.	Скачать приложение из github;
2.	Проверить Dockerfile линтером Habolint (https://github.com/hadolint/hadolint);
3.	Создать Docker image;
4.	Протестировать Docker image (запустить и проверить, доступен ли веб-интерфейс приложения);
5.	Загрузить Docker image в registery;
6.	Развернуть приложение в k8s в пространство имен для pre-production среды;
7.	Проверить, доступен ли веб-интерфейс приложения;
8.	Отобразить, в веб-интерфейсе Jenkins, сообщение о состоянии развертывания в pre-production среде с возможностью ручного одобрения развёртывания на production;
9.	Развернуть приложение в k8s в пространство имен для production среды;
10.	Удалить развертывание из pre-production среды.

# Для правильной работы pipeline необходимо:
1.	На хосте с jankens должен быть установлен docker.
2.	В jankens должны быть установлены плагины: Docker Pipeline, Docker, Kubernetes CLI , Kubernetes, Kubernetes Credentials.
3.	Необхадимо создать Credentials для DockerHub  и Kubernetes.
4.	На хосте с jankens необхадимо добавить в файл /etc/hosts запись ‘ip-address_kubernetes wcg.local’
