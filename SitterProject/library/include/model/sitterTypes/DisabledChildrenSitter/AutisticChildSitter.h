#ifndef WARSZTATY_AUTISTICCHILDSITTER_H
#define WARSZTATY_AUTISTICCHILDSITTER_H

#include "DisabledChildrenSitter.h"

class AutisticChildSitter : public DisabledChildrenSitter {
public:
            //KONSTRUKTOR I DEKONSTRUKTOR
    AutisticChildSitter(const std::string &name, int minChildAge, int maxChildAge, const std::string &id, double wage,
                        double bonus);
    virtual ~AutisticChildSitter() override=default;

            //METODY
    virtual std::string getInfo() override;
};

#endif //WARSZTATY_AUTISTICCHILDSITTER_H


