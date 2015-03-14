#include <u.h>

void
putc(char c)
{
	*(char *)0xb0000000 = c;
}

void
puts(char *s)
{
	while(*s)
		putc(*s++);
}

void
puthex(u32int u)
{
	static char *dig = "0123456789abcdef";
	int i;
	
	for(i = 0; i < 8; i++){
		putc(dig[u >> 28]);
		u <<= 4;
	}
}

void
putdec(int n)
{
	if(n / 10 != 0)
		putdec(n / 10);
	putc(n % 10 + '0');
}

void
print(char *s, ...)
{
	va_list va;
	int n;
	u32int u;
	
	va_start(va, s);
	while(*s)
		if(*s == '%'){
			switch(*++s){
			case 's':
				puts(va_arg(va, char *));
				break;
			case 'x':
				puthex(va_arg(va, u32int));
				break;
			case 'd':
				n = va_arg(va, int);
				if(n < 0){
					putc('-');
					putdec(-n);
				}else
					putdec(n);
				break;
			case 'I':
				u = va_arg(va, u32int);
				putdec(u >> 24);
				putc('.');
				putdec((uchar)(u >> 16));
				putc('.');
				putdec((uchar)(u >> 8));
				putc('.');
				putdec((uchar)u);
				break;
			case 0:
				va_end(va);
				return;
			}
			s++;
		}else
			putc(*s++);			
	va_end(va);
}

void
main(void)
{
}
