//
// Created by student on 12.06.23.
//

#ifndef SITTER_PROJECT_EXCEPTIONS_H
#define SITTER_PROJECT_EXCEPTIONS_H

#include <string>
#include <stdexcept>

class ParametrException : public std::logic_error{
public:
    ParametrException(std::string message);
};

class DuplicateException : public std::logic_error{
public:
    DuplicateException(std::string message);
};

class NoAvailableException : public std::logic_error{
public:
    NoAvailableException(std::string message);
};

class FileException : public std::logic_error{
public:
    FileException(std::string message);
};
#endif //SITTER_PROJECT_EXCEPTIONS_H


