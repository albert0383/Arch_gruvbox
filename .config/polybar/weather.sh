#!/bin/bash

CITY="Firenze"
API_KEY="d262fb61513e9110cb7328f40d0a8d03"
URL="https://api.openweathermap.org/data/2.5/weather?q=$CITY&appid=$API_KEY&units=metric"

# Ottieni i dati meteo in formato JSON
WEATHER=$(curl -s "$URL")

# Estrai i dati rilevanti
CONDITION=$(echo "$WEATHER" | jq -r '.weather[0].main') # Condizione meteo (es: Clear, Clouds, Rain)
TEMP=$(echo "$WEATHER" | jq -r '.main.temp')            # Temperatura in °C
WIND_SPEED=$(echo "$WEATHER" | jq -r '.wind.speed')     # Velocità vento in m/s
WIND_DIR=$(echo "$WEATHER" | jq -r '.wind.deg')         # Direzione vento in gradi

# Converti la velocità del vento in nodi
WIND_SPEED_KNOTS=$(echo "$WIND_SPEED * 1.94384" | bc)

# Arrotonda la velocità del vento e la temperatura a 1 decimale
TEMP_ROUNDED=$(printf "%.0f" "$TEMP") # %.1f per 1 decimale
WIND_SPEED_KNOTS_ROUNDED=$(printf "%.0f" "$WIND_SPEED_KNOTS")

# Determina la direzione del vento in base ai gradi
if [ "$WIND_DIR" -ge 0 ] && [ "$WIND_DIR" -lt 23 ]; then
  WIND_DIR_TEXT="↑" # Nord
elif [ "$WIND_DIR" -ge 23 ] && [ "$WIND_DIR" -lt 68 ]; then
  WIND_DIR_TEXT="↗" # Nord-Est
elif [ "$WIND_DIR" -ge 68 ] && [ "$WIND_DIR" -lt 113 ]; then
  WIND_DIR_TEXT="→" # Est
elif [ "$WIND_DIR" -ge 113 ] && [ "$WIND_DIR" -lt 158 ]; then
  WIND_DIR_TEXT="↘" # Sud-Est
elif [ "$WIND_DIR" -ge 158 ] && [ "$WIND_DIR" -lt 203 ]; then
  WIND_DIR_TEXT="↓" # Sud
elif [ "$WIND_DIR" -ge 203 ] && [ "$WIND_DIR" -lt 248 ]; then
  WIND_DIR_TEXT="↙" # Sud-Ovest
elif [ "$WIND_DIR" -ge 248 ] && [ "$WIND_DIR" -lt 293 ]; then
  WIND_DIR_TEXT="←" # Ovest
elif [ "$WIND_DIR" -ge 293 ] && [ "$WIND_DIR" -lt 338 ]; then
  WIND_DIR_TEXT="↖" # Nord-Ovest
else
  WIND_DIR_TEXT="↑" # Nord (default)
fi

# Icone meteo (basato sulla condizione meteo)
if [ "$CONDITION" == "Clear" ]; then
  ICON="" # Sole
elif [ "$CONDITION" == "Clouds" ]; then
  ICON="" # Nuvole
elif [ "$CONDITION" == "Rain" ]; then
  ICON="" # Pioggia
elif [ "$CONDITION" == "Snow" ]; then
  ICON="❄" # Neve
elif [ "$CONDITION" == "Thunderstorm" ]; then
  ICON="" # Tempesta
else
  ICON="" # Condizione sconosciuta
fi

# Mostra le informazioni meteo
echo "$CITY $ICON $TEMP_ROUNDED°C | $WIND_DIR_TEXT$WIND_SPEED_KNOTS_ROUNDED knts"
