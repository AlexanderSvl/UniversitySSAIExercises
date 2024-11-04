#include <iostream>
#include <cmath>
#include <corecrt_math_defines.h>
#include <sstream>
#include <vector>

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
void CountSymmetricDiagonalElements(std::vector<std::vector<double>> arr) {
    size_t rows = arr.size();
    size_t cols = arr[0].size();

    for (size_t i = 0; i < rows; i++) {
        for (size_t j = 0; j < cols; j++) {
            // Check for: element is above the main diagonal
            if (j > i) {
                 
            }
            std::cout << "i: " << i << " j: " << j << "\n";

            if (i == reverseDigits(j)) {
                std::cout << "RR i: " << i << " j: " << j << "\n";
            }
        }
    }
}

int main() {
    CountSymmetricDiagonalElements({
        { 1, 2, 3 },
        { 4, 5, 6 },
        { 7, 8, 9 }
    });
}

