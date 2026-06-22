# 🩺 Health Monitor IoT ("Healthy")

Health Monitor IoT to inteligentna platforma telemedyczna oparta na architekturze sterowanej zdarzeniami (Event-Driven Microservices). Służy do ciągłego, zdalnego monitorowania parametrów życiowych pacjentów przy wykorzystaniu strumieni danych z czujników IoT oraz hybrydowych algorytmów uczenia maszynowego (ML) do natychmiastowej detekcji anomalii. 

Projekt został zrealizowany w **5-osobowym zespole inżynierskim**.

### 🏗️ Architektura Systemu
System został podzielony na niezależne mikroserwisy, co gwarantuje wysoką dostępność i skalowalność. Komunikacja asynchroniczna realizowana jest poprzez brokera RabbitMQ.

* **Moduł Infrastruktury:** Netflix Eureka (Service Discovery) oraz Spring Cloud Config Server.
* **Moduł Dostępowy:** API Gateway realizujący wzorzec API Composition oraz Auth Service zintegrowany z serwerem tożsamości Keycloak (OAuth2.0 / OpenID Connect).
* **Moduł Danych Operacyjnych:** Mikroserwisy Patient Service i Medical Staff Service oparte na bazach PostgreSQL.
* **Moduł Akwizycji Danych IoT:** Integration Service (bufor wejściowy JSON) oraz Vital Signs Service zapisujący setki tysięcy odczytów w specjalistycznej, nierelacyjnej bazie szeregów czasowych InfluxDB.
* **Moduł AI (Worker):** Autonomiczne środowisko w Pythonie.

### 🧠 Moduł Sztucznej Inteligencji i Detekcji Anomalii
Rdzeniem analitycznym systemu jest dedykowana mikrousługa Pythonowa, która asynchronicznie odbiera znormalizowane pakiety danych i analizuje je w czasie rzeczywistym. Zastosowano tu podejście dwuwarstwowe:

1. **Isolation Forest (Analiza Chwilowa):** Algorytm uczenia nienadzorowanego budujący las losowych drzew izolujących. Wykrywa nagłe odchylenia pojedynczych pomiarów wykorzystując funkcję wskaźnika anomalii:
   $score(x,n)=2^{-E(h(x))/c(n)}$
2. **LSTM Autoencoder (Analiza Trendów):** Rekurencyjna sieć neuronowa analizująca okna czasowe (10 ostatnich pomiarów) w celu wykrycia negatywnych trendów poprzez obliczanie błędu rekonstrukcji (MSE).

Dzięki standaryzacji metodą **Z-score** ($z=(x-\mu)/\sigma$, modele adaptują się do indywidualnej fizjologii pacjenta, a moduł **Explainable AI (XAI)** generuje dla lekarzy czytelne raporty wyjaśniające przyczyny każdego wygenerowanego alertu.

### 🛠️ Stos Technologiczny
* **Backend:** Java 21, Spring Boot 4, Python 3.10+ (FastAPI).
* **Frontend:** React 18 (TypeScript, Vite) dla panelu medycznego oraz React Native dla aplikacji mobilnej. Komunikacja w czasie rzeczywistym via WebSockets (STOMP).
* **Bazy Danych (Polyglot Persistence):** PostgreSQL 17 (dane relacyjne), InfluxDB (szeregi czasowe).
* **Infrastruktura & DevOps:** Docker, Docker Compose, RabbitMQ, Grafana, Loki (Obserwability).
