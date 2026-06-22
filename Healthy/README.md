# 🩺 Health Monitor IoT ("Healthy")

Health Monitor IoT to inteligentna platforma telemedyczna oparta na architekturze sterowanej zdarzeniami (Event-Driven Microservices). [cite_start]Służy do ciągłego, zdalnego monitorowania parametrów życiowych pacjentów przy wykorzystaniu strumieni danych z czujników IoT oraz hybrydowych algorytmów uczenia maszynowego (ML) do natychmiastowej detekcji anomalii[cite: 53, 54, 57]. 

Projekt został zrealizowany w **5-osobowym zespole inżynierskim**.

### 🏗️ Architektura Systemu
[cite_start]System został podzielony na niezależne mikroserwisy [cite: 58][cite_start], co gwarantuje wysoką dostępność i skalowalność[cite: 63]. [cite_start]Komunikacja asynchroniczna realizowana jest poprzez brokera RabbitMQ[cite: 94].

* [cite_start]**Moduł Infrastruktury:** Netflix Eureka (Service Discovery) oraz Spring Cloud Config Server[cite: 87].
* [cite_start]**Moduł Dostępowy:** API Gateway realizujący wzorzec API Composition [cite: 154] [cite_start]oraz Auth Service zintegrowany z serwerem tożsamości Keycloak (OAuth2.0 / OpenID Connect)[cite: 93, 156].
* [cite_start]**Moduł Danych Operacyjnych:** Mikroserwisy Patient Service i Medical Staff Service oparte na bazach PostgreSQL[cite: 99, 161, 164].
* [cite_start]**Moduł Akwizycji Danych IoT:** Integration Service (bufor wejściowy JSON) oraz Vital Signs Service zapisujący setki tysięcy odczytów w specjalistycznej, nierelacyjnej bazie szeregów czasowych InfluxDB[cite: 101, 173, 176].
* [cite_start]**Moduł AI (Worker):** Autonomiczne środowisko w Pythonie[cite: 181].

### 🧠 Moduł Sztucznej Inteligencji i Detekcji Anomalii
[cite_start]Rdzeniem analitycznym systemu jest dedykowana mikrousługa Pythonowa, która asynchronicznie odbiera znormalizowane pakiety danych i analizuje je w czasie rzeczywistym[cite: 256, 258]. [cite_start]Zastosowano tu podejście dwuwarstwowe[cite: 263]:

1. [cite_start]**Isolation Forest (Analiza Chwilowa):** Algorytm uczenia nienadzorowanego budujący las losowych drzew izolujących[cite: 299, 301]. Wykrywa nagłe odchylenia pojedynczych pomiarów wykorzystując funkcję wskaźnika anomalii:
   [cite_start]$score(x,n)=2^{-E(h(x))/c(n)}$ [cite: 306, 307]
2. [cite_start]**LSTM Autoencoder (Analiza Trendów):** Rekurencyjna sieć neuronowa analizująca okna czasowe (10 ostatnich pomiarów) w celu wykrycia negatywnych trendów poprzez obliczanie błędu rekonstrukcji (MSE)[cite: 408, 414, 416].

[cite_start]Dzięki standaryzacji metodą **Z-score** ($z=(x-\mu)/\sigma$ [cite: 468][cite_start]), modele adaptują się do indywidualnej fizjologii pacjenta, a moduł **Explainable AI (XAI)** generuje dla lekarzy czytelne raporty wyjaśniające przyczyny każdego wygenerowanego alertu[cite: 264, 521].

### 🛠️ Stos Technologiczny
* [cite_start]**Backend:** Java 21, Spring Boot 4, Python 3.10+ (FastAPI)[cite: 86, 90].
* [cite_start]**Frontend:** React 18 (TypeScript, Vite) dla panelu medycznego oraz React Native dla aplikacji mobilnej[cite: 80, 82, 83]. [cite_start]Komunikacja w czasie rzeczywistym via WebSockets (STOMP)[cite: 84].
* [cite_start]**Bazy Danych (Polyglot Persistence):** PostgreSQL 17 (dane relacyjne), InfluxDB (szeregi czasowe)[cite: 96, 99, 101].
* [cite_start]**Infrastruktura & DevOps:** Docker, Docker Compose, RabbitMQ, Grafana, Loki (Obserwability)[cite: 94, 103, 106].
