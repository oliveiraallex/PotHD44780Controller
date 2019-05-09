Class {
	#name : #PotLCD2004DeviceI2C,
	#superclass : #PotLCDI2C,
	#category : #'PharoThings-Devices-HD44780'
}

{ #category : #initialization }
PotLCD2004DeviceI2C >> initialize [
	super initialize.
	self
		displayControl: #('LCD_DISPLAYON');
		displayFunction: #('LCD_4BITMODE' 'LCD_2LINE' 'LCD_5x8DOTS');
		displayMode: #('LCD_ENTRYLEFT')

]
