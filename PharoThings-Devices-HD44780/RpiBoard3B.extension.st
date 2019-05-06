Extension { #name : #RpiBoard3B }

{ #category : #'*PharoThings-Devices-HD44780' }
RpiBoard3B >> configurePotLCD: aDevice [
   aDevice
		setPin: (self pinWithId: 27) at: #modePin; "RS 1 character or 0 lcd commands" 
		setPin: (self pinWithId: 22) at: #clockPin; "EN clock enable"
		setPin: (#(18 23 24 25) collect: [:id | self pinWithId: id]) at: #dataPins; "D7 D6 D5 D4 [D3 D2 D1 D0] data bit 4bit or [8bit]"
		setPin: (self pinWithId: 12) at: #backlight; "BL back light PWM"
		busMode: '#4bit'. "4bit or 8bit LCD bus mode"
		
	

]
