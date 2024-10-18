"
Clase que genera el documento con los datos del clima
"
Class {
	#name : 'WeatherDocument',
	#superclass : 'Object',
	#instVars : [
		'currentWeatherData'
	],
	#category : 'Bottlegram-ForeCast',
	#package : 'Bottlegram-ForeCast'
}

{ #category : 'formatting' }
WeatherDocument >> formatHour: aHour [
    "Este método formatea una hora en formato 'HH:00', rellenando con ceros a la izquierda si es necesario."
    | paddedHour |
    paddedHour := aHour printPaddedWith: $0 to: 2.
    ^ paddedHour, ':00'.
]

{ #category : 'formatting' }
WeatherDocument >> formatHourlyWeatherData: aWeather atIndex: i [
    "Este método formatea los datos meteorológicos (hora, temperatura, humedad y lluvia) obtenidos de un diccionario a partir del índice i, los organiza y luego crea un registro de datos meteorológicos (WeatherData)."
    | formattedHour formattedTemp hour hourly hourlyUnits time temperature humidity rain weatherValues weatherRecord |
    
    "Obtiene los diccionarios de datos horarios y las unidades de medida."
    hourly := aWeather at: 'hourly'.
    hourlyUnits := aWeather at: 'hourly_units'.

    "Obtiene los valores de la hora, temperatura, humedad y lluvia en un array utilizando getWeatherValuesAt:fromHourly:."
    weatherValues := self getWeatherValuesAt: i fromHourly: hourly.

    "Asigna los valores individuales del array a las variables correspondientes."
    time := weatherValues first.
    temperature := weatherValues second.
    humidity := weatherValues third.
    rain := weatherValues fourth.

    "Convierte la hora obtenida en un formato de 24 horas."
    hour := (DateAndTime fromString: time) hour24.
    
    "Formatea la hora y la temperatura."
    formattedHour := self formatHour: hour.
    formattedTemp := self formatTemperature: temperature.

    "Crea un registro de datos meteorológicos (WeatherData) con los valores formateados y las unidades correspondientes."
    weatherRecord := WeatherData with: formattedHour formattedTemp: formattedTemp humidity: humidity rain: rain hourlyUnits: hourlyUnits.

    "Devuelve la cadena de texto con los datos formateados."
    ^ weatherRecord weatherReportString.
]

{ #category : 'formatting' }
WeatherDocument >> formatTemperature: aTemperature [
    "Este método formatea la temperatura, asegurándose de que se rellene con ceros a la izquierda si es necesario, y lo convierte en cadena."
    ^ (aTemperature printPaddedWith: $0 to: 2) asString.
]

{ #category : 'as yet unclassified' }
WeatherDocument >> generateWeatherReportDocument [
    "Este método genera el documento completo del pronóstico del clima, combinando la cabecera de la tabla con los datos meteorológicos por hora."
    | table |

    "Inicializa la tabla como una cadena vacía."
    table := 'Clima del día ', Date today yyyymmdd, String lf.

    "Recorre los datos meteorológicos horarios y genera una tabla con los datos de cada hora, agregando cada fila al documento."
    ((currentWeatherData at: 'hourly') at: 'time') withIndexDo: [ :each :i |
        table := table, (self formatHourlyWeatherData: currentWeatherData atIndex: i)
    ].

    "Devuelve el documento completo con la tabla."
    ^ table.
]

{ #category : 'as yet unclassified' }
WeatherDocument >> getValueFromDictionary: aDictionary forKey: aKey atIndex: i withDefaultValue: defaultValue [
    "Este método obtiene el valor de un diccionario a partir de una clave y un índice específico, o devuelve un valor por defecto si no se encuentra el dato."
    ^ (aDictionary at: aKey) at: i ifAbsent: [^ defaultValue].
]

{ #category : 'accessing' }
WeatherDocument >> getWeatherValuesAt: i fromHourly: hourly [ 
    "Este método obtiene los valores de tiempo, temperatura, humedad y lluvia de los datos horarios en el índice i."
    | keysDefaults weatherValues |
    
    "Define las claves y valores por defecto en un OrderedDictionary."
    keysDefaults := (OrderedDictionary new).
	 keysDefaults
        add: 'time' -> 'No hay datos disponibles'; 
        add: 'temperature_2m' -> 'No hay temperatura disponible'; 
        add: 'relative_humidity_2m' -> 'No hay humedad disponible'; 
        add: 'rain' -> 'No hay datos de lluvia disponibles'.

    "Recupera los valores de los datos horarios utilizando las claves definidas."
    weatherValues := keysDefaults keys collect: [:key | 
        self getValueFromDictionary: hourly forKey: key atIndex: i withDefaultValue: (keysDefaults at: key)
    ].
    
    "Devuelve un array con los valores obtenidos."
    ^ weatherValues.
]

{ #category : 'initialization' }
WeatherDocument >> initializeWeatherHeaderWithData: aWeather [
    "Inicializa el objeto con los datos del clima pasados en 'aWeather'."
    currentWeatherData := aWeather.
]
