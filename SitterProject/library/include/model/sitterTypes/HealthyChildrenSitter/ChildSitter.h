#ifndef WARSZTATY_CHILDSITTER_H
#define WARSZTATY_CHILDSITTER_H

#include "HealthyChildrenSitter.h"

class ChildSitter : public HealthyChildrenSitter{
public:
            //KONSTRUKTOR I DEKONSTRUKTOR
    ChildSitter();
    virtual ~ChildSitter() = default;

            //GETTERY
    virtual std::string getInfo()const override ;
    virtual double totalCost(int minChildAge, int maxChildAge)override;
};

#endif //WARSZTATY_CHILDSITTER_H


