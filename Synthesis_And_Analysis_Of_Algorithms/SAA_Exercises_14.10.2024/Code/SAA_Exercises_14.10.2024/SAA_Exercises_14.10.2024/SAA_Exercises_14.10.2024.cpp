#include <iostream>
#include <cmath>
#include <corecrt_math_defines.h>
#include <sstream>
#include <vector>

// Design an algorithm that finds the product of only those elements of a one-dimensional
// array that are part of pairs whose sum of elements is not greater than 12.  
double FindProductOfAdjacentElements(const std::vector<int>& arr) {
    double finalProduct = 1;
    bool foundPair = false; 

    for (size_t i = 0; i < arr.size() - 1; ++i) {
        if (arr[i] + arr[i + 1] <= 12) {
            finalProduct *= arr[i] * arr[i + 1];
            foundPair = true; 
        }
    }

    // If no pairs meåt the condition, return 0
    return foundPair ? finalProduct : 0;
}

// Design an algorithm that finds the number of blocks in a one-dimensional array. 
// A block is a sequence of two or more identical elements. 
double FindBlocksCount(const std::vector<int>& arr) {
    int blocksCount = 0;

    for (size_t i = 0; i < arr.size() - 1; ++i) {
        if (arr[i] == arr[i + 1]) {
            blocksCount++;
        }
    }
    
    return blocksCount;
}

// Design an algorithm that finds the sum of the elements along the perimeter of a two-dimensional array.
double FindSumOfPerimeterElements(std::vector<std::vector<double>> arr) {
    double sum = 0;

    size_t rows = arr.size();
    size_t cols = arr[0].size();

    for (size_t i = 0; i < rows; i++) {
        for (size_t j = 0; j < cols; j++) {
            if (i == 0 || i == rows - 1) {
                // Top or bottom row: add all elements
                sum += arr[i][j];
            }
            else if (j == 0 || j == cols - 1) {
                // Middle rows: add only left and right edge elements
                sum += arr[i][j];
            }
        }
    }

    return sum;
}

// Using a two-dimensional array find the sum of the elements on the main diagonal, 
// the sums of the elements of each row, and the number of elements below the main 
// diagonal with values that are smaller than the sum of their indices. Put all of 
// these results in a one-dimensional array.
void FindSumOfStuff(std::vector<std::vector<double>> arr) {
    std::vector<double> result = {};

    size_t rows = arr.size();
    size_t cols = arr[0].size();

    double sumOfDiagonal = 0;
    double sumOfCurrentRow = 0;
    double countOfElements = 0;

    for (size_t i = 0; i < rows; i++) {
        sumOfCurrentRow = 0;

        for (size_t j = 0; j < cols; j++) {
            // Check for: element is a part of the main diagonal
            if (i == j) {
                sumOfDiagonal += arr[i][j];
            }

            sumOfCurrentRow += arr[i][j];

            // Check for: element is below the main diagonal
            if (j < i) {
                if (arr[i][j] < j + i) {
                    countOfElements++;
                }
            }
        }

        //std::cout << "\nCurrent Row SUM: " << sumOfCurrentRow;
        result.push_back(sumOfCurrentRow);
    }

    //std::cout << "\nMain Diagonal SUM: " << sumOfDiagonal;
    result.push_back(sumOfDiagonal);

    //std::cout << "\nElements COUNT: " << countOfElements;
    result.push_back(countOfElements);

    std::cout << "\nAll of the requested values in one array: ";
    for (size_t i = 0; i < result.size(); i++)
    {
        std::cout << result[i];

        if (i != result.size() - 1)
        {
            std::cout << ", ";
        }
    }
}

// Design an algorithm that finds the sum of the elements on the secondary diagonal of a two-dimensional array.
double FindSumOfSecondaryDiagonal(std::vector<std::vector<double>> arr) {
    double sum = 0;

    size_t rows = arr.size();
    size_t cols = arr[0].size();

    for (size_t i = 0; i < rows; i++) {
        for (size_t j = 0; j < cols; j++) {
            if ((i + j) == (arr.size() - 1)) {
                sum += arr[i][j];
            }
        }
    }

    return sum;
}

int main()
{
	// Task 1
	std::cout << "<=== Task 1 ===>\n";
	std::cout << FindProductOfAdjacentElements({ 5, 3, 10, 8, 2, 7 }) << "\n";
	std::cout << FindProductOfAdjacentElements({ 6, 7, 3, 2 }) << "\n";
	std::cout << FindProductOfAdjacentElements({ 10, 5, 9, 4 }) << "\n";

    // Task 2
    std::cout << "\n<=== Task 2 ===>\n";
    std::cout << FindBlocksCount({ 10, 5, 9, 4 }) << "\n";
    std::cout << FindBlocksCount({ 10, 10, 2, 45 }) << "\n";
    std::cout << FindBlocksCount({ 1, 1, 1, 1, 1, 1, 9, 4 }) << "\n";

    // Task 3
    std::cout << "\n<=== Task 3 ===>\n";
    std::cout << FindSumOfPerimeterElements({
        { 1.1, 2.2, 3.3 },
        { 4.4, 5.5, 6.6 },
        { 7.7, 8.8, 9.9 }
    }) << "\n";
    std::cout << FindSumOfPerimeterElements({
        { 1, 2, 3 },
        { 4, 5, 6 },
        { 7, 8, 9 }
    }) << "\n";
    std::cout << FindSumOfPerimeterElements({
       { 1, 2, 3, 4 }
    }) << "\n";

    // Task 4
    std::cout << "\n<=== Task 4 ===>\n";
    FindSumOfStuff({
        { 1, 2, 3 },
        { 4, 5, 6 },
        { 7, 8, 9 },
    });
    FindSumOfStuff({
        { 3, 3 },
        { 3, 3 },
    });
    FindSumOfStuff({
        { 1, 2, 3, 4 },
        { 5, 6, 7, 8 },
        { 9, 10, 11, 12 },
        { 13, 14, 15, 16 },
    });

    // Task 5
    std::cout << "\n\n<=== Task 5 ===>\n";
    std::cout << FindSumOfSecondaryDiagonal({
        { 1, 2, 3 },
        { 4, 5, 6 },
        { 7, 8, 9 }
    }) << "\n";
    std::cout << FindSumOfSecondaryDiagonal({
        { 4, 5, 1 },
        { 8, 2, 4 },
        { 9, 5, 7 }
    }) << "\n";
    std::cout << FindSumOfSecondaryDiagonal({
        { -23, 12, 43 },
        { 53, -37, -40 },
        { 24, 34, 86 }
    }) << "\n";
}