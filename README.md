# Grupo

Nombre: Kirin_Objetos
Juego: 2048

Integrantes: 

	- Francisco Ou Su
	- Zoe Yusti
	- Kenzo Grosvald

# Consigna TP Integrador

Hacer un juego aplicando los conceptos de la materia. El tp tiene una parte práctica, que es programar el juego en sí, y una parte teórica, que es justificar decisiones que hayan tomado y mencionar para resolver qué problemas utilizaron los conceptos de la materia.
El TP debe:
- aplicar los conceptos que vemos durante la materia.
- tener tests para las funcionalidades que definan.
- evitar la repetición de lógica.

# Como correrlo

Boton derecho sobre `juego.wpgm > Run as > Wollok Program`.

# Entregas

Van a haber varios checkpoints presenciales en los cuales vamos a ver el estado del tp, dar correcciones y junto con ustedes decidir en qué continuar trabajando.
Los checkpoints presenciales están en la página: https://www.pdep.com.ar/cursos/lunes-tarde

# Parte práctica

## Cosas faltantes:
- [ ] Implementar lógica de ganador cuando llega a 2048
- [ ] Arreglar el sistema que chequea si hay movimientos faltantes disponibles cuando el tablero está lleno

# Parte teórica

Les vamos a ir dando preguntas para cada checkpoint que **tienen que** dejar contestadas por escrito. Pueden directamente editar este README.md con sus respuestas:

--------------------

## Checkpoint 1: 25/9

a) Detectar un conjunto de objetos que sean polimórficos entre sí, aclarando cuál es la interfaz según la cuál son polimórficos, y _quién_ los trata de manera polimórfica.

El conjunto de objetos que son polimorficos entre si en este caso serían los numeros, quien los trata de manera polimorfica tendría que ser el handler del juego, que sería en este caso el objeto de juego que maneja la ejecución del programa.

b) Tomar alguna clase definida en su programa y justificar por qué es una clase y no se definió con `object`.

La clase definida de Numero fue definida como tal ya que es un molde que se usa para instanciar nuevos numeros que se generan en tiempo de ejecución y comparten la misma inerfaz, cada numero tiene atributos distintos en cuanto a sus coordenadas por lo tanto no podría estar definido como un objeto ya que su estado interno no podría ser compartido. Se requieren de muchos numeros en simultaneo que van a ser repetidos y cada uno se encuentra en una coordenada distinta, habiendo sido instanciado bajo un numero distinto.

c) De haber algún objeto definido con `object`, justificar por qué.

El handler del juego es un objeto, ya que su tarea es mantener (a futuro supongo) un estado interno de todas las coordenadas ocupadas en algun lado (Diccionario, Lista, etc) y poder ser consultable por objetos externos al momento de verificar si la coordenada se encuentra ocupada y por quien, para poder tomar decisiones acorde. Sirve a modo de una base de datos de lo que está pasando en el programa en tiempo de ejecución.

