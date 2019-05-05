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
]

{ #category : #initialization }
PotLCDI2C >> gpioConfiguration [
	^ nil
]

{ #category : #testing }
PotLCDI2C >> isConnected [
	^ i2cConnection notNil
]

{ #category : #writing }
PotLCDI2C >> syncClock [
	"see how this works in datasheet of I2C chipset"
	i2cConnection write8BitsAt: 16r31 data: 16r01
]

{ #category : #writing }
PotLCDI2C >> write: aByteArray charMode: aBit [
	"see how this works in datasheet of I2C chipset"
	i2cConnection write8BitsAt: 16r31 data: aByteArray asHex.
]
