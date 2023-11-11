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
    