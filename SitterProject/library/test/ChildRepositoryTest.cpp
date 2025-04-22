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

BOOST_AUTO_TEST_SUITE(ChildrenRepositoryTest)
    BOOST_AUTO_TEST_CASE(AddRemoveChildManagerTest) {
        ChildPtr x(new Child("asia","12",1));
        ChildManager cm;
        ChildRepository cr;
        cr.addChild(x,cm.children);
        BOOST_CHECK_EQUAL(cm.countChildren(),1);
        cr.removeChild(x,cm.children);
        BOOST_CHECK_EQUAL(cm.countChildren(),0);
    }

BOOST_AUTO_TEST_SUITE_END()