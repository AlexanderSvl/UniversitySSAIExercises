#include "Customer.h";
#include <iostream>

void Customer::printInfo() const {
	std::cout << "\nCustomer ID: " << ID << "\nCustomer name: " << name
		<< "\nCustomer account number: " << accountNumber << "\nCustomer account amount: " << accountAmount << "\nCustomer SSN: " << SSN <<  std::endl;
}