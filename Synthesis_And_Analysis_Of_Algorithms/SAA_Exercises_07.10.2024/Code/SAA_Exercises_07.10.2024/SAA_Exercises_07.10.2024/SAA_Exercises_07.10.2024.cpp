#include <iostream>
#include <cmath>
#include <corecrt_math_defines.h>
#include <sstream>
#include <vector>

int SumOfDigits(int number)
{
    int sum = 0;

    while (number != 0) {
        sum = sum + number % 10;
        number /= 10;
    }

    return sum;
}

void SwapValuesByAddition(int a, int b) {
    std::cout << "A (before): " << a << "; B (before): " << b << "\n";

    a = a + b;
    b = a - b;
    a = a - b;

    std::cout << "A (after): " << a << "; B (after): " << b << "\n";
}

double FindTrianglePerimeter(double firstAngle, double secondAngle, double a) {
    double A_rad = firstAngle * M_PI / 180.0;
    double B_rad = secondAngle * M_PI / 180.0;

    double thirdAngle = 180.0 - firstAngle - secondAngle;
    double C_rad = thirdAngle * M_PI / 180.0;

    double b = a * (sin(B_rad) / sin(A_rad));
    double c = a * (sin(C_rad) / sin(A_rad));

    return std::ceil((a + b + c) * 100.0) / 100.0;;
}

std::string FindIfYearIsALeapYear(int year) {
    std::stringstream ss;
    ss << "The year " << year << (year % 4 == 0 && (year % 100 != 0 || year % 400 == 0) 
        ? " is a leap year." 
        : " is not a leap year.");

    return ss.str();
}

int SumOfDigitsSecondVersion(int number) {
    int sum = 0;

    while (number != 0) {
        sum += number % 10;  // Add the last digit to sum
        number /= 10;        // Remove the last digit from the number
    }

    return sum;
}

int CountDifferentSignPairs(const std::vector<int>& arr) {
    int count = 0;

    for (size_t i = 0; i < arr.size() - 1; ++i) {
        if ((arr[i] < 0 && arr[i + 1] > 0) || (arr[i] > 0 && arr[i + 1] < 0)) {
            count++;  
        }
    }

    return count;
}

int main()
{
    std::cout.precision(4);

    // Task 1
    std::cout << "<=== Task 1 ===>\n";
    std::cout << SumOfDigits(562) << "\n";
    std::cout << SumOfDigits(1245) << "\n";
    std::cout << SumOfDigits(56321) << "\n";

    // Task 2
    std::cout << "\n\n<=== Task 2 ===>\n";
    SwapValuesByAddition(4, 7);
    SwapValuesByAddition(31, 24);
    SwapValuesByAddition(712, 421);

    // Task 3
    std::cout << "\n\n<=== Task 3 ===>\n";
    std::cout << FindTrianglePerimeter(30, 45, 5) << "\n";
    std::cout << FindTrianglePerimeter(60, 60, 10) << "\n";
    std::cout << FindTrianglePerimeter(45, 45, 8) << "\n";

    // Task 4
    std::cout << "\n\n<=== Task 4 ===>\n";
    std::cout << FindIfYearIsALeapYear(2023) << "\n";
    std::cout << FindIfYearIsALeapYear(1002) << "\n";
    std::cout << FindIfYearIsALeapYear(2000) << "\n";

    // Task 5
    std::cout << "\n\n<=== Task 5 ===>\n";
    std::cout << "Number of adjacent pairs with different signs: "  
        << CountDifferentSignPairs({ -3, 5, -7, 8, -10 }) << "\n";
    std::cout << "Number of adjacent pairs with different signs: "  
        << CountDifferentSignPairs({ 2, 3, -7, -3, 210, -34 }) << "\n";
    std::cout << "Number of adjacent pairs with different signs: " 
        << CountDifferentSignPairs({ -3, -3, -3, 5, 3, -4, 3 }) << "\n";
}

