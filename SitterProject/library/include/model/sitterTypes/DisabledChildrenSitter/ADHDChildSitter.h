#ifndef WARSZTATY_ADHDCHILDSITTER_H
#define WARSZTATY_ADHDCHILDSITTER_H

#include "DisabledChildrenSitter.h"

class ADHDChildSitter : public DisabledChildrenSitter {
public:
                //KONSTRUKTOR I DEKONSTRUKTOR
    ADHDChildSitter(const std::string &name, int minChildAge, int maxChildAge, const std::string &id, double wage,
                    double bonus);
    virtual ~ADHDChildSitter()=default;

                    //METODY
    virtual std::string getInfo() override;

};

#endif //WARSZTATY_ADHDCHILDSITTER_H


