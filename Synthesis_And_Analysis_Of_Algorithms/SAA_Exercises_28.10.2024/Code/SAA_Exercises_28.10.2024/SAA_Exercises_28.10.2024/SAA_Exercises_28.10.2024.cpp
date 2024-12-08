#include <iostream>
#include <cmath>
#include <corecrt_math_defines.h>
#include <sstream>
#include <vector>

// Function to calculate the total number of characters in an array of strings using recursion.
int TotalCharactersRecursive(const std::vector<std::string>& arr) {
    if (arr.empty()) {
        return 0;
    }

    std::string firstElement = arr[0];
    std::vector<std::string> remainingElements(arr.begin() + 1, arr.end());

    return firstElement.size() + TotalCharactersRecursive(remainingElements);
}

// Function to calculate the Nth triangular number using recursion.
int TriangularNumberRecursive(int n) {
    if (n == 1) {
        return 1;
    }
    return n + TriangularNumberRecursive(n - 1);
}

// Function to find the first index of 'x' in a string using recursion.
int FirstIndexOfXRecursive(const std::string& str, int index = 0) {
    if (index >= str.size()) {
        return -1; // 'x' not found (should never happen based on problem constraints)
    }

    if (str[index] == 'x') {
        return index;
    }

    return FirstIndexOfXRecursive(str, index + 1);
}

// Function to calculate the number of unique paths in a grid using recursion.
int UniquePathsRecursive(int rows, int cols) {
    if (rows == 1 || cols == 1) {
        return 1;
    }

    return UniquePathsRecursive(rows - 1, cols) + UniquePathsRecursive(rows, cols - 1);
}

int main() {
    // Task 1
    std::cout << "<=== Task 1 ===>\n";
    std::cout << TotalCharactersRecursive({ "ab", "c", "def", "ghij" }) << std::endl;
    std::cout << TotalCharactersRecursive({ "hello", "world" }) << std::endl; 
    std::cout << TotalCharactersRecursive({ "a", "bb", "ccc", "dddd" }) << std::endl; 

    // Task 2
    std::cout << "\n<=== Task 2 ===>\n";
    std::cout << TriangularNumberRecursive(7) << std::endl; 
    std::cout << TriangularNumberRecursive(5) << std::endl; 
    std::cout << TriangularNumberRecursive(10) << std::endl; 

    // Task 3
    std::cout << "\n<=== Task 3 ===>\n";
    std::cout << FirstIndexOfXRecursive("abcdefghijklmnopqrstuvwxyz") << std::endl;
    std::cout << FirstIndexOfXRecursive("xabc") << std::endl;
    std::cout << FirstIndexOfXRecursive("abcx") << std::endl; 

    // Task 4
    std::cout << "\n<=== Task 4 ===>\n";
    std::cout << UniquePathsRecursive(3, 7) << std::endl; 
    std::cout << UniquePathsRecursive(2, 2) << std::endl; 
    std::cout << UniquePathsRecursive(3, 3) << std::endl; 

    return 0;
}