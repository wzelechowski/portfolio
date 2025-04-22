#ifndef WARSZTATY_RESERVATIONREPOSITORY_H
#define WARSZTATY_RESERVATIONREPOSITORY_H

#include <vector>
#include "model/Reservation.h"

                //DODAWANIE I USUWANIE REZERWACJI

class ReservationRepository {
public:
    void addReservation(ReservationPtr reservation, std::vector<ReservationPtr> &reservations);
    void removeReservation(ReservationPtr reservation, std::vector<ReservationPtr> &reservations);
};
#endif //WARSZTATY_RESERVATIONREPOSITORY_H


