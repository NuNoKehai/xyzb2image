$type_bonddata=Struct.new(:id, :sp, :cell, :data)

def read_num_bond(filename_in,line_start)

  line_in=IO.readlines(filename_in)

  num_bond=line_in[line_start].split[5].to_i

  return num_bond

end

def read_bond_unit(filename_in,num_bond,line_start)

  line_in=IO.readlines(filename_in)


  bond=[]
  for l in 0..num_bond-1
#    p l+line_start+1
    id0=line_in[l+line_start+1].split[0].to_i
    sp0=line_in[l+line_start+1].split[1]
	  id1=line_in[l+line_start+1].split[2].to_i
	  sp1=line_in[l+line_start+1].split[3]
	  c1=line_in[l+line_start+1].split[4].to_i
	  c2=line_in[l+line_start+1].split[5].to_i
	  c3=line_in[l+line_start+1].split[6].to_i
    data=[]
    if line_in[l+line_start+1].split.size > 7
      for i in 7..line_in[l+line_start+1].split.size-1
        data << line_in[l+line_start+1].split[i].to_f
      end
    end
	  bond<<$type_bonddata.new([id0,id1],[sp0,sp1],[c1,c2,c3],data)
  end

  return bond

end

def read_avec_bond(filename_in,line_avec)

	line_in=IO.readlines(filename_in)

  column_avec=7

  if line_in[line_avec].split.size > column_avec
    avec=[]
    i=column_avec
    a0=line_in[line_avec].split[i].to_f
    a1=line_in[line_avec].split[i+1].to_f
    a2=line_in[line_avec].split[i+2].to_f
    avec<<[a0,a1,a2]
    i=i+3
    a0=line_in[line_avec].split[i].to_f
    a1=line_in[line_avec].split[i+1].to_f
    a2=line_in[line_avec].split[i+2].to_f
    avec<<[a0,a1,a2]
    i=i+3
    a0=line_in[line_avec].split[i].to_f
    a1=line_in[line_avec].split[i+1].to_f
    a2=line_in[line_avec].split[i+2].to_f
    avec<<[a0,a1,a2]
  end

	return avec

end
