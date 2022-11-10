#include <iostream>
#include <intrin.h>
using namespace std;

float getFloat()
{
	float f;
	cin >> f;
	return f;
}

void printFloat(float f)
{
	cout << f << endl;
	return;
}

void printString(char* s)
{
	cout << s;
	return;
}

int main()
{
	float out;
	char s[] = "Input Float: ";

	__asm {
		// load the input string into eax then push it onto the stack so it can be called by the printString function
		lea eax, s
		push eax
		call printString

		// initialize the FPU
		finit

		// load PI into the FPU stack
		fldpi

		// get a float from the user which is automatically stored on the FPU stack
		call getFloat

		// display the string again then remove the value from the stack as we don't need it anymore
		call printString
		pop eax

		// get another float
		call getFloat

		// perform the arithmetic sqrt((a+b)*pi
		fadd ST(0), ST(1)
		fmul ST(0), ST(2)
		fsqrt

		// save the result to the variable
		fstp out

		// push the result to the stack to pass it into the printFloat function then pop the stack to manage memory
		push out
		call printFloat
		pop out
	}
	return 0;
}