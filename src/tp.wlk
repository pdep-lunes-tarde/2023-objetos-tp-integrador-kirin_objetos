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
	
	const property numeros = []
	var referencia
	var puntajes
	var movimientos
	var musica
	const volumen = 0.5
			
	method iniciar() {	
		
		self.hacerConfiguracionInicial()
		self.configurarTeclas()
		
		
		/*
		 * Bug: los primeros dos numeros pueden llegar a caer en la misma coordenada y sumarse, por lo que
		 * al abrir el juego te encontras directamente un 4 y nada más
		 * 
		 * 
		 */
		
		game.start()
		 	
	}
	
	method hacerConfiguracionInicial() {
		
		game.width(6)
		game.height(7)
		game.cellSize(100)
		game.title("2048")
		game.boardGround("assets/fondo.png")
		game.addVisual(pantallaPuntaje)
		game.addVisual(pantallaMovimiento)
		self.iniciarMusica("assets/sleepTight.mp3")
		
		puntajes = 0
		movimientos = 0
		
		tablero.init()
			
		self.agregarNumero()
		self.agregarNumero()
	}
	
	method configurarTeclas() {
		
		keyboard.up().onPressDo{
			self.ordenarNumeros("arriba")
			self.numeros().forEach({num => self.moverNumero(num, "arriba")})
			self.agregarNumero()
			movimientos += 1
		}
		
		keyboard.down().onPressDo{
			self.ordenarNumeros("abajo")
			self.numeros().forEach({num => self.moverNumero(num, "abajo")})
			self.agregarNumero()
			movimientos += 1
		}
		keyboard.left().onPressDo{
			self.ordenarNumeros("izquierda")
			self.numeros().forEach({num => self.moverNumero(num, "izquierda")})
			self.agregarNumero()
			movimientos += 1
		}
		keyboard.right().onPressDo{
			self.ordenarNumeros("derecha")
			self.numeros().forEach({num => self.moverNumero(num, "derecha")})
			self.agregarNumero()
			movimientos += 1
		}
		
//		keyboard.r().onPressDo{
//			self.perder()
//			game.clear()
//			self.iniciar()
//		}

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
		
		const ejeRandom = self.eje_random()
		
		if(!tablero.estaLleno()){
			
				if (!self.estaOcupado(ejeRandom)){
					
					referencia = new Numero(numero=2,position=ejeRandom)
					numeros.add(referencia)
					
					tablero.addNumero(referencia,referencia.positionX(),referencia.positionY())
					
					game.addVisual(referencia)
					
				} else {
					self.agregarNumero()
				}
				 
            }
		}
	
	method eje_random() = game.at(new Range(start = 1, end = 4).anyOne(),new Range(start = 1, end = 4).anyOne())
	
	method agregarNumeroEn(cual,x,y){ // Solo para troubleshooting	
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
		var casilleros
	
		if (direccion == "derecha") {
	  		casilleros = 4 - x
		} else if (direccion == "izquierda") {
	  		casilleros = x - 1
		} else if (direccion == "arriba") {
	  		casilleros = 4 - y
		} else if (direccion == "abajo") {
	  		casilleros = y - 1
		}
	
		numero.movimientosFaltantes(casilleros)
		
		if(!tablero.estaLleno()){ // esto despues hay que cambiarlo para que primero revise si hay movimientos disponibles
		
			if(numero.movimientosFaltantes() > 0) {
				
				if (direccion == "derecha" && x < 4) {
			  		if (!self.estaOcupado(x + 1, y)) {
	
						tablero.borrar(tablero.armarEje(x,y))
						
			    		numero.derecha(1)		    		
			    		numero.movimientosFaltantes(-1)
			    		
			    		tablero.addNumero(numero, numero.positionX(), numero.positionY())
			    		
			    		self.moverNumero(numero, direccion)
			    		
			  		} else {
			  			
			  			const numero_a_la_derecha = self.getNumeroEn(x+1,y)
			  			
			  			if (numero.numero() == numero_a_la_derecha.numero()){
			  				
			  				self.fusionarNumeros(numero,numero_a_la_derecha)
			  				
			  				self.moverNumero(numero, direccion)
			  				
			  			} else {
			  				
			  				numero.movimientosFaltantes(0)
			  				
			  			}
			  		}
			  		
				} else if (direccion == "izquierda" && x > 1) {
					
					if (!self.estaOcupado(x - 1, y)) {
						
						tablero.borrar(tablero.armarEje(x,y))
						
						numero.izquierda(1)
						numero.movimientosFaltantes(-1)
						
						tablero.addNumero(numero, numero.positionX(), numero.positionY())
						
						self.moverNumero(numero, direccion)
						
					} else {
						
						const numero_a_la_izquierda = self.getNumeroEn(x-1,y)
						
			  			if (numero.numero() == numero_a_la_izquierda.numero()){
			  				
			  				self.fusionarNumeros(numero,numero_a_la_izquierda)
			  				self.moverNumero(numero, direccion)
			  				
			  			} else {
			  				
			  				numero.movimientosFaltantes(0)
			  			}
			  		}
			  		
		  		} else if (direccion == "arriba" && y < 4) {
		  			
					if (!self.estaOcupado(x, y + 1) ) {
						
						tablero.borrar(tablero.armarEje(x,y))
						
			  			numero.arriba(1)
			  			numero.movimientosFaltantes(-1)
			  			
			  			tablero.addNumero(numero, numero.positionX(), numero.positionY())
			  			
			  			self.moverNumero(numero, direccion)
			  			
					} else {
						
						const numero_arriba = self.getNumeroEn(x,y+1)
						
			  			if (numero.numero() == numero_arriba.numero()) {
			  				
			  				self.fusionarNumeros(numero,numero_arriba)
			  				self.moverNumero(numero, direccion)
			  				
			  			} else {
			  				
			  				numero.movimientosFaltantes(0)
			  				
			  			}
			  		}
				} else if (direccion == "abajo" && y > 1) {
			  		if (!self.estaOcupado(x, y - 1)) {
			  			
			  			tablero.borrar(tablero.armarEje(x,y))
			  			
			    		numero.abajo(1)
			    		numero.movimientosFaltantes(-1)
			    		
			    		tablero.addNumero(numero, numero.positionX(), numero.positionY())
			    		
			    		self.moverNumero(numero, direccion)
			    		
			  		}  else {
			  			
			  			const numero_abajo = self.getNumeroEn(x,y-1)
			  			
			  			if (numero.numero() == self.getNumeroEn(x,y-1).numero()){
			  				
			  				self.fusionarNumeros(numero,numero_abajo)
			  				self.moverNumero(numero, direccion)
			  				
			  			} else {
			  				
			  				numero.movimientosFaltantes(0)
			  			
			  			}
			  		}
				}
			}
	
	} else {
		
//		if (!self.movimientosPosibles()) {
            console.println("Game over. Perdiste.")
            self.perder()
//		}
	}
}
	
	
	method fusionarNumeros(numero1, numero2) {
		
		if(!tablero.estaLleno()){
			
			if (numero1.numero() == numero2.numero()) {
				
	        	numero1.numero(numero1.numero()*2)
	        	puntajes += numero1.numero()
	        	numero1.image()
	        	
	        	
	        	tablero.borrar(tablero.armarEje(numero2.positionX(),numero2.positionY()))
	        	game.removeVisual(numero2)
	        	
	       		self.numeros().remove(numero2)
	    	} 
		} 
		else {
			if (!self.movimientosPosibles())
			self.perder()
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
	
	method perder(){
		self.musica().stop()
		game.addVisual(pantallaPerder)	
		game.stop()
	}
	
	method movimientosPosibles(){
    	if(self.movimientosPosiblesEnDireccion("arriba"))
    		return true
    	else if(self.movimientosPosiblesEnDireccion("abajo"))
    		return true
    	else if(self.movimientosPosiblesEnDireccion("izquierda"))
    		return true
    	else return self.movimientosPosiblesEnDireccion("derecha")
           
	}

	method movimientosPosiblesEnDireccion(direccion) {
		const numerosAntes = new List()
		const numerosDespues = new List()
		
		numeros.forEach{numero=>
			numerosAntes.add(numero)
			numerosDespues.add(numero)
		}
				
   		self.ordenarNumeros(direccion)

    	numerosDespues.forEach({ numero => self.moverNumero(numero, direccion) })
    	
    	return numerosAntes != numerosDespues
	}
	
}

object pantallaPuntaje {
	method position() = game.at(2,6)
	method image() = "assets/label.png"
	method text() = "Puntos: " + juego.puntajes()
	method textColor() = "FFFFFF"
}

object pantallaMovimiento {
	method position() = game.at(4,6)
	method image() = "assets/label.png"
	method text() = "Movimientos: " + juego.movimientos()
	method textColor() = "FFFFFF"
}

object pantallaPerder {
	method position() = game.at(0,0)
	method image() = "assets/gameOver.png"
}