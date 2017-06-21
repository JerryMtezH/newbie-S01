# encoding: UTF-8
require 'pdf-reader'
require 'zip'
require 'csv'
require 'net/ftp'

class GetZIPFiles
	
	attr_accessor :origen, :destino, :destino_pdfs, :created_at, :current_dir, :root_dir, :zips_entrada, :zips_procesados, :pdfs_extraidos, :pdfs_procesados, :csvs_generados, :csvs_enviados
	attr_reader :zip_list
	
	@zip_list = []
	@origen = ""
	@destino = ""
	@destino_pdfs = ""
	@created_at = ""
	@created_dirs = false
	@root_dir = ""
	@current_dir = ""
	@files_to_process = false
	@zips_entrada = ""
	@zips_procesados = ""
	@pdfs_extraidos = ""
	@pdfs_procesados = ""
	@csvs_generados = ""
	@csvs_enviados = ""
	
	def initialize
		@file_path = "**"
		@origen = "/ZIPs_Para_Importacion/"
		@created_at = Time.new
		@root_dir = "/" + @created_at.to_s.split("-").join.to_s.split(":").join.to_s.split(" ").join("_")[0..14] + "/"
		@current_dir = FileUtils.pwd
		@files_to_process = false
		@created_dirs = false
		@root_dir = @current_dir + @root_dir
		@zips_entrada = "ZIPs_Entrada/"
		@zips_procesados = "ZIPs_Procesados/"	
		@pdfs_extraidos = "PDFs_Extraidos/"
		@pdfs_procesados = "PDFs_Procesados/"
		@csvs_generados = "CSVs_Generados/"
		@csvs_enviados = "CSVs_Enviados/"
	end

	def process_zip_list
		work_dir = @current_dir + @origen
		FileUtils.cd work_dir
		l = GetFilesInDir.new('.zip')
		while l.list.count != 0
			l.list.each do |path_and_file|
				if not self.created_dirs?
					self.create_dir_tree
				end	
				dir = @root_dir + @zips_entrada
				FileUtils.mv path_and_file, dir
			end
			l.refresh_list('.zip')
		end	
		if self.created_dirs?
			work_dir = @root_dir + @zips_entrada
			to_dir_zips = @root_dir + @zips_procesados
			to_dir_pdfs = @root_dir + @pdfs_extraidos
			FileUtils.cd work_dir
			l = GetFilesInDir.new('.zip')
			while l.list.count != 0
				l.list.each do |path_and_file|
					self.extract_zip(path_and_file, @zips_entrada)
					FileUtils.mv path_and_file, to_dir_zips
				end
				l.refresh_list('.zip')
			end	
			p = GetFilesInDir.new('.pdf')
			p.list.each do |path_and_file|
				FileUtils.mv path_and_file, to_dir_pdfs
				@files_to_process = true
			end
			FileUtils.cd @root_dir
		else
			puts "No existen archivos que procesar..."
		end		
	end	

	def something_to_process?
		@files_to_process
	end	

	protected
	def extract_zip(file, destination)
		Zip::File.open(file) do |zip_file|
		    zip_file.each do |f|
			    fpath = f.name
			    zip_file.extract(f, fpath) unless File.exist?(fpath)
		    end
	    end
	end	
	def created_dirs?
		@created_dirs
	end	

	def create_dir_tree
		last_dir = FileUtils.pwd
		FileUtils.mkdir @root_dir
		FileUtils.cd @root_dir
		FileUtils.mkdir "./CSVs_Generados"
		FileUtils.mkdir "./CSVs_Enviados"
		FileUtils.mkdir "./PDFs_Extraidos"
		FileUtils.mkdir "./PDFs_Procesados"
		FileUtils.mkdir "./ZIPs_Procesados"
		FileUtils.mkdir "./ZIPs_Entrada"
		@created_dirs = true
		FileUtils.cd last_dir
	end
end	

