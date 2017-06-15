# encoding: UTF-8

require 'pdf-reader'
require 'zip'
require 'csv'

class GetFilesInDir
	attr_reader :list
	@list = ""
	def initialize(kind)
		@list = Dir.glob("**/*").find_all { |i| i.downcase.include? kind }
	end	
	def list
		@list
	end	
	def refresh_list
		@list = Dir.glob("**/*").find_all { |i| i.downcase.include? kind }
	end
end	

class ZIPFiles
	
	attr_accessor :origen, :destino, :destino_pdfs
	attr_reader :zip_list
	
	@zip_list = []
	@origen = ""
	@destino = ""
	@destino_pdfs = ""
	
	def initialize
		@file_path = "**"
		@origen = "./ZIPs_Entrada/"
		@destino = "/ZIPs_Procesados/"
		@destino_pdfs = "/PDFs_Extraidos/"
	end

	def process_zip_list
		FileUtils.cd @origen
		l = GetFilesInDir.new('.zip')
		@zip_list = l.list
		while @zip_list.count != 0
			@zip_list.each do |path_and_file|
				self.extract_zip(path_and_file, @origen)
				extracted_file = ".." + @destino + (File.basename path_and_file)
				FileUtils.mv path_and_file, extracted_file
			end
			@zip_list = l.refresh_list
		end	
		p = GetFilesInDir.new('.pdf')
		file_list = p.list
		file_list.each do |path_and_file|
			extracted_pdf = ".." + @destino_pdfs + (File.basename path_and_file)
			FileUtils.mv path_and_file, extracted_pdf
		end
		FileUtils.cd ".."
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

	def get_files(kind)
		
	end
end	

