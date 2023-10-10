import wollok.game.*

class Numero {
	var property numero
	var property position
	var movimientosFaltantes = 0
	
	method numero() = numero
	
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
  	
  	method positionX() = self.position().x()
	
	method positionY() = self.position().y()

	method image() = "assets/" + numero + ".png"
}

object tablero{

	const casilleros = new Dictionary()
	
	method casilleros() = casilleros
	
	method init(){
		
		/*
		
		 a Dictionary [
		 "1x1" -> 0, "1x2" -> 0, "1x3" -> 0, "1x4" -> 0,
		 "2x1" -> 0, "2x2" -> 0, "2x3" -> 0, "2x4" -> 0,
		 "3x1" -> 0, "3x2" -> 0, "3x3" -> 0, "3x4" -> 0,
		 "4x1" -> 0, "4x2" -> 0, "4x3" -> 0, "4x4" -> 0]
		 
		*/
		
		self.addNumero(0,1,1)
		self.addNumero(0,2,1)
		self.addNumero(0,3,1)
		self.addNumero(0,4,1)
		
		self.addNumero(0,1,2)
		self.addNumero(0,2,2)
		self.addNumero(0,3,2)
		self.addNumero(0,4,2)
		
		self.addNumero(0,1,3)
		self.addNumero(0,2,3)
		self.addNumero(0,3,3)
		self.addNumero(0,4,3)
		
		self.addNumero(0,1,4)
		self.addNumero(0,2,4)
		self.addNumero(0,3,4)
		self.addNumero(0,4,4)

	}
	
	method addNumero(numero,ejeX,ejeY){
		casilleros.put(self.armarEje(ejeX,ejeY),numero)
	}
	
	method armarEje(ejeX,ejeY){
		return ejeX.toString() + "x" + ejeY.toString()
	}
	
	method getNumero(ejeX,ejeY) = casilleros.get(self.armarEje(ejeX,ejeY))

	method borrar(coordenada){
		casilleros.put(coordenada,0)
	}
	
	method buscar(coordenada) = casilleros.basicGet(coordenada)
	
	method estaLleno() = casilleros.values().all{numero => numero != 0}
	
}

object juego {
	
