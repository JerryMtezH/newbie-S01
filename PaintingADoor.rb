#Codigo:
class Painting
  attr_accessor :color, :painting_object
  attr_reader :how_it_looks
  def initialize
  end
  def paint
    puts "Paint..."
  end  
  def how_it_looks
    @how_it_looks = "looks great!"
  end  
end

class PaintedObject < Painting
  attr_accessor :color
  def initialize
  end
  def spray_paint(color)
    return "The #{color.capitalize} #{painting_object} #{how_it_looks}"
  end
  def brush_paint(color)
    return "The #{color.capitalize} #{painting_object} was brushed painted and #{how_it_looks}"
  end
end  
#Resultado del Ejercicio.......
big_door = PaintedObject.new
big_door.painting_object = 'door'
p big_door.spray_paint('yellow') == "The Yellow door looks great!"

#Pruebas Adicionales......
big_door.paint
p big_door.brush_paint('yellow')