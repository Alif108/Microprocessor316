/*
 * CounterDemo.c
 *
 * Created: 4/5/2021 1:34:28 PM
 * Author : Asus
 */ 

#define F_CPU 1000000

#include <avr/io.h>
#include <util/delay.h>

int main(void)
{
    /* Replace with your application code */
	
	DDRA = 0b00000001;
	DDRB = 0b00001111;
	DDRD = 0b00000000;
		
	unsigned char count = 0;
	unsigned char zero = 1;
	
    while (1) 
    {
		PORTA = zero;
		
		unsigned char in = PIND; 
		
		if(in & 0b00000001)
		{
			count++;
			if(count == 16)
			{
				count = 0;
			}
			
			if(count == 0)
				zero = 1;
			else
				zero = 0;
			
			PORTA = zero;						
			PORTB = count;
			_delay_ms(500);
		}
		else if(in & 0b00000010)
		{
			count--;
			if(count == 255)
				count = 15;
			
			if(count == 0)
				zero = 1;
			else
				zero = 0;
			
			PORTA = zero;						
			PORTB = count;
			_delay_ms(500);
		}
		
		else if(in & 0b00000100)
		{
			count = 0;
			zero = 1;
			
			PORTA = zero;					
			PORTB = count;
			_delay_ms(500);
		}

    }
}

