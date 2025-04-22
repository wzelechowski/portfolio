#ifndef WARSZTATY_DISABLEDCHILDRENSITTER_H
#define WARSZTATY_DISABLEDCHILDRENSITTER_H

#include "model/Sitter.h"

class DisabledChildrenSitter : public Sitter {
    double bonus;
public:
            //KONSTRUKTOR I DEKONSTRUKTOR
    DisabledChildrenSitter(const std::string &name, int minChildAge, int maxChildAge, const std::string &id,
                           double wage, double bonus);
    virtual ~DisabledChildrenSitter()=default;

            //METODY
    virtual double totalCost() override;

            //GETTERY
    virtual std::string getInfo() override;
    double getBonus() const;

            //SETTERY
    void setBonus(double bonus);
};

#endif //WARSZTATY_DISABLEDCHILDRENSITTER_H


