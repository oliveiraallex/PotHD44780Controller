"
I'm a class to control the HD44780 chipset based devices. 

My code was based in python code from Adafruit:

https://github.com/adafruit/Adafruit_Python_CharLCD/blob/master/Adafruit_CharLCD/Adafruit_CharLCD.py

To use:
(inspector)
lcd := board installDevice: PotLCD1602Device new.
or to I2C
lcd := board installDevice: PotLCD1602DeviceI2C new.

(playground. change the board model  to your board)
lcd := (RpiBoard3B current) installDevice: PotLCD1602Device new.
or to I2C
lcd := (RpiBoard3B current) installDevice: PotLCD1602DeviceI2C new.

Sent a message to LCD display:
lcd showMessage: 
'your text first row
your text second row'

Clear LCD display:
lcd clearDisplay

API:
lcd showMessage: 'Hello
Pharo IoT'.
lcd clearDisplay.
lcd disableBlinkCursor.
lcd disableDisplay.
lcd disableUnderlineCursor. 
lcd enableBlinkCursor.
lcd enableDisplay.
lcd enableUnderlineCursor.
lcd moveCursorLeft.
lcd moveCursorRight.
lcd returnHome.
lcd setCursorAtRow:2.
lcd setCursorAtRow:1 column:1.
lcd setLeftJustify.
lcd setLeftToRight.
lcd setRightJustify.
lcd setRightToLeft.
"
Class {
	#name : #PotLCDHD44780,
	#superclass : #PotDevice,
	#instVars : [
		'displayControl',
		'displayFunction',
		'displayMode'
	],
	#classVars : [
		'LCD_1LINE',
		'LCD_2LINE',
		'LCD_4BITMODE',
		'LCD_5x10DOTS',
		'LCD_5x8DOTS',
		'LCD_8BITMODE',
		'LCD_BACKLIGHT',
		'LCD_BLINKOFF',
		'LCD_BLINKON',
		'LCD_CLEARDISPLAY',
		'LCD_CURSORMOVE',
		'LCD_CURSOROFF',
		'LCD_CURSORON',
		'LCD_CURSORSHIFT',
		'LCD_DISPLAYCONTROL',
		'LCD_DISPLAYMOVE',
		'LCD_DISPLAYOFF',
		'LCD_DISPLAYON',
		'LCD_ENABLEBIT',
		'LCD_ENTRYLEFT',
		'LCD_ENTRYMODESET',
		'LCD_ENTRYRIGHT',
		'LCD_ENTRYSHIFTDECREMENT',
		'LCD_ENTRYSHIFTINCREMENT',
		'LCD_FUNCTIONSET',
		'LCD_MOVELEFT',
		'LCD_MOVERIGHT',
		'LCD_NOBACKLIGHT',
		'LCD_READWRITEBIT',
		'LCD_REGISTERBIT',
		'LCD_RETURNHOME',
		'LCD_ROW_OFFSETS',
		'LCD_SETCGRAMADDR',
		'LCD_SETDDRAMADDR'
	],
	#category : #'PharoThings-Devices-HD44780'
}

