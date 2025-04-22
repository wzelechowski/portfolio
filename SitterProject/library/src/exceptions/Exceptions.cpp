#include "exceptions/Exceptions.h"

ParametrException::ParametrException(std::string message) :
        logic_error(message)
{}

DuplicateException::DuplicateException(std::string message):
        logic_error(message)
{}

NoAvailableException::NoAvailableException(std::string message) :
    logic_error(message){}

FileException::FileException(std::string message) :
    logic_error(message) {}



