#### Endpoints

Desc                       | Verb     | URI Pattern                   | Body Ex.:
---------------------------|----------|-------------------------------|-------
List Users                 | GET      | /users                        | -
Create User                | POST     | /users                        | {"data": {"type":"users", "attributes":{"name":"Raoni", "email":"raoni@boring.test", "password":"12345678"}}}
Get One User               | user GET | /users/:id                    |  -
Edit User                  | PATCH    | /users/:id                    |  -
Edit User                  | PUT      | /users/:id                    |  -
Delete User                | DELETE   | /users/:id                    |  -
Confirm Email              | GET      | /confirmations/email/token    |  -
Login                      | POST     | /auth/login                   |  -
Send Recover Pass To Email | POST     | /auth/request-password-change |  -
Recover Password           |  POST    | /auth/recover-password        |  -

#### Up and Down Application

The app container will use port 3000 and postgresql db will use port 5432,
you need have these ports available or edit docker-compose.yml to an available port

Up application

```
$ docker-compose up -d
```

When your app image is built (following the instructions of the Dockerfile), it doesn't have a
connection to a db container. The webserver and database images are independents and the
containers are linked when you launch them (following the definitions of the docker-compose.yml file).

You cannot link to a container during the image build because it would break the principle that
an image build must be reproducible, So you cannot add database commands in docker files.
Similarly, you cannot mount a volume from the host machine during an image build neither.
So the command below is a correct way to initalize the database. You can run migrations and
seeders too

```
$ docker-compose run app rails db:create
$ docker-compose run app rails db:migrate
$ docker-compose run app rails db:seed
```

After the above commands, the expectation is to have your application running in the development environment without
problems. To close the application just use the command below

```
$ docker-compose down
```

--------------------

### Debugging

The tips below can be useful to debug your app.

You can rebuild and up a fresh app container with the command below

```
 $ docker-compose down && docker-compose build --no-cache && docker-compose up -d
```

You can access the app container

```
$ docker exec -it authentication-without-gem-app-1 bash
```

Assuming you're looking to kill rails server on port 3000,
type this inside your app container to find out the PID of the process:

```
$ apt install lsof
$ lsof -wni tcp:3000
```

Then, use the number in the PID column to kill the process

```
$ kill -9 PID
```

This can be useful to unlock the database for example

-----------

#### Pendências

- Logout e invalidação de tokens
- Refresh Token
- Reenvio de token de confirmação de Email