class PDFFiles
	
	attr_reader :list, :lotes, :regpats, :pdf_files_list
	attr_accessor :origen_pdf, :destino_pdf, :destino_csv, :root_dir, :csv_enviados

	@created_at = ""
	@pdf_files_list = []
	@lotes = []
	@regpats = []
	@registros_ctl = 0
	@registros_procesados = 0
	@registros_rej = 0
	@origen_pdf = ""
	@destino_pdf = ""
	@destino_csv = ""
	@csv_enviados = ""
	@root_dir = ""
	@get_ctl_lines = false
	@get_det_lines = false
	@get_rej_lines = false
	@complete_rej_line_switch = false
	@ctl_row = 0
	@det_row = 0
	@rej_row = 0	
	@rej_arr = Array.new(7, "")
	@count_files = 0
	@d_opr_bajas = 0
	@d_opr_modif = 0
	@d_opr_reing = 0
	@d_opr_total = 0
	@d_rej_bajas = 0
	@d_rej_modif = 0
	@d_rej_reing = 0
	@d_rej_total = 0
	@ctl_rej_movs = []
	@ctl_opr_movs = []
	@ctl_rec_movs = []

	@@reader = ""
	@all_ctl_records = []
	@all_det_records = []
	@all_rej_records = []
	@@title_det_string = "TipoNSSNombreAseguradoSal.BaseExt.UMFTipoFec-MovTipoC.Baja"
	@@title_rej_string1 = "Relacióndemovimientosrechazados"
	@@title_rej_string2 = "T-MOVNSSNombreAseguradoError"
	@@end_of_line_or_det_txt = "SelloDigital:"
	@@end_of_rej_txt_1 = "Paraefectos"
	@@end_of_rej_txt_2 = "deSeguridadSocial),Sal.Base(Salariobase)"
	@@lote_txt = "Númerodelote:"
	@@reg_pat_txt = "RegistroPatronal:"
	@@ctl_record_string = "BajasModif.Reing.TotalBajasModif.Reing.TotalBajasModif.Reing.Total"
	@@sep = "|"
	@logfile = ""
	
	def initialize(created_at)
		@lotes = []
		@regpats = []
		@registros_ctl = 0
		@registros_procesados = 0
		@registros_rej = 0
		@origen_pdf = ""
		@destino_pdf = ""
		@destino_csv = ""
		@root_dir = ""
		@csv_enviados = ""
		@complete_rej_line_switch = false	
		@get_ctl_lines = false
		@get_det_lines = false
		@get_rej_lines = false
		@ctl_row = 0
		@det_row = 0
		@rej_row = 0
		@rej_arr = Array.new(7, "")
		@count_files = 0
		@d_opr_bajas = 0
		@d_opr_modif = 0
		@d_opr_reing = 0
		@d_opr_total = 0
		@d_rej_bajas = 0
		@d_rej_modif = 0
		@d_rej_reing = 0
		@d_rej_total = 0
		@ctl_rej_movs = []
		@ctl_opr_movs = []
		@ctl_rec_movs = []
		@all_ctl_records = []
		@all_det_records = []
		@all_rej_records = []
		@created_at = created_at
		@date_and_time_for_files = @created_at.to_s.split("-").join.to_s.split(":").join.to_s.split(" ").join("_")[0..14]
	end

	def process_pdf_list
		@logfile = @root_dir + @destino_csv + "LI1_" + @date_and_time_for_files + ".tmp"
		$stdout.reopen(@logfile, "w")
		$stdout.sync = true
		$stderr.reopen($stdout)
		count_files = 0
		last_dir = FileUtils.pwd
		work_dir = @root_dir + @origen_pdf
		FileUtils.cd work_dir
		p = GetFilesInDir.new('.pdf')
		@pdf_files_list = p.list
		puts "------------------------> Archivos Seleccionados: #{@pdf_files_list.count}"
		@pdf_files_list.each do |path_and_file|
			count_files += 1
			puts "------------------------>  Inicia: #{path_and_file}  (#{count_files}) "
			self.process_file(path_and_file)
			processed_file = @root_dir + @destino_pdf
			FileUtils.mv path_and_file, processed_file
		end
		if @all_ctl_records.count != 0
			puts " Total ------------------------>  @all_ctl_records.count: #{@all_ctl_records.count}"	
			self.write_ctl_in_csv_as_stdout
		end	
		if @all_det_records.count != 0
			puts " Total ------------------------>  @all_det_records.count: #{@all_det_records.count}"	
			self.write_det_in_csv_as_stdout
		end	
		if @all_rej_records.count != 0
			puts " Total ------------------------>  @all_rej_records.count: #{@all_rej_records.count}"	
			self.write_rejs_in_csv_as_stdout
		end	
		@logfile = @root_dir + @destino_csv + "LI5_" + @date_and_time_for_files + ".zzz"
		$stdout.reopen(@logfile, "w")
		$stdout.sync = true
		$stderr.reopen($stdout)
		dir = @root_dir + @destino_csv
		FileUtils.cd dir
		log_final = "Log_Importacion_" + @date_and_time_for_files + ".txt"
		tmp_files_to_merge = "*#{@date_and_time_for_files}" + ".tmp"
		p tmp_files_to_merge
		File.open(log_final,'a') do |mergedfile|
		  	Dir.glob("#{tmp_files_to_merge}").each do |file|
		    	File.foreach(file) do |li|
		      		mergedfile.write(li)
		    	end
		  	end
		end
		FileUtils.cd last_dir
	end	

	def send_files_to_ibm_server(site)
		ftp_site = site
		@logfile = @root_dir + @csv_enviados + "Log_Envio_" + @date_and_time_for_files + ".txt"
		$stdout.reopen(@logfile, "w")
		$stdout.sync = true
		$stderr.reopen($stdout)
		count_files = 0
		FileUtils.cd @root_dir + @destino_csv
		c = GetFilesInDir.new('.csv')
		csv_files_list = c.list
		puts "------------------------> Archivos CSV Seleccionados: #{csv_files_list.count}"
		puts csv_files_list
		csv_files_list.each do |path_and_file|
			puts "------------------------> Procesa Archivo: #{path_and_file}"
			count_files += 1
			dir_of_file = @root_dir + @destino_csv
			sending_file = File.basename path_and_file
			ftp_site.transfer_files(dir_of_file, sending_file, "./inbound")
			processed_file = @root_dir + @csv_enviados
			FileUtils.mv path_and_file, processed_file
		end
		t = GetFilesInDir.new('.txt')
		txt_files_list = t.list
		puts "------------------------> Archivos TXT Seleccionados: #{txt_files_list.count}"
		puts txt_files_list
		txt_files_list.each do |path_and_file|
			puts "------------------------> Procesa Archivo: #{path_and_file}"
			count_files += 1
			dir_of_file = @root_dir + @destino_csv
			sending_file = File.basename path_and_file
			ftp_site.transfer_files(dir_of_file, sending_file, "./inbound")
			processed_file = @root_dir + csv_enviados
			FileUtils.mv path_and_file, processed_file
		end
		ftp_site.dirlist("./inbound")
	end	

	protected
	def process_file(pdf_file)
		#puts " Entro ------------------------>  process_file #{pdf_file}"	
		@@reader = PDF::Reader.new(pdf_file)
		count_page = 0
		@complete_rej_line_switch = false	
		@get_rej_lines = false
		@get_ctl_lines = false
		@rej_arr = Array.new(7, "")
		@d_opr_bajas = 0
		@d_opr_modif = 0
		@d_opr_reing = 0
		@d_opr_total = 0
		@d_rej_bajas = 0
		@d_rej_modif = 0
		@d_rej_reing = 0
		@d_rej_total = 0

		@@reader.pages.each do |page|
			count_page += 1
			#puts " Entro ------------------------>  reader.pages.each (page: #{count_page})"	
			txt_lines = @@reader.page(count_page).text.split(/\n/) 
			@ctl_row = 0
			@det_row = 0
			@rej_row = 0
			@get_ctl_lines = false
			@get_det_lines = false
			txt_lines[1..-1].each.with_index do |line, row|
				#puts "C:#{@ctl_row} R:#{row} #{line.split(" ")}"
				txt_match = line.split(" ").join
				@lotes << self.get_field_of_the_left_titles(line,"lote:") if txt_match.include? @@lote_txt
				@regpats << self.get_field_of_the_left_titles(line,"Patronal:") if txt_match.include? @@reg_pat_txt
				self.str_considering_ctl_line(row) if txt_match.include? @@ctl_record_string
				self.str_considering_det_lines(row) if txt_match.include? @@title_det_string
				self.stp_of_all_type_of_lines if txt_match.include? @@end_of_line_or_det_txt 
				self.stp_considering_det_lines if txt_match.include? @@title_rej_string1
				self.str_of_rej_lines_process(row) if txt_match.include? @@title_rej_string2
				self.stp_of_rej_lines_process(pdf_file, count_page, row) if (txt_match.include? @@end_of_rej_txt_1 or txt_match.include? @@end_of_rej_txt_2)
				self.ctl_line_process(pdf_file, count_page, row, line) if (row >= @ctl_row and self.get_ctl_lines?)
				self.det_line_process(pdf_file, count_page, row, line) if (row >= @det_row and self.get_det_lines?)
				self.rej_line_process(pdf_file, count_page, row, line) if (row >= @rej_row and self.get_rej_lines?) 
			end
		end
		@count_files += 1
		@ctl_opr_movs << [@count_files,pdf_file,[@d_opr_bajas,@d_opr_modif,@d_opr_reing,@d_opr_total]]
		@ctl_rej_movs << [@count_files,pdf_file,[@d_rej_bajas,@d_rej_modif,@d_rej_reing,@d_rej_total]]
		@ctl_rec_movs << [@count_files,pdf_file,[(@d_rej_bajas + @d_opr_bajas),(@d_rej_modif + @d_opr_modif),(@d_rej_reing + @d_opr_reing),(@d_rej_total + @d_opr_total)]]
		puts "------------------------> Cifras a Detalle procesadas directamente renglon por renglon:"
		puts "  Recibidas (B, M, R y T): #{@ctl_rec_movs.last}"
		puts "   Operadas (B, M, R y T): #{@ctl_opr_movs.last}"
		puts " Rechazadas (B, M, R y T): #{@ctl_rej_movs.last}"
		puts "  Fecha y Hora de Proceso: #{Time.new}"
		puts "------------------------> Termina: #{pdf_file}  (#{@count_files})"
	end	

	def ctl_line_process(pdf_file, count_page, row, line) 
		#puts " Entro ------------------------>  ctl_line_process"	
		arr_line = line.split(" ")
		if arr_line.count == 12
			self.set_ctl_rcd(pdf_file, @lotes.last, @regpats.last, count_page, row, arr_line)
			self.stp_considering_ctl_lines
			puts "------------------------> Cifras en el registro de Control:"
			puts "  Rec_bajas: #{arr_line[0]}"
	    	puts "  Rec_modif: #{arr_line[1]}"
	    	puts "  Rec_reing: #{arr_line[2]}" 
	    	puts "  Rec_total: #{arr_line[3]}"
	    	puts "  opr_bajas: #{arr_line[4]}"
	    	puts "  opr_modif: #{arr_line[5]}"
	    	puts "  opr_reing: #{arr_line[6]}"
	    	puts "  opr_total: #{arr_line[7]}"
	    	puts "  rej_bajas: #{arr_line[8]}" 
	    	puts "  rej_modif: #{arr_line[9]}" 
	    	puts "  rej_reing: #{arr_line[10]}"
	    	puts "  rej_total: #{arr_line[11]}"
		end
	end	

	def det_line_process(pdf_file, count_page, row, line)
		#puts " Entro ------------------------>  det_line_process"	
		arr_line = line.split(" ")
		if arr_line.count != 0
			self.set_det_rcd(pdf_file, @lotes.last, @regpats.last, count_page, row, arr_line)
		end	
	end

	def rej_line_process(pdf_file, count_page, row, line)
		#puts " Entro ------------------------>  rej_line_process"	
		arr_line = line.split(/\W\W+/)
		if arr_line.count >= 4 or (arr_line.count < 4 and arr_line.count > 1 and arr_line[1][0] == "0")
			if self.complete_rej_line_switch?
				self.complete_rej_line_construction(pdf_file, count_page, row)
			else
				if arr_line[1][0] != "0"
					@complete_rej_line_switch = true
				end
			end		
			if arr_line.count >= 4
				@rej_arr[0] = arr_line[1].strip
				@rej_arr[1] = arr_line[2].strip
				@rej_arr[2] = arr_line[3].strip
				if arr_line.count > 4 
					@rej_arr[3] = arr_line[4][0..2]
					if @rej_arr[4] == ""
						@rej_arr[4] = arr_line[4].strip
					else
						@rej_arr[4] = @rej_arr[4] + " " + arr_line[4].strip
					end	
				end	
				@rej_arr[5] = ""
				@complete_rej_line_switch = true
			else
				@rej_arr[0] = ""
				@rej_arr[1] = ""
				@rej_arr[2] = ""
				@rej_arr[3] = ""
				@rej_arr[4] = arr_line[1]
				@rej_arr[5] = ""
			end	
		elsif arr_line.count < 4 and arr_line.count > 0	and arr_line[1][0] != "0"
			if line.strip.include? "Dato registrado en el IMSS"
				@rej_arr[5] = arr_line.last.strip
			else
				@rej_arr[4] = @rej_arr[4].strip + " " + arr_line.last.strip
			end
		end	
	end	

	def set_ctl_rcd(file, lote, reg_pat, page, line, arr)
		#puts " Entro ------------------------>  set_ctl_rcd"	
		@registros_ctl += 1
		det_rcd = [@registros_ctl, file, lote, reg_pat, "C", page, line, @created_at]
		det_rcd += arr
		@all_ctl_records << det_rcd
		#puts " Ctl. Rec: #{@all_ctl_records.last}"
	end	
	
	def set_det_rcd(file, lote, reg_pat, page, line, arr)
		#puts " Entro ------------------------>  set_det_rcd"	
		@registros_procesados += 1
		det_rcd = [@registros_procesados, file, lote, reg_pat, "D", page, line, @created_at]
		det_rcd += arr.first(2)
		det_rcd << arr[2..arr.count.to_i-9].join(" ")
		det_rcd += arr.last(7)
		@all_det_records << det_rcd
		@d_opr_bajas += 1 if det_rcd[8].to_i == 2
    	@d_opr_modif += 1 if det_rcd[8].to_i == 7
    	@d_opr_reing += 1 if det_rcd[8].to_i == 8 
    	@d_opr_total += 1 
    	#puts " Det. Rec: #{@all_det_records.last}"
    	#puts " ----- Opr. Bajas: #{@d_opr_bajas}"
    	#puts " ----- Opr. Modif: #{@d_opr_modif}"
    	#puts " ----- Opr. Reing: #{@d_opr_reing}"
    	#puts " ----- Opr. Total: #{@d_opr_total}"
	end	
	
	def set_rej_det_rcd(file, lote, reg_pat, page, line, arr)
		#puts " Entro ------------------------>  set_rej_det_rcd"	
		@registros_rej += 1
		det_rcd = [@registros_rej, file, lote, reg_pat, "R", page, line, @created_at]
		arr[3] = arr[4][0..2]
		det_rcd += arr
		@all_rej_records << det_rcd
		@d_rej_bajas += 1 if det_rcd[8].to_i == 2
    	@d_rej_modif += 1 if det_rcd[8].to_i == 7
    	@d_rej_reing += 1 if det_rcd[8].to_i == 8 
    	@d_rej_total += 1 
    	#puts " Rej. Rec: #{@all_rej_records.last}"
	end	

	def get_field_of_the_left_titles(line,txto)
		#puts " Entro ------------------------>  get_field_of_the_left_titles"
		line.split(" ")[line.split(" ").index(txto).to_i+1]
	end	

	def str_considering_ctl_line(row)
		#puts " Entro ------------------------>  str_considering_ctl_line"
		@get_ctl_lines = true
		@ctl_row = row + 2
	end		

	def str_considering_det_lines(row)
		#puts " Entro ------------------------>  str_considering_det_lines"
		self.stp_considering_ctl_lines
		@get_det_lines = true
		@det_row = row + 2
	end	

	def str_of_rej_lines_process(row)
		#puts " Entro ------------------------>  str_of_rej_lines_process"
		self.stp_considering_ctl_lines
		self.stp_considering_det_lines
		self.str_considering_rej_lines(row)
	end			

	def str_considering_rej_lines(row)
		#puts " Entro ------------------------>  str_considering_rej_lines"
		self.stp_considering_ctl_lines
		@get_rej_lines = true
		@rej_row = row + 1
	end	

	def complete_rej_line_construction(pdf_file, count_page, row)
		#puts " Entro ------------------------>  complete_rej_line_construction"	
		self.set_rej_det_rcd(pdf_file, @lotes.last, @regpats.last, count_page, row, @rej_arr)
		@complete_rej_line_switch = false
		@rej_arr = Array.new(7, "")
	end	

	def stp_considering_ctl_lines
		#puts " Entro ------------------------>  stp_considering_ctl_lines"
		@get_ctl_lines = false
		@ctl_row = 0
	end		

	def stp_considering_det_lines
		#puts " Entro ------------------------>  stp_considering_det_lines"
		@get_det_lines = false
		@det_row = 0
	end		

	def stp_of_rej_lines_process(pdf_file, count_page, row)
		#puts " Entro ------------------------>  stp_of_rej_lines_process"
		self.stp_of_all_type_of_lines
		self.complete_rej_line_construction(pdf_file, count_page, row) if self.complete_rej_line_switch?
	end	

	def stp_considering_rej_lines
		#puts " Entro ------------------------>  stp_considering_rej_lines"
		@get_rej_lines = false
		@rej_row = 0
	end	

	def stp_of_all_type_of_lines
		#puts " Entro ------------------------>  stp_of_all_type_of_lines"
		self.stp_considering_ctl_lines
		self.stp_considering_det_lines
		self.stp_considering_rej_lines
	end								

	def get_ctl_lines?
		@get_ctl_lines
	end	

	def get_det_lines?
		@get_det_lines
	end								

	def get_rej_lines?
		@get_rej_lines
	end								

	def complete_rej_line_switch?
		@complete_rej_line_switch
	end	

	def write_ctl_in_csv_as_stdout
		#puts " Entro ------------------------>  write_ctl_in_csv_as_stdout"	
		tot_arr = [" ", "Total_General_Proceso", " ", " "," "," "," ",@created_at] + Array.new(36, 0)
		idx = 0
		csv_file = @root_dir + @destino_csv + "Cifras_Importacion_" + @date_and_time_for_files + ".csv"
		$stdout.reopen(csv_file, "w")
		$stdout.sync = true
		$stderr.reopen($stdout)
		puts "Rcd|Archivo|Lote|reg_pat|Tipo|Pagina|Renglon|Fecha|C.ctl_Rec_Bajas|C.ctl_Rec_Modif|C.ctl_Rec_Reing|C.ctl_Rec_Total|C.ctl_opr_Bajas|C.ctl_opr_Modif|C.ctl_opr_Reing|C.ctl_opr_Total|C.ctl_rej_Bajas|C.ctl_rej_Modif|C.ctl_rej_Reing|C.ctl_rej_Total|R.Det_Rec_Bajas|R.Det_Rec_Modif|R.Det_Rec_Reing|R.Det_Rec_Total|R.Det_opr_Bajas|R.Det_opr_Modif|R.Det_opr_Reing|R.Det_opr_Total|R.Det_rej_Bajas|R.Det_rej_Modif|R.Det_rej_Reing|R.Det_rej_Total|V.Dif_Rec_Bajas|V.Dif_Rec_Modif|V.Dif_Rec_Reing|V.Dif_Rec_Total|V.Dif_opr_Bajas|V.Dif_opr_Modif|V.Dif_opr_Reing|V.Dif_opr_Total|V.Dif_rej_Bajas|V.Dif_rej_Modif|V.Dif_rej_Reing|V.Dif_rej_Total".force_encoding('utf-8').encode('iso-8859-1')
		@all_ctl_records.each do |row|
			@ctl_rec_movs[idx][2].each {|x|row << x.to_s}
			@ctl_opr_movs[idx][2].each {|x|row << x.to_s}
			@ctl_rej_movs[idx][2].each {|x|row << x.to_s}
			12.times do |x|
				row << (row[x+8].to_i - row[x+20].to_i).to_s 	
			end
			row[0..42].each {|r| print "#{r}|"}
			puts row[43]
			36.times do |x|
				tot_arr[x+8] += row[x+8].to_i
			end
			idx += 1	
		end
  		tot_arr[0..42].each {|r| print "#{r}|"}
		puts tot_arr[43]
		@logfile = @root_dir + @destino_csv + "LI2_" + @date_and_time_for_files + ".tmp"
		$stdout.reopen(@logfile, "w")
		$stdout.sync = true
		$stderr.reopen($stdout)
	end	

	def write_det_in_csv_as_stdout
		#puts " Entro ------------------------>  write_det_in_csv_as_stdout"	
		csv_file = @root_dir + @destino_csv + "Detalle_Importacion_" + @date_and_time_for_files + ".csv"
		$stdout.reopen(csv_file, "w")
		$stdout.sync = true
		$stderr.reopen($stdout)
		puts "Rcd|Archivo|Lote|reg_pat|Tipo|Pagina|Renglon|Fecha|Tipo|NSS|Nombre_Asegurado|Sal_Base|Ext|UMF|Tipo|Fec-Mov|Tipo|Cod_Baja"
		@all_det_records.each do |x|
			x[0..9].each {|r| print "#{r}|"}
			print "#{x[10].force_encoding('utf-8').encode('iso-8859-1')}|"
	    	x[11..16].each {|r| print "#{r}|"}
	    	puts x[17]
		end	
		@logfile = @root_dir + @destino_csv + "LI3_" + @date_and_time_for_files + ".tmp"
		$stdout.reopen(@logfile, "w")
		$stdout.sync = true
		$stderr.reopen($stdout)
	end	

	def write_rejs_in_csv_as_stdout
		#puts " Entro ------------------------>  write_rejs_in_csv_as_stdout"	
  		csv_file = @root_dir + @destino_csv + "Rechazos_Importacion_" + @date_and_time_for_files + ".csv"
		$stdout.reopen(csv_file, "w")
		$stdout.sync = true
		$stderr.reopen($stdout)
		puts "Rcd|Archivo|Lote|reg_pat|Tipo|Pagina|Renglon|Fecha|T-Mov|NSS|Nombre_Asegurado|Codigo_Error|Error|Dato_Adicional"
		@all_rej_records.each do |x|
			x[0..9].each {|r| print "#{r}|"}
			x[10..12].each {|r| print "#{r.force_encoding('utf-8').encode('iso-8859-1')}|" }
			puts x[13].force_encoding('utf-8').encode('iso-8859-1')	
		end	
		@logfile = @root_dir + @destino_csv + "LI4_" + @date_and_time_for_files + ".tmp"
		$stdout.reopen(@logfile, "w")
		$stdout.sync = true
	end
