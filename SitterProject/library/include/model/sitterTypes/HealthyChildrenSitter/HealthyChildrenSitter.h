#ifndef WARSZTATY_HEALTHYCHILDRENSITTER_H
#define WARSZTATY_HEALTHYCHILDRENSITTER_H

#include <string>
#include <memory>
#include "model/Reservation.h"

class HealthyChildrenSitter{
public:
    virtual double totalCost(int minChildAge, int maxChildAge)=0;
    virtual ~HealthyChildrenSitter()=default;

            //GETTERY
    virtual std::string getInfo()const=0;
};

#endif //WARSZTATY_HEALTHYCHILDRENSITTER_H

