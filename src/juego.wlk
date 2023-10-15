import wollok.game.*

class Numero {
	var property numero
	var property position
	
	method numero() = numero
	  	
  	method x() = self.position().x()
	
	method y() = self.position().y()

	method image() = "assets/" + numero + ".png"
}

object juego {
	
	var property terminado = false
	const property numeros = new List()
	var movimientos = 0
	var referencia
	var puntajes = 0
	var puntajeMasAlto = 0
	const tablero = [
		game.at(1,4),game.at(2,4),game.at(3,4),game.at(4,4),
		game.at(1,3),game.at(2,3),game.at(3,3),game.at(4,3),
		game.at(1,2),game.at(2,2),game.at(3,2),game.at(4,2),
		game.at(1,1),game.at(2,1),game.at(3,1),game.at(4,1)]
			
	method iniciar() {	
		self.initBasico()
		self.hacerConfiguracionInicial()
		self.configurarTeclas()
		game.start()
	}
	
	method initBasico(){
		game.width(6)
		game.height(7)
		game.cellSize(100)
		game.title("2048")
		game.boardGround("assets/fondo.png")
		game.addVisual(pantallaPuntaje)
		game.addVisual(pantallaMovimiento)
		game.addVisual(pantallaPuntajeMasAlta)
		
	}
	
	method hacerConfiguracionInicial() {
		puntajes = 0
		movimientos = 0
		self.terminado(false)
		self.agregarNumero()
		self.agregarNumero()
	}
	
	method tecla(direccion){
	    if(!terminado){
	        var seMovio = false
	        self.ordenarNumeros(direccion)
	        self.numeros().forEach { num =>
	            if(self.moverNumero(num, direccion)) {
	                seMovio = true
	            }
	        }
	        
	        if(seMovio) { 
	            self.agregarNumero()
	            movimientos += 1
	            self.chequearPuntaje(puntajes)
	            self.numeros().forEach { numero => self.chequearGanador(numero) }
	            
	            if(!game.hasVisual(pantallaGanar)){
	                self.chequearPerdedor()   
	            } 
	        }
	    }
	}

	method configurarTeclas() {
		keyboard.up().onPressDo{ self.tecla("arriba") }
		keyboard.down().onPressDo{ self.tecla("abajo") }
		keyboard.left().onPressDo{ self.tecla("izquierda") }
		keyboard.right().onPressDo{ self.tecla("derecha") }
		keyboard.r().onPressDo{ self.reiniciar() }
	}
			
	method reiniciar(){
		if(terminado){
			self.numeros().forEach{numero =>
				numeros.remove(numero)
				game.removeVisual(numero)
			}
			if(game.hasVisual(pantallaPerder)){
				game.removeVisual(pantallaPerder)
			}
			if(game.hasVisual(pantallaGanar)){
				game.removeVisual(pantallaGanar)
			}
			self.hacerConfiguracionInicial()
		}
	}
	
	method ordenarNumeros(direccion) {
		if (direccion == "derecha") {
	 		 numeros.sortBy{ num1,num2 => num1.x() > num2.x() }
		} else if (direccion == "izquierda") {
			numeros.sortBy{ num1,num2 => num1.x() < num2.x() }
		} else if (direccion == "abajo") {
	 		numeros.sortBy{ num1,num2 => num1.y() < num2.y() }
		} else if (direccion == "arriba") {
			numeros.sortBy{ num1,num2 => num1.y() > num2.y() }
		}
	}
	
	method agregarNumero(){
		if(!self.estaLleno()){
			referencia = new Numero(numero=2,position=self.eje_random())
			numeros.add(referencia)
			game.addVisual(referencia)
		}
	}
	
	method eje_random() {
		const x = new Range(start = 1, end = 4).anyOne()
		const y = new Range(start = 1, end = 4).anyOne()
		if(!self.estaOcupado(x,y))
			return game.at(x,y)
		else
			return self.eje_random()	
	}
	
	method agregarNumeroEn(cual,x,y){	
		referencia = new Numero(numero=cual,position=game.at(x,y))
		numeros.add(referencia)
		game.addVisual(referencia)	
	}
		
	method estaOcupado(x,y) = game.getObjectsIn(game.at(x,y)).size() > 0
		
