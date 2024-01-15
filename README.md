## Instalación


📋 Pre requisitos 📚

- Requiere instalar Java 21
- Requiere proyecto con gestor de dependencia maven
- Requiere IDE de su preferencia (Recomendación intelliJ IDEA o VS Code)
- En el archivo pom.xml del proyecto se deben agregar las siguientes dependencias
 ```bash
        <dependency>
            <groupId>com.intuit.karate</groupId>
            <artifactId>karate-junit5</artifactId>
            <version>${karate.version}</version>
            <scope>test</scope>
        </dependency>
        <dependency>
            <groupId>io.cucumber</groupId>
            <artifactId>cucumber-junit</artifactId>
            <version>7.15.0</version>
            <scope>test</scope>
        </dependency>
        <dependency>
            <groupId>org.junit.jupiter</groupId>
            <artifactId>junit-jupiter-api</artifactId>
            <version>5.9.2</version>
            <scope>test</scope>
        </dependency>
        <dependency>
            <groupId>org.junit.jupiter</groupId>
            <artifactId>junit-jupiter</artifactId>
            <version>5.10.1</version>
            <scope>test</scope>
        </dependency>
        <dependency>
            <groupId>net.masterthought</groupId>
            <artifactId>cucumber-reporting</artifactId>
            <version>5.7.5</version>
            <scope>test</scope>
        </dependency>
```
## 📋 Justificación

> Este proyecto implementa la automatización de pruebas para los servicios expuestos por la web restfulbooker
esta implementación se realiza utilizando karate ya que es un framework amplicamente utilizado y enfocado en
la automatizacion de pruebas e2e desde el backend, es bastante robusto con respecto a sus capaciadades ya que
implementa la posibilidad de generar scripts en javascript o java y estas sean utilizados dentro del marco de la
ejecución, esto abre las posibilidades de realizar test mas completos y en arquitecturas de servicios extendidos 
y complejas, adicionalmente como parte de su sintaxis utiliza el lenguaje gherkin basado en BDD lo que poermite 
que tenga una implementación sencilla y con un lenguaje comun de negocio


## Configuración del proyecto 

- Dentro del archivo de configuracion de karate karate-config.js incluir la siguiente parametrización

 ```bash
function fn(){
    var config = {
    baseUrl: 'https://restful-booker.herokuapp.com',

    endpointAuth: '/auth',
    endpointBooking: '/booking',
    endpointPing: '/ping',
    username: 'admin',
    password: 'password123',
    authToken: 'Basic YWRtaW46cGFzc3dvcmQxMjM='
    };

    karate.configure('continueOnStepFailure', true);

    return config;
}
```
Esta parametrización básica permite:
- Define variables de entorno, esto con el fin de hacer el proyecto mantenible en el tiempo y reutilizable 
- Define configuraciones comunes como por ejemplo tiempos de espera o comoen este caso la acción que debe generar karate 
en el caso de que una aserción falle se continue con las demas validaciones

## Ejecución

- Para la ejecución se ha utilizado junit por lo cual se define dentro de la ruta "src/test/java/TestRunner.java"
la implementación requerida para correr los test definidos,asi mismo se incluye un script que permite incluir dentro del 
proyecto los reportes de cucumber que tienen un aspecto mas dinamico y gerencial que los reportes nativo de karate


## Estructura del proyecto

El proyecto fue estructurado a partir del estandar de java implementando clases en java asociadas a la ejecución y
funciones comunes que son reutilizadas en varias test definidas con javascript.

📁 java: [./src/test]
> Contiene todas las clases que estan implementadas en lenguaje java, como el test runner y cualquier otra clase para
funciones mascomplejas que se requiera implementar


📁 features: [./src/resources]
> Contiene los casos de pruebas definidos en lenguahe gherkin e interpretados por karate framework para cada uno de los
servicios que se están testeando


📁 data: [./src/resources]
> Contiene estructuras de datos de entrada y de salida que son reutilizados en varios test cuando asi se requieran
aplicando principios SOLID donde se segregan interfaces para usos comunes


📁 commons-functions: [./src/resources]
> Contiene funciones comunes que son utilizadas por varios escenarios de prueba para generar acciones especificas,
esto aplicando principios SOLID para poder extender la implementación a multiples flujos sin mayor complejidad

## Entorno

> Esta suite de pruebas se ejecuta en un entprno publico a los servicios REST expuestos por restful booker


## Autor

Test Automation Engineer
David Enriquez - kdavid.enriquez@gmail.com

## Consideraciones en automatización

- **Buenas practicas:**

    - **Estructura del proyecto:** Dentro de este proyecto se aplica una estructura sencilla donde claramente se definen las
      responsabilidades de cada uno de las clases y en cada ruta se asignan nombres descriptivos y coherencia con las
      funciones contenidas para un mejor entendimiento, el código esta dividido en archivos y funciones para que sea modular
      y de fácil mantenimiento y escalabilidad
    - **Documentación de pruebas:** Es una de las partes mas relevantes dentro de la codificación docuemntar adecuadamente
      las pruebas para su facil entendimiento, dentro de este proyecto se agrega el archivo README.md que incluye los detalles de implementación y ejecución.
    - **Aplicar principios SOLID:** Es importante considerar estos principios dentro de cualquier proyecto de programación
      y la automatización no es la excepción, dentro de este proyecto se aplica principios como:
        - SRP - Responsabilidad unica: Clases que se enfocan en una función especifica dentro del proyecto
        - OCP - Open/Closed: Clases que definen elementos dentro de la página y que se pueden extender hacia nuevas
          implemenataciones dentro del mismo contexto y ser reutilizados en diferentes clases de prueba
        - ISP - Segregación de interfaces: Se definen metodos para funciones de lectura y escritura y comandos que obtienen
          el resultado