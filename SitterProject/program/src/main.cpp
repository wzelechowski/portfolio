#include <iostream>
#include <fstream>
#include <algorithm>
#include "model/Reservation.h"
#include "model/Sitter.h"
#include "HealthyChildrenSitter/BabySitter.h"
#include "HealthyChildrenSitter/ChildSitter.h"
#include "DisabledChildrenSitter/DisabledChildrenSitter.h"
#include "DisabledChildrenSitter/DownSyndromeChildrenSitter.h"
#include "DisabledChildrenSitter/ADHDChildSitter.h"
#include "DisabledChildrenSitter/AutisticChildSitter.h"
#include "exceptions/Exceptions.h"
#include "managers/ReservationManager.h"
#include "repositories/ReservationRepository.h"
#include "repositories/SitterRepository.h"
#include "managers/SitterManager.h"
#include "managers/ChildManager.h"
#include "repositories/ChildRepository.h"

using namespace std;
using namespace ReservationSpace;

int main() {
            //MANAGERS + REPOSITORIES
    ReservationManager rm;
    ReservationRepository rr;
    SitterManager sm;
    SitterRepository sr;
    ChildRepository cr;
    ChildManager cm;

            //LOADING DATA
            sm.loadSitter(sr);
            rm.loadReservations(rr);
            cm.loadChildren(cr);

            //NEW SITTERS
    SitterPtr disabledSitter = std::make_shared<DisabledChildrenSitter>("basia",1,3,"2",24.0,2.0);
    SitterPtr downSitter = std::make_shared<DownSyndromeChildrenSitter>("kasia",1,3,"3",25.0,2.0);
    SitterPtr adhdSitter = std::make_shared<ADHDChildSitter>("asia",1,3,"4",25.0,2.0);
    SitterPtr autisticSitter = std::make_shared<AutisticChildSitter>("krysia",1,3,"5",25.0,2.0);
    TypePtr babySitter = std::make_shared<BabySitter>(2.0);
    TypePtr childSitter = std::make_shared<ChildSitter>();


            //NEW RESERVATIONS
    ReservationPtr reservation3 = std::make_shared<Reservation>(13,January,10,12,"14");
    ReservationPtr reservation4 = std::make_shared<Reservation>(14,April,10,14,"15");

            //NEW CHILDREN
    ChildPtr child1 = std::make_shared<Child>("kasia","1233",3);
    ChildPtr child2 = std::make_shared<Child>("asia","1234",4);

    reservation3->setSitter(adhdSitter);
    reservation4->setSitter(disabledSitter);


    return 0;
}


