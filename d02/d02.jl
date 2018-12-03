using Test
# d = Dict{Int64,Bool}(0 => true)
# shift = 0
# while true
  # open("input/input") do f
      # for l in eachline(f)
          # global shift
          # shift += parse(Int64,l)
          # if haskey(d, shift)
            # println(shift)
            # exit()
          # else
            # d[shift] = true
          # end
      # end
  # end
# end

function chksum(box_ids)
  n2 = 0
  n3 = 0

  for id  in box_ids
    app = cnt_letters(id)
    if app == 3
      n3 += 1
    elseif app == 2
      n2 += 1
    elseif app == 5
      n3 += 1
      n2 += 1
    end
  end
  return n2 * n3
end

function cnt_letters(id)
  d = Dict{Char,Integer}()
  for c in id
    if haskey(d, c)
      d[c] += 1
    else
      d[c] = 1
    end
  end
  ret = 0
  if 2 in values(d)
    ret += 2
  end
  if 3 in values(d)
    ret += 3
  end
  return ret
end

ret = cnt_letters("abcdefgh")

@test    0 == cnt_letters("abcdef")
@test    5 == cnt_letters("bababc")
@test    2 == cnt_letters("abbcde")
@test    3 == cnt_letters("abcccd")
@test    2 == cnt_letters("aabcdd")
@test    2 == cnt_letters("abcdee")
@test    3 == cnt_letters("ababab")


t = [ "abcdef",
      "bababc",
      "abbcde",
      "abcccd",
      "aabcdd",
      "abcdee",
      "ababab",
      ]
@test chksum(t) == 12

l = []
open("in/test") do f
  global l
  l = readlines(f)
end

println(l)
println(chksum(l))

open("in/input") do f
  global l
  l = readlines(f)
end

println(chksum(l))

for x in l, y in l
  ndiff = 0
  diff = ""
  diffidx = -1
  for i in eachindex(x)
    if x[i] != y[i]
      ndiff += 1
      diff = x[i]
      diffidx = i
    end
    if ndiff > 1
      break
    end
  end
  if ndiff == 1
    println(x * " <=> " * y)
    z = deleteat!(collect(x),diffidx)
    println(join(z))
  end
end


    
  
