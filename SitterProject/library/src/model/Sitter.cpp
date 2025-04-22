#include "DisabledChildrenSitter/DisabledChildrenSitter.h"
#include "exceptions/Exceptions.h"
#include "model/Sitter.h"

#include <sstream>
#include <iomanip>

Sitter::Sitter(const std::string &name, int minChildAge, int maxChildAge, const std::string &id, double wage) : name(
        name), minChildAge(minChildAge), maxChildAge(maxChildAge), id(id), wage(wage) {
    if(name.empty()){
        throw ParametrException("Sitter have to get a name!");
    }
    if(minChildAge <0){
        throw ParametrException("Child can't be younger than 0!");
    }
    if(maxChildAge < 0){
        throw ParametrException("Child can't be younger than 0!");
    }
    if(id.empty()){
        throw ParametrException("Sitter have to get an ID!");
    }
    if(wage < 0){
        throw ParametrException("Sitter isn't a volunteer!");
    }
}


const std::string &Sitter::getName() const {
    return name;
}

const std::string &Sitter::getId() const {
    return id;
}

double Sitter::getWage() const {
    return wage;
}

int Sitter::getMinChildAge() const {
    return minChildAge;
}

int Sitter::getMaxChildAge() const {
    return maxChildAge;
}


void Sitter::setMinChildAge(int minChildAge) {
    Sitter::minChildAge = minChildAge;
}

void Sitter::setMaxChildAge(int maxChildAge) {
    Sitter::maxChildAge = maxChildAge;
}

double Sitter::totalCost() {
    if(this->getHealthyChildrenSitters() != nullptr)
        return (getWage() * this->getHealthyChildrenSitters()->totalCost(getMinChildAge(), getMaxChildAge()));
    else
        return getWage();
}

std::string Sitter::getInfo() {
    std::stringstream info;
    info << "ID: " << getId() << "\nName: " << getName() << "\nMinimum Child Age: " << getMinChildAge()<<"\nMaximum Child Age: "
    <<getMaxChildAge()<<"\nWage: "<< std::fixed<<std::setprecision(2)<<getWage()<<"\n";

    if(this->getHealthyChildrenSitters() == nullptr){
        std::stringstream total;
        total << "Total Cost: "<<std::fixed<<std::setprecision(2)<<totalCost();
    return ("Sitter\n"+info.str() +total.str()+"\n");
    }
    else{
        std::stringstream total;
        total << "Total Cost: "<<std::fixed<<std::setprecision(2)<<this->getHealthyChildrenSitters()->totalCost(getMinChildAge(),getMaxChildAge());
        return this->getHealthyChildrenSitters()->getInfo()+info.str()+ total.str() + "\n";
    }
}

const TypePtr &Sitter::getHealthyChildrenSitters() const {
    return healthyChildrenSitters;
}

void Sitter::setHealthyChildrenSitters(const TypePtr &healthyChildrenSitters) {
    Sitter::healthyChildrenSitters = healthyChildrenSitters;
}


