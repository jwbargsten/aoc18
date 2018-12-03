using Test
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

function teststuff()

  ret = cnt_letters("abcdefgh")

  @test 0 == cnt_letters("abcdef")
  @test 5 == cnt_letters("bababc")
  @test 2 == cnt_letters("abbcde")
  @test 3 == cnt_letters("abcccd")
  @test 2 == cnt_letters("aabcdd")
  @test 2 == cnt_letters("abcdee")
  @test 3 == cnt_letters("ababab")


  t = [ "abcdef",
        "bababc",
        "abbcde",
        "abcccd",
        "aabcdd",
        "abcdee",
        "ababab",
        ]
  @test chksum(t) == 12
end

function first_part()
  l = open("in/test") do f
    readlines(f)
  end

  return chksum(l)
end

function second_part()

  l = open("in/input") do f
    readlines(f)
  end

  for i in 1:(length(l)-1)
    x = l[i]
    for j in (i+1):length(l)
      y = l[j]
      ndiff = 0
      diff = ""
      diffidx = -1
      for k in eachindex(x)
        if x[k] != y[k]
          ndiff += 1
          diff = x[k]
          diffidx = k
        end
        if ndiff > 1
          break
        end
      end
      if ndiff == 1
        return (x,y,join(deleteat!(collect(x),diffidx)))
      end
    end
  end
end

println("checksum is $(first_part())")
println("identical chars are $(second_part()[3])")
