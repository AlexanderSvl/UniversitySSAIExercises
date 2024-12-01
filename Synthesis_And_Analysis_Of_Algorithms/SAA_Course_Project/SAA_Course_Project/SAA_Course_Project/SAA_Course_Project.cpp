#include <iostream>
#include "Customer.h"
#include <vector>
#include <random>
#include <sstream>

const char* boldCode = "\033[1m";
const char* greenCode = "\033[32m";
const char* redCode = "\033[31m";
const char* resetCode = "\033[0m";

std::string generateID();
int partition(std::vector<Customer>& customers, int low, int high);
void quicksort(std::vector<Customer>& customers, int low, int high);

int main()
{
    std::vector<Customer> customers;

	std::cout << "|======| Bank management system |======|" << std::endl;
	std::cout << "\n  |==|   0 - Exit the program";
	std::cout << "\n  |==|   1 - Add a customer"; 
	std::cout << "\n  |==|   2 - Display all customers";
	std::cout << "\n  |==|   3 - Sort customer data by account amount (DESC) and display the information";
	std::cout << "\n  |==|   4 - Sort customer data by name (ASC) and display the information";
	std::cout << "\n  |==|   5 - Find all customers with more than a given amount of money";

	int option;
	std::cout << redCode << boldCode << "\n\nChoose an option: " << resetCode;
	std::cin >> option;

	while (option != 0) {
		switch (option)
		{
			case 1: {
				std::string ID = generateID();
				std::string name;
				std::string accountID = generateID();
				double accountAmount;
				int SSN;

				std::cout << "\n\Generated customer ID: " << boldCode << greenCode << ID << resetCode;

				std::cout << "\n\nEnter customer full name: ";
				std::cin.ignore();
				std::getline(std::cin, name);

				std::cout << "\nEnter customer account amount: ";
				std::cin >> accountAmount;

				std::cout << "\nEnter customer SSN ( Social Security Number ): ";
				std::cin >> SSN;

				customers.push_back(Customer(ID, name, accountID, accountAmount, SSN));

				break;
			}
			case 2: {
				for (Customer customer : customers) {
					customer.printInfo();
				}

				break; 
			}
			case 3: {
				for (int i = 0; i < customers.size() - 1; i++) {
					for (int j = i + 1; j < customers.size(); j++) {
						if (customers[i].getName() > customers[j].getName()) {
							std::swap(customers[i], customers[j]);
						}
					}
				}

				for (Customer customer : customers) {
					customer.printInfo();
				}

				break; 
			}
			case 4: {
				quicksort(customers, 0, customers.size() - 1);

				for (Customer customer : customers) {
					customer.printInfo();
				}

				break;
			}
			case 5: {
				double salaryToSearchFor;
				std::cout << "\nEnter lower salary limit: ";
				std::cin >> salaryToSearchFor;

				for (Customer customer : customers) {
					if (customer.getAccountAmount() > salaryToSearchFor) {
						customer.printInfo();
					}
				}

				break;
			}
		}

		std::cout << redCode << boldCode << "\n\nChoose an option: " << resetCode;
		std::cin >> option;
	}
	
}

std::string generateID() {
	std::random_device rd;
	std::mt19937 gen(rd());
	std::uniform_int_distribution<> dis(0, 15);

	std::stringstream ss;
	const char* hexChars = "0123456789abcdef";

	for (int i = 0; i < 32; ++i) {
		if (i == 8 || i == 12 || i == 16 || i == 20) {
			ss << "-";
		}
		ss << hexChars[dis(gen)];
	}

	return ss.str();
}

int partition(std::vector<Customer>& customers, int low, int high) {
	std::string pivot = customers[high].getName(); 
	int i = low - 1;

	for (int j = low; j < high; j++) {
		if (customers[j].getName() < pivot) {
			i++;
			std::swap(customers[i], customers[j]);
		}
	}
	std::swap(customers[i + 1], customers[high]);
	return i + 1;
}

void quicksort(std::vector<Customer>& customers, int low, int high) {
	if (low < high) {
		int pi = partition(customers, low, high);  

		quicksort(customers, low, pi - 1);
		quicksort(customers, pi + 1, high);
	}
}