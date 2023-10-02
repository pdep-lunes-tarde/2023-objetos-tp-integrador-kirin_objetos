import wollok.game.*


class Numero {
	const numero
	var property position
	var movimientosFaltantes = 0
	
	method movimientosFaltantes() = movimientosFaltantes
	
	method movimientosFaltantes(nuevo_numero){
		movimientosFaltantes += nuevo_numero
	}
	
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
  	
  	
  	method positionX(){
		return self.position().x()
	}
	
	method positionY(){
		return self.position().y()
	}

	method image() = "assets/" + numero + ".png"
}

object juego {
	const property numeros = []
	var referencia
				
	method iniciar() {
		game.width(6)
		game.height(7)
		game.cellSize(100)
		game.title("2048")
		game.boardGround("fondo.png")

		self.agregarNumero() 
		self.agregarNumero()
		
//		keyboard.up().onPressDo{self.moverArriba()}
//		keyboard.down().onPressDo{self.moverAbajo()}
//		keyboard.left().onPressDo{self.moverIzquierda()}
//		keyboard.right().onPressDo{self.moverDerecha()}

		self.numeros().forEach({num =>
					keyboard.up().onPressDo{
						self.moverArriba(num)
					}
					keyboard.down().onPressDo{
						self.moverAbajo(num)
					}
					keyboard.left().onPressDo{
						self.moverIzquierda(num)
					}
					keyboard.right().onPressDo{
						self.moverDerecha(num)
					}
				})


		game.start()
	}
	
	method removeAndAdd(objeto,position){
		game.removeVisual(objeto)
		game.addVisualIn(objeto, position)
	}
	
	method agregarNumero(){
		const ejeX = self.eje_random()
		const ejeY = self.eje_random()
		referencia = new Numero(numero=2,position=game.at(ejeX,ejeY))
		numeros.add(referencia)
		game.addVisual(referencia)
	}
	
	method positionX(){
		return referencia.position().x()
	}
	
	method positionY(){
		return referencia.position().y()
	}
	
	method coordenada_a_posicion(x,y){
		return game.at(x,y)
	}
	
	method estaOcupado(x,y){
		return game.getObjectsIn(self.coordenada_a_posicion(x,y)).size() != 0
	}
	
	method moverDerecha(numero){
		const x = numero.positionX()
		const casilleros = 4 - x
		numero.movimientosFaltantes(casilleros)
		if(x < 4){
			if(!self.estaOcupado(numero.positionX()+1,numero.positionY())){
				if(numero.movimientosFaltantes()>0){
					numero.derecha(1)
					numero.movimientosFaltantes(-1)
					self.moverDerecha(numero)
				}
			}
		} else {
			console.println("limite")
		}
	}
	
//	method moverIzquierda(numero){
//		const x = numero.positionX()
//		const casilleros = x - 1
//		if(x > 1){
//			numero.izquierda(casilleros)
//		} else {
//			console.println("limite")
//		}
//	}
	
	
	method moverIzquierda(numero){
		const x = numero.positionX()
		const casilleros = x - 1
		numero.movimientosFaltantes(casilleros)
		
		if(x > 1){
			if(!self.estaOcupado(numero.positionX()-1,numero.positionY())){
				if(numero.movimientosFaltantes()> 0){
					numero.izquierda(1)
					numero.movimientosFaltantes(-1)
					self.moverIzquierda(numero)
				}
			}
		}
		else {
			console.println("limite")
		}
	}
	
//	method moverArriba(numero){
//		const y = numero.positionY()
//		const casilleros = 4 - y
//		if(y < 4){
//			numero.arriba(casilleros)
//		} else {
//			console.println("limite")
//		}
//	}
	
	
	method moverArriba(numero){
		const y = numero.positionY()
		const casilleros = 4 - y
		numero.movimientosFaltantes(casilleros)
		
		if(y < 4){
			if(!self.estaOcupado(numero.positionX(),numero.positionY()+1)){
				if(numero.movimientosFaltantes()> 0){
					numero.arriba(1)
					numero.movimientosFaltantes(-1)
					self.moverArriba(numero)
				}
			}
		}
		else {
			console.println("limite")
		}
	}
	
	
//	method moverAbajo(numero){
//		const y = numero.positionY()
//		const casilleros = y - 1
//		if(y > 1){
//			numero.abajo(casilleros)
//		} else {
//			console.println("limite")
//		}
//	}
	

method moverAbajo(numero){
		const y = numero.positionY()
		const casilleros = y - 1
		numero.movimientosFaltantes(casilleros)
		
		if(y > 1){
			if(!self.estaOcupado(numero.positionX(),numero.positionY()+1)){
				if(numero.movimientosFaltantes()> 0){
					numero.abajo(1)
					numero.movimientosFaltantes(-1)
					self.moverAbajo(numero)
				}
			}
		}
		else {
			console.println("limite")
		}
	}
		
	method eje_random(){
		return new Range(start = 1, end = 4).anyOne()

	}

}
