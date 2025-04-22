#include <boost/test/unit_test_suite.hpp>
#include <boost/test/test_tools.hpp>
#include "repositories/ChildRepository.h"
#include "managers/ChildManager.h"
#include "exceptions/Exceptions.h"
#include <string>

using namespace std;
namespace btt = boost::test_tools;

BOOST_AUTO_TEST_SUITE(ChildrenTest)
BOOST_AUTO_TEST_CASE(ChildBaseTest) {
        ChildRepository klasa;
        ChildManager manager;

        BOOST_TEST(manager.countChildren()==0);
        ChildPtr child1(new Child("dziecko1", "1234", 4));
        ChildPtr child2(new Child("dziecko2", "1235", 5));

        BOOST_REQUIRE_EQUAL(manager.checkChild(child1), true);
        BOOST_REQUIRE_EQUAL(manager.checkChild(child2), true);
        BOOST_TEST(manager.countChildren() == 2);
        klasa.removeChild(child1, manager.children);
        BOOST_TEST(manager.countChildren() ==  1);
}
    BOOST_AUTO_TEST_CASE(ChildDuplicateTest) {
        ChildManager k;
        ChildPtr a(new Child("dzieckox", "2111", 5));
        ChildPtr b(new Child("dzieckox", "2111", 5));
        BOOST_REQUIRE_EQUAL(k.checkChild(a),true);
        BOOST_CHECK_THROW(k.checkChild(a), DuplicateException);
        BOOST_REQUIRE_EQUAL(k.countChildren(),1);
    }

    BOOST_AUTO_TEST_CASE(ChildParameterExceptionTest) {
        BOOST_CHECK_THROW(ChildPtr child(new Child("", "21h3", 6)),  ParametrException);
    }


BOOST_AUTO_TEST_SUITE_END()

