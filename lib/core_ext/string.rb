class String
  COLORS = { red: 31,
    green: 32,
    yellow: 33,
    blue: 34,
    pink: 35
  }

  # colorization
  def colorize(color_code)
    "\e[#{color_code}m#{self}\e[0m"
  end

  COLORS.each do |color, code|
    define_method(color) { colorize(code) }
  end
end
