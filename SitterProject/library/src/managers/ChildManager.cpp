#include "managers/ChildManager.h"
#include "exceptions/Exceptions.h"
#include "repositories/ChildRepository.h"


bool ChildManager::checkChild(ChildPtr child) {
    for (int i=0; i<children.size(); i++){
        if(children[i]->getId()==child->getId()){
            throw DuplicateException( "Child already exists");
        }
    }
    ChildRepository dziecko;
    dziecko.addChild(child, children);
    return true;
}

int ChildManager::countChildren() {
    return children.size();
}

void ChildManager::saveChild(ChildPtr child) {
    std::ofstream childSave;
    childSave.open("../../program/saves/childStatus",std::ios_base::app);
    if (childSave.good() != true){
        childSave.close();
        throw FileException("File not found!");
    }
    else{
        childSave << child->getInfoForFile() << std::endl;
    }
    childSave.close();
}

void ChildManager::loadChildren(ChildRepository &childrenR) {
    std::ifstream childLoad;
    childLoad.open("../../program/saves/childStatus", std::ios_base::in);
    if (childLoad.good() != true){
        childLoad.close();
        throw FileException("File not found!");
    }
    else {
        std::string line;
        std::string name, id;
        int age;
        while (getline(childLoad, line)){
            size_t colonPos = line.find(":");
            if (colonPos != std::string::npos) {
                std::string variable = line.substr(0,colonPos);
                std::string value = line.substr(colonPos + 2);
                if (variable == "Name") {
                    name = value;
                }
                else if(variable == "ID"){
                    id = value;
                }
                else if(variable == "Age"){
                    age = stoi(value);
                }
            }
        }
        ChildPtr child = std::make_shared<Child>(name,id,age);
        childrenR.addChild(child,this->children);
    }
    childLoad.close();
}

std::string ChildManager::findChild(std::string id) {
    for (int i=0; i<children.size(); i++){
        if(children[i]->getId()==id){
            return children[i]->getInfo();
        }
    }
    throw NoAvailableException("Child not found!");
}
