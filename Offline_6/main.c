#ifndef F_CPU
#define F_CPU 1000000UL // 1 MHz clock speed
#endif

#define D4 eS_PORTD4
#define D5 eS_PORTD5
#define D6 eS_PORTD6
#define D7 eS_PORTD7
#define RS eS_PORTC6
#define EN eS_PORTC7

#include <avr/io.h>
#include <util/delay.h>
#include <stdio.h>
#include <stdlib.h>
#include "lcd.h"
#include <avr/io.h>

int main(void)
{
	unsigned int result = 0;
	float analogue_value = 0.0;
	
	char message[20];
	char float_value[5];
	
	DDRD = 0xFF;
	DDRC = 0xFF;
	
	ADMUX = 0x62;									// 0110 0010        // REF -> 01 ;		ADLAR -> 1 ;		MUX -> 00010	
	ADCSRA = 0x83;									// 1000 0011		// ADEN, ADSC, ADATE, ADIF, ADIE -> 10000;		ADPS2, ADPS1, ADPS0 -> 011		
	
	Lcd4_Init();
	
	while(1)
	{
		ADCSRA |= (1<<ADSC);						// start the conversion
			
		while(ADCSRA & (1 << ADSC));				// wait till conversion ends
		
		result = (ADCL>>6) | (ADCH<<2);				// reading ADCL first
		analogue_value = (float) result * 5/1024;	// getting the actual value
		
		Lcd4_Set_Cursor(1,0);
		sprintf(message, "Voltage: ");
		Lcd4_Write_String(message);
		
		Lcd4_Set_Cursor(1,9);
		dtostrf(analogue_value, 4, 2, float_value);
		Lcd4_Write_String(float_value);
	}
}