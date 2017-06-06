def construye_tablero
	tablero = []
	v = ["a","b","c","d","e","f","g","h"]
	h_l = 0x2550
	v_l = 0x2551
	l_i_s = 0x2560
	i_s = 0x256C
	r_i_s = 0x2563
	l_c = [0x2554,0x255A]
	c_s = [0x2566,0x2569]
	r_c = [0x2557,0x255D]
	b = 0x2591
	system('cls')
	tablero << ""
	
	for z in 2.times
		string1 = ""
		string2 = ""	
		
		#Borde Superior -----------------------------------------------------------------------------------------------------
		if z == 0
			v.each {|y|string1 = string1.strip + "        #{y}"}
			string2 = "#{l_c[z].chr('UTF-8')}"	
			for i in 8.times 
				for i1 in 8.times 
					string2 = string2.strip + h_l.chr('UTF-8')	
				end	
				i < 7 ? (string2 = string2.strip + c_s[z].chr('UTF-8')) : (string2 = string2.strip + r_c[z].chr('UTF-8'))
			end
			tablero << "       #{string1}" 
			tablero << "   #{string2}"
		
			#Parte Interna
			b_o_n = "b"
			for w in 8.times
				string1 = "" 
				string2 = ""
				for x in 10.times 
					string1 = string1.strip + "#{v_l.chr('UTF-8')}" if x == 1
					if b_o_n == "b"
						string1 = string1.strip + "        #{v_l.chr('UTF-8')}" if x > 1 
						b_o_n = "n"
					else
						b_o_n = "b"
						string1 = string1.strip + "#{b.chr('UTF-8') * 8}#{v_l.chr('UTF-8')}" if x > 1 
					end       
					if x < 9
						string2 = "#{l_i_s.chr('UTF-8')}" if x == 1
						for i in 8.times 
							string2 = string2.strip + h_l.chr('UTF-8')	
						end	
						x < 7 ? (string2 = string2.strip + i_s.chr('UTF-8')) : (string2 = string2.strip + r_i_s.chr('UTF-8'))
					end	
				end
				for i in 5.times
					i == 2 ? (tablero << " #{w+1} #{string1} #{w+1}") : (tablero << "   #{string1}")
				end
				tablero << "   #{string2}" if w < 7	
				b_o_n == "b" ?  b_o_n = "n" : b_o_n = "b"
			end
		
        #Borde Inferior -----------------------------------------------------------------------------------------------------
		else
			string1 = ""
			v.each {|y|string1 = string1.strip + "        #{y}"}
			string2 = "#{l_c[z].chr('UTF-8')}"	
			for i in 8.times 
				for i1 in 8.times 
					string2 = string2.strip + h_l.chr('UTF-8')	
				end	
				i < 7 ? (string2 = string2.strip + c_s[z].chr('UTF-8')) : (string2 = string2.strip + r_c[z].chr('UTF-8'))
			end
			tablero << "   #{string2}"
			tablero << "       #{string1}" 
		end	
	end
	tablero.each {|tab|puts "#{tab}"}	
end	
construye_tablero
