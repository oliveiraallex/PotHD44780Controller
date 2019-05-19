"
I'm a class to control the HD44780 chipset based devices using I2C protocol
"
Class {
	#name : #PotLCDHD44780I2C,
	#superclass : #PotLCDHD44780,
	#instVars : [
		'i2cConnection'
	],
	#category : #'PharoThings-Devices-HD44780'
}

{ #category : #controlling }
PotLCDHD44780I2C >> connect [
	i2cConnection := board connectToI2CDevice: 16r27 .
	self initializeRegisters
]

{ #category : #initialization }
PotLCDHD44780I2C >> initializeRegisters [
	self 
		"Initialize the display"
		writeCommand: 16r03;
		writeCommand: 16r03;
		writeCommand: 16r03;
		writeCommand: 16r02;
		"Write registers"
		setDisplayFunction: displayFunction;
		setDisplayControl: displayControl ;
		setDisplayMode: displayMode;
		clearDisplay
]

{ #category : #testing }
PotLCDHD44780I2C >> isConnected [
	^ i2cConnection notNil
]

{ #category : #writing }
PotLCDHD44780I2C >> lower4Bits: anHex [
	^ (anHex bitShift: 4 ) bitAnd: 16rF0
	"return a byte with the last 4 bits of parameter. Ex:
	16r28 returns 16r80 = 0010 1000 -> 1000 0000
	16r03 returns 16r30 = 0000 0011 -> 0011 0000
	16r61 returns 16r10 = 0110 0001 -> 0001 0000"
]

{ #category : #writing }
PotLCDHD44780I2C >> syncClock: anHex [
	i2cConnection read8BitsAt: (anHex bitOr: LCD_ENABLEBIT).
	i2cConnection read8BitsAt: (anHex bitAnd: (LCD_ENABLEBIT bitInvert))
]

{ #category : #writing }
PotLCDHD44780I2C >> upper4Bits: anHex [
	^ anHex bitAnd: 16rF0
	"return a byte with the first 4 bits of parameter. Ex:
	16r28 returns 16r20 = 0010 1000 -> 0010 0000
	16r03 returns 16r00 = 0000 0011 -> 0000 0000
	16r61 returns 16r60 = 0110 0001 -> 0110 0000"
]

{ #category : #writing }
PotLCDHD44780I2C >> write: anHex mode: aBit [
	"mode:0 to send commands or mode:1 to send characters. Use writeCommand: and writeCharacter:"
	| upper4BitsWithMode lower4BitsWithMode upper4BitsWithModeAndBacklight lower4BitsWithModeAndBacklight|
	
	upper4BitsWithMode := aBit bitOr: (self upper4Bits:anHex).
	lower4BitsWithMode := aBit bitOr: (self lower4Bits:anHex).
	upper4BitsWithModeAndBacklight := upper4BitsWithMode bitOr: LCD_BACKLIGHT.
	lower4BitsWithModeAndBacklight := lower4BitsWithMode bitOr: LCD_BACKLIGHT.
	
	i2cConnection read8BitsAt: (upper4BitsWithModeAndBacklight).
	self syncClock: (upper4BitsWithModeAndBacklight).
	i2cConnection read8BitsAt: (lower4BitsWithModeAndBacklight).
	self syncClock: (lower4BitsWithModeAndBacklight)
]
