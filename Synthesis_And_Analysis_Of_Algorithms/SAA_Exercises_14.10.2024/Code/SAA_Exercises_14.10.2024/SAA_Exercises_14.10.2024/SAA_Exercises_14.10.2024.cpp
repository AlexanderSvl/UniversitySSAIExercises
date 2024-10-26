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

    // If no pairs met the condition, return 0
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

int main()
{
	// Task 1
	std::cout << "<=== Task 1 ===>\n";
	std::cout << FindProductOfAdjacentElements({ 5, 3, 10, 8, 2, 7 }) << "\n";
	std::cout << FindProductOfAdjacentElements({ 6, 7, 3, 2 }) << "\n";
	std::cout << FindProductOfAdjacentElements({ 10, 5, 9, 4 }) << "\n";

    // Task 2
    std::cout << "\n<=== Task 2 == = >\n";
    std::cout << FindBlocksCount({ 10, 5, 9, 4 }) << "\n";
    std::cout << FindBlocksCount({ 10, 10, 2, 45 }) << "\n";
    std::cout << FindBlocksCount({ 1, 1, 1, 1, 1, 1, 9, 4 }) << "\n";
}