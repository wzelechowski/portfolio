#include <sstream>
#include "model/Child.h"
#include "exceptions/Exceptions.h"

Child::Child(const std::string &name, const std::string &id, int age) : name(name), id(id), age(age) {
    if (name.empty()){
        throw ParametrException("No name given!");
    }
    if (id.empty()) {
        throw ParametrException("No ID given!");
    }
    if (age < 0) {
        throw ParametrException("Wrong age given!");
    }
}

const std::string &Child::getChildName() const {
    return name;
}

const std::string &Child::getId() const {
    return id;
}

int Child::getAge() const {
    return age;
}

void Child::setAge(int age) {
    Child::age = age;
}

std::string Child::getInfo() const {
    std::stringstream info;
    info <<"Child\n"<< "ID: " << getId() << "\nName: " << getChildName() << "\nAge: " << getAge()<<"\n";
    return info.str();
}

std::string Child::getInfoForFile() const {
    std::stringstream info;
    info << "ID: " << getId() << "\nName: " << getChildName() << "\nAge: " << getAge()<<"\n";
    return info.str();
}

void Child::setChildName(const std::string &name) {
    Child::name = name;
}

