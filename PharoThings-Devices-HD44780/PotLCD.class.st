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
   self isConfigured ifFalse: [  board configurePotLCD: self]
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

{ #category : #writing }
PotLCD >> syncClock [
	(gpioDic at: #clockPin) value: 0; value: 1; value: 0
]

{ #category : #writing }
PotLCD >> write: anHex charMode: aBit [
	| j |
	j := 1.
	(Delay forSeconds: 0.001) wait.
	"1 miliseconds waiting to prevent write too quickly"
	(gpioDic at: #modePin) value: aBit.
	1 to: 8 do: [ :i | 
		(busMode = '4bit' and: [ j > 4 ]) 
			ifTrue: [ j := 1.
				self syncClock ]. "if busMode is 4bit reuse the 4 wires to resend the last 4 bits"
		((gpioDic at: #dataPins) at: j) value: (anHex bitAt: i) ].
	self syncClock
]
