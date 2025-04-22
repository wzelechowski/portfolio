#include <sstream>
#include <iostream>
#include "model/Reservation.h"
#include "exceptions/Exceptions.h"

namespace ReservationSpace{
    std::ostream& operator<<(std::ostream& os, const Month& month) {
        switch (month) {
            case January:
                os << "January";
                break;
            case February:
                os << "February";
                break;
            case March:
                os << "March";
                break;
            case April:
                os << "April";
                break;
            case May:
                os << "May";
                break;
            case June:
                os << "June";
                break;
            case July:
                os << "July";
                break;
            case August:
                os << "August";
                break;
            case September:
                os << "September";
                break;
            case October:
                os << "October";
                break;
            case November:
                os << "November";
                break;
            case December:
                os << "December";
                break;
        }
        return os;
    }
}


Reservation::Reservation(int day, Month month, int startHour, int endHour, const std::string &id) : day(day),
                                                                                                  month(month),
                                                                                                  startHour(startHour),
                                                                                                  endHour(endHour),
                                                                                                  id(id) {
    if(day < 1 || day >31) {
        throw ParametrException("Wrong date!");
    }
    if(startHour < 8 || startHour > 20) {
        throw ParametrException("Our rental is closed in this time!");
    }
    if (endHour < 8 || endHour > 21) {
        throw ParametrException("Our rental is closed in this time!");
    }
    if(id.empty()) {
        throw ParametrException("Reservation have to get an ID!");
    }
}

int Reservation::getDay() const {
    return day;
}

Month Reservation::getMonth() const {
    return month;
}

int Reservation::getStartHour() const {
    return startHour;
}

int Reservation::getEndHour() const {
    return endHour;
}

const std::string &Reservation::getId() const {
    return id;
}

void Reservation::setDay(int day) {
    Reservation::day = day;
}

void Reservation::setMonth(Month month) {
    Reservation::month = month;
}

void Reservation::setStartHour(int startHour) {
    Reservation::startHour = startHour;
}

void Reservation::setEndHour(int endHour) {
    Reservation::endHour = endHour;
}

int Reservation::countHours() const{
    int count = endHour - startHour;
    return count;
}

std::string Reservation::getInfo() const {
    std::stringstream info;
    info << "Reservation\n" << "ID: "<< getId() << "\nDay: "<< getDay()<<"\nMonth: "<< getMonth()<<"\nStart Hour: "
    <<getStartHour()<<"\nEnd Hour: "<<getEndHour()<<"\nCount of Hours: "<<countHours()<<"\n";
    return info.str();
}
std::string Reservation::getInfoForFile() const {
    std::stringstream info;
    info << "ID: "<< getId() << "\nDay: "<< getDay()<<"\nMonth: "<< getMonth()<<"\nStart Hour: "
         <<getStartHour()<<"\nEnd Hour: "<<getEndHour()<<"\n";
    return info.str();
}

const SitterPtr &Reservation::getSitter() const {
    return sitters;
}

void Reservation::setSitter(const SitterPtr &sitter) {
    Reservation::sitters = sitter;
}

double Reservation::getReservationCost() {
    if(this->getSitter()==nullptr) {
        throw ParametrException("Sitter doesn't get a reservation yet!");
    }
        return (this->getSitter()->totalCost() * double(countHours()));
}

