#ifndef WARSZTATY_BABYSITTER_H
#define WARSZTATY_BABYSITTER_H

#include "HealthyChildrenSitter.h"
#include "model/Sitter.h"

class BabySitter : public HealthyChildrenSitter{
    double bonus;

public:
            //KONSTRUKTOR I DEKONSTRUKTOR
    BabySitter(double bonus);
    virtual ~BabySitter()=default;

            //METODY
    double totalCost(int minChildAge, int maxChildAge)override;

            //GETTERY
    double getBonus() const;
    virtual std::string getInfo() const override;

            //SETTERY
    void setBonus(double bonus);
};

#endif //WARSZTATY_BABYSITTER_H


