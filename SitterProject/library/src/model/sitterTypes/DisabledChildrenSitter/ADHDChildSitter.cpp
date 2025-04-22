#include <sstream>
#include <iomanip>
#include "../../../include/model/sitterTypes/DisabledChildrenSitter/ADHDChildSitter.h"
#include "exceptions/Exceptions.h"

ADHDChildSitter::ADHDChildSitter(const std::string &name, int minChildAge, int maxChildAge, const std::string &id,
                                 double wage, double bonus) : DisabledChildrenSitter(name, minChildAge, maxChildAge, id,
                                                                                     wage, bonus) {}


std::string ADHDChildSitter::getInfo(){
    std::stringstream info;
    if(this->getHealthyChildrenSitters() == nullptr) {
        info << Sitter::getInfo() << "Bonus: "<<std::fixed<<std::setprecision(2)<<getBonus()<<"\n";
        return ("ADHD Children " + info.str());
    }
    else {
        throw ParametrException("Healthy Children can't be Disabled!");
    }
}

