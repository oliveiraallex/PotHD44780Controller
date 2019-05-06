Class {
	#name : #PotLCD1602Device,
	#superclass : #PotLCD,
	#category : #'PharoThings-Devices-HD44780'
}

{ #category : #initialization }
PotLCD1602Device >> initialize [
	super initialize.
	self
		displayControl: #('LCD_DISPLAYON' 'LCD_CURSOROFF' 'LCD_BLINKOFF');
		displayFunction: #('LCD_4BITMODE' 'LCD_1LINE' 'LCD_2LINE' 'LCD_5x8DOTS');
		displayMode: #('LCD_ENTRYLEFT' 'LCD_ENTRYSHIFTDECREMENT')
]
