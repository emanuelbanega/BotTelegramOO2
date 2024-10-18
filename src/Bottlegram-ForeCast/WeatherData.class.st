"
Clase que contiene los datos del clima
"
Class {
	#name : 'WeatherData',
	#superclass : 'Object',
	#instVars : [
		'formattedHour',
		'formattedTemp',
		'humidity',
		'rain',
		'hourlyUnits'
	],
	#category : 'Bottlegram-ForeCast',
	#package : 'Bottlegram-ForeCast'
}

{ #category : 'as yet unclassified' }
WeatherData class >> with: formattedHour formattedTemp: formattedTemp humidity: humidity rain: rain hourlyUnits: hourlyUnits [ 
        ^ self new
            formattedHour: formattedHour;
            formattedTemp: formattedTemp;
            humidity: humidity;
            rain: rain;
            hourlyUnits: hourlyUnits;
			yourself 
]

{ #category : 'accessing' }
WeatherData >> formattedHour: aFormattedHour [ 
        formattedHour := aFormattedHour.
]

{ #category : 'accessing' }
WeatherData >> formattedTemp: aFormattedTemp [ 
        formattedTemp := aFormattedTemp.
    
]

{ #category : 'accessing' }
WeatherData >> hourlyUnits: aHourlyUnits [ 
        hourlyUnits := aHourlyUnits.
]

{ #category : 'accessing' }
WeatherData >> humidity: aHumidity [ 
        humidity := aHumidity.
]

{ #category : 'accessing' }
WeatherData >> rain: aRain [ 
        rain := aRain.
   
]

{ #category : 'as yet unclassified' }
WeatherData >> weatherReportString [
	^ 'Hora: ', formattedHour, 
     ' Temperatura: ', formattedTemp, ' ', (hourlyUnits at: 'temperature_2m'),
     ' Humedad: ', humidity asString, ' ', (hourlyUnits at: 'relative_humidity_2m'),
     ' Lluvia: ', rain asString, ' ', (hourlyUnits at: 'rain'), '.', String lf.
]
