#include "model/sitterTypes/HealthyChildrenSitter/ChildSitter.h"
#include <string>
#include <sstream>
#include "exceptions/Exceptions.h"
#include "model/Sitter.h"

ChildSitter::ChildSitter() {}

std::string ChildSitter::getInfo() const {
        std::stringstream info;
        info <<"Child Sitter\n";
        return info.str();
    }

double ChildSitter::totalCost(int minChildAge, int maxChildAge){
    if(maxChildAge<4){
        throw ParametrException("Child Sitter is for children above 4 years old!");
    }
    else{
        return 1.0;
    }
}