#ifndef WARSZTATY_RESERVATIONMANAGER_H
#define WARSZTATY_RESERVATIONMANAGER_H

#include "model/Sitter.h"
#include "model/Reservation.h"
#include "repositories/ReservationRepository.h"
#include <memory>

class ReservationManager{
public:
    std::vector <ReservationPtr> reservations;

    bool createReservation(std::vector <SitterPtr> sitters, ReservationPtr reservation);
    int countReservations();

    std::string findReservation(std::string id);

            //SAVE + LOAD
    void saveReservation(ReservationPtr reservation);
    void loadReservations(ReservationRepository& reservationR);
};

#endif //WARSZTATY_RESERVATIONMANAGER_H


