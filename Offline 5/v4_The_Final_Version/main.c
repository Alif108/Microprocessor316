#define F_CPU 1000000
#include <avr/io.h>
#include <util/delay.h>
#include <avr/interrupt.h>

int i=0, j=0, k=0;
int state = 0;

//char col[] = {0b00011000, 0b00100100, 0b01000000, 0b00000010, 0b00001110};
//char row[] = {0b01111110, 0b10111101, 0b11000011, 0b11011011, 0b11110111};

char col[] = {0b00000000, 0b01000000, 0b00100000, 0b00010000, 0b00001000, 0b00000100, 0b00000010, 0b00000000};
char row[] = {0b00000000, 0b11000011, 0b10111101, 0b01111110, 0b01110110, 0b10110101, 0b11010011, 0b00000000};

char leftRotate(char n, unsigned int d)		// for wrap around LED binary
{
	return (n << d)|(n >> (8 - d));
}

ISR(INT0_vect)
{
	state = 1 - state;
}

int main(void)
{
	DDRB = 0xFF;
	DDRA = 0xFF;
	
	PORTD = (1<<2);				//	INT0
	GICR = (1<<6);
	MCUCR = 0x02;				//	Falling Edge
	
	sei();
 
    while (1) 
    {
		
		while(state)
		{
			for(k=0; k<1000; k++)
			{
				//PORTA = col[i];
				PORTA = leftRotate(col[i], j);
				PORTB = row[i];
				
				i++;
				
				if(i>7)
					i = 0;
			}
			
			j++;
			if(j>7)
				j = 0;
			
			_delay_ms(50);
		}
		
		PORTA = leftRotate(col[i], j);
		PORTB = row[i];
		_delay_ms(2);
		
		i++;
		if(i > 7)
			i = 0;
    }
}