	method moverNumero(numero, direccion){
	    const x = numero.x()
	    const y = numero.y()
	    const movimientosRestantes = self.calcularCasillerosRestantes(numero, direccion)
	
	    if (movimientosRestantes > 0) {
	        const nuevoX = x + self.calcularIncrementoX(direccion)
	        const nuevoY = y + self.calcularIncrementoY(direccion)
	
	        if (!self.estaOcupado(nuevoX, nuevoY)) {
	        	
	            numero.position(game.at(nuevoX, nuevoY))
	            self.moverNumero(numero, direccion)
	            return true
	            
	        } else {
	            const numeroEnNuevaPosicion = self.getNumeroEn(nuevoX, nuevoY)
	            
	            if (numero.numero() == numeroEnNuevaPosicion.numero()) {
	            	
	                self.sumarNumeros(numero, numeroEnNuevaPosicion)
	                self.moverNumero(numero, direccion)
	                return true
	            }
	        }
		}
		return false
	}

	method calcularCasillerosRestantes(numero, direccion) {
	    const x = numero.x()
	    const y = numero.y()
	    
	    if (direccion == "derecha") {
	        return 4 - x
	    } else if (direccion == "izquierda") {
	        return x - 1
	    } else if (direccion == "arriba") {
	        return 4 - y
	    } else {
	        return y - 1
	    }
	}

	method calcularIncrementoX(direccion) {
	    if (direccion == "derecha") {
	        return 1
	    } else if (direccion == "izquierda") {
	        return -1
	    } else {
	        return 0
	    }
	}

	method calcularIncrementoY(direccion) {
	    if (direccion == "arriba") {
	        return 1
	    } else if (direccion == "abajo") {
	        return -1
	    } else {
	        return 0
	    }
	}

	method sePuedeMover(numero){
    	return 	self.movimientoValido(numero, "derecha") or
    			self.movimientoValido(numero, "izquierda") or
    			self.movimientoValido(numero, "abajo") or
    			self.movimientoValido(numero, "arriba")
	}

	method movimientoValido(numero, direccion) {
	    const x = numero.x()
	    const y = numero.y()
	    const movimientosRestantes = self.calcularCasillerosRestantes(numero, direccion)
	
	    if (movimientosRestantes <= 0) {
	        return false
	    }
	    const nuevoX = x + self.calcularIncrementoX(direccion)
	    const nuevoY = y + self.calcularIncrementoY(direccion)
	    
	    if (nuevoX >= 1 && nuevoX <= 4 && nuevoY >= 1 && nuevoY <= 4) {
	        if (self.estaOcupado(nuevoX, nuevoY)) {
	            const numeroEnNuevaPosicion = self.getNumeroEn(nuevoX, nuevoY)
	            return numero.numero() == numeroEnNuevaPosicion.numero()
	        } else {
	            return true
	        }
	    }
	  return false
	}

	method sumarNumeros(numero1, numero2) {
			
		if (numero1.numero() == numero2.numero()) {
	    	numero1.numero(numero1.numero()*2)
	    	puntajes += numero1.numero()
        	game.removeVisual(numero2)
	       	self.numeros().remove(numero2)
		}  	
	} 

	method getNumeroEn(x, y) = game.getObjectsIn(game.at(x,y)).head()
	
	method puntajes() = puntajes
	
	method puntajeMasAlto() = puntajeMasAlto
	
	method movimientos() = movimientos	
	
	method terminar(visual){
		game.addVisual(visual)	
		terminado = true
	}
	
	method chequearGanador(numero){
		if(numero.numero() == 2048){
			self.terminar(pantallaGanar)
		}
	}
	
	method chequearPerdedor(){
		if(self.estaLleno() && !self.numeros().any({numero=>self.sePuedeMover(numero)})){
			self.terminar(pantallaPerder)
		}
	}
	
	method chequearPuntaje(numero) {
		if(numero >= puntajeMasAlto){
			puntajeMasAlto = numero
		}
	}
	
	method estaLleno() = tablero.all{casillero=>self.estaOcupado(casillero.x(),casillero.y())}
}

object pantallaPuntajeMasAlta {
	method position() = game.at(5,6)
	method text() = "" + juego.puntajeMasAlto()
	method textColor() = "766e65"
}

object pantallaPuntaje {
	method position() = game.at(4,6)
	method text() = "" + juego.puntajes()
	method textColor() = "766e65"
}

object pantallaMovimiento {
	method position() = game.at(3,6)
	method text() = "" + juego.movimientos()
	method textColor() = "766e65"
}

object pantallaPerder {
	method position() = game.at(0,0)
	method image() = "assets/perdiste.png"
}

object pantallaGanar {
	method position() = game.at(0,0)
	method image() = "assets/ganaste.png"
}