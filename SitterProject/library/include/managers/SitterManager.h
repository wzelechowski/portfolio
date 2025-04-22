#ifndef WARSZTATY_SITTERMANAGER_H
#define WARSZTATY_SITTERMANAGER_H

#include "model/Sitter.h"
#include "model/Reservation.h"
#include "repositories/SitterRepository.h"

class Sitter;
typedef std::shared_ptr<Sitter>SitterPtr;

class Reservation;
typedef std::shared_ptr<Reservation>ReservationPtr;

class SitterManager{
public:
    std::vector <SitterPtr> sitters;

    std::vector <ReservationPtr> getAllSitterReservations(SitterPtr sitter, std::vector <ReservationPtr> reservations);
    bool checkSitter(SitterPtr sitter);     //sprawdza czy opiekunka jest juz w bazie
    int countSitters();                     //zliczanie istniejacych opiekunek
    std::string findSitter(std::string id);
            //SAVE + LOAD
    void saveSitter(SitterPtr sitter);
    void loadSitter(SitterRepository& sitterR);

};

#endif //WARSZTATY_SITTERMANAGER_H

