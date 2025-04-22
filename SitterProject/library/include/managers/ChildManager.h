#ifndef WARSZTATY_CHILDMANAGER_H
#define WARSZTATY_CHILDMANAGER_H

#include "model/Child.h"
#include "model/Reservation.h"
#include "repositories/ChildRepository.h"

class ChildManager{
public:
    std::vector <ChildPtr> children;

    bool checkChild(ChildPtr child);        //sprawdza czy dziecko jest juz w bazie
    int countChildren();                    //zliczanie ilości dzieci
    std::string findChild(std::string id);

            //SAVE + LOAD
    void saveChild(ChildPtr child);
    void loadChildren(ChildRepository& childrenR);
};

#endif //WARSZTATY_CHILDMANAGER_H

