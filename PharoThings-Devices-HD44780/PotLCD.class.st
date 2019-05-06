Class {
	#name : #PotLCD,
	#superclass : #PotHD44780Controller,
	#instVars : [
		'busMode'
	],
	#category : #'PharoThings-Devices-HD44780'
}

{ #category : #accessing }
PotLCD >> busMode: aSymbol [
	busMode := aSymbol
]

{ #category : #controlling }
PotLCD >> connect [
	self isConfigured ifFalse: [ board configurePotLCD: self ].
	self setPinsToDigitalOutput.
	self initializeRegisters
]

{ #category : #initialization }
PotLCD >> gpioConfiguration [
	board configurePotLCD: self
]

{ #category : #testing }
PotLCD >> isConfigured [ 
	^ gpioDic notNil
]

{ #category : #testing }
PotLCD >> isConnected [
	^ board notNil
]

{ #category : #initialization }
PotLCD >> setPin: anObject at: aSymbol [
	gpioDic ifNil: [gpioDic := Dictionary new].
	gpioDic add: aSymbol -> anObject 
]

{ #category : #initialization }
PotLCD >> setPinsToDigitalOutput [
	| gpioArray |
	gpioArray := (gpioDic values collect: #asGlamorousArray ) flattened.
	gpioArray do: [ :i |i beDigitalOutput ]
]

{ #category : #writing }
PotLCD >> syncClock [
	(gpioDic at: #clockPin) value: 0; value: 1; value: 0
]

{ #category : #writing }
PotLCD >> write: anHex charMode: aBit [
	| j  bits pins |
	j := 1.
	pins := ''.
	bits := ''.
	(Delay forSeconds: 0.001) wait.
	"1 miliseconds waiting to prevent write too quickly"
	(gpioDic at: #modePin) value: aBit.
	Transcript cr; show: 'char: ',((anHex asCharacter asString) padLeftTo:1),' hex: ',((anHex hex asString) padLeftTo:5) ,' decimal: ',((anHex asString) padLeftTo:3),' charMode: ',aBit asString,' index i:j:'.
	8 to: 1 by: -1 do: [ :i | 
		(busMode = '#4bit' and: [ j > 4 ]) 
			ifTrue: [ j := 1.
				self syncClock ]. "if busMode is 4bit reuse the 4 wires to send the last 4 bits"
		((gpioDic at: #dataPins) at: j) value: (anHex bitAt: i).
		
		bits := bits,(anHex bitAt: i)asString.
		pins := pins,(((gpioDic at: #dataPins) at: j) id) asString,' '.
		Transcript show: ' ',i asString,j asString,' '.
		j := j+1.
		 ].
	Transcript show: ' bits: ',bits asString.
	Transcript show: ' pins: ',pins asString.
	self syncClock
]
