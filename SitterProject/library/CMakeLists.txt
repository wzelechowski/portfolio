cmake_minimum_required(VERSION 3.4)
project(Library)

set(SOURCE_FILES
		src/model/Child.cpp
		src/repositories/ChildRepository.cpp
		src/managers/ChildManager.cpp
		src/model/Reservation.cpp
		src/repositories/ReservationRepository.cpp
		src/managers/ReservationManager.cpp
		src/model/Sitter.cpp
		src/repositories/SitterRepository.cpp
		src/managers/SitterManager.cpp
		src/model/sitterTypes/HealthyChildrenSitter/HealthyChildrenSitter.cpp
		src/model/sitterTypes/HealthyChildrenSitter/ChildSitter.cpp
		src/model/sitterTypes/HealthyChildrenSitter/BabySitter.cpp
		src/model/sitterTypes/DisabledChildrenSitter/ADHDChildSitter.cpp
		src/model/sitterTypes/DisabledChildrenSitter/DisabledChildrenSitter.cpp
		src/model/sitterTypes/DisabledChildrenSitter/AutisticChildSitter.cpp
		src/model/sitterTypes/DisabledChildrenSitter/DownSyndromeChildrenSitter.cpp
		src/exceptions/Exceptions.cpp
        test/SitterManagerTest.cpp test/ChildrenManagerTest.cpp test/ReservationManagerTest.cpp test/ReservationRepositoryTest.cpp test/SitterRepositoryTest.cpp test/ChildRepositoryTest.cpp)

#Utwórz bibliotekę typu STATIC, SHARED albo MODULE ze wskazanych źródeł
add_library(Library ${SOURCE_FILES})

target_include_directories(Library PUBLIC include)
target_include_directories(Library PUBLIC include/child)
target_include_directories(Library PUBLIC include/reservations)
target_include_directories(Library PUBLIC "include/model/sitterTypes")

enable_testing()

find_package (Boost 1.60.0 COMPONENTS "unit_test_framework" REQUIRED)

include_directories(
        ${CMAKE_CURRENT_SOURCE_DIR}/include
        ${Boost_INCLUDE_DIRS}
)

set(SOURCE_TEST_FILES 
	test/master.cpp
	test/ChildrenTest.cpp
	test/ReservationTest.cpp
	test/SitterTest.cpp


        test/SitterManagerTest.cpp test/ChildrenManagerTest.cpp test/ReservationManagerTest.cpp test/ReservationRepositoryTest.cpp test/SitterRepositoryTest.cpp test/ChildRepositoryTest.cpp) # tu w przyszłości będą dodawane pliki źródłowe testów

add_executable (LibraryTest ${SOURCE_TEST_FILES})

#dołącz bibliotekę z testowanymi klasami oraz bibliotekę boost.test do programu testów
target_link_libraries (LibraryTest
        Library
        ${Boost_UNIT_TEST_FRAMEWORK_LIBRARY}
        )

#dodaj test TestBiblioteki1. Instrukcji cmake add_test może być wiele.
#Dodatkowe parametry wpływają na szczegółowość generowanego raportu. Standardowo znajduje się on w Testing/Temporary.
add_test(LibraryTest1 LibraryTest
        --report_level=detailed
        --log_level=all
        --color_output=yes
        )

