function react_iteratively(polymer)
  np = polymer
  npb = IOBuffer(maxsize=2*length(polymer), sizehint=length(polymer), write=true)
  while true
    i = 1
    l = length(np)
    while i < l
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
      write(npb, last(np))
    end
    nptmp = String(take!(npb))
    if length(nptmp) == length(np)
      break
    end
    np = nptmp
  end
  return length(np)
end
# this is too slow, but keep it for reference:
# to remind me of never doing this again

# it is better to use a stack
function react_stack(polymer)
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

function second_part(polymer)
  units = unique(collect(lowercase(polymer)))
  sizes = map(u -> react_stack(reduce(replace, [ lowercase(u) => "", uppercase(u) => "" ], init=polymer)), units)
  min = findmin(sizes)
  println("$(units[min[2]]) had a big impact, removing it resulted in length $(min[1])")
end


function foo()
  polymer = open("in/input") do f
    return readline(f)
  end
  #polymer = "dabAcCaCBAcCcaDA"

  println("reacted polymer has size $(react_stack(polymer))")
  second_part(polymer)
  println("iterative reaction $(react_iteratively(polymer))")
end
foo()
