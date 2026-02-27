#!/bin/bash

# Parametri
CITY="Firenze"                             # Modifica con la tua città
API_KEY="d262fb61513e9110cb7328f40d0a8d03" # La tua API Key da OpenWeatherMap
URL="https://api.openweathermap.org/data/2.5/forecast?q=$CITY&appid=$API_KEY&units=metric"

# Ottieni le previsioni meteo a 3 giorni
FORECAST=$(curl -s "$URL")

# Estrai le informazioni (giorno, condizione meteo, temperatura, vento)
DAY1_DATE=$(echo "$FORECAST" | jq -r '.list[0].dt_txt')
DAY1_COND=$(echo "$FORECAST" | jq -r '.list[0].weather[0].main')
DAY1_TEMP=$(echo "$FORECAST" | jq -r '.list[0].main.temp')
DAY1_WIND_SPEED=$(echo "$FORECAST" | jq -r '.list[0].wind.speed')
DAY1_WIND_DIR=$(echo "$FORECAST" | jq -r '.list[0].wind.deg')

DAY2_DATE=$(echo "$FORECAST" | jq -r '.list[8].dt_txt')
DAY2_COND=$(echo "$FORECAST" | jq -r '.list[8].weather[0].main')
DAY2_TEMP=$(echo "$FORECAST" | jq -r '.list[8].main.temp')
DAY2_WIND_SPEED=$(echo "$FORECAST" | jq -r '.list[8].wind.speed')
DAY2_WIND_DIR=$(echo "$FORECAST" | jq -r '.list[8].wind.deg')

DAY3_DATE=$(echo "$FORECAST" | jq -r '.list[16].dt_txt')
DAY3_COND=$(echo "$FORECAST" | jq -r '.list[16].weather[0].main')
DAY3_TEMP=$(echo "$FORECAST" | jq -r '.list[16].main.temp')
DAY3_WIND_SPEED=$(echo "$FORECAST" | jq -r '.list[16].wind.speed')
DAY3_WIND_DIR=$(echo "$FORECAST" | jq -r '.list[16].wind.deg')

# Funzione per determinare la direzione del vento con freccette
get_wind_arrow() {
  local WIND_DIR=$1
  if [ "$WIND_DIR" -ge 0 ] && [ "$WIND_DIR" -lt 23 ]; then
    echo "↑" # Nord
  elif [ "$WIND_DIR" -ge 23 ] && [ "$WIND_DIR" -lt 68 ]; then
    echo "↗" # Nord-Est
  elif [ "$WIND_DIR" -ge 68 ] && [ "$WIND_DIR" -lt 113 ]; then
    echo "→" # Est
  elif [ "$WIND_DIR" -ge 113 ] && [ "$WIND_DIR" -lt 158 ]; then
    echo "↘" # Sud-Est
  elif [ "$WIND_DIR" -ge 158 ] && [ "$WIND_DIR" -lt 203 ]; then
    echo "↓" # Sud
  elif [ "$WIND_DIR" -ge 203 ] && [ "$WIND_DIR" -lt 248 ]; then
    echo "↙" # Sud-Ovest
  elif [ "$WIND_DIR" -ge 248 ] && [ "$WIND_DIR" -lt 293 ]; then
    echo "←" # Ovest
  elif [ "$WIND_DIR" -ge 293 ] && [ "$WIND_DIR" -lt 338 ]; then
    echo "↖" # Nord-Ovest
  else
    echo "↑" # Nord (default)
  fi
}

# Direzioni vento
DAY1_WIND_ARROW=$(get_wind_arrow "$DAY1_WIND_DIR")
DAY2_WIND_ARROW=$(get_wind_arrow "$DAY2_WIND_DIR")
DAY3_WIND_ARROW=$(get_wind_arrow "$DAY3_WIND_DIR")

# Crea la stringa del popup con le previsioni
PREVISIONS="Previsioni meteo a 3 giorni per $CITY:
  
Giorno 1 ($DAY1_DATE):
Condizione: $DAY1_COND
Temperatura: ${DAY1_TEMP}°C
Vento: $DAY1_WIND_SPEED m/s ($DAY1_WIND_ARROW)

Giorno 2 ($DAY2_DATE):
Condizione: $DAY2_COND
Temperatura: ${DAY2_TEMP}°C
Vento: $DAY2_WIND_SPEED m/s ($DAY2_WIND_ARROW)

Giorno 3 ($DAY3_DATE):
Condizione: $DAY3_COND
Temperatura: ${DAY3_TEMP}°C
Vento: $DAY3_WIND_SPEED m/s ($DAY3_WIND_ARROW)"

# Mostra il popup con le previsioni
yad --title="Previsioni Meteo" --text="$PREVISIONS" --width=300 --height=300 --buttons-layout=center --center
