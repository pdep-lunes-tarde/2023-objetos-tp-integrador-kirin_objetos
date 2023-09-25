import wollok.game.*

class Numero {
	const ejeX
	const ejeY
	const numero
	var property position = game.at(ejeX,ejeY)
	
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
	
	method iniciar() {
		game.width(4)
		game.height(4)
		game.cellSize(100)
		game.title("2048")
		game.boardGround("fondo.png")

		
		self.agregarNumero(2)
		self.agregarNumero(2)
		
		keyboard.any().onPressDo { self.agregarNumero(self.numeroRandom()) }
		
		game.start()
	}
	
	method agregarNumero(cualNumero){
		game.addVisualCharacter(new Numero(numero=cualNumero,ejeX=self.ejeXrandom(),ejeY=self.ejeYrandom()))
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

//object numero2 {
//	var ejeX = new Range(start = 0, end = 3).anyOne()
//	var ejeY = new Range(start = 0, end = 3).anyOne()
//	var property position = game.at(ejeX,ejeY)
//	var numero
//	method arriba() {
//    	position = position.up(1) 
//  	}
//  	method abajo() {
//    	position = position.down(1) 
//  	}
//  	method izquierda() {
//    	position = position.left(1) 
//  	}
//  	method derecha() {
//    	position = position.right(1) 
//  	}
//	method image() = "assets/" + numero + ".png"
//}