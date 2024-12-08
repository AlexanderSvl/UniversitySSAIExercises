#include <iostream>
#include <vector>

int GreatestNumber(const std::vector<int>& vec) {
    int greatest = vec[0];

    for (size_t i = 1; i < vec.size(); i++) {
        if (vec[i] > greatest) {
            greatest = vec[i];
        }
    }

    return greatest;
}

void ReverseArray(std::vector<int>& arr) {
    int start = 0;
    int end = arr.size() - 1;

    // Swap elements from both ends of the array
    while (start < end) {
        std::swap(arr[start], arr[end]);
        start++;
        end--;
    }
}

const int num = 6;
int coins[num] = { 50, 20, 10, 5, 2, 1 };

void CountCoins(int sum) {
    int i = 0;
    int j = sum;

    while (j > 0) {
        int coinCount = j / coins[i];  

        if (coinCount > 0) {
            std::cout << "Coin: " << coins[i] << ", number = " << coinCount << std::endl;
        }

        j = j % coins[i];  
        i++;
    }
}

int main() {
    // Task 1
    std::cout << "<=== Task 1 ===>\n";
    std::cout << "Greatest number: " << GreatestNumber({ 1, 3, 2, 8, 4, 9, 5 }) << std::endl;
    std::cout << "Greatest number: " << GreatestNumber({ 4, 8, 12, 43, 54, 2, 23 }) << std::endl;
    std::cout << "Greatest number: " << GreatestNumber({ 1, 453, 3, 2, 53, 3, 21 }) << std::endl;

    // Task 2
    std::cout << "\n<=== Task 2 ===>\n";
    std::vector<int> arr = { 1, 2, 3, 4, 5 };

    std::cout << "Original array: ";
    for (int num : arr) 
    {
        std::cout << num << " ";
    }
    std::cout << std::endl;

    ReverseArray(arr);

    std::cout << "Reversed array: ";
    for (int num : arr) 
    {
        std::cout << num << " ";
    }

    std::cout << std::endl;

    // Task 3
    std::cout << "\n<=== Task 3 ===>\n";
    CountCoins(87);
    CountCoins(42);

    return 0;
}