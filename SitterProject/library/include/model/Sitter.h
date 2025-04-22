#ifndef WARSZTATY_SITTER_H
#define WARSZTATY_SITTER_H

#include <string>
#include <memory>
#include <vector>
#include <fstream>
#include "HealthyChildrenSitter/HealthyChildrenSitter.h"
#include "Reservation.h"

class HealthyChildrenSitter;
typedef std::shared_ptr <HealthyChildrenSitter> TypePtr;

class Sitter {
    std::string name;
    int minChildAge;
    int maxChildAge;
    std::string id;
    double wage;
    TypePtr healthyChildrenSitters;
public:
    //KONSTRUKTORY DESTRUKTORY
    Sitter(const std::string &name, int minChildAge, int maxChildAge, const std::string &id, double wage);
    virtual ~Sitter()=default;

            //GETTERY
    const std::string &getName() const;
    const std::string &getId() const;
    double getWage() const;
    int getMinChildAge() const;
    int getMaxChildAge() const;
    virtual double totalCost();
    virtual std::string getInfo();
    const TypePtr &getHealthyChildrenSitters() const;

    //SETTERY
    void setMinChildAge(int minChildAge);
    void setMaxChildAge(int maxChildAge);
    void setHealthyChildrenSitters(const TypePtr &healthyChildrenSitters);
};
typedef std::shared_ptr <Sitter> SitterPtr;

#endif //WARSZTATY_SITTER_H



