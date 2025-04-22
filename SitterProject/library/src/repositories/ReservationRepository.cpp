#include "model/Reservation.h"
#include "repositories/ReservationRepository.h"

void ReservationRepository::addReservation(ReservationPtr reservation, std::vector <ReservationPtr> &reservations) {
    reservations.push_back(reservation);

}

void ReservationRepository::removeReservation(ReservationPtr reservation, std::vector <ReservationPtr> &reservations) {
    for (int i=0; i<reservations.size(); i++){
        if(reservations[i]==reservation){
            reservations.erase(reservations.begin()+i);
        }
    }
}

