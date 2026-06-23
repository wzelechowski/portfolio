# 🍕 PolishPizza

A comprehensive microservices-based pizzeria management system developed as an engineering thesis project for the Applied Computer Science program at Lodz University of Technology.

The platform supports end-to-end order processing, menu management, delivery tracking, and user account administration. Additionally, it leverages Artificial Intelligence to generate product recommendations and personalized promotions based on customer behavior and order history.

---

## 🚀 Key Features

* User registration and authentication
* Order creation and management
* Pizza, ingredients, and inventory management
* Delivery tracking and courier management
* Promotion and discount code handling
* AI-powered recommendation engine
* AI-generated personalized promotions
* Centralized configuration management
* Service discovery and API gateway routing
* Event-driven communication between microservices

---

## 🏗 System Architecture

The system follows a microservices architecture where each business domain is implemented as an independent service.

### Backend Technologies

#### Spring Cloud Ecosystem

* Spring Cloud Gateway (API Gateway)
* Netflix Eureka (Service Discovery)
* Spring Cloud Config (Centralized Configuration)

#### Domain Microservices

* User Service
* Menu Service
* Order Service
* Delivery Service
* Promotions Service

#### Databases & Storage

* PostgreSQL
* Redis

#### Messaging

* RabbitMQ

#### Authentication & Authorization

* Keycloak

---

## 🤖 Artificial Intelligence Module

The AI module is implemented in Python and is responsible for:

* Product recommendation generation
* Customer purchasing pattern analysis
* Personalized promotion suggestions
* Association rule mining using algorithms such as Apriori

Location-based recommendation functionality was initially considered but is currently not part of the system.

---

## 📱 Frontend Applications

### Customer & Delivery Application

Technology:

* React Native
* Expo

Features:

* Order placement
* Order tracking
* Delivery management
* User account management

### Administration Panel

Technology:

* React
* TypeScript
* Vite

Features:

* Order management
* Employee management
* Menu administration
* Promotion approval workflow
* Business analytics

---

## 🐳 Infrastructure

* Docker
* Docker Compose
* Nginx
* RabbitMQ
* Keycloak
* PostgreSQL
* Redis

The entire environment can be launched using containerized services.

---

## 📂 Project Structure

```text
admin/         - Web administration panel
ai/            - Machine learning services and recommendation engine
config/        - Spring Cloud Config Server
db/            - Database initialization scripts and configuration
delivery/      - Delivery management microservice
eureka/        - Eureka service discovery server
frontend/      - Mobile application (React Native)
gateway/       - API Gateway
keycloak/      - Identity and access management configuration
menu/          - Menu, ingredients and inventory management
order/         - Order processing and cart management
promotions/    - Promotion and discount management
user/          - User profile service
```

---

## ⚙️ Local Setup

### Prerequisites

* Docker
* Docker Compose
* Node.js
* Java 21+ (optional)
* Maven (optional)

---

### Clone Repository

```bash
git clone git@github.com:wzelechowski/PolishPizza.git
cd PolishPizza
```

---

### Start Infrastructure & Backend

```bash
docker-compose up -d
```

> The initial startup may take several minutes while Docker images are being built and dependencies are downloaded.

---

### Run Administration Panel

```bash
cd admin
npm install
npm run dev
```

---

### Run Mobile Application

```bash
cd frontend
npm install
npx expo start
```

---

## 🔐 Security

Authentication and authorization are handled by Keycloak.

Features include:

* Role-based access control (RBAC)
* JWT authentication
* Centralized identity management
* Secure microservice communication

---

## 📈 Future Improvements

* Real-time order notifications
* Advanced recommendation models
* Analytics dashboard enhancements
* Kubernetes deployment
* CI/CD automation
* Cloud deployment support

---

## 👨‍💻 Author

**Wiktor Żelechowski**

Applied Computer Science Student
Specialization: Software Engineering and Data Analysis

GitHub: https://github.com/wzelechowski
