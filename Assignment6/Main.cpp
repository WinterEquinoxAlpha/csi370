#include <iostream>
extern "C" void asmMain();

extern "C" int* getInput()
{
	int a[2];
	std::cout << "Input:\nA: ";
	std::cin >> a[0];
	std::cout << "B: ";
	std::cin >> a[1];
	return a;
}

extern "C" void dispOutput(int sum)
{
	std::cout << "A+B: " << sum << std::endl;
}

int main()
{
	asmMain();
	return 0;
}