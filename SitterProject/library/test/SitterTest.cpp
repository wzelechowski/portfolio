#include <boost/test/unit_test.hpp>
#include <boost/test/test_tools.hpp>
#include "model/Sitter.h"
#include "managers/SitterManager.h"
#include "repositories/SitterRepository.h"
#include "exceptions/Exceptions.h"
#include "DisabledChildrenSitter/DisabledChildrenSitter.h"
#include "DisabledChildrenSitter/ADHDChildSitter.h"
#include "HealthyChildrenSitter/BabySitter.h"
#include "HealthyChildrenSitter/ChildSitter.h"
#include "model/sitterTypes/HealthyChildrenSitter/HealthyChildrenSitter.h"
using namespace std;
namespace btt = boost::test_tools;

BOOST_AUTO_TEST_SUITE(SitterTest)

BOOST_AUTO_TEST_CASE(SitterBaseTest) {
        SitterManager a;
        SitterRepository b;
        BOOST_REQUIRE_EQUAL(a.countSitters(),0);
        SitterPtr x(new Sitter("Janina Paralityczka", 5, 10, "1", 12.0));
        SitterPtr y(new Sitter("Katarzyna Kanibal", 1, 9, "2", 10.0));
        BOOST_REQUIRE_EQUAL(a.checkSitter(x),true);
        BOOST_REQUIRE_EQUAL(a.checkSitter(y),true);
        BOOST_REQUIRE_EQUAL(a.countSitters(),2);
        b.removeSitter(x, a.sitters);
        BOOST_REQUIRE_EQUAL(a.countSitters(),1);
}
    BOOST_AUTO_TEST_CASE(SitterTotalCostTest){
        SitterPtr xy(new Sitter("Janek Dzbanek",3,9,"123",2.0));
        TypePtr a(new BabySitter(1.0));
        TypePtr aa(new ChildSitter());
        SitterPtr x(new ADHDChildSitter("Janina Paralityczka", 5, 10, "1", 12.0,1.0));
        SitterPtr y(new DisabledChildrenSitter("Katarzyna Kanibal", 1, 9, "33", 10.0,1.0));
        SitterPtr xx(new ADHDChildSitter("Gabrysia Bąk", 5, 8, "43",15.0,1.0));
        SitterPtr yy(new DisabledChildrenSitter("Katarzyna Solka", 1, 4, "2", 50.0,3.0));
        BOOST_REQUIRE_EQUAL(x->totalCost(),12.0);
        BOOST_REQUIRE_EQUAL(y->totalCost(),10.0);
        BOOST_REQUIRE_EQUAL(xx->totalCost(),15.0);
        BOOST_REQUIRE_EQUAL(yy->totalCost(),150.0);
        BOOST_REQUIRE_EQUAL(xy->totalCost(),2.0);
        xy->setHealthyChildrenSitters(a);
        BOOST_REQUIRE_CLOSE(xy->totalCost(), 2.0, 0.01);
        xy->setHealthyChildrenSitters(aa);
        BOOST_REQUIRE_CLOSE(xy->totalCost(), 2.0, 0.01);
    }

    BOOST_AUTO_TEST_CASE(DuplicateSitterTest){
        SitterManager a;
        SitterPtr x(new Sitter("Janina Paralityczka", 5, 10, "1", 12.0));
        SitterPtr y(new Sitter("Katarzyna Kanibal", 1, 9, "2", 10.0));
        BOOST_REQUIRE_EQUAL(a.checkSitter(x),true);
        BOOST_REQUIRE_EQUAL(a.checkSitter(y),true);
        BOOST_CHECK_THROW(a.checkSitter(x), DuplicateException);
}
    BOOST_AUTO_TEST_CASE(SitterParameterExceptionTest) {
        BOOST_CHECK_THROW(SitterPtr s1(new Sitter("",5, -10, "1", 12.0)), ParametrException);
        BOOST_CHECK_THROW(SitterPtr s2(new Sitter("Janina Paralityczka", 5, -10, "1", 12.0)), ParametrException);
        BOOST_CHECK_THROW(SitterPtr s3(new Sitter("Janina Paralityczka", -5, 10, "1", 12.0)), ParametrException);
        BOOST_CHECK_THROW(SitterPtr s4(new Sitter("Janina Paralityczka", 5, 10, "1", -12.0)), ParametrException);
    }
BOOST_AUTO_TEST_SUITE_END()