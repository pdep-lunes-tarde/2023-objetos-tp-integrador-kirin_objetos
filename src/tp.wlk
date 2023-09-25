import wollok.game.*


class Numero {
	const numero
	var property position
	
	method arriba() {
 		position = position.up(1)
 	}
  	method abajo() {
 		position = position.down(1)
 	}
  	method izquierda() {
    	position = position.left(1) 
  	}
  	method derecha() {
    	position = position.right(1)
  	}

	method image() = "assets/" + numero + ".png"
}

object juego {
	var pepita
				
	method iniciar() {
		game.width(4)
		game.height(4)
		game.cellSize(100)
		game.title("2048")
		game.boardGround("fondo.png")

		
		self.agregarNumero(2) 
		
		keyboard.up().onPressDo{pepita.arriba()}
		keyboard.down().onPressDo{pepita.abajo()}
		keyboard.left().onPressDo{pepita.izquierda()}
		keyboard.right().onPressDo{pepita.derecha()}
		game.start()
	}
	
	method removeAndAdd(objeto){
		game.removeVisual(objeto)
		game.addVisual(objeto)
	}
	
	method agregarNumero(cualNumero){
		const ejeX = juego.ejeXrandom()
		const ejeY = juego.ejeYrandom()
		pepita = new Numero(numero=cualNumero,position=game.at(ejeX,ejeY))
		game.addVisual(pepita)
	}

	method pepita(){
		return pepita.position()
	}
	
		
	method ejeXrandom(){
		return new Range(start = 0, end = 3).anyOne()

	}
	method ejeYrandom(){
		return new Range(start = 0, end = 3).anyOne()

	}
	method numeroRandom(){
		//return new Range(start = 2, end = 1024).anyOne()
		return 2
	}
}
