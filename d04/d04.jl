function parse_event(ev)
  rx = r"^\[(\d+)-(\d+)-(\d+)\s(\d+):(\d+)\]\s(.*)$"
  m = match(rx, ev)
  return (
    Y=parse(Int16,m.captures[1]),
    m=parse(Int16,m.captures[2]),
    d=parse(Int16,m.captures[3]),
    H=parse(Int16,m.captures[4])+1,
    M=parse(Int16,m.captures[5])+1,
    msg=m.captures[6]
  )
end

function sleep_times()
  events = open("in/input") do f
    map(ev -> parse_event(ev), sort(readlines(f)))
  end

  guards = Dict{Int32, Array{Int32, 1}}()
  #guards = Dict{String, Array{Int32,1}}

  id = nothing
  sleep_start = missing

  for ev in events
    if occursin("falls asleep", ev.msg)
      sleep_start = ev.M
    elseif occursin("wakes up", ev.msg) && sleep_start !== missing
      guards[id][sleep_start:(ev.M-1)] .+= 1
      sleep_start = missing
    elseif occursin("begins shift", ev.msg)
      id = replace(ev.msg, " begins shift" => "")
      id = replace(id, "Guard #" => "")
      id = parse(Int32, id)
      if !haskey(guards, id)
        guards[id] = zeros(Int32, 60)
      end
      sleep_start = missing
    end
  end
  return guards
end

function first_part(st)
  st_total = map(x -> sum(x), collect(values(st)))

  g = collect(keys(st))[findmax(st_total)[2]]
  m = findmax(collect(st[g]))
  println("Guard #$(g) likes to sleep at min $(m[2]-1), chksum: $(g * (m[2]-1))")
end
  
function second_part(st)
  st_max = map(x -> maximum(x), collect(values(st)))

  g = collect(keys(st))[findmax(st_max)[2]]
  m = findmax(collect(st[g]))
  
  println("Guard #$(g) slept $(m[1]) times at min $(m[2]-1), chksum: $(g * (m[2]-1))")
end

st = sleep_times()
first_part(st)
second_part(st)
