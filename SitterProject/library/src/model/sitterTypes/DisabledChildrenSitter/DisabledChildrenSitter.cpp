#include <sstream>
#include <iomanip>
#include "../../../include/model/sitterTypes/DisabledChildrenSitter/DisabledChildrenSitter.h"
#include "exceptions/Exceptions.h"

DisabledChildrenSitter::DisabledChildrenSitter(const std::string &name, int minChildAge, int maxChildAge,
                                               const std::string &id, double wage, double bonus) : Sitter(name,
                                                                                                          minChildAge,
                                                                                                          maxChildAge,
                                                                                                          id, wage),
                                                                                                   bonus(bonus) {}

std::string DisabledChildrenSitter::getInfo(){
    std::stringstream info;
    if(this->getHealthyChildrenSitters()==nullptr) {
        info << Sitter::getInfo() << "Bonus: "<<std::fixed<<std::setprecision(2)<<getBonus()<<"\n";
        return ("Disabled Children " + info.str())+"\n";
    }
    else {
        throw ParametrException("Healthy Children can't be Disabled!");
    }
}

double DisabledChildrenSitter::totalCost() {
    if(this->getHealthyChildrenSitters()==nullptr) {
        return (getWage() * getBonus());
    }
    else {
        throw ParametrException("Healthy Children can't be Disabled!");
    }
}

double DisabledChildrenSitter::getBonus() const {
    return bonus;
}

void DisabledChildrenSitter::setBonus(double bonus) {
    DisabledChildrenSitter::bonus = bonus;
}



