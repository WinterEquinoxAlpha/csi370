#include <iostream>
extern "C" void asmMain();

extern "C" void displaySomething()
{
	std::cout << "Hello" << std::endl;
}

int main()
{
	asmMain();
	return 0;
}