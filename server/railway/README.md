# tog/server

A mock server for Tog.

## Running
You need `Java OpenJDK 11` and `Maven` to start this server. Use the following command:
```shell
mvn spring-boot:run
```
The first time you start the server though, you might want to fill the database first with this command:
```shell
mvn spring-boot:run -Dspring-boot.run.profiles=datagen
```
You can remove the database by removing the `.database/` directory.