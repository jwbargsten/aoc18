function foo1()
  polymer = open("in/input") do f
    return readline(f)
  end

  #polymer = "dabAcCaCBAcCcaDA"

  np = polymer
  while true
    npb = IOBuffer()
    i = 1
    while i < length(np)
      if (islowercase(np[i]) && isuppercase(np[i+1]) ||
         isuppercase(np[i]) && islowercase(np[i+1])) &&
         lowercase(np[i]) == lowercase(np[i+1])
         i += 2
         continue
      else
        write(npb, np[i])
      end
      i += 1
    end
    if i == length(np)
      write(npb, np[length(np)])
    end
    nptmp = String(take!(npb))
    if length(nptmp) == length(np)
      break
    end
    np = nptmp
  end
  println("np: $(length(np))")
end
# this is too slow, but keep it for reference:
# to remind me of never doing this again
#foo1()

# it is better to use a stack
function react(polymer)
  stack = []
  for u in polymer
    if isempty(stack)
      push!(stack, u)
      continue
    end
    if (islowercase(last(stack)) && isuppercase(u) ||
       isuppercase(last(stack)) && islowercase(u)) &&
       lowercase(last(stack)) == lowercase(u)
       pop!(stack)
    else
      push!(stack, u)
    end
  end
  return length(stack)
end

function first_part()
  polymer = open("in/input") do f
    return readline(f)
  end
  println("reacted polymer has size $(react(polymer))")
end

first_part()

function second_part()
  polymer = open("in/input") do f
    return readline(f)
  end
  units = unique(collect(lowercase(polymer)))
  sizes = map(u -> react(replace(replace(polymer, string(lowercase(u)) => ""), string(uppercase(u)) => "")), units)
  min = findmin(sizes)
  println("$(units[min[2]]) had a big impact, removing it resulted in length $(min[1])")
end

second_part()
