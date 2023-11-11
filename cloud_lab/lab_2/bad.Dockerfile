FROM ubuntu:14.04 
#Используется старый образ, неподдерживаемый большинством платформ

ARG token 
RUN echo "$token" >> /token.txt 
#Используеться небезопасное хранение секретов, каждый пользователь может прочитать секрет из файла

WORKDIR /
COPY app.py /

RUN apt install python3 curl 
RUN curl "https://bootstrap.pypa.io/pip/3.4/get-pip.py" -o "get-pip.py"
RUN python3 get-pip.py
RUN pip install requests
#Используемый метод не позволит собрать контейнер без сетевого подключения

CMD [ "python3", "/app.py" ] 
