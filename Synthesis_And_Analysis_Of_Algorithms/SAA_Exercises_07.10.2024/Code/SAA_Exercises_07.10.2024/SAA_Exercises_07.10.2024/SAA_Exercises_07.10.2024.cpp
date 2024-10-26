#include <iostream>
#include <cmath>
#include <corecrt_math_defines.h>
#include <sstream>
#include <vector>

// Design an algorithm that finds the sum of the digits of a natural three-digit number
int SumOfDigits(int number)
{
    int sum = 0;

    while (number != 0) {
        sum = sum + number % 10;
        number /= 10;
    }

    return sum;
}

// Design an algorithm that swaps the values of two variables (natural numbers) by addition 
void SwapValuesByAddition(int a, int b) {
    std::cout << "A (before): " << a << "; B (before): " << b << "\n";

    a = a + b;
    b = a - b;
    a = a - b;

    std::cout << "A (after): " << a << "; B (after): " << b << "\n";
}

// Write a program that finds the perimeter of a triangle using 
// the law of sines, when two angles and a side are known.
double FindTrianglePerimeter(double firstAngle, double secondAngle, double a) {
    double A_rad = firstAngle * M_PI / 180.0;
    double B_rad = secondAngle * M_PI / 180.0;

    double thirdAngle = 180.0 - firstAngle - secondAngle;
    double C_rad = thirdAngle * M_PI / 180.0;

    double b = a * (sin(B_rad) / sin(A_rad));
    double c = a * (sin(C_rad) / sin(A_rad));

    return std::ceil((a + b + c) * 100.0) / 100.0;;
}

// Write a program to determine if a given year is a leap year 
// (Hint: The extra leap day occurs in each year that is a multiple of 4, 
// except for years evenly divisible by 100 but not by 400.)
std::string FindIfYearIsALeapYear(int year) {
    std::stringstream ss;
    ss << "The year " << year << (year % 4 == 0 && (year % 100 != 0 || year % 400 == 0) 
        ? " is a leap year." 
        : " is not a leap year.");

    return ss.str();
}

// Rewrite the program in Task 1 so that it finds the sum of the digits
// of a natural number with an arbitrary number of digits.
int SumOfDigitsSecondVersion(int number) {
    int sum = 0;

    while (number != 0) {
        sum += number % 10;  
        number /= 10;       
    }

    return sum;
}

// Design an algorithm that counts the number of pairs of adjacent elements 
// in which the two elements have different signs.
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
    // The values for each algorithm are hardcoded for ease of visualization of the algorithms. 
    // Of course, th values can be read from the console at request using cin.

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
    std::cout << "<=== Task 1 ===>\n";
    std::cout << SumOfDigitsSecondVersion(562) << "\n";
    std::cout << SumOfDigitsSecondVersion(1245) << "\n";
    std::cout << SumOfDigitsSecondVersion(56321) << "\n";

    // Task 6
    std::cout << "\n\n<=== Task 5 ===>\n";
    std::cout << "Number of adjacent pairs with different signs: "  
        << CountDifferentSignPairs({ -3, 5, -7, 8, -10 }) << "\n";
    std::cout << "Number of adjacent pairs with different signs: "  
        << CountDifferentSignPairs({ 2, 3, -7, -3, 210, -34 }) << "\n";
    std::cout << "Number of adjacent pairs with different signs: " 
        << CountDifferentSignPairs({ -3, -3, -3, 5, 3, -4, 3 }) << "\n";
}

