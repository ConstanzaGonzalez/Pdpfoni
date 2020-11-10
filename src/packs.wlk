class Pack{
	
	const fechaVencimiento
	
	method vencido() = fechaVencimiento < new Date()
	
	method satisfaceConsumo(consumo) = not self.vencido() and self.cubre(consumo)
	
	method cubre(consumo)
	
	method producirGasto(consumo)
	
	method estaAcabado() = false
	
	method sirve() = not self.vencido() or not self.estaAcabado()
}

class CreditoDisponible inherits Pack{
	var credito
	
	override method cubre(consumo) = consumo.costo() <= credito
	
	override method producirGasto(consumo){
		credito -= consumo.costo()
	} 
	
	override method estaAcabado() = credito == 0
}
class MbLibres inherits Pack {
	
	var property cantidadMB
	
	override method cubre(consumo) = consumo.cubreInternet()
	
	override method producirGasto(consumo){
		cantidadMB -= consumo.cantidadMB()
	}
	
	override method estaAcabado() = cantidadMB == 0
}

class MbLibresPlus inherits MbLibres {
	
	override method cubre(consumo) = super(consumo) and self.cantidadMB() < 0.1
	
}


class LlamadasGratis inherits Pack{
	
	override method cubre(consumo) = consumo.cubreLlamadas()
}
class InternetIliminadoLosFindes inherits Pack{
	
	override method cubre(consumo) = consumo.cubreInternet() and consumo.esFinde()
}