#include <boost/test/unit_test.hpp>
#include <boost/test/test_tools.hpp>
#include <memory>
#include "model/Sitter.h"
#include "model/sitterTypes/HealthyChildrenSitter/HealthyChildrenSitter.h"
#include "managers/SitterManager.h"
#include "managers/ReservationManager.h"
#include "managers/ChildManager.h"
#include "repositories//ChildRepository.h"
#include "exceptions/Exceptions.h"
#include "model/Reservation.h"
#include "repositories/ReservationRepository.h"
#include "model/Child.h"

using namespace std;

BOOST_AUTO_TEST_SUITE(ChildrenManagerTest)
    BOOST_AUTO_TEST_CASE(CheckCountChildManagerTest) {
        ChildPtr x(new Child("asia","12",1));
        ChildManager cm;
        BOOST_CHECK_EQUAL(cm.checkChild(x),true);
        BOOST_CHECK_EQUAL(cm.countChildren(),1);
    }
    BOOST_AUTO_TEST_CASE(ChildManagerSaveLoad){
        ChildManager cm;
        ChildRepository cr;
        ChildPtr x(new Child("ania","12",1));
        cr.addChild(x,cm.children);
        cm.saveChild(x);
        cr.removeChild(x,cm.children);
        cm.loadChildren(cr);
        BOOST_CHECK_EQUAL(cm.countChildren(),1);
    }

BOOST_AUTO_TEST_SUITE_END()