#ifndef F_CPU
#define F_CPU 16000000UL // 16 MHz clock speed
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

/*void float_to_string(char x[], float y)
{
	
	int z = y * 100;
	char temp[5] = "00000";
	sprintf(temp, "%d", z);
	
	if(y>1)
	{
		x[0] = temp[0];
		x[1] = '.';
		x[2] = temp[1];
		x[3] = temp[2];
	}
	else
	{
		x[0] = '0';
		x[1] = '.';
		x[2] = temp[0];
		x[3] = temp[1];
	}
}*/

int main(void)
{
	unsigned int result_upper = 0;
	unsigned int result_lower = 0;
	unsigned int result = 0;
	float analogue_value = 0.0;
	
	char message[20];
	char float_value[5];
	
	DDRD = 0xFF;
	DDRC = 0xFF;
	
	ADMUX = 0x62;			// 0110 0010        // REF -> 01 ;		ADLAR -> 1 ;		MUX -> 00010	
	ADCSRA = 0x83;			// 1000 0011		// ADEN, ADSC, ADATE, ADIF, ADIE -> 10000;		ADPS2, ADPS1, ADPS0 -> 011		
	
	Lcd4_Init();
	
	while(1)
	{
		ADCSRA |= (1<<ADSC);						// start the conversion
			
		while(ADCSRA & (1 << ADSC));				// wait till conversion ends
		
		result_lower = ADCL>>8;						// reading ADCL first
		result_upper = ADCH<<2;
		result = result_upper | result_lower;	
		analogue_value = (float) result * 5/1024;	// getting the actual value
		
		//Lcd4_Clear();
		
		Lcd4_Set_Cursor(1,0);
		sprintf(message, "Voltage: ");
		Lcd4_Write_String(message);
		
		Lcd4_Set_Cursor(1,9);
		dtostrf(analogue_value, 4, 2, float_value);
		Lcd4_Write_String(float_value);

		//_delay_ms(500);
	}
}