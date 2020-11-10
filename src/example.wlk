/** First Wollok example */
class Linea {
	var packs = []
	const consumos = []
	var property deuda = 0
	
	var tipoLinea
	
	method consumosEnRangoDeFecha(inicial, final) = consumos.filter({consumo => consumo.consumidoEntre(inicial,final)})
	
	method promedioConsumo(inicial, final) = self.sumaCostosEnRangoFecha(inicial, final) / self.consumosEnRangoDeFecha(inicial,final).size()
	
	method sumaCostosEnRangoFecha(inicial, final) = self.consumosEnRangoDeFecha(inicial, final).sum({ consumo => consumo.costo()})
	
	method costoUltimosTreintaDias() = self.consumosEnRangoDeFecha(new Date().minusDays(30), new Date())
	
	method agregarPack(pack){
		packs.add(pack)
	}
	method puedeSatisfacerConsumo(consumo) = packs.any({pack => pack.satisfaceConsumo(consumo)})
	
	method realizarConsumo(consumo){
		if (not self.puedeSatisfacerConsumo(consumo)) tipoLinea.accionar(self, consumo)
		else self.consumirPack(consumo)
	}
	
	method consumirPack(consumo){
		consumos.add(consumo)
		const pack = packs.reverse().find({pack => pack.satisfaceConsumo(consumo)})
		pack.producirGasto(consumo)
	}
	method limpiarPacks(){
		packs = packs.filter({pack => pack.sirve()})
	}
	method sumarDeuda(costo){
		deuda += costo
	}
}

object black{
	method accionar(linea, consumo){
		linea.sumarDeuda(consumo.costo())
	}
	
}
object platinum{
	method accionar(linea, consumo){}
	
}
object comun{
	method accionar(linea, consumo){
		self.error("No existe ningun pack que pueda satisfacer ese consumo")
	}
}


class Consumo{
	var property fecha = new Date()
	
	method consumidoEntre(inicial,final) = fecha.between(inicial, final)
	
	method cubreInternet() = false
	
	method cubreLlamadas() = false
	
	method esFinde() = fecha.isWeekendDay()
}

class ConsumoInternet inherits Consumo{
	
	var property cantidadMB 
	
	method costo() = cantidadMB * pdpfoni.precioMB()
	
	override method cubreInternet() = true

}

class ConsumoLlamadas inherits Consumo{
	
	var segundos
	const segundosFijo = 30
	
	method costo() {
		if (segundosFijo > segundos) return pdpfoni.precioFijoLlamada() 
		return pdpfoni.precioFijoLlamada() + (segundos - segundosFijo) * pdpfoni.precioSegundo()	
	}
	
	override method cubreLlamadas() = true
}

object pdpfoni{
	var property precioMB = 10
	var property precioSegundo = 10
	var property precioFijoLlamada = 10
}