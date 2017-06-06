class Ajedrez

	@@tablero = []
	@@piezas = []
	@@v = []
	@@h_l = 0
	@@v_l = 0
	@@l_i_s = 0
	@@i_s = 0
	@@r_i_s = 0
	@@l_c = []
	@@c_s = []
	@@r_c = []
	@@b = 0
	@@coordenadas = []
	@@jugada = 0
	@@turno = ""

	def initialize
		@@tablero = []
		@@piezas = []
		@@coordenadas = []
		@@v = ["A","B","C","D","E","F","G","H"]
		@@h_l = 0x2550
		@@v_l = 0x2551
		@@l_i_s = 0x2560
		@@i_s = 0x256C
		@@r_i_s = 0x2563
		@@l_c = [0x2554,0x255A]
		@@c_s = [0x2566,0x2569]
		@@r_c = [0x2557,0x255D]
		@@b = 0x2591	
		@@jugada = 0
		@@turno = "B"
	end

	def nuevo
		crea_tablero_de_juego
		crea_coordenadas_de_casillas
		establece_posiciones_iniciales
		muestra_tablero
		pone_piezas
		muestra_tablero
	end	

	def crea_tablero_de_juego
		@@tablero << ""
		genera_borde_del_Tablero(0)
		genera_parte_interna_del_tablero
		genera_borde_del_Tablero(1)
	end	

	def muestra_tablero
		system('cls')
		@@tablero.each {|tab|puts "#{tab}"}	
	end	

	def genera_borde_del_Tablero(borde)
		blank = " "
		string1 = ""
		string2 = ""	
		@@v.each {|y|string1 = string1.strip + "#{blank*8}#{y}"}
		string2 = "#{@@l_c[borde].chr('UTF-8')}"	
		for i in 8.times 
			8.times { string2 = string2.strip + @@h_l.chr('UTF-8') }
			i < 7 ? (string2 = string2.strip + @@c_s[borde].chr('UTF-8')) : (string2 = string2.strip + @@r_c[borde].chr('UTF-8'))
		end
		if borde == 0
			@@tablero << "#{blank*7}#{string1}" 
			@@tablero << "#{blank*3}#{string2}"
		else	
			@@tablero << "#{blank*3}#{string2}"
			@@tablero << "#{blank*7}#{string1}" 
		end	
	end

	def genera_parte_interna_del_tablero
		b_o_n = "b"
		blank = " "
		for w in 8.times
			string1 = "" 
			string2 = ""
			for x in 10.times 
				string1 = string1.strip + "#{@@v_l.chr('UTF-8')}" if x == 1
				if b_o_n == "b"
					string1 = string1.strip + "#{blank*8}#{@@v_l.chr('UTF-8')}" if x > 1 
					b_o_n = "n"
				else
					b_o_n = "b"
					string1 = string1.strip + "#{@@b.chr('UTF-8') * 8}#{@@v_l.chr('UTF-8')}" if x > 1 
				end       
				if x < 9
					string2 = "#{@@l_i_s.chr('UTF-8')}" if x == 1
					8.times { string2 = string2.strip + @@h_l.chr('UTF-8') }	
					x < 7 ? (string2 = string2.strip + @@i_s.chr('UTF-8')) : (string2 = string2.strip + @@r_i_s.chr('UTF-8'))
				end	
			end
			5.times.select {|i|i == 2 ? (@@tablero << " #{w+1} #{string1} #{w+1}") : (@@tablero << "#{blank*3}#{string1}") }
			@@tablero << "#{blank*3}#{string2}" if w < 7	
			b_o_n == "b" ?  b_o_n = "n" : b_o_n = "b"
		end
	end

	def crea_coordenadas_de_casillas
		linea = 5
		columna = 6
		i2 = 0
		for i in 8.times
			for i1 in @@v
				@@coordenadas[i2] = { casilla: i1+(i+1).to_s, linea: linea, columna: columna }
				columna += 9
				i2 += 1
			end	
			linea += 6
			columna = 6
		end		
	end

	def establece_posiciones_iniciales
        @@piezas << {pieza:"TN",casilla:"A8"}
		@@piezas << {pieza:"CN",casilla:"B8"}
		@@piezas << {pieza:"AN",casilla:"C8"}
		@@piezas << {pieza:"DN",casilla:"D8"}
		@@piezas << {pieza:"RN",casilla:"E8"}
		@@piezas << {pieza:"AN",casilla:"F8"}
		@@piezas << {pieza:"CN",casilla:"G8"}
		@@piezas << {pieza:"TN",casilla:"H8"}
		@@piezas << {pieza:"PN",casilla:"A7"}
		@@piezas << {pieza:"PN",casilla:"B7"}
		@@piezas << {pieza:"PN",casilla:"C7"}
		@@piezas << {pieza:"PN",casilla:"D7"}
		@@piezas << {pieza:"PN",casilla:"E7"}
		@@piezas << {pieza:"PN",casilla:"F7"}
		@@piezas << {pieza:"PN",casilla:"G7"}
		@@piezas << {pieza:"PN",casilla:"H7"}
		@@piezas << {pieza:"TB",casilla:"A1"}
		@@piezas << {pieza:"CB",casilla:"B1"}
		@@piezas << {pieza:"AB",casilla:"C1"}
		@@piezas << {pieza:"DB",casilla:"D1"}
		@@piezas << {pieza:"RB",casilla:"E1"}
		@@piezas << {pieza:"AB",casilla:"F1"}
		@@piezas << {pieza:"CB",casilla:"G1"}
		@@piezas << {pieza:"TB",casilla:"H1"}
		@@piezas << {pieza:"PB",casilla:"A2"}
		@@piezas << {pieza:"PB",casilla:"B2"}
		@@piezas << {pieza:"PB",casilla:"C2"}
		@@piezas << {pieza:"PB",casilla:"D2"}
		@@piezas << {pieza:"PB",casilla:"E2"}
		@@piezas << {pieza:"PB",casilla:"F2"}
		@@piezas << {pieza:"PB",casilla:"G2"}
		@@piezas << {pieza:"PB",casilla:"H2"}
	end

	def pone_piezas
		for i in @@piezas
			cas = i[:casilla]
			pza = i[:pieza]
			coor = posicion_de_casilla(cas)
			linea = coor[:linea]
			columna = coor[:columna] 
			@@tablero[linea][columna..(columna+3)]="(#{pza})"  				
		end
	end	

	def posicion_de_casilla(cas)
		@@coordenadas.find {|x| x[:casilla] == cas}
	end	

	def inicia_partida
		jugada = 0
		loop do
			puts ""
			if jugada != @@jugada
				jugada = @@jugada
			end	
			if @@turno == "B"
				print "Jugador Blanco, indique un movimiento: "
			else   
				print "Jugador Negro, indique un movimiento: "
			end
			respuesta = gets.chomp	
			return if (respuesta.downcase == "exit" or respuesta.downcase == "quit")
			if respuesta != nil and respuesta != "exit" and respuesta != "quit"
				mueve_pieza(respuesta)
			end	
			muestra_tablero
		end	
	end	

	def mueve_pieza(movimiento) 
		m = movimiento.upcase
		if (m.length == 3 and !["T","C","A","D","R","P"].include?(m[0])) or m.length > 3 or
			m.strip == ""
			puts "Movimiento incorrecto!"
			sleep 3
		else
			if @@turno = "B"
				@@jugada += 1	
				@@turno = "N"
			else
				@@jugada += 1	
				@@turno = "B"
			end
		end	
	end	
end

juego = Ajedrez.new
juego.nuevo
juego.inicia_partida