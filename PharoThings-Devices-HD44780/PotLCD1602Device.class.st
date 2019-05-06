Class {
	#name : #PotLCD1602Device,
	#superclass : #PotLCD,
	#category : #'PharoThings-Devices-HD44780'
}

{ #category : #initialization }
PotLCD1602Device >> initialize [
	super initialize. 
	"Set and initialize display control, function, and mode registers"
	self displayControl: #('LCD_DISPLAYON' 'LCD_CURSOROFF' 'LCD_BLINKOFF').
	self displayFunction: #('LCD_4BITMODE' 'LCD_1LINE' 'LCD_2LINE' 'LCD_5x8DOTS' ).
	self displayMode: #('LCD_ENTRYLEFT' 'LCD_ENTRYSHIFTDECREMENT').
	self initializeRegisters.
]
