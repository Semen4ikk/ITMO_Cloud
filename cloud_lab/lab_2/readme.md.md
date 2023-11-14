
# Лабораторная № 2
```
Написать два Dockerfile – плохой и хороший. Плохой должен запускаться и работать корректно, но в нём должно быть не менее 3 “bad practices”. В хорошем Dockerfile они должны быть исправлены. В Readme описать все плохие практики из кода Dockerfile и почему они плохие, как они были исправлены в хорошем  Dockerfile, а также две плохие практики по использованию этого контейнера
```
### ```“Bad practices”```, которые мы решили рассмотреть в задании:

1. Использование устаревших/ненадежных образов, что приводит к уязвимостям и ошибкам т.к. образ может не поддерживаться;
   
2. Использование методов, которые зависят от сети т.е. пользователь, загрузив Docker единожды будет вынужден подгружать пакеты каждый раз и не сможет работать без выхода в Интернет;
   
3. Использование методов, которые не позволяют хранить конфиденциальную информацию (пароли, ключи, API), поскольку они не засекречивают такую информацию и каждый пользователь может получит к ним доступ.

Файл app.py является вспомогательным, в нем используется open weather API, чтобы мы могли показать 2 и 3 ошибки.

```python
import requests

# Чтение токена доступа из файла
with open('token.txt', 'r') as file:
    api_token = file.readline().strip()

# URL для запроса API
url = "https://api.openweathermap.org/data/2.5/weather?lat=59.9311&lon=30.3609&appid=" + api_token + "&units=metric"

# Получение данных о погоде
response = requests.get(url)
data = response.json()

# Проверка статуса ответа API
if response.status_code == 200:
    # Извлечение информации о погоде
    temperature = data['main']['temp']
    weather_desc = data['weather'][0]['description']
    
    # Вывод информации о погоде
    print("Temperature in St. Petersburg:" + str(temperature))
    print("Description of the weather:" + weather_desc)
else:
    print("Could not get weather data. Check the access token and connection.")

while True: 
    pass

```
Файл bad.Dockerfile содержит в себе Докер с Bad practices

```Dockerfile
FROM ubuntu:14.04 
#Используется старый образ, неподдерживаемый большинством платформ

ARG token 
RUN echo "$token" >> /token.txt 
#Используется небезопасное хранение секретов, каждый пользователь может прочитать секрет из файла

WORKDIR /
COPY app.py /

RUN apt install python3 curl 
RUN curl "https://bootstrap.pypa.io/pip/3.4/get-pip.py" -o "get-pip.py"
RUN python3 get-pip.py
RUN pip install requests
#Используемый метод не позволит собрать контейнер без сетевого подключения

CMD [ "python3", "/app.py" ] 

```
### Ошибки

1. ```ubuntu:14.04``` - Используется давно устаревшая версия убунты, которая не поддерживается разработчиками;

2. ```RUN echo "$token" >> /token.txt``` - В данной строке используется метод, которые никак не засекречивает ключ API и к нему сможет получить доступ любой желающий;

3.
 ```Dockerfile
RUN apt install python3 curl 
RUN curl "https://bootstrap.pypa.io/pip/3.4/get-pip.py" -o "get-pip.py"
RUN python3 get-pip.py
RUN pip install requests

 ``` 
  Данный метод предполагает, что при использовании докера придется скачивать пакеты заново, а значит пользователь не сможет использовать его без подключения к Интернету.

Но данные ошибки не ведут к поломке Докера, он все так же способен запускаться и выполнять свои задачи.

#### Файл good.Dockerfile содержит в себе Докер с исправлением предыдущих ошибок. 

```Dockerfile
FROM nyurik/alpine-python3-requests:latest
#используется безопасный образ, в котором уже есть все необходимые пакеты (сделав одну загрузку, можно собирать контейнер без подключения к сети)

RUN ln -sf /run/secrets/owa_token /token.txt
#используется безопасное хранение секретов при помощи docker swarm

WORKDIR /
COPY app.py /

CMD [ "python3", "/app.py" ] 

```

1. ```nyurik/alpine-python3-requests:latest``` - В данной строке мы решаем 1 и 3 ошибки, ведь используем последнюю версию образа, который содержит в себе все необходимые пакеты. Загрузив единожды, пользователь сможет использовать Докер без выхода в сеть;

1. ```RUN ln -sf /run/secrets/owa\_token /token.txt``` - В данной строчке решается 2 проблема, тут используется Docker swarm, которые позволяет создавать секреты и сохраняет конфиденциальность данных 
