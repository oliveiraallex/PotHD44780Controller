Class {
	#name : #PotLCDI2C,
	#superclass : #PotHD44780Controller,
	#instVars : [
		'i2cConnection'
	],
	#category : #'PharoThings-Devices-HD44780'
}

{ #category : #controlling }
PotLCDI2C >> connect [
	i2cConnection := board connectToI2CDevice: 16r27 .
	self initializeRegisters
]

{ #category : #initialization }
PotLCDI2C >> initializeRegisters [
	"Initialize the display"
	self writeCommand: 16r03.
	self writeCommand: 16r03.
	self writeCommand: 16r03.
	self writeCommand: 16r02.
	"Write registers"
	self writeCommand: ((instructionDic at: #LCD_FUNCTIONSET) bitOr: displayFunction).
	self writeCommand: ((instructionDic at: #LCD_DISPLAYCONTROL) bitOr: displayControl).
	self clearDisplay.
	self writeCommand: ((instructionDic at: #LCD_ENTRYMODESET) bitOr: displayMode)
]

{ #category : #testing }
PotLCDI2C >> isConnected [
	^ i2cConnection notNil
]

{ #category : #writing }
PotLCDI2C >> lower4Bits: anHex [
	^ (anHex bitShift: 4 ) bitAnd: 16rF0
	"return a byte with the last 4 bits of parameter. Ex:
	16r28 returns 16r80 = 0010 1000 -> 1000 0000
	16r03 returns 16r30 = 0000 0011 -> 0011 0000
	16r61 returns 16r10 = 0110 0001 -> 0001 0000"
]

{ #category : #writing }
PotLCDI2C >> syncClock: anHex [
	
	i2cConnection read8BitsAt: (anHex bitOr: (instructionDic at: #LCD_ENABLEBIT)) .
	i2cConnection read8BitsAt: (anHex bitAnd: ((instructionDic at: #LCD_ENABLEBIT) bitInvert))
]

{ #category : #writing }
PotLCDI2C >> upper4Bits: anHex [
	^ anHex bitAnd: 16rF0
	"return a byte with the first 4 bits of parameter. Ex:
	16r28 returns 16r20 = 0010 1000 -> 0010 0000
	16r03 returns 16r00 = 0000 0011 -> 0000 0000
	16r61 returns 16r60 = 0110 0001 -> 0110 0000"
]

{ #category : #writing }
PotLCDI2C >> write: anHex charMode: aBit [
	| upper4BitsWithMode lower4BitsWithMode upper4BitsWithModeAndBacklight lower4BitsWithModeAndBacklight|
	
	upper4BitsWithMode := aBit bitOr: (self upper4Bits:anHex).
	lower4BitsWithMode := aBit bitOr: (self lower4Bits:anHex).
	upper4BitsWithModeAndBacklight := upper4BitsWithMode bitOr: (instructionDic at: #LCD_BACKLIGHT).
	lower4BitsWithModeAndBacklight := lower4BitsWithMode bitOr: (instructionDic at: #LCD_BACKLIGHT).
	
	i2cConnection read8BitsAt: (upper4BitsWithModeAndBacklight).
	self syncClock: (upper4BitsWithModeAndBacklight).
	i2cConnection read8BitsAt: (lower4BitsWithModeAndBacklight).
	self syncClock: (lower4BitsWithModeAndBacklight)
]
