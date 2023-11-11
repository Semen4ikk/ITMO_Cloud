FROM nyurik/alpine-python3-requests:latest
#используется безопасный образ, в котором уже есть все необходимые пакеты (сделав одну загрузку, можно собирать контейнер без подключения к сети)

RUN ln -sf /run/secrets/owa_token /token.txt
#используется безопасное хранение секретов при помощи docker swarm

WORKDIR /
COPY app.py /

CMD [ "python3", "/app.py" ] 