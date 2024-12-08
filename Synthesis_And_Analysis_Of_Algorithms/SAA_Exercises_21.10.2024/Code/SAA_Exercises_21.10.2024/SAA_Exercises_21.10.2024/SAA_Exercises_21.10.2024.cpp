#include <iostream>
#include <cmath>
#include <corecrt_math_defines.h>
#include <sstream>
#include <vector>

// Helper function for the CountSymmetricDiagonalElements() function.
int reverseDigits(int num)
{
    int rev_num = 0;
    while (num > 0) {
        rev_num = rev_num * 10 + num % 10;
        num = num / 10;
    }
    return rev_num;
}

// Design an algorithm that counts the number of pairs of symmetric 
// (to the main diagonal) elements for which the value of the element 
// above the main diagonal is less than the value of the element below 
// the main diagonal. For example, the following pairs of elements 
// are symmetric about the main diagonal: à10 and à01; à20 and à02;
// à21 and à12; à30 and à03 and so on.
void CountSymmetricDiagonalElements(const std::vector<std::vector<double>>& arr) {
    size_t rows = arr.size();
    size_t cols = arr[0].size();
    int count = 0;

    // Check if the matrix is square, as only square matrices have a main diagonal
    if (rows != cols) {
        std::cout << "Error: The matrix must be square." << std::endl;
        return;
    }

    // Loop through the elements above the main diagonal
    for (size_t i = 0; i < rows; i++) {
        for (size_t j = i + 1; j < cols; j++) { 
            double above = arr[i][j]; 
            double below = arr[j][i]; 

            if (above < below) {
                count++;
            }
        }
    }

    std::cout << "Total count of symmetric pairs where arr[i][j] < arr[j][i]: " << count << std::endl;
}

// Design an algorithm that converts a positive decimal integer to binary using a recursive function. 
int IntegerToBinary(int number) {
    if (number == 0) {
        return 0;
    }
    else {
        return (number % 2 + 10 * (IntegerToBinary(number / 2)));
    }
}

// Design an algorithm that calculates xn (n is an integer) using a recursive function and the following formulas:
// 
//  x^n = x * x^n-1, n > 0
//  x^n = 1, n = 0
//  x^n = 1 / (x * x^n-1), n < 0.

double CalculateExponentRecursive(double base, int exponent) {
    if (exponent == 0) {
        return 1.0;
    }
    // If exponent is positive, we use x^n = x * x^(n-1)
    else if (exponent > 0) {
        return base * CalculateExponentRecursive(base, exponent - 1);
    }
    // If exponent is negative, we use x^n = 1 / (x * x^(-n-1))
    else {
        return 1.0 / (base * CalculateExponentRecursive(base, -exponent - 1));
    }
}

// Design an algorithm that calculates the sum of the elements of a given 
// one - dimensional array using a recursive function.
int SumOfElementsRecursive(std::vector<int> arr) {
    if (arr.empty()) {
        return 0;
    }

    int firstElement = arr[0];
    arr.erase(arr.begin());
    return firstElement + SumOfElementsRecursive(arr);
}

// Design an algorithm that checks for the presence of a given digit in 
// a natural number using a recursive function.
bool IsDigitPresent(int naturalNumber, int digit) {
    if (naturalNumber == 0) {
        return false;
    }

    if (naturalNumber % 10 == digit) {
        return true;
    }

    return IsDigitPresent(naturalNumber / 10, digit);
}


int main() {
    // Task 1
    std::cout << "<=== Task 1 ===>\n";
    CountSymmetricDiagonalElements({
        { 1, 2, 3 },
        { 4, 5, 6 },
        { 7, 8, 9 }
    });

    CountSymmetricDiagonalElements({
        { 1, 5, 9 },
        { 2, 6, 10 },
        { 3, 7, 11 }
    });

    CountSymmetricDiagonalElements({
        { 10, 2, 30 },
        { 20, 50, 5 },
        { 40, 60, 70 }
    });

    // Task 2
    std::cout << "\n<=== Task 2 ===>\n";
    std::cout << IntegerToBinary(318) << std::endl;
    std::cout << IntegerToBinary(230) << std::endl;
    std::cout << IntegerToBinary(1000) << std::endl;

    // Task 3
    std::cout << "\n<=== Task 3 ===>\n";
    std::cout << CalculateExponentRecursive(2.43, 4) << std::endl;
    std::cout << CalculateExponentRecursive(3.12, 2) << std::endl;
    std::cout << CalculateExponentRecursive(9, 2) << std::endl;

    // Task 4
    std::cout << "\n<=== Task 4 ===>\n";
    std::cout << SumOfElementsRecursive({ 4, 3, 5, 6 }) << std::endl;
    std::cout << SumOfElementsRecursive({ 14, 34, 12, 12 }) << std::endl;
    std::cout << SumOfElementsRecursive({ 536, 157, 287, 457 }) << std::endl;

    // Task 5
    std::cout << "\n<=== Task 5 ===>\n";
    std::cout << (IsDigitPresent(12345, 3) ? "True" : "False") << std::endl;
    std::cout << (IsDigitPresent(243002, 7) ? "True" : "False") << std::endl;
    std::cout << (IsDigitPresent(255332, 2) ? "True" : "False") << std::endl;
}

