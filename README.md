# Gitlab CI-CD для Spring Boot приложения с мониторингом развернутого в Docker

Подход основан на [статье](https://habr.com/ru/articles/764568/).

## 1. Установка и регистрация Gitlab Runner

Можно выполнить с [помощью](https://github.com/sergei-zachesov/docker-compose-gitlab-runner).

## 2. Настройка SSH-ключа и сервера

На стороне целевого сервера приложения.

* Генерация SSH-ключа: `ssh-keygen -t rsa -b 4096`. На вопросы жмем Enter
* Добавление публичного ключа в `authorized_keys`: `cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys`
* Вывод в терминал секретного ключа `cat ~/.ssh/id_rsa` и скопировать его в репозиторий gitlab в Settings->CI/CD->
  Variables
  `$SSH_PRIVATE_KEY_PROD` или `$SSH_PRIVATE_KEY_TEST`.
* Удаление ключей сгенерированных файлов `rm ~/.ssh/id_rsa.pub && rm ~/.ssh/id_rsa`
* Установить доступ к `authorized_keys`: `chmod 600 ~/.ssh/authorized_keys`
* Настройка не `root` пользователя, на работу с `docker` без `sudo`.
  Подробнее https://docs.docker.com/engine/install/linux-postinstall/, https://askubuntu.com/a/477554, https://stackoverflow.com/questions/48957195/how-to-fix-docker-got-permission-denied-issue
    * Добавление группы: `sudo groupadd  docker`
    * Помещение юзера в группу: `sudo usermod -aG docker $USER`
    * Доступ к сокетам docker: `sudo chmod 666 /var/run/docker.sock`

## 3. Переменные окружения CI/CD

Устанавливаются в Settings->CI/CD->Variables. Отдельно для разных контуров. Возможно убрать `Protect variable`, либо
сделать ветку `Protect`.

* `$SSH_PRIVATE_KEY_PROD(_TEST)` - секретный SSH-ключ
* `$SERVICE_NAME` - наименование сервиса
* `$HOST_PROD(_TEST)` - хост сервера
* `$USER_PROD(_TEST)` - юзер сервера

## 4. Мониторинг приложения

* Директорию из проекта `monitoring` поместить в нужную директорию (по-умолчанию `/home/monitoring`). Указать путь до
  директории в `.env` (`PROMETHEUS_CONFIG`, `GRAFANA_SOURCE`)
* Указать в `monitoring/prometheus/prometheus.yml` в параметре `scrape_configs.static_configs.targets` указать хост и
  порт spring приложения.
* Указать в `monitoring/grafana/provisioning/datasources/all.yaml` в параметре `datasources.url` URL Prometheus.
* По необходимости поменять параметры с дефолтных в файле `.env`.