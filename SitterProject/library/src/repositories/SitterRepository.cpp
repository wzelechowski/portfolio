#include "repositories/SitterRepository.h"

void SitterRepository::addSitter(SitterPtr sitter, std::vector <SitterPtr> &sitters) {
    sitters.push_back(sitter);
}

void SitterRepository::removeSitter(SitterPtr sitter, std::vector <SitterPtr> &sitters) {
    for (int i=0; i<sitters.size(); i++){
        if(sitters[i]==sitter){
            sitters.erase(sitters.begin()+i);
        }
    }
}

