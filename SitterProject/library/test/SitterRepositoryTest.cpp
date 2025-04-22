#include <boost/test/unit_test.hpp>
#include <boost/test/test_tools.hpp>
#include <memory>
#include "model/Sitter.h"
#include "managers/SitterManager.h"

using namespace std;

BOOST_AUTO_TEST_SUITE(SitterRepositoryTest)
    BOOST_AUTO_TEST_CASE(AddRemoveSitterManagerTest) {
        SitterPtr x(new Sitter("Janina Paralityczka", 5, 10, "1", 12.0));
        SitterManager sm;
        SitterRepository sr;
        sr.addSitter(x,sm.sitters);
        BOOST_CHECK_EQUAL(sm.countSitters(),1);
        sr.removeSitter(x,sm.sitters);
        BOOST_CHECK_EQUAL(sm.countSitters(),0);
    }
BOOST_AUTO_TEST_SUITE_END()