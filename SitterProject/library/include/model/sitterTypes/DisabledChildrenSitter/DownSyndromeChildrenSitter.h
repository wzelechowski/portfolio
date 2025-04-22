#ifndef WARSZTATY_DOWNSYNDROMECHILDRENSITTER_H
#define WARSZTATY_DOWNSYNDROMECHILDRENSITTER_H

#include "DisabledChildrenSitter.h"

class DownSyndromeChildrenSitter : public DisabledChildrenSitter {
public:
    DownSyndromeChildrenSitter(const std::string &name, int minChildAge, int maxChildAge, const std::string &id,
                               double wage, double bonus);

    virtual ~DownSyndromeChildrenSitter()=default;

    virtual std::string getInfo() override;
};

#endif //WARSZTATY_DOWNSYNDROMECHILDRENSITTER_H


