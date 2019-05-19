"
I'm a class to control the HD44780 chipset based devices using GPIOs. You can configure the GPIOs in configureForRpiBoard3B: method


"
Class {
	#name : #PotLCDHD44780Gpio,
	#superclass : #PotLCDHD44780,
	#instVars : [
		'modePin',
		'clockPin',
		'dataPins',
		'backlightPin'
	],
	#category : #'PharoThings-Devices-HD44780'
}

{ #category : #initialization }
PotLCDHD44780Gpio >> configureForRpiBoard3B: aBoard [
	"Pin mapping:
	---------------------------------------------------------------
	VSS|VDD|V0 |RS |RW | E |D0 |D1 |D2 |D3 |D4 |D5 |D6 |D7 | A | K 
	   |   |   |27 |   |22 |   |   |   |   |25 |24 |23 |18 |   |12 
	                           [8 BIT]          4 BIT             
	---------------------------------------------------------------" 
		modePin := (aBoard pinWithId: 27). "RS 1 character or 0 lcd commands" 
		clockPin :=  (aBoard pinWithId: 22). "EN clock enable"
		dataPins := (#(18 23 24 25) collect: [:id | aBoard pinWithId: id]). "D7 D6 D5 D4 [D3 D2 D1 D0] data bit 4bit or [8bit]"
		backlightPin := (aBoard pinWithId: 12) "BL backlight PWM"
]

{ #category : #controlling }
PotLCDHD44780Gpio >> connect [
	self isConfigured ifFalse: [ board configureComplexDevice: self ].
	self setPinsToDigitalOutput.
	self initializeRegisters
]

{ #category : #initialization }
PotLCDHD44780Gpio >> initializeRegisters [
	self
		"Write registers"
		setDisplayFunction: displayFunction;
		setDisplayControl: displayControl ;
		setDisplayMode: displayMode;
		clearDisplay
]

{ #category : #testing }
PotLCDHD44780Gpio >> isConfigured [ 
	^ dataPins notNil
]

{ #category : #testing }
PotLCDHD44780Gpio >> isConnected [
	^ board notNil
]

{ #category : #commands }
PotLCDHD44780Gpio >> setBacklightIntensity: anInteger [
	backlightPin value: 1024 - (anInteger min: 0 max: 1024).
	"The range is from 0-1024 pwm. 0 is totaly bright and 1024 totaly dark. 
	The (1024 - anInteger) is to invert the parameter"
]

{ #category : #initialization }
PotLCDHD44780Gpio >> setPinsToDigitalOutput [
	| gpioArray |
	gpioArray := { clockPin . modePin . dataPins . backlightPin } flattened.
	gpioArray do: [ :i |i beDigitalOutput ]
]

{ #category : #writing }
PotLCDHD44780Gpio >> syncClock [
	clockPin value: 0; value: 1; value: 0
]

{ #category : #writing }
PotLCDHD44780Gpio >> write: anHex mode: aBit [
	"mode:0 to send commands or mode:1 to send characters. Use writeCommand: and writeCharacter:"
	| j |
	j := 1.
	0.001 milliSeconds wait.
	"1 miliseconds waiting to prevent write too quickly"
	modePin value: aBit.
	8 to: 1 by: -1 do: [ :i | 
		j > dataPins size
			ifTrue: [ j := 1.
				self syncClock ].	"if busMode is 4bit reuse the 4 wires to send the last 4 bits"
		(dataPins at: j) value: (anHex bitAt: i).
		j := j + 1 ].
	self syncClock
]
