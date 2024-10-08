"
Clase Forecast
"
Class {
	#name : 'Forecast',
	#superclass : 'AnObsoleteBottlegram',
	#instVars : [
		'city',
		'country'
	],
	#category : 'Bottlegram-ForeCast',
	#package : 'Bottlegram-ForeCast'
}

{ #category : 'action' }
Forecast >> defaultText: aMessage [
	^ aMessage answer: 'XD'
]

{ #category : 'as yet unclassified' }
Forecast >> generateDocument: aWeather [
	| a1 a2 a3 table hourly hourlyUnits time temperature humidity rain|
	table := 'Clima del dia ', Date today yyyymmdd, String cr. 
	
	hourly := aWeather at: 'hourly'.
	hourlyUnits := aWeather at: 'hourly_units'. 
	a1 := hourlyUnits at: 'temperature_2m'.
	a2 := hourlyUnits at: 'relative_humidity_2m'.
	a3 := hourlyUnits at: 'rain'.
	
	
	time := hourly at: 'time'.
	temperature := hourly at: 'temperature_2m'.
	humidity := hourly at: 'relative_humidity_2m'.
	rain := hourly at: 'rain'.
	
	time withIndexDo: [ :each :i | table := table, 'Hora: ', (DateAndTime fromString: each) hour24 asString, ' Temperatura: ', (temperature at: i) asString, a1, ' Humedad: ', (humidity at: i) asString, a2, ' Lluvia: ', (rain at: i) asString, a3, '.', String cr].

	^ table 
]

{ #category : 'as yet unclassified' }
Forecast >> getCoordinates: aCity country: aCountry [ 		
	| array response result |
	
	response := (ZnClient new)
				url:'https://geocoding-api.open-meteo.com/v1/search?name=',aCity,'&count=10&language=en&format=json';    
				get;
				response. 
				
	array := (STONJSON fromString: response contents) at: 'results'.
	
	result := array select: [ :each | (each at: 'country') = 'Argentina'].
	
	result ifNotEmpty: [
        ^ (result first at: 'latitude') -> (result first at: 'longitude')
    ] ifEmpty: [
        ^ 'No se encontraron coordenadas para ', aCity, ' en ', aCountry.
    ].
]

{ #category : 'as yet unclassified' }
Forecast >> getWeatherForCity: aCity country: aCountry [
    | coordinates latitude longitude weatherData |

    coordinates := self getCoordinates: aCity country: aCountry.
    
    coordinates ifNotNil: [
        latitude := (coordinates key).
        longitude := (coordinates value).
        
        weatherData := self getWeatherForCoordinates: (latitude asString) longitude: (longitude asString).
        
        ^ self generateDocument: weatherData

    ] ifNil: [
        ^ 'No se encontraron coordenadas para ', aCity, ' en ', aCountry.
    ].
]

{ #category : 'as yet unclassified' }
Forecast >> getWeatherForCoordinates: latitude longitude: longitude [
    | response weatherData |

    response := (ZnClient new)
        url: 'https://api.open-meteo.com/v1/forecast?latitude=',latitude,'&longitude=',longitude ,'&hourly=temperature_2m,relative_humidity_2m,rain&start_date=',Date today yyyymmdd,'&end_date=',Date today yyyymmdd;
        get;
        response.

    weatherData := STONJSON fromString: response contents.
    
    ^ weatherData.
]

{ #category : 'action' }
Forecast >> slashHelp: aMessage [
	^ aMessage answer: 'Ayuda'
]

{ #category : 'action' }
Forecast >> slashStart: aMessage [
	| array city country|
	array := aMessage substrings:','.
	city := array first.
	country := array last.
	^ self getWeatherForCity: city country: country 
]
