#ifndef WARSZTATY_RESERVATION_H
#define WARSZTATY_RESERVATION_H

#include <string>
#include <memory>
#include "Sitter.h"
#include "Child.h"
#include "HealthyChildrenSitter/HealthyChildrenSitter.h"
#include <iostream>
#include <ostream>

class Sitter;
typedef std::shared_ptr <Sitter> SitterPtr;

namespace ReservationSpace {
    enum Month {
        January,
        February,
        March,
        April,
        May,
        June,
        July,
        August,
        September,
        October,
        November,
        December
    };
}

using namespace ReservationSpace;

class Reservation {
private:
    int day;
    Month month;
    int startHour;
    int endHour;
    std::string id;
    SitterPtr sitters;
    ChildPtr children;
public:
    const SitterPtr &getSitter() const;

    void setSitter(const SitterPtr &sitter);

    //KONSTRUKTORY DESTRUKTORY
    Reservation(int day, Month month, int startHour, int endHour, const std::string &id);

    virtual ~Reservation() = default;

    //GETTERY

    int getDay() const;
    Month getMonth() const;
    int getStartHour() const;
    int getEndHour() const;
    const std::string &getId() const;

    std::string getInfo() const;
    std::string getInfoForFile() const;
    double getReservationCost();


    //SETTERY
    void setDay(int day);

    void setMonth(Month month);

    void setStartHour(int startHour);

    void setEndHour(int endHour);

    //METODY
    int countHours() const;
};
typedef std::shared_ptr<Reservation> ReservationPtr;

#endif //WARSZTATY_RESERVATION_H


