
#include <vector>
#include "managers/ReservationManager.h"
#include "repositories/ReservationRepository.h"
#include "managers/SitterManager.h"
#include "exceptions/Exceptions.h"
#include "model/Reservation.h"

bool ReservationManager::createReservation(std::vector<SitterPtr> sitters, ReservationPtr reservation) {
    ReservationRepository rep;
    rep.addReservation(reservation, reservations);
    SitterManager s;
    std::vector<ReservationPtr> res;
    for (int i = 0; i < sitters.size(); i++) {
        res = s.getAllSitterReservations(sitters[i], reservations);
        if (res.size() == 0) {
            reservation->setSitter(sitters[i]);
            return true;
        }

        bool flag = true;

        for (int j = 0; j < res.size(); j++) {
            if (reservation->getMonth() == res[j]->getMonth()) {
                if (reservation->getDay() == res[j]->getDay()) {
                    if ((reservation->getStartHour() < res[j]->getStartHour() && reservation->getEndHour() < res[j]->getStartHour()) ||
                        (reservation->getStartHour() > res[j]->getEndHour() && reservation->getEndHour() > res[j]->getEndHour()))
                        flag = true;
                    else {
                        flag = false;
                        break;
                    }
                }

            }
        }
        if (flag == true) {
            reservation->setSitter(sitters[i]);
            return true;
        }
    }

    rep.removeReservation(reservation, reservations);
    throw NoAvailableException("No available sitterTypes. Reservation has been cancelled.");
}


int ReservationManager::countReservations() {
    return reservations.size();
}

void ReservationManager::saveReservation(ReservationPtr reservation) {
    std::ofstream reservationSave;
    reservationSave.open("../../program/saves/reservationStatus",std::ios_base::app);            //app - dopisujemy do pliku
    if (reservationSave.good() != true){
        reservationSave.close();
        throw FileException("File not found!");
    }
    else{
        reservationSave << reservation->getInfoForFile() << std::endl;
    }
    reservationSave.close();
}

void ReservationManager::loadReservations(ReservationRepository &reservationR) {
    std::ifstream reservationLoad;
    reservationLoad.open("../../program/saves/reservationStatus", std::ios_base::in);
    if (reservationLoad.good() != true){
        reservationLoad.close();
        throw FileException("File not found!");
    }
    else {
        std::string line;
        int day, startHour, endHour;
        std::string id;
        Month month = January;
        while (getline(reservationLoad, line)){
            size_t colonPos = line.find(":");
            if (colonPos != std::string::npos) {
                std::string variable = line.substr(0,colonPos);
                std::string value = line.substr(colonPos + 2);
                if (variable == "ID") {
                    id = value;
                }
                else if(variable == "Day"){
                    day = stoi(value);
                }
                else if(variable == "Month"){
                    if(value == "January"){
                        month = January;
                    }
                    else if(value == "February"){
                        month = February;
                    }
                    else if(value == "March"){
                        month = March;
                    }
                    else if(value == "April"){
                        month = April;
                    }
                    else if(value == "May"){
                        month = May;
                    }
                    else if(value == "June"){
                        month = June;
                    }
                    else if(value == "July"){
                        month = July;
                    }
                    else if(value == "August"){
                        month = August;
                    }
                    else if(value == "September"){
                        month = September;
                    }
                    else if(value == "October"){
                        month = October;
                    }
                    else if(value == "November"){
                        month = November;
                    }
                    else if(value == "December"){
                        month = December;
                    }
                }
                else if(variable == "Start Hour"){
                    startHour = stoi(value);
                }
                else if(variable == "End Hour"){
                    endHour = stoi(value);
                }
            }
        }
        ReservationPtr reservation = std::make_shared<Reservation>(day,month,startHour,endHour,id);
        reservationR.addReservation(reservation,this->reservations);
    }
    reservationLoad.close();
}

std::string ReservationManager::findReservation(std::string id) {
    for (int i = 0; i < reservations.size(); i++) {
        if (reservations[i]->getId() == id) {
            //std::cout << reservations[i]->getInfo() << std::endl;
            return reservations[i]->getInfo();
        }
    }
    throw NoAvailableException("Reservation not found!");
}


