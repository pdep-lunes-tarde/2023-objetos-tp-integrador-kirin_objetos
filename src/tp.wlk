import wollok.game.*


class Numero {
	const numero
	var property position
	
	method arriba(casilleros) {
 		position = position.up(casilleros)
 	}
  	method abajo(casilleros) {
 		position = position.down(casilleros)
 	}
  	method izquierda(casilleros) {
    	position = position.left(casilleros) 
  	}
  	method derecha(casilleros) {
    	position = position.right(casilleros)
  	}

	method image() = "assets/" + numero + ".png"
}

object juego {
	var pepita
				
	method iniciar() {
		game.width(6)
		game.height(7)
		game.cellSize(100)
		game.title("2048")
		game.boardGround("background.gif")

		
		self.agregarNumero(2) 
		
		keyboard.up().onPressDo{self.moverArriba()}
		keyboard.down().onPressDo{self.moverAbajo()}
		keyboard.left().onPressDo{self.moverIzquierda()}
		keyboard.right().onPressDo{self.moverDerecha()}
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
	
	method positionX(){
		return pepita.position().x()
	}
	
	method positionY(){
		return pepita.position().y()
	}
	
	method moverDerecha(){
		const x = self.positionX()
		const casilleros = 4 - x
		if(x < 4){
			pepita.derecha(casilleros)
		} else {
			console.println("limite")
		}
	}
	
	method moverIzquierda(){
		const x = self.positionX()
		const casilleros = x - 1
		if(x > 1){
			pepita.izquierda(casilleros)
		} else {
			console.println("limite")
		}
	}
	
	method moverArriba(){
		const y = self.positionY()
		const casilleros = 4 - y
		if(y < 4){
			pepita.arriba(casilleros)
		} else {
			console.println("limite")
		}
	}
	
	method moverAbajo(){
		const y = self.positionY()
		const casilleros = y - 1
		if(y > 1){
			pepita.abajo(casilleros)
		} else {
			console.println("limite")
		}
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
