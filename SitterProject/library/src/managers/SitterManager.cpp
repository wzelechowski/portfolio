#include "managers/SitterManager.h"
#include "repositories/SitterRepository.h"
#include "exceptions/Exceptions.h"
#include "DisabledChildrenSitter/DisabledChildrenSitter.h"
#include "DisabledChildrenSitter/ADHDChildSitter.h"
#include "DisabledChildrenSitter/DownSyndromeChildrenSitter.h"
#include "DisabledChildrenSitter/AutisticChildSitter.h"


bool SitterManager::checkSitter(SitterPtr sitter) {
    for (int i=0; i<sitters.size(); i++){
        if(sitters[i]->getId()==sitter->getId()){
            throw DuplicateException( "Sitter already exists");
        }
    }
    SitterRepository a;
    a.addSitter(sitter, sitters);
    return true;
}

std::vector <ReservationPtr> SitterManager::getAllSitterReservations(SitterPtr sitter, std::vector <ReservationPtr> reservations) {
    std::vector <ReservationPtr> sitres;
    for (int i=0; i<reservations.size(); i++)
    {
        if(reservations[i]->getSitter()==nullptr)
        {
            return sitres;
        }
        if(reservations[i]->getSitter()->getId()==sitter->getId()) {
            sitres.push_back(reservations[i]);
        }
    }
    return sitres;
}

int SitterManager::countSitters() {
    return sitters.size();
}

void SitterManager::saveSitter(SitterPtr sitter) {
    std::ofstream sitterSave;
    sitterSave.open("../../program/saves/sitterStatus",std::ios_base::app);
    if (sitterSave.good() != true){
        sitterSave.close();
        throw FileException("File not found!");
    }
    else{
        sitterSave << sitter->getInfo() << std::endl;
    }
    sitterSave.close();
}

void SitterManager::loadSitter(SitterRepository& sitterR) {
    std::ifstream sitterLoad;
    sitterLoad.open("../../program/saves/sitterStatus", std::ios_base::in);
    if (sitterLoad.good() != true) {
        sitterLoad.close();
        throw FileException("File not found!");
    } else {
        std::string line,firstline;
        std::string name, id;
        int maxChildrenAge, minChildrenAge;
        double wage,bonus;
        getline(sitterLoad,firstline);
        while (getline(sitterLoad, line)) {
            size_t colonPos = line.find(":");
            if (colonPos != std::string::npos && colonPos +2 <line.size()) {
                std::string variable = line.substr(0, colonPos);
                std::string value = line.substr(colonPos + 2);
                if (variable == "ID") {
                    id = value;
                } else if (variable == "Name") {
                    name = value;
                }
                else if (variable == "Minimum Child Age") {
                    minChildrenAge = stoi(value);
                }
                else if (variable == "Maximum Child Age") {
                    maxChildrenAge = stoi(value);
                }
                else if (variable == "Wage") {
                    wage = stod(value);
                }
                else if(variable == "Bonus"){
                    bonus = stod(value);
                }
            }
        }
        if(firstline == "Sitter") {
            SitterPtr sitter = std::make_shared<Sitter>(name, minChildrenAge, maxChildrenAge, id, wage);
            sitterR.addSitter(sitter, this->sitters);
        }
        else if(firstline == "Disabled Children Sitter"){
            SitterPtr sitter = std::make_shared<DisabledChildrenSitter>(name,minChildrenAge,maxChildrenAge,id,wage, bonus);
            sitterR.addSitter(sitter, this->sitters);
        }
        else if(firstline == "ADHD Children Sitter"){
            SitterPtr sitter = std::make_shared<ADHDChildSitter>(name,minChildrenAge,maxChildrenAge,id,wage, bonus);
        }
        else if(firstline == "Down Syndrome Children Sitter"){
            SitterPtr sitter = std::make_shared<DownSyndromeChildrenSitter>(name,minChildrenAge,maxChildrenAge,id,wage, bonus);
        }
        else if(firstline == "Autistic Children Sitter"){
            SitterPtr sitter = std::make_shared<AutisticChildSitter>(name,minChildrenAge,maxChildrenAge,id,wage, bonus);
        }
        sitterLoad.close();
    }
}

std::string SitterManager::findSitter(std::string id) {
    for (int i=0; i<sitters.size(); i++){
        if(sitters[i]->getId()==id){
            return sitters[i]->getInfo();
        }
    }
    throw NoAvailableException("Sitter not found");
}

