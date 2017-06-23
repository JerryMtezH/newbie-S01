class SuperSay
  def say(text)
    puts "Entró ------> say de la clase SuperSay"
    text
  end

  def prepare_text(text)
    puts "Entró ------> prepare_text de la clase SuperSay"
    "<p>" + text + "</p>"
  end
end

class HtmlSay < SuperSay
  def say(text)
    puts "Entró ------> say de la clase HtmlSay"
    prepare_text(text)
  end

  def prepare_text(text)
    puts "Entró ------> prepare_text de la clase HtmlSay"
    super
  end
end

class CssSay < HtmlSay
  def say(text)
    puts "Entró ------> say de la clase CssSay"
    super
  end

  def prepare_text(text)
    puts "Entró ------> prepare_text de la clase CssSay"
    do_something_with(text)
  end

  def do_something_with(text)
    puts "Entró ------> do_something_with de la clase CssSay"
    text
  end
end

doc = HtmlSay.new
style = CssSay.new

#test
p doc.say("You've refactored") == "<p>You've refactored</p>"
p style.say("I like to code") == "I like to code"