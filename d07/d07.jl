function parse_step(s::String)
  rx = r"^Step (\w+) must be finished before step (\w+) can begin.$"
  m = match(rx, s)
  return (m.captures[1], m.captures[2])
end

function isbefore(a,b,steps)
  if any(x -> x[1] == a && x[2] == b,steps)
    return true
  end
  if any(x -> x[1] == b && x[2] == a,steps)
    return false
  end
  println(a,b, isless(a,b))
  return isless(a,b)
end

  steps = open("in/input") do f
    map(s -> parse_step(s), readlines(f))
  end

usteps = unique(collect(Iterators.flatten(steps)))
dup = Dict()
ddown = Dict()
for s in steps
  if haskey(dup, s[2])
    push!(dup[s[2]], s[1])
  else
    dup[s[2]] = [ s[1] ]
  end
  if haskey(ddown, s[1])
    push!(ddown[s[1]], s[2])
  else
    ddown[s[1]] = [ s[2] ]
  end
end
for s in usteps
  if !haskey(dup, s)
    dup[s] = SubString{String}[]
  end
  if !haskey(ddown, s)
    ddown[s] = SubString{String}[]
  end
end

queue = sort(filter(x -> isempty(dup[x]),usteps))
order = []
visited = Dict(map(x -> x => false, usteps))
while !isempty(queue)
  global queue
  n = first(filter(x -> isempty(dup[x]) || all(k -> visited[k],dup[x]), sort(queue)))
  visited[n] = true
  queue = filter(x -> x != n, queue)
  push!(order, n)
  if !isempty(ddown[n])
    append!(queue,ddown[n])
  end
  #println("n: $(n), q: $(queue)")
end

println( join(order))
  



#sort(usteps, lt=(x,y) -> isbefore(x,y,steps))