	var property terminado = false
	const property numeros = new List()
	const volumen = 0.5
	var movimientos
	var referencia
	var puntajes
	var musica
			
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
		self.iniciarMusica("assets/sleepTight.mp3")
		
	}
	
	method hacerConfiguracionInicial() {
		
		
		game.addVisual(pantallaPuntaje)
		game.addVisual(pantallaMovimiento)
		
		
		puntajes = 0
		movimientos = 0
		
		self.terminado(false)
		
		tablero.init()
			
		self.agregarNumero()
		self.agregarNumero()
	}
	
	method tecla(direccion){
		if(!terminado){
			
			self.ordenarNumeros(direccion)
			self.numeros().forEach({num => self.moverNumero(num, direccion)})
			
			self.numeros().forEach({numero => self.chequearGanador(numero)})
			
			self.agregarNumero()
			
			movimientos += 1
		}
	}
	
	method configurarTeclas() {
		
		keyboard.up().onPressDo{
			self.tecla("arriba")
		}
		
		keyboard.down().onPressDo{
			self.tecla("abajo")
		}
		keyboard.left().onPressDo{
			self.tecla("izquierda")
		}
		keyboard.right().onPressDo{
			self.tecla("derecha")
		}
		
		keyboard.r().onPressDo{
			
			self.numeros().forEach{num =>
				numeros.remove(num)
				game.removeVisual(num)
			}
		
			game.removeVisual(pantallaPuntaje)
			game.removeVisual(pantallaMovimiento)
			
			if(game.hasVisual(pantallaGanar)){
				game.removeVisual(pantallaGanar)
			} 
			if(game.hasVisual(pantallaPerder)){
				game.removeVisual(pantallaPerder)
			}
			
			self.hacerConfiguracionInicial()
		}
		

	}
	
	method ordenarNumeros(direccion) {
		
		if (direccion == "derecha") {
	 		 numeros.sortBy{ num1,num2 => num1.positionX() > num2.positionX() }
		} else if (direccion == "izquierda") {
			numeros.sortBy{ num1,num2 => num1.positionX() < num2.positionX() }
		} else if (direccion == "abajo") {
	 		numeros.sortBy{ num1,num2 => num1.positionY() < num2.positionY() }
		} else if (direccion == "arriba") {
			numeros.sortBy{ num1,num2 => num1.positionY() > num2.positionY() }
		}
	}
	
	method agregarNumero(){
		
		if(!tablero.estaLleno()){
			referencia = new Numero(numero=2,position=self.eje_random())
			numeros.add(referencia)
			tablero.addNumero(referencia,referencia.positionX(),referencia.positionY())
			game.addVisual(referencia)
		} else {
			if(!self.numeros().any({num=>self.sePuedeMover(num)})){
				self.terminar(pantallaPerder)
			}
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
	
	method coordenada_a_posicion(x,y) = game.at(x,y)
	
	method estaOcupado(x,y) = game.getObjectsIn(self.coordenada_a_posicion(x,y)).size() > 0
	
	method estaOcupado(posicion) = game.getObjectsIn(posicion).size() > 0
	
	method moverNumero(numero, direccion){
		
	    const x = numero.positionX()
	    const y = numero.positionY()
	    const movimientosRestantes = self.calcularCasillerosRestantes(numero, direccion)
	
	    if (movimientosRestantes > 0) {
	    	
	        const nuevoX = x + self.calcularIncrementoX(direccion)
	        const nuevoY = y + self.calcularIncrementoY(direccion)
	
	        if (!self.estaOcupado(nuevoX, nuevoY)) {
	        	
	            tablero.borrar(tablero.armarEje(x, y))
	            numero.position(game.at(nuevoX, nuevoY))
	            tablero.addNumero(numero, nuevoX, nuevoY)
	            self.moverNumero(numero, direccion)
	            
	        } else {
	        	
	            const numeroEnNuevaPosicion = self.getNumeroEn(nuevoX, nuevoY)
	            
	            if (numero.numero() == numeroEnNuevaPosicion.numero()) {
	            	
	                self.fusionarNumeros(numero, numeroEnNuevaPosicion)
	                self.moverNumero(numero, direccion)
	                
	            }
	        }
    	} 
	}

	method calcularCasillerosRestantes(numero, direccion) {
	    const x = numero.positionX()
	    const y = numero.positionY()
	    
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
	    const x = numero.positionX()
	    const y = numero.positionY()
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

	method fusionarNumeros(numero1, numero2) {
			
		if (numero1.numero() == numero2.numero()) {
			
        	numero1.numero(numero1.numero()*2)
        	puntajes += numero1.numero()

        	tablero.borrar(tablero.armarEje(numero2.positionX(),numero2.positionY()))
        	game.removeVisual(numero2)
 
       		self.numeros().remove(numero2)
    	} 
	    	
	} 

	method getNumeroEn(x, y) = game.getObjectsIn(game.at(x,y)).head()
	
	method puntajes() = puntajes
	
	method movimientos() = movimientos
	
	method musica() = musica
	
	method iniciarMusica(music) {
		musica = game.sound(music)
		musica.shouldLoop(true)
		musica.volume(volumen)
		game.schedule(100, {musica.play()})
	}
	
	method terminar(visual){
		self.musica().stop()
		game.addVisual(visual)	
		terminado = true
	}
	
	method chequearGanador(numero){
		if(numero.numero() == 2048){
			self.terminar(pantallaGanar)
			
		}
	}
	
}

object pantallaPuntaje {
	method position() = game.at(5,6)
//	method image() = "assets/label.png"
	method text() = "" + juego.puntajes()
	method textColor() = "766e65"
}

object pantallaMovimiento {
	method position() = game.at(4,6)
//	method image() = "assets/label.png"
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