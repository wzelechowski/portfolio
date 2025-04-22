#include "model/sitterTypes/HealthyChildrenSitter/BabySitter.h"
#include <string>
#include <sstream>
#include "exceptions/Exceptions.h"

BabySitter::BabySitter(double bonus) : bonus(bonus) {
}

std::string BabySitter::getInfo() const {
    std::stringstream info;
    info <<"Baby Sitter\n";
    return info.str();
}

double BabySitter::totalCost(int minChildAge, int maxChildAge) {
    if(minChildAge>3) {
        throw ParametrException("Baby Sitter is for children below 4 year old!");
    }
    else {
        return getBonus();
    }
}

double BabySitter::getBonus() const {
    return bonus;
}

void BabySitter::setBonus(double bonus) {
    BabySitter::bonus = bonus;
}