class PDFFiles
	
	attr_reader :list, :lotes, :registros_patronales, :origen, :destino

	@pdf_files_list = []
	@lotes = []
	@registros_patronales = []
	@registros_procesados = 0
	@registros_rechazados = 0
	@origen = ""
	@destino = ""
	@destino_csv = ""
	@get_detail_lines = false
	@get_reject_lines = false

	@@reader = ""
	@@all_detail_records = []
	@@all_rejected_records = []
	@@created_at = ""
	@@title_detail_string = "TipoNSSNombreAseguradoSal.BaseExt.UMFTipoFec-MovTipoC.Baja"
	@@title_rejected_string1 = "Relacióndemovimientosrechazados"
	@@title_rejected_string2 = "T-MOVNSSNombreAseguradoError"
	@@end_of_line_or_detail_text = "SelloDigital:"
	@@end_of_rejected_text = "Paraefectos"
	@@lote_text = "Númerodelote:"
	@@registro_patronal_text = "RegistroPatronal:"
	@complete_reject_line_switch = false
	@detail_row = 0
	@rejected_row = 0	
	@arr_rechazados = Array.new(7, "")
	
	def initialize
		@lotes = []
		@registros_patronales = []
		@registros_procesados = 0
		@registros_rechazados = 0
		@origen = "./PDFs_Extraidos/"
		@destino = "/PDFs_Procesados/"
		@destino_csv = "/CSVs_Generados/"
		@@all_detail_records = []
		@@all_rejected_records = []
		@@created_at = Time.new 
		@complete_reject_line_switch = false	
		@get_detail_lines = false
		@get_reject_lines = false
		@detail_row = 0
		@rejected_row = 0
		@arr_rechazados = Array.new(7, "")
	end

	def process_pdf_list
		FileUtils.cd @origen
		p = GetFilesInDir.new('.pdf')
		@pdf_files_list = p.list
		@pdf_files_list.each do |path_and_file|
			self.process_file(path_and_file)
			processed_file = ".." + @destino + (File.basename path_and_file)
			#FileUtils.mv path_and_file, processed_file
		end
		FileUtils.cd ".."
		if @@all_detail_records.count != 0
			#puts " Entro ------------------------>  @@all_detail_records.count: #{@@all_detail_records.count}"	
			self.write_detail_in_csv
		end	
		if @@all_rejected_records.count != 0
			#puts " Entro ------------------------>  @@all_rejected_records.count: #{@@all_rejected_records.count}"	
			self.write_rejects_in_csv
		end	
	end	

	protected
	def process_file(pdf_file)
		#puts " Entro ------------------------>  process_file"	
		@@reader = PDF::Reader.new(pdf_file)
		count_page = 0
		@complete_reject_line_switch = false	
		@get_reject_lines = false
		@arr_rechazados = Array.new(7, "")

		@@reader.pages.each do |page|
			count_page += 1
			text_lines = @@reader.page(count_page).text.split(/\n/) 
			@detail_row = 0
			@rejected_row = 0
			@get_detail_lines = false
			text_lines[1..-1].each.with_index do |line, row|
				line_text_to_match = line.split(" ").join
				self.start_considering_detail_lines(row) if line_text_to_match.include? @@title_detail_string
				self.stop_of_all_type_of_lines if line_text_to_match.include? @@end_of_line_or_detail_text 
				self.stop_considering_detail_lines if line_text_to_match.include? @@title_rejected_string1
				self.start_of_rejected_lines_process(row) if line_text_to_match.include? @@title_rejected_string2
				self.stop_of_rejected_lines_process(pdf_file, count_page, row) if line_text_to_match.include? @@end_of_rejected_text
				@lotes << self.get_field_of_the_left_titles(line,"lote:") if line_text_to_match.include? @@lote_text
				@registros_patronales << self.get_field_of_the_left_titles(line,"Patronal:") if line_text_to_match.include? @@registro_patronal_text
				self.detail_line_process(pdf_file, count_page, row, line) if (row >= @detail_row and self.get_detail_lines?)
				self.rejected_line_process(pdf_file, count_page, row, line) if (row >= @rejected_row and self.get_reject_lines?) 
			end
		end
		puts "#{pdf_file} procesado #{Time.new}"
	end	
	
	def get_detail_rcd(file, lote, registro_patronal, page, line, arr)
		#puts " Entro ------------------------>  get_detail_rcd"	
		@registros_procesados += 1
		detail_rcd = [@registros_procesados, file, lote, registro_patronal, "D", page, line, @@created_at]
		detail_rcd += arr.first(2)
		detail_rcd << arr[2..arr.count.to_i-9].join(" ")
		detail_rcd += arr.last(7)
		@@all_detail_records << detail_rcd
	end	
	
	def get_rejected_detail_rcd(file, lote, registro_patronal, page, line, arr)
		#puts " Entro ------------------------>  get_rejected_detail_rcd"	
		@registros_rechazados += 1
		detail_rcd = [@registros_rechazados, file, lote, registro_patronal, "R", page, line, @@created_at]
		detail_rcd += arr
		@@all_rejected_records << detail_rcd
	end	

	def write_detail_in_csv
		#puts " Entro ------------------------>  write_detail_in_csv"	
		csv_file = "." + @destino_csv + "Detalle_Importacion.csv"
		CSV.open(csv_file,'wb', col_sep: "|",  encoding: "UTF-8") do |csvfile|
			@@all_detail_records.each do |row|
    			csvfile << row
  			end
  		end
	end	

	def write_rejects_in_csv
		#puts " Entro ------------------------>  write_rejects_in_csv"	
		csv_file = "." + @destino_csv + "Rechazos_Importacion.csv"
		CSV.open(csv_file,'wb', col_sep: "|",  encoding: "UTF-8") do |csvfile|
			@@all_rejected_records.each do |row|
    			csvfile << row
  			end
  		end
	end	

	def complete_reject_line_construction(pdf_file, count_page, row)
		#puts " Entro ------------------------>  complete_reject_line_construction"	
		self.get_rejected_detail_rcd(pdf_file, @lotes.last, @registros_patronales.last, count_page, row, @arr_rechazados)
		@complete_reject_line_switch = false
		@arr_rechazados = Array.new(7, "")
	end	

	def detail_line_process(pdf_file, count_page, row, line)
		#puts " Entro ------------------------>  detail_line_process"	
		arr_line = line.split(" ")
		if arr_line.count != 0
			self.get_detail_rcd(pdf_file, @lotes.last, @registros_patronales.last, count_page, row, arr_line)
		end	
	end

	def rejected_line_process(pdf_file, count_page, row, line)
		#puts " Entro ------------------------>  rejected_line_process"	
		arr_line = line.split(/\W\W+/)
		if arr_line.count >= 4 or (arr_line.count < 4 and arr_line.count > 1 and arr_line[1][0] == "0")
			if self.complete_reject_line_switch?
				self.complete_reject_line_construction(pdf_file, count_page, row)
			else
				if arr_line[1][0] != "0"
					@complete_reject_line_switch = true
				end
			end		
			if arr_line.count >= 4
				@arr_rechazados[0] = arr_line[1].strip
				@arr_rechazados[1] = arr_line[2].strip
				@arr_rechazados[2] = arr_line[3].strip
				if arr_line.count > 4 
					@arr_rechazados[3] = arr_line[4][0..2]
					if @arr_rechazados[4] == ""
						@arr_rechazados[4] = arr_line[4].strip
					else
						@arr_rechazados[4] = @arr_rechazados[4] + " " + arr_line[4].strip
					end	
				end	
				@arr_rechazados[5] = ""
				@complete_reject_line_switch = true
			else
				@arr_rechazados[0] = ""
				@arr_rechazados[1] = ""
				@arr_rechazados[2] = ""
				@arr_rechazados[3] = arr_line[1][0..2]
				@arr_rechazados[4] = arr_line[1]
				@arr_rechazados[5] = ""
			end	
		elsif arr_line.count < 4 and arr_line.count > 0	and arr_line[1][0] != "0"
			if line.strip.include? "Dato registrado en el IMSS"
				@arr_rechazados[5] = arr_line.last.strip
			else
				@arr_rechazados[4] = @arr_rechazados[4].strip + " " + arr_line.last.strip
			end
		end	
	end	

	def get_field_of_the_left_titles(line,texto)
		#puts " Entro ------------------------>  get_field_of_the_left_titles"
		line.split(" ")[line.split(" ").index(texto).to_i+1]
	end	

	def start_considering_detail_lines(row)
		#puts " Entro ------------------------>  start_considering_detail_lines"
		@get_detail_lines = true
		@detail_row = row + 2
	end	

	def start_of_rejected_lines_process(row)
		#puts " Entro ------------------------>  start_of_rejected_lines_process"
		self.stop_considering_detail_lines
		self.start_considering_reject_lines(row)
	end			

	def start_considering_reject_lines(row)
		#puts " Entro ------------------------>  start_considering_reject_lines"
		@get_reject_lines = true
		@rejected_row = row + 1
	end	

	def stop_considering_detail_lines
		#puts " Entro ------------------------>  stop_considering_detail_lines"
		@get_detail_lines = false
		@detail_row = 0
	end		

	def stop_of_rejected_lines_process(pdf_file, count_page, row)
		#puts " Entro ------------------------>  stop_of_rejected_lines_process"
		self.stop_of_all_type_of_lines
		self.complete_reject_line_construction(pdf_file, count_page, row) if self.complete_reject_line_switch?
	end	

	def stop_considering_reject_lines
		#puts " Entro ------------------------>  stop_considering_reject_lines"
		@get_reject_lines = false
		@rejected_row = 0
	end	

	def stop_of_all_type_of_lines
		#puts " Entro ------------------------>  stop_of_all_type_of_lines"
		self.stop_considering_detail_lines
		self.stop_considering_reject_lines
	end								

	def get_detail_lines?
		@get_detail_lines
	end								

	def get_reject_lines?
		@get_reject_lines
	end								

	def complete_reject_line_switch?
		@complete_reject_line_switch
	end	

end		

zip_list = ZIPFiles.new
zip_list.process_zip_list
pdf_list = PDFFiles.new
pdf_list.process_pdf_list