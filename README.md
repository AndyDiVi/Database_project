# 🧩 Online Challenge Activity – Database Project

Progetto accademico per la modellazione e realizzazione di una base di dati a supporto di un’applicazione per la gestione di **sfide online a squadre**, pensata per ambienti didattici basati su **gamification** e **game-based learning**.

![Modello E-R in DataGrip](./datagrip-model.jpg)

## 📚 Contesto

Il progetto è stato sviluppato nell’ambito del corso di **Basi di Dati** (a.a. 2020/2021), con l’obiettivo di tradurre specifiche complesse in una base di dati relazionale solida, estensibile e normalizzata.

Le funzionalità supportate includono:
- Definizione di giochi e plance con immagini, caselle e icone tematiche
- Inserimento di **quiz a risposta multipla**, **task con file**, **video** e **meccaniche dinamiche** come serpenti, scale e dadi
- Gestione di sfide **sincrone** o **asincrone**, con supporto per **aiuti tra squadre**
- Monitoraggio di progressi, punteggi e classifiche in tempo reale

## 📌 Contenuto del Repository

- `schema.sql` – Script SQL per la creazione del database relazionale
- `query.sql` – Interrogazioni di esempio sul database (query SELECT significative)
- `datagrip.pdf` – PDF contenente il modello E-R creato in DataGrip
- `README.md` – Questo file

## 🏗 Struttura del Modello

Le entità principali includono:
- **Gioco** (plancia, caselle, icone, podi)
- **Sfida** (sincrona/asincrona, squadre partecipanti, data/orario)
- **Squadra** (nome, icona, membri)
- **Utente** (nickname, email, ruoli)
- **Casella** (tipologia, coordinate, contenuto)
- **Quiz** e **Risposte** (punteggi, immagini opzionali)
- **Task** (consegna file, validazione manuale)
- **Dado**, **Aiuti**, **Turni** e **Punteggi**

## 🧪 Requisiti

Per eseguire lo script SQL è sufficiente un qualsiasi DBMS relazionale come:

- **PostgreSQL**
- **MySQL**
- **SQLite** (con modifiche minime)
- **DataGrip** o altro client SQL per visualizzare graficamente il modello

## ▶️ Esecuzione

1. Crea un nuovo database
2. Esegui lo script `schema.sql` per generare le tabelle
3. (Opzionale) Popola con dati di test o esegui le query in `queries.sql`
4. Esplora il modello E-R con il file `.jpg` allegato

