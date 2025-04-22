#include <sstream>
#include <iomanip>
#include "exceptions/Exceptions.h"
#include "DisabledChildrenSitter/DownSyndromeChildrenSitter.h"

DownSyndromeChildrenSitter::DownSyndromeChildrenSitter(const std::string &name, int minChildAge, int maxChildAge,
                                                       const std::string &id, double wage, double bonus)
        : DisabledChildrenSitter(name, minChildAge, maxChildAge, id, wage, bonus) {}


std::string DownSyndromeChildrenSitter::getInfo(){
    std::stringstream info;
    if(this->getHealthyChildrenSitters()== nullptr) {
        info << Sitter::getInfo() << "Bonus: "<<std::fixed<<std::setprecision(2)<<getBonus()<<"\n";
        return ("Down Syndrome Children " + info.str());
    }
    else {
        throw ParametrException("Healthy Children can't be Disabled!");
    }
}

