Class {
	#name : #PotLCD1602DeviceI2C,
	#superclass : #PotLCDHD44780I2C,
	#category : #'PharoThings-Devices-HD44780'
}

{ #category : #initialization }
PotLCD1602DeviceI2C >> initialize [
	super initialize.
	displayControl := self hexArrayBitOrToNumber: {LCD_DISPLAYON}.
	displayFunction := self hexArrayBitOrToNumber: {LCD_4BITMODE. LCD_2LINE. LCD_5x8DOTS}.
	displayMode := self hexArrayBitOrToNumber: {LCD_ENTRYLEFT}
]
