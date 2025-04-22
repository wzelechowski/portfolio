#include "repositories/ChildRepository.h"

void ChildRepository::addChild(ChildPtr child, std::vector<ChildPtr> &children) {
    children.push_back(child);
}

void ChildRepository::removeChild(ChildPtr child, std::vector<ChildPtr> &children) {
    for (int i = 0; i < children.size(); i++) {
        if (children[i] == child) {
            children.erase(children.begin() + i);
        }
    }

}


