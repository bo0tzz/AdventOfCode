class Walker

  def walk(direction, x, y, z)
    case direction
    when 'n'
      x += 1
      y += 1
    when 'ne'
      x += 1
      z += 1
    when 'se'
      y -= 1
      z += 1
    when 's'
      x -= 1
      y -= 1
    when 'sw'
      x -= 1
      z -= 1
    when 'nw'
      y += 1
      z -= 1
    end
    return x, y, z
  end

  def distance(ax, ay, az, bx, by, bz)
    ((ax - bx).abs + (ay - by).abs + (az - bz).abs) / 2
  end

end

if $PROGRAM_NAME == __FILE__

  aFile = File.new("input.txt", "r")
  if aFile
    content = aFile.readline()
  else
    puts "Unable to open file!"
  end

  w = Walker.new

  steps = content.split(',')

  x, y, z, furthest = 0, 0, 0, 0
  steps.each do |s|
    x, y, z = w.walk(s, x, y, z)
    d = w.distance(x, y, z, 0, 0, 0)
    if d > furthest
      furthest = d
    end
  end

  puts furthest

end
