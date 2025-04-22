#ifndef WARSZTATY_SITTERREPOSITORY_H
#define WARSZTATY_SITTERREPOSITORY_H

#include "model/Sitter.h"

                //DODAWANIE I USUWANIE OPIEKUNEK

class SitterRepository{
public:
    void addSitter(SitterPtr sitter, std::vector <SitterPtr> &sitters);
    void removeSitter(SitterPtr sitter, std::vector <SitterPtr> &sitters);
};

#endif //WARSZTATY_SITTERREPOSITORY_H

