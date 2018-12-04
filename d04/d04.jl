function parse_event(ev::String)
  rx = r"^\[(\d+)-(\d+)-(\d+)\s(\d+):(\d+)\]\s(.*)$"
  m = match(rx, ev)
  return (
    Y=parse(Int32,m.captures[1]),
    m=parse(Int32,m.captures[2]),
    d=parse(Int32,m.captures[3]),
    H=parse(Int32,m.captures[4])+1,
    M=parse(Int32,m.captures[5])+1,
    msg=m.captures[6]
  )
end

function sleep_times()::Dict{Int32, Array{Int32, 1}}
  events = open("in/input") do f
    map(ev -> parse_event(ev), sort(readlines(f)))
  end

  guards = Dict{Int32, Array{Int32, 1}}()

  id = nothing
  sleep_start = -1

  for ev in events
    if occursin("falls asleep", ev.msg)
      sleep_start = ev.M
    elseif sleep_start > 0 && occursin("wakes up", ev.msg)
      guards[id][sleep_start:(ev.M-1)] .+= 1
      sleep_start = -1
    elseif occursin("begins shift", ev.msg)
      id = parse(Int32, replace(ev.msg, r".*Guard #(\d+) begins shift.*" => s"\1"))
      if !haskey(guards, id)
        guards[id] = zeros(Int32, 60)
      end
      sleep_start = -1
    end
  end
  return guards
end

function first_part(st::Dict{Int32, Array{Int32, 1}})
  st_total = map(x -> sum(x), collect(values(st)))

  g = collect(keys(st))[findmax(st_total)[2]]
  m = findmax(collect(st[g]))
  println("Guard #$(g) likes to sleep at min $(m[2]-1), chksum: $(g * (m[2]-1))")
end
  
function second_part(st::Dict{Int32, Array{Int32, 1}})
  st_max = map(x -> maximum(x), collect(values(st)))

  g = collect(keys(st))[findmax(st_max)[2]]
  m = findmax(collect(st[g]))
  
  println("Guard #$(g) slept $(m[1]) times at min $(m[2]-1), chksum: $(g * (m[2]-1))")
end

function foo()
    st::Dict{Int32, Array{Int32, 1}} = sleep_times()
    first_part(st)
    second_part(st)
end

foo()
