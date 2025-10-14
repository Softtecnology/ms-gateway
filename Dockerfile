# Usamos una imagen de Maven para compilar el proyecto Java
FROM maven:3.8.5-openjdk-17 AS build

# Establecemos el directorio de trabajo dentro del contenedor
WORKDIR /ms-gateway

# Copiamos el archivo pom.xml para descargar dependencias
COPY pom.xml .
RUN mvn dependency:go-offline

# Copiamos el resto del código fuente y construimos el .jar
COPY src ./src
RUN mvn package -DskipTests

# ---- Fase 2: Ejecución (Runtime) ----
# Usamos una imagen ligera con solo el entorno de ejecución de Java
FROM eclipse-temurin:17-jre-noble

# Establecemos el directorio de trabajo
WORKDIR /ms-gateway

# Copiamos el .jar construido desde la fase anterior
COPY --from=build /ms-gateway/target/*.jar ms-eureka.jar

# Exponemos el puerto en el que corre la aplicación Spring
EXPOSE 8080

# Comando para ejecutar la aplicación cuando el contenedor inicie
ENTRYPOINT ["java", "-jar", "ms-gateway.jar"]