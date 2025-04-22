#include <boost/test/unit_test.hpp>
#include <boost/test/test_tools.hpp>
#include <memory>
#include "model/Sitter.h"
#include "managers/SitterManager.h"

using namespace std;

BOOST_AUTO_TEST_SUITE(SitterManagerTest)
    BOOST_AUTO_TEST_CASE(CheckCountSitterManagerTest) {
        SitterPtr x(new Sitter("Janina Paralityczka", 5, 10, "1", 12.0));
        SitterManager sm;
        SitterRepository sr;
        BOOST_CHECK_EQUAL(sm.checkSitter(x),true);
        BOOST_CHECK_EQUAL(sm.countSitters(),1);
    }
    BOOST_AUTO_TEST_CASE(SitterManagerSaveLoad){
    SitterManager sm;
    SitterRepository sr;
    SitterPtr x(new Sitter("ania",1,2,"12",1.0));
    sr.addSitter(x,sm.sitters);
    sm.saveSitter(x);
    sr.removeSitter(x,sm.sitters);
    sm.loadSitter(sr);
    BOOST_CHECK_EQUAL(sm.countSitters(),1);
}

BOOST_AUTO_TEST_SUITE_END()