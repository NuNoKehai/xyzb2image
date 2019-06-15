$type_atomdata=Struct.new(:id, :sp, :x, :data)

def read_num_atom(filename_in)

  line_in=IO.readlines(filename_in)

  num_atom=line_in[0].split[0].to_i

  return num_atom

end

def read_xyz_unit(filename_in,num_atom,line_start)

  line_in=IO.readlines(filename_in)

  atom=[]
  for i in 0..num_atom-1
    id=i+1
    sp=line_in[i+line_start+2].split[0]
    x=line_in[i+line_start+2].split[1].to_f
	  y=line_in[i+line_start+2].split[2].to_f
	  z=line_in[i+line_start+2].split[3].to_f
    data=[]
    for j in 4..line_in[i+line_start+2].split.size-1
      data << line_in[i+line_start+2].split[j].to_f
    end
	  atom<<$type_atomdata.new(id,sp,[x,y,z],data)
  end

  return atom

end
