"
Clase que hace las peticiones a la API como las coordenadas y el clima
"
Class {
	#name : 'ForeCastWebClient',
	#superclass : 'Object',
	#classInstVars : [
		'instance'
	],
	#category : 'Bottlegram-ForeCast',
	#package : 'Bottlegram-ForeCast'
}

{ #category : 'instance creation' }
ForeCastWebClient class >> instance [
	instance ifNil: [ instance := super new ].
        ^ instance.
]

{ #category : 'instance creation' }
ForeCastWebClient class >> new [
        self error: 'Use instance to access the singleton instance'.
]

{ #category : 'API' }
ForeCastWebClient >> fetchCoordinatesForCity: aCity [ 
    | url |
    url := 'https://geocoding-api.open-meteo.com/v1/search?name=', aCity, '&count=10&language=en&format=json'.
    ^ (self fetchFromURL: url) at: 'results'.
]

{ #category : 'API' }
ForeCastWebClient >> fetchFromURL: aURL [ 
    | response |
    response := (ZnClient new)
        url: aURL;
        get;
        response.
    ^ STONJSON fromString: response contents.
]

{ #category : 'API' }
ForeCastWebClient >> fetchWeatherForLatitude: aLatitude longitude: aLongitude [
    | url today |
    today := Date today yyyymmdd.
    url := 'https://api.open-meteo.com/v1/forecast?latitude=', aLatitude, '&longitude=', aLongitude, '&hourly=temperature_2m,relative_humidity_2m,rain&start_date=', today, '&end_date=', today.
    ^ self fetchFromURL: url.
]
