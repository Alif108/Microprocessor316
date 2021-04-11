#define F_CPU 1000000
#include <avr/io.h>
#include <util/delay.h>
#include <avr/interrupt.h>

int i=0, j=0, k=0;
int state = 0;

char row[] = {1, 2, 4, 8, 16, 32, 64, 128};
char column[] = {0x18,0x24,0x42,0x40,0x4e,0x42,0x24,0x18};
	
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
	
   	while(1)
   	{
	   	while(state)
	   	{	
			for(k=0; k<100; k++)							// how fast the shifting would be
		   	{
		   		PORTA = row[i];
		   		PORTB = ~(leftRotate(column[i], j));	
		   		_delay_ms(2);
				   	
		   		i++;
				   	
		   		if(i>7)
		   			i = 0;
	   		}

			j++;
			if(j>7)
				j = 0;
	   		_delay_ms(50);
		}
		
		PORTA = row[i];
		PORTB =	 ~(leftRotate(column[i], j));
		_delay_ms(2);
		
		i++;
		if(i>7)
			i = 0;
   	}
}