end	

class GetFilesInDir

	attr_reader :list
	
	@list = ""
	
	def initialize(kind = " ")
		self.refresh_list(kind)
	end	
	def list
		@list
	end	
	def refresh_list(kind)
		@list = Dir.glob("**/*").find_all { |i| i.downcase.include? kind }
	end
	def list_all
		@list = Dir.glob("**/*")
	end
end	

class Ftp_manager

	attr_reader :server
	attr_accessor :server, :login, :password

	@server = ""
	@login = ""
	@password = ""
	
	def initialize(server, login, password)
		@server = server
		@login = login
		@password = password
	end	

	def dirlist(destino)
		Net::FTP.open(@server, @login, @password) do |ftp|
		  ftp.chdir(destino)
		  files = ftp.list
		  puts "--------------- > list files in directory #{destino}:"
		  puts files
		end
	end
	def transfer_files(dir, file, destino)
		localfile = dir + file
		Net::FTP.open(@server, @login, @password) do |ftp|
			ftp.debug_mode = true
			ftp.chdir(destino)
		 	ftp.puttextfile(localfile, remotefile = File.basename(localfile))
		end
	end	
end	

input_array = ARGV
server = input_array[0]
user = input_array[1]
password = input_array[2]

zip_list = GetZIPFiles.new
zip_list.process_zip_list
if zip_list.something_to_process?
	pdf_list = PDFFiles.new(zip_list.created_at)
	pdf_list.root_dir = zip_list.root_dir
	pdf_list.origen_pdf = zip_list.pdfs_extraidos
	pdf_list.destino_pdf = zip_list.pdfs_procesados
	pdf_list.destino_csv = zip_list.csvs_generados
	pdf_list.csv_enviados = zip_list.csvs_enviados
	pdf_list.process_pdf_list
	if pdf_list.pdf_files_list.count != 0
		ftp = Ftp_manager.new(server, user, password)
		pdf_list.send_files_to_ibm_server(ftp)
	end	
end	