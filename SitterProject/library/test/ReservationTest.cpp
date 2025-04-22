#include <boost/test/unit_test.hpp>
#include <boost/test/test_tools.hpp>
#include <memory>
#include "model/Sitter.h"
#include "model/sitterTypes/HealthyChildrenSitter/HealthyChildrenSitter.h"
#include "managers/SitterManager.h"
#include "managers/ReservationManager.h"
#include "exceptions/Exceptions.h"
#include "model/Reservation.h"
#include "repositories/ReservationRepository.h"
#include "model/Child.h"

using namespace std;
using namespace ReservationSpace;

BOOST_AUTO_TEST_SUITE(ReservationTest)
    BOOST_AUTO_TEST_CASE(BaseReservationTest) {
        ReservationRepository rep;
        ChildPtr a(new Child("Jan Kowalski","11",1));
        ChildPtr b(new Child("Jakub Rychter","15",2));
        ChildPtr c(new Child("Alicja Nowak","31",10));
        SitterPtr s1(new Sitter("Janina Kowalska",1,17,"123",1.0));
        SitterPtr s2(new Sitter("Katarzyna Nowak",2,15, "9", 1.0));
        ReservationPtr r1(new Reservation (10,February,10,12,"1"));
        ReservationPtr r2(new Reservation (12,March,11,14,"2"));
        ReservationPtr r3(new Reservation (5,October,8,10,"3"));
        SitterManager k;
        BOOST_REQUIRE_EQUAL(k.checkSitter(s1),true);
        BOOST_REQUIRE_EQUAL(k.checkSitter(s2),true);
        ReservationManager r;
        BOOST_REQUIRE_EQUAL(r.countReservations(), 0);
        BOOST_REQUIRE_EQUAL(r.createReservation(k.sitters, r1), true);
        BOOST_REQUIRE_EQUAL(r.createReservation(k.sitters, r2), true);
        BOOST_REQUIRE_EQUAL(r.createReservation(k.sitters, r3), true);
        rep.removeReservation(r3, r.reservations);
        BOOST_REQUIRE_EQUAL(r.countReservations(), 2);
    }

    BOOST_AUTO_TEST_CASE(ReservationNoAvailableTest) {
        ChildPtr a(new Child("dziecko1", "1234", 4));
        ChildPtr b(new Child("dziecko2", "2137", 10));
        SitterPtr s1(new Sitter("Janina Paralityczka", 5, 10, "1", 12.0));
        SitterPtr s2(new Sitter("Katarzyna Kanibal", 1, 9, "2", 10.0));
        ReservationPtr r1(new Reservation (20, October, 8, 15, "231"));
        ReservationPtr r2(new Reservation (20, December, 10, 15, "233"));
        SitterManager k;
        BOOST_REQUIRE_EQUAL(k.checkSitter(s1),true);
        BOOST_REQUIRE_EQUAL(k.checkSitter(s2),true);
        ReservationManager r;
        BOOST_REQUIRE_EQUAL(r.createReservation(k.sitters, r1), true);
        BOOST_REQUIRE_EQUAL(r.createReservation(k.sitters, r2), true);

    }

    BOOST_AUTO_TEST_CASE(ReservationParameterExceptionTest) {
        ChildPtr a(new Child("dziecko1", "1234", 4));
        BOOST_CHECK_THROW(ReservationPtr r(new Reservation (33, December, 8, 15, "231")), ParametrException);
        BOOST_CHECK_THROW(ReservationPtr r1(new Reservation (20, December, 3, 15, "231")), ParametrException);
        BOOST_CHECK_THROW(ReservationPtr r1(new Reservation (20, November, 8, 23, "231")), ParametrException);
        BOOST_CHECK_THROW(ReservationPtr r1(new Reservation (20, October, 8, 15, "")), ParametrException);
        ReservationPtr r(new Reservation (20, April, 8, 15, "231"));
        BOOST_CHECK_THROW(r->getReservationCost(), ParametrException);
    }

BOOST_AUTO_TEST_SUITE_END()