{ #category : #commands }
PotLCDHD44780 >> clearDisplay [
	self writeCommand: LCD_CLEARDISPLAY.
	3 milliSeconds wait
	"waiting to clear the display"
]

{ #category : #initialization }
PotLCDHD44780 >> connect [
	self subclassResponsibility 
]

{ #category : #commands }
PotLCDHD44780 >> disableBlinkCursor [
	self
		setDisplayControl: (displayControl bitAnd: LCD_BLINKON bitInvert)
]

{ #category : #commands }
PotLCDHD44780 >> disableDisplay [
	self
		setDisplayControl: (displayControl bitAnd: LCD_DISPLAYON bitInvert)
]

{ #category : #commands }
PotLCDHD44780 >> disableUnderlineCursor [
	self
		setDisplayControl: (displayControl bitAnd: LCD_CURSORON bitInvert)
]

{ #category : #commands }
PotLCDHD44780 >> enableBlinkCursor [
	self 
		setDisplayControl: (displayControl bitOr: LCD_BLINKON)
]

{ #category : #commands }
PotLCDHD44780 >> enableDisplay [
	self 
		setDisplayControl: (displayControl bitOr: LCD_DISPLAYON)
]

{ #category : #commands }
PotLCDHD44780 >> enableUnderlineCursor [
	self 
		setDisplayControl: (displayControl bitOr: LCD_CURSORON)
]

{ #category : #initialization }
PotLCDHD44780 >> hexArrayBitOrToNumber: anArray [
	^ anArray inject: 0 into:  [:each : hex | hex bitOr: each]
	"hexArrayToNumber: #(16r06 16r01 16r08) ^16r0F"
]

{ #category : #initialization }
PotLCDHD44780 >> initialize [
	LCD_CLEARDISPLAY := 16r01.
	LCD_RETURNHOME := 16r02.
	LCD_ENTRYMODESET := 16r04.
	LCD_DISPLAYCONTROL := 16r08.
	LCD_CURSORSHIFT := 16r10.
	LCD_FUNCTIONSET := 16r20.
	LCD_SETCGRAMADDR := 16r40.
	LCD_SETDDRAMADDR := 16r80.
	"Entry flags"
	LCD_ENTRYRIGHT := 16r00.
	LCD_ENTRYLEFT := 16r02.
	LCD_ENTRYSHIFTINCREMENT := 16r01.
	LCD_ENTRYSHIFTDECREMENT := 16r00.
	"Control flags"
	LCD_DISPLAYON := 16r04.
	LCD_DISPLAYOFF := 16r00.
	LCD_CURSORON := 16r02.
	LCD_CURSOROFF := 16r00.
	LCD_BLINKON := 16r01.
	LCD_BLINKOFF := 16r00.
	"Move flags"
	LCD_DISPLAYMOVE := 16r08.
	LCD_CURSORMOVE := 16r00.
	LCD_MOVERIGHT := 16r04.
	LCD_MOVELEFT := 16r00.
	"Function set flags"
	LCD_8BITMODE := 16r10.
	LCD_4BITMODE := 16r00.
	LCD_2LINE := 16r08.
	LCD_1LINE := 16r00.
	LCD_5x10DOTS := 16r04.
	LCD_5x8DOTS := 16r00.
	"Offset for up to 4 rows"
	LCD_ROW_OFFSETS := #(16r00 16r40 16r14 16r54).
	LCD_BACKLIGHT := 16r08.
	LCD_NOBACKLIGHT := 16r00.
	"Enable bit"
	LCD_ENABLEBIT := 16r04.
	"Read/Write bit"
	LCD_READWRITEBIT := 16r02.
	"Register select bit"
	LCD_REGISTERBIT := 16r01
]

{ #category : #initialization }
PotLCDHD44780 >> initializeRegisters [
	self subclassResponsibility 
]

{ #category : #testing }
PotLCDHD44780 >> isConnected [
	^self subclassResponsibility 
]

{ #category : #commands }
PotLCDHD44780 >> moveCursorLeft [
	self 
		writeCommand: (self hexArrayBitOrToNumber: {LCD_DISPLAYMOVE . LCD_CURSORSHIFT . LCD_MOVELEFT})
]

{ #category : #commands }
PotLCDHD44780 >> moveCursorRight [
	self 
		writeCommand: (self hexArrayBitOrToNumber: {LCD_DISPLAYMOVE . LCD_CURSORSHIFT . LCD_MOVERIGHT})
]

{ #category : #commands }
PotLCDHD44780 >> returnHome [ 
	self writeCommand: LCD_RETURNHOME.
	3 milliSeconds wait
	"this command takes a long time"
]

{ #category : #commands }
PotLCDHD44780 >> setCursorAtRow: row [
	self setCursorAtRow: row column: 1
]

{ #category : #commands }
PotLCDHD44780 >> setCursorAtRow: row column: column [  
	self writeCommand: (LCD_SETDDRAMADDR bitOr: (column -1) + (LCD_ROW_OFFSETS at:row))
]

{ #category : #initialization }
PotLCDHD44780 >> setDisplayControl: anHex [
	self writeCommand: (LCD_DISPLAYCONTROL bitOr: anHex).
	1 milliSeconds wait
]

{ #category : #initialization }
PotLCDHD44780 >> setDisplayFunction: anHex [
	self writeCommand: (LCD_FUNCTIONSET bitOr: anHex).
	1 milliSeconds wait
]

{ #category : #initialization }
PotLCDHD44780 >> setDisplayMode: anHex [
	self writeCommand: (LCD_ENTRYMODESET bitOr: anHex).
	1 milliSeconds wait
]

{ #category : #commands }
PotLCDHD44780 >> setLeftAutoScroll [
	self 
		setDisplayMode: {displayMode bitAnd: (LCD_ENTRYSHIFTINCREMENT bitInvert)}
]

{ #category : #commands }
PotLCDHD44780 >> setLeftToRight [
	self 
		setDisplayMode: {displayMode bitOr: LCD_ENTRYLEFT}
]

{ #category : #commands }
PotLCDHD44780 >> setRightAutoScroll [
	self 
		setDisplayMode: {displayMode bitOr: LCD_ENTRYSHIFTINCREMENT}
]

{ #category : #commands }
PotLCDHD44780 >> setRightToLeft [
	self 
		setDisplayMode: {displayMode bitAnd: (LCD_ENTRYLEFT bitInvert)}
]

{ #category : #writing }
PotLCDHD44780 >> showMessage: aString [
	| i |
	i := 1.
	aString
		do: [ :char | 
			char = Character cr
				ifTrue: [ self setCursorAtRow: (i := i + 1) ]
				ifFalse: [ self writeCharacter: char asciiValue ] ]
]

{ #category : #writing }
PotLCDHD44780 >> write: anHex mode: aBit [
	"mode:0 to send commands or mode:1 to send characters. Use writeCommand: and writeCharacter:"
	self subclassResponsibility
]

{ #category : #writing }
PotLCDHD44780 >> writeCharacter: anHex [
	self write: anHex mode: 1
]

{ #category : #writing }
PotLCDHD44780 >> writeCommand: anHex [
	self write: anHex mode: 0
]
