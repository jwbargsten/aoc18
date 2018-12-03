function parse_patch(p::String)
  rx = r"^#(\d+)\s@\s(\d+),(\d+):\s(\d+)x(\d+)$"
  m = match(rx, p)
  pp = parse.(Int32, m.captures)
  return (id=pp[1], x=pp[3]+1, y=pp[2]+1, w=pp[4], h=pp[5])
end

function foo()
  patches = open("in/input") do f
    map(p -> parse_patch(p), readlines(f))
  end

  #x = cols, y = rows
  dim_x = maximum(map(p -> p.x + p.h, patches))
  dim_y = maximum(map(p -> p.y + p.w, patches))

  fabric = zeros(Int32,  dim_x, dim_y)
  for p in patches
    x1 = p.x
    x2 = p.x+p.h-1

    y1 = p.y
    y2 = p.y+p.w-1

    fabric[x1:x2,y1:y2] .+= 1
  end

  gt2 = sum(map(x -> x > 1, fabric))
  println("$gt2 inches with two or more claims")

  for p in patches
    x1 = p.x
    x2 = p.x+p.h-1

    y1 = p.y
    y2 = p.y+p.w-1

    if sum(fabric[x1:x2,y1:y2]) == p.h * p.w
      println("unique patch ID is $(p.id)")
      break
    end
  end
end

foo()

#fabric = zeros(Int32, 10,10)
#x = parse_patch("#123 @ 3,2: 5x4")
