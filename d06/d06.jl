function parse_point(ev::String)
  rx = r"^(\d+),\s*(\d+)$"
  m = match(rx, ev)
  return (map(p -> parse(Int32, p), m.captures))
end

function dist(p1,p2)
  return abs(p1[1] - p2[1]) + abs(p1[2] - p2[2])
end

function threat_area(points, safe_size)

  xextr = extrema(map(p -> p[1], points))
  yextr = extrema(map(p -> p[2], points))

  lies_at_border = zeros(Bool, length(points))

  cnt_danger = zeros(Int32, length(points))
  cnt_safe = 0

  for x in xextr[1]:xextr[2], y in yextr[1]:yextr[2]
    dists = map(p -> dist(p, (x,y)), points)

    if sum(dists) < safe_size
      cnt_safe += 1
    end

    min,min_idx = findmin(dists)
    if length(filter(z -> z == min, dists)) == 1 && !lies_at_border[min_idx]
      if x in xextr || y in yextr
        lies_at_border[min_idx] = true
        continue
      end
      cnt_danger[min_idx] += 1
    end
  end

  return (dangerous=maximum(cnt_danger), safe=cnt_safe)
end
  
function foo()
  points = open("in/input") do f
    map(p -> parse_point(p), readlines(f))
  end
  area = threat_area(points, 10000)
  println("area size if coords are dangerous: $(area.dangerous)")
  println("area size if coords are safe: $(area.safe)")
end
foo()
