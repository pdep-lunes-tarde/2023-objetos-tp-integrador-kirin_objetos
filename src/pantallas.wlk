import wollok.game.*
import juego.*

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