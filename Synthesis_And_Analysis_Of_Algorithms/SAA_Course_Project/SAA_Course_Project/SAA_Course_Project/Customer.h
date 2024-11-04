#pragma once

#ifndef CONTRACT_H
#define CONTRACT_H

#include <string>

class Customer {
public:
    Customer(std::string _id, std::string _name, std::string _accountNumber, double _accountAmount, int _SSN);

    // Getter functions
    std::string getID() const { return ID; }
    std::string getName() const { return name; }
    std::string getAccountNumber() const { return accountNumber; }
    double getAccountAmount() const { return accountAmount; }
    int getSSN() const { return SSN; }

    // Setter functions
    void setName(std::string newName) { name = newName; }
    void setAccountAmount(int newAccountAmount) { accountAmount = newAccountAmount; }

    // Other functions
    void printInfo() const;

    ~Customer() = default;

private:
    std::string ID;             
    std::string name;
    std::string accountNumber;   
    double accountAmount;
    int SSN;                     
};

// Constructor definition
inline Customer::Customer(std::string _id, std::string _name, std::string _accountNumber, double _accountAmount, int _SSN)
    : ID(_id), name(_name), accountNumber(_accountNumber), accountAmount(_accountAmount), SSN(_SSN) {}

#endif