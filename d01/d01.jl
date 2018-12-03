function first_part()
  return open("in/input") do f
      shift = 0
      for l in eachline(f)
          shift += parse(Int64,l)
      end
      shift
  end
end

function second_part()
  d = Dict{Int64,Bool}(0 => true)
  shift = 0
  not_finished = true
  while not_finished
    open("in/input") do f
        for l in eachline(f)
            shift += parse(Int64,l)
            if haskey(d, shift)
              not_finished = false
              break
            else
              d[shift] = true
            end
        end
    end
  end
  return shift
end

println("shift is $(first_part())")
println("shift is $(second_part())")
