Class {
	#name : #PotHD44780Controller,
	#superclass : #PotDevice,
	#instVars : [
		'instructionDic',
		'gpioDic',
		'displayControl',
		'displayFunction',
		'displayMode'
	],
	#category : #'PharoThings-Devices-HD44780'
}

{ #category : #initialization }
PotHD44780Controller >> bitOrArray: anArray [
	
	| hex hexOr |
	1 to: anArray size do: [ :i |  
		hex := (instructionDic at: (anArray at: i )) .
		hexOr ifNil: [ hexOr := hex] ifNotNil: [ hexOr := hexOr bitOr: hex ].
		 ].   
	^hexOr. 
]

{ #category : #commands }
PotHD44780Controller >> clear [
	self writeCommand: (instructionDic at: #LCD_CLEARDISPLAY).
	(Delay forSeconds: 0.003) wait
	"3 miliseconds waiting to clear the display"
]

{ #category : #initialization }
PotHD44780Controller >> connect [
	self subclassResponsibility 
]

{ #category : #initialization }
PotHD44780Controller >> displayControl: anArray [
	displayControl := self bitOrArray: anArray.
	
]

{ #category : #initialization }
PotHD44780Controller >> displayFunction: anArray [
	displayFunction := self bitOrArray: anArray
]

{ #category : #initialization }
PotHD44780Controller >> displayMode: anArray [
	displayMode := self bitOrArray: anArray
]

{ #category : #initialization }
PotHD44780Controller >> gpioConfiguration [
	self subclassResponsibility 
]

{ #category : #commands }
PotHD44780Controller >> home [ 
	self writeCommand: (instructionDic at: #LCD_RETURNHOME).
	(Delay forSeconds: 0.003) wait.
	"3 miliseconds waiting, this command takes a long time"
]

{ #category : #initialization }
PotHD44780Controller >> initialize [
	
	instructionDic := Dictionary new.
	instructionDic 
		"Commands"
		add: (#LCD_CLEARDISPLAY -> 16r01);
		add: (#LCD_RETURNHOME -> 16r02);
		add: (#LCD_ENTRYMODESET -> 16r04);
		add: (#LCD_DISPLAYCONTROL -> 16r08);
		add: (#LCD_CURSORSHIFT -> 16r10);
		add: (#LCD_FUNCTIONSET -> 16r20);
		add: (#LCD_SETCGRAMADDR -> 16r40);
		add: (#LCD_SETDDRAMADDR -> 16r80);
		"Entry flags"
		add: (#LCD_ENTRYRIGHT -> 16r00);
		add: (#LCD_ENTRYLEFT -> 16r02);
		add: (#LCD_ENTRYSHIFTINCREMENT -> 16r01);
		add: (#LCD_ENTRYSHIFTDECREMENT -> 16r00);
		"Control flags"
		add: (#LCD_DISPLAYON -> 16r04);
		add: (#LCD_DISPLAYOFF -> 16r00);
		add: (#LCD_CURSORON -> 16r02);
		add: (#LCD_CURSOROFF -> 16r00);
		add: (#LCD_BLINKON -> 16r01);
		add: (#LCD_BLINKOFF -> 16r00);
		"Move flags"
		add: (#LCD_DISPLAYMOVE -> 16r08);
		add: (#LCD_CURSORMOVE -> 16r00);
		add: (#LCD_MOVERIGHT -> 16r04);
		add: (#LCD_MOVELEFT -> 16r00);
		"Function set flags"
		add: (#LCD_8BITMODE -> 16r10);
		add: (#LCD_4BITMODE -> 16r00);
		add: (#LCD_2LINE -> 16r08);
		add: (#LCD_1LINE -> 16r00);
		add: (#LCD_5x10DOTS -> 16r04);
		add: (#LCD_5x8DOTS -> 16r00);
		"Offset for up to 4 rows"
		add: (#LCD_ROW_OFFSETS -> #(16r00 16r40 16r14 16r54)) .
	
]

{ #category : #initialization }
PotHD44780Controller >> initializeRegisters [
	"Initialize the display"
	self writeCommand: 16r33.
	self writeCommand: 16r32.
	"Write registers"
	self writeCommand: ((instructionDic at: #LCD_DISPLAYCONTROL) bitOr: displayControl).
	self writeCommand: ((instructionDic at: #LCD_FUNCTIONSET) bitOr: displayFunction).
	self writeCommand: ((instructionDic at: #LCD_ENTRYMODESET) bitOr: displayMode).
	self clear
]

{ #category : #testing }
PotHD44780Controller >> isConnected [
	^self subclassResponsibility 
]

{ #category : #commands }
PotHD44780Controller >> setCursorAtRow: anInteger [
	self setCursorAtRow: anInteger col: 1

	
]

{ #category : #commands }
PotHD44780Controller >> setCursorAtRow: anInteger col: anInteger2 [
	self writeCommand:
		((instructionDic at: #LCD_SETDDRAMADDR)
			bitOr: anInteger2 + ((instructionDic at: #LCD_ROW_OFFSETS) at:anInteger))
]

{ #category : #initialization }
PotHD44780Controller >> setPin: anObject at: aSymbol [
	gpioDic ifNil: [gpioDic := Dictionary new].
	gpioDic add: aSymbol -> anObject
]

{ #category : #writing }
PotHD44780Controller >> showMessage: aString [
	| charHex |
	1 to: aString size do: [ :i | 
		charHex := (aString at: i) hex.
		(aString at: i) = $\
			ifTrue: [ self setCursorAtRow: 2 ]
			ifFalse: [ self writeText: charHex ] ]
]

{ #category : #writing }
PotHD44780Controller >> syncClock [
	self subclassResponsibility 
]

{ #category : #writing }
PotHD44780Controller >> write: anHex charMode: aBit [

	self subclassResponsibility 
]

{ #category : #writing }
PotHD44780Controller >> writeCommand: anHex [
	self write: anHex charMode: 0
]

{ #category : #writing }
PotHD44780Controller >> writeText: anHex [
	self write: anHex charMode: 1
]
