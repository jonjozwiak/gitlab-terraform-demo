# Spring Boot Hello World 

This sample app was taken from [Spring Getting Started Guide](https://spring.io/guides/gs/spring-boot/).  Also the [Spring Boot Docker](https://spring.io/guides/gs/spring-boot-docker/) guide was used for adding this to a container.

## Basic Steps

```bash
git clone https://github.com/spring-guides/gs-spring-boot.git
mv gs-spring-boot/complete/* `pwd`
cp gs-spring-boot/LICENSE* `pwd`
rm -rf gs-spring-boot
```

Build app with Gradle: 

```bash
docker build --build-arg JAR_FILE=build/libs/\*.jar -t springio/gs-spring-boot-docker .
```

Or build app with Maven:

```bash
docker build -t springio/gs-spring-boot-docker .
```

Then run the app:

```bash
docker build -t springio/gs-spring-boot-docker .
docker run -p 8080:8080 springio/gs-spring-boot-docker
```

Connect to test at http://localhost:8080
