# skripsi

## Tech Stack
- **Frontend:** Flutter framework
- **Backend stack:**
  - Golang with Gin framework
  - PostgreSQL with PostGIS extension
- **Third Party Services:**
  - Mapbox API
  - Firebase for messaging and remote config

## Getting Started
Make sure to setup Firebase messaging and remote config for the backend and frontend.

### Pre-requisites
Before you begin, make sure to download the required softwares:
- [Go](https://go.dev/doc/install) programming language.
- [Flutter](https://docs.flutter.dev/get-started/install).
- [PostgreSQL](https://www.postgresql.org/download/) with [PostGIS extension](https://postgis.net/documentation/getting_started/) or you can run the database using Docker.
```bash
$ cd backend
$ docker-compose up -d
```


> **NOTE:**
> To initialize firebase in Flutter, please follow [this step](https://firebase.google.com/docs/flutter/setup?platform=android)

### Setup Firebase in Backend:
- Create a new Firebase project in [Firebase Console](https://console.firebase.google.com/), make sure that it supports Android and iOS.
- Generate a private key file in the Firebase Console by going to `Project settings >  Service accounts > Generate new private key`.
- Put the file in the root of the `backend` folder.


### Setup Firebase Remote Config Variables:
- backend_host: string, example: 192.168.0.1:8000
- mock_location_service: boolean

### Setup MapBox
- Create an account in [Mapbox](https://www.mapbox.com/).
- Go to the [console page](https://console.mapbox.com/) and generate a new private key.
- Copy the key and paste it to the `.env` file in the `frontend` folder.

### Run Project
- Run backend server
```bash
$ cd backend
$ go run cmd/main.go
```
- Run frontend server
```bash
$ cd frontend
$ flutter run
```