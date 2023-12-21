# Лабораторная работа 3

## Цель работы

```
Сделать, чтобы после пуша в ваш репозиторий автоматически собирался докер образ и результат его сборки сохранялся куда-нибудь. (например, если результат - текстовый файлик, он должен автоматически сохраниться на локальную машину, в ваш репозиторий или на ваш сервер).
```
## Выполнение работы

 [Ссылка не репозиторий, в котором выполнялась лаба](https://github.com/lilbeb/cloud-ict-2023)


- Создадим в папке `.github` папку `workflows` с ```yml``` файлом, далее напишем код с инструкциями github actions.

- Запишем два секрета с логином и паролем

![Иллюстрация к проекту](https://github.com/lilbeb/cloud-ict-2023/raw/main/assets/k1.png)


```yml
name: Docker image to Docker Hub

# когда будет пуш в main
on: 
  push:
    branches:
      - 'main'

jobs:
  push_to_docker_hub:
    name: Push image to Docker Hub

    runs-on: ubuntu-latest

    steps:
      # проверка кода репозитория
      - name: Checkout out the repo 
        uses: actions/checkout@v4

      # вход в с использованием логина и пароля Docker Hub
      - name: Log in to Docker Hub 
        uses: docker/login-action@v3
        with:
          username: ${{ secrets.DOCKER_HUB_LOGIN }}
          password: ${{ secrets.DOCKER_HUB_PASSWORD }}

      # сборка Docker-образа и публикация в Docker Hub
      - name: Build image and push
        uses: docker/build-push-action@v5
        with:
          context: .
          push: true
          tags: oblcc564/lilbeb:latest

```
`DockerFile:`

```DockerFile
FROM alpine:latest

RUN echo "Hello, Docker!" > result.txt
```
### Итог: все шаги выполнены, образ собран

![Иллюстрация к проекту](https://github.com/lilbeb/cloud-ict-2023/raw/main/assets/k2.png)