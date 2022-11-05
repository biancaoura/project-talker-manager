# Talker Manager Project

## Goals

### Develop a CRUD API to registrate speakers:

- Create endpoints:
  - POST
    - `/login`
    - `/talker`
  - GET
    - `/talker`
    - `/talker/:id`
    - `/talker/search`
  - PUT
    - `/talker/:id`
  - DELETE
    - `/talker/:id`

- Create middlewares to validate login
  - When logging in, a token is generated

- Create an authentication middleware to validate a token

- Create middlewares to validate field to register a speaker:
  - `name`, `age`, `id`, `talk`, `watchedAt`, `rate`

#### First project using _Node.js_

##

> Project developed with Node.js

> talker.json provided by Trybe
