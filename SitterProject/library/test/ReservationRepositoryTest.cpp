#include <boost/test/unit_test.hpp>
#include <boost/test/test_tools.hpp>
#include <memory>
#include "model/Sitter.h"
#include "managers/SitterManager.h"
#include "managers/ReservationManager.h"
#include "model/Reservation.h"

using namespace std;
using namespace ReservationSpace;

BOOST_AUTO_TEST_SUITE(ReservationRepositoryTest)
    BOOST_AUTO_TEST_CASE(AddRemoveReservationManagerTest) {
        ReservationPtr x(new Reservation(1,May,10,12,"12"));
        ReservationManager rm;
        ReservationRepository rr;
        rr.addReservation(x,rm.reservations);
        BOOST_CHECK_EQUAL(rm.countReservations(),1);
        rr.removeReservation(x,rm.reservations);
        BOOST_CHECK_EQUAL(rm.countReservations(),0);
    }

BOOST_AUTO_TEST_SUITE_END()