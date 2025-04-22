#ifndef WARSZTATY_CHILD_H
#define WARSZTATY_CHILD_H

#include <string>
#include <memory>

class Child {
private:
    std::string name;
    std::string id;
    int age;

public:
            //KONSTRUKTORY DEKONSTRUKTORY
    virtual ~Child()=default;
    Child(const std::string &name,const std::string &id, int age);

            //GETTERY
    const std::string &getChildName() const;
    const std::string &getId() const;
    int getAge() const;
    std::string getInfo() const;
    std::string getInfoForFile() const;

            //SETTERY
    void setAge(int age);
    void setChildName(const std::string &name);

};

typedef std::shared_ptr <Child> ChildPtr;

#endif //WARSZTATY_CHILD_H


