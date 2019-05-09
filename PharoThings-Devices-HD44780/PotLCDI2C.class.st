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
	i2cConnection := board connectToI2CDevice: 16r27 
	"self initializeRegisters"
]

{ #category : #writing }
PotLCDI2C >> first4Bits: anHex [
	^ anHex >> 4
]

{ #category : #initialization }
PotLCDI2C >> initializeRegisters [
	"Initialize the display"
	self writeCommand: 16r03.
	self writeCommand: 16r03.
	self writeCommand: 16r03.
	self writeCommand: 16r02.
	"Write registers"
	self writeCommand: ((instructionDic at: #LCD_DISPLAYCONTROL) bitOr: displayControl).
	self writeCommand: ((instructionDic at: #LCD_FUNCTIONSET) bitOr: displayFunction).
	self writeCommand: ((instructionDic at: #LCD_ENTRYMODESET) bitOr: displayMode).
	self clearDisplay
]

{ #category : #testing }
PotLCDI2C >> isConnected [
	^ i2cConnection notNil
]

{ #category : #writing }
PotLCDI2C >> last4Bits: anHex [
	^ (anHex bitOr: 16rF0) bitXor: 16rF0.
]

{ #category : #writing }
PotLCDI2C >> splitByte: anHex [
	| first4Bits last4Bits |
	first4Bits := (self first4Bits: anHex) printPaddedWith: $0 to: 4 base: 2.
	last4Bits := (self last4Bits: anHex) printPaddedWith: $0 to: 4 base: 2.
	^ Array with: (anHex printPaddedWith: $0 to: 8 base: 2) with: first4Bits with: last4Bits
	
	"splitByte: 16r61 
	^ #('01100001' '0110' '0001')"
]

{ #category : #writing }
PotLCDI2C >> syncClock: halfByte [
	
	i2cConnection read8BitsAt: (halfByte bitOr: 16r04) .
	(Delay forSeconds: 0.005) wait.
	i2cConnection read8BitsAt: (halfByte bitAnd: (16r04 bitInvert)).
	(Delay forSeconds: 0.001) wait.
	self log: halfByte txt: 'Clock: halfByte' eol: 0. 
	self log: (halfByte bitOr: 16r04) txt: 'halfByte+or0100' eol: 0. 
	self log: (halfByte bitAnd: (16r04 bitInvert)) txt: 'halfByte+or0100+' eol: 1. 
]

{ #category : #writing }
PotLCDI2C >> write: anHex charMode: aBit [
	| first4Bits last4Bits |
	self log: anHex txt: 'hex' eol: 0. 
	self log: aBit txt: 'bit' eol: 1.
	self log: (anHex bitAnd: 16rF0) txt: 'f4b' eol: 0. 
	self log: ((anHex bitShift: 4 ) bitAnd: 16rF0) txt: 'l4b' eol: 1.
	"first4Bits := aBit bitOr: (self first4Bits: anHex) .
	last4Bits  := aBit bitOr: (self last4Bits: anHex)."
	first4Bits := aBit bitOr: (anHex bitAnd: 16rF0) .
	last4Bits  := aBit bitOr: ((anHex bitShift: 4 ) bitAnd: 16rF0).
	self log: first4Bits txt: 'f4b+reg' eol: 0. 
	self log: last4Bits txt: 'l4b+reg' eol: 1.
	self log: (first4Bits bitOr: 16r08) txt: 'f4b+bl1000' eol: 0. 
	self log: (last4Bits bitOr: 16r08) txt: 'l4b+bl1000' eol: 1.
	
	i2cConnection read8BitsAt: (first4Bits bitOr: 16r08).
	self syncClock: (first4Bits bitOr: 16r08).
	i2cConnection read8BitsAt: (last4Bits bitOr: 16r08).
	self syncClock: (last4Bits bitOr: 16r08).
	
	
]
