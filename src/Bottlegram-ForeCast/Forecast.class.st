"
Clase Forecast
"
Class {
	#name : 'Forecast',
	#superclass : 'Bottlegram',
	#instVars : [
		'webClient'
	],
	#category : 'Bottlegram-ForeCast',
	#package : 'Bottlegram-ForeCast'
}

{ #category : 'action' }
Forecast >> defaultText: aMessage [
	^ aMessage send: 'Ha enviado un mensaje por default.'.
]

{ #category : 'as yet unclassified' }
Forecast >> findCoordinatesIn: results forCountry: aCountry [ 
    | filteredResults |
    filteredResults := results select: [ :each | (each at: 'country') = aCountry ].
    filteredResults ifNotEmpty: [
        ^ (filteredResults first at: 'latitude') -> (filteredResults first at: 'longitude')
    ] ifEmpty: [
        ^ nil
    ].
]

{ #category : 'formatting' }
Forecast >> generateWeatherDocumentFor: aWeather [
    | document |
    document := WeatherDocument new initializeWeatherHeaderWithData: aWeather.
    ^ document generateWeatherReportDocument.
]

{ #category : 'as yet unclassified' }
Forecast >> getCoordinates: aCity country: aCountry [ 
    | results coordinates |
    results := (self webClient) fetchCoordinatesForCity: aCity.
    coordinates := self findCoordinatesIn: results forCountry: aCountry.
    
    coordinates ifNil: [
        ^ 'No se encontraron coordenadas para ', aCity, ' en ', aCountry
    ].
    ^ coordinates.
]

{ #category : 'as yet unclassified' }
Forecast >> getWeatherForCity: aCity country: aCountry [ 
    | coordinates weatherData |
    coordinates := self getCoordinates: aCity country: aCountry.
    
    coordinates ifNil: [
        ^ 'No se encontraron coordenadas para ', aCity, ' en ', aCountry.
    ].
    
    weatherData := (self webClient) fetchWeatherForLatitude: (coordinates key asString) longitude: (coordinates value asString).

    ^ self generateWeatherDocumentFor: weatherData.
]

{ #category : 'initialization' }
Forecast >> initialize [ 
	
	super initialize.
	self registerCommand: #slashWeather: to: '/weather'.
	webClient := ForeCastWebClient instance
	
]

{ #category : 'action' }
Forecast >> slashHelp: aMessage [
	| helpText |
    helpText := 'Aquí tienes una lista de comandos que puedes usar:' , String lf ,
                ' /start - Iniciar el bot y recibir una bienvenida' , String lf ,
                ' /help - Ver este mensaje de ayuda' , String lf ,
                ' /weather - Obtener el pronóstico del clima para una ciudad'.
    ^ aMessage send: helpText.
]

{ #category : 'action' }
Forecast >> slashStart: aMessage [
    | welcomeText |
    welcomeText := '¡Bienvenido a ForecastBot! Soy tu bot de pronóstico del clima.' , String lf ,
                   'Puedes pedirme el clima actual de cualquier ciudad del mundo.'.
    ^ aMessage send: welcomeText .
]

{ #category : 'action' }
Forecast >> slashWeather: aMessage [
    "Inicia el proceso para manejar la entrada de ciudad y país de manera concurrente."
		| city country |
        
        "Pregunta por la ciudad."
        aMessage send: 'Ingrese una ciudad, por favor.'.

        "Espera la respuesta del usuario con getUpdates."
        city := self waitForCityResponse: aMessage. 
			
        "Pregunta por el país."
        aMessage send: 'Ingrese un país, por favor.'.

        "Espera la respuesta del usuario con getUpdates."
        country := self waitForCountryResponse: aMessage.
			
        "Una vez que tenemos ciudad y país, obtenemos el clima."
        aMessage send: (self getWeatherForCity: city country: country).
]

{ #category : 'as yet unclassified' }
Forecast >> waitForCityResponse: aMessage [
    | response cityResponse  |
    Transcript show: 'Hola';cr.
    "Esperar hasta recibir una respuesta de ciudad."
    [
        response := self getUpdates: true.  "Obtener las actualizaciones más recientes."
        
        response isEmpty ifFalse: [
            "Solo intentar detectar si hay actualizaciones."
				Transcript show: (response first text ~= '');cr.
            cityResponse := response detect: [:each | each text ~= ''] ifNone: [nil].
				Transcript show: cityResponse text;cr.
        ].
		  Transcript show: cityResponse;cr.
        cityResponse notNil
    ] whileFalse: [
        "Sigue esperando hasta que haya una respuesta válida."
        (Delay forSeconds: 1) wait.  "Evitar consumir recursos mientras espera."
    ].
    ^ cityResponse text.
]

{ #category : 'as yet unclassified' }
Forecast >> waitForCountryResponse: aMessage [
    | response countryResponse |
	 Transcript show: 'Chau';cr.
    "Esperar hasta recibir una respuesta de pais."
    [
        response := self getUpdates: true.  "Obtener las actualizaciones más recientes."
        
        response isEmpty ifFalse: [
				
            "Solo intentar detectar si hay actualizaciones."
				Transcript show: (response first text ~= '');cr.
            countryResponse := response detect: [:each | each text notEmpty] ifNone: [nil].
				Transcript show: countryResponse text;cr.
        ].
		  Transcript show: countryResponse;cr.
        countryResponse notNil
    ] whileFalse: [
        "Sigue esperando hasta que haya una respuesta válida."
        (Delay forSeconds: 1) wait.  "Evitar consumir recursos mientras espera."
    ].
    ^ countryResponse text.
]

{ #category : 'accessing' }
Forecast >> webClient [
	^ webClient 
]
