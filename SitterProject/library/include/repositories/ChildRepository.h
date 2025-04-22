#ifndef WARSZTATY_CHILDREPOSITORY_H
#define WARSZTATY_CHILDREPOSITORY_H

#include <vector>
#include "model/Child.h"

                        //DODAWANIE I USUWANIE DZIECI

class ChildRepository {
public:
    void addChild(ChildPtr child, std::vector<ChildPtr> &children);
    void removeChild(ChildPtr child, std::vector<ChildPtr> &children);
};

#endif //WARSZTATY_CHILDREPOSITORY_H


