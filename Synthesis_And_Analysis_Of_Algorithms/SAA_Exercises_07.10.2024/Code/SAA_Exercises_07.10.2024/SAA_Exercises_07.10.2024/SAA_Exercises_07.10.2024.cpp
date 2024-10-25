#include <iostream>

int SumOfDigits(int number)
{
    int sum = 0;

    while (number != 0) {
        sum = sum + number % 10;
        number /= 10;
    }

    return sum;
}

int main()
{
    // Task 1
    std::cout << SumOfDigits(562) << "\n";
    std::cout << SumOfDigits(1245) << "\n";
    std::cout << SumOfDigits(56321) << "\n";

    
}