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
	float a;
	char s[] = {'H','e','l','l','o',0};

	__asm {
		finit
		call getFloat
		fadd ST(0), ST(0)
		fstp a
	}
	printFloat(a);
	//_printString(&s[0]);
	return 0;
}