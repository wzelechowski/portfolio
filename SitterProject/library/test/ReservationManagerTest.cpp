#include <boost/test/unit_test.hpp>
#include <boost/test/test_tools.hpp>
#include <memory>
#include "model/Sitter.h"
#include "managers/SitterManager.h"
#include "managers/ReservationManager.h"
#include "model/Reservation.h"

using namespace std;
using namespace ReservationSpace;

BOOST_AUTO_TEST_SUITE(ReservationManagerTest)
    BOOST_AUTO_TEST_CASE(CreateCountReservationManagerTest) {
        ReservationPtr x(new Reservation(1,May,10,12,"12"));
        ReservationManager rm;
        SitterManager sm;
        SitterRepository sr;
        SitterPtr y(new Sitter("ania",1,2,"13",1.0));
        sr.addSitter(y,sm.sitters);
        BOOST_CHECK_EQUAL(rm.createReservation(sm.sitters,x),true);
        BOOST_CHECK_EQUAL(rm.countReservations(),1);
    }
    BOOST_AUTO_TEST_CASE(ReservationManagerSaveLoad){
        ReservationManager rm;
        ReservationRepository rr;
        ReservationPtr x(new Reservation(1,May,10,12,"12"));
        rr.addReservation(x,rm.reservations);
        rm.saveReservation(x);
        rr.removeReservation(x,rm.reservations);
        rm.loadReservations(rr);
        BOOST_CHECK_EQUAL(rm.countReservations(),1);
    }

BOOST_AUTO_TEST_SUITE_END()