require "read_xyz"
require "read_bond"

$type_elem=Struct.new(:rad, :color)
$type_circ=Struct.new(:x, :r, :w, :c)
$type_line=Struct.new(:x1, :x2, :w, :c)
$type_box=Struct.new(:x, :w, :c)


def get_axisid(str_axis)

  axis=[]
  if str_axis == "x"
    axis[0]=0
    axis[1]=1
    axis[2]=2
  elsif str_axis == "y"
    axis[0]=1
    axis[1]=2
    axis[2]=0
  elsif str_axis == "z"
    axis[0]=2
    axis[1]=0
    axis[2]=1
  end

  return axis

end

def get_atomorder(str_axis,atom)

  axis=get_axisid(str_axis)

  x=[]
  for i in 0..atom.size-1
    x << atom[i].x[axis[0]]
  end
  xsort=x.sort

  order=[]
  used=[]
  for i in 0..atom.size-1
    for j in 0..xsort.size-1
      if atom[i].x[axis[0]] == xsort[j]
        if used[j].nil?
          order[i]=j
          used[j]=1
          break
        end
      end
    end
  end

  return order

end

def get_invorder(order)


  inv_order=[]
  for i in 0..order.size-1
#    p [i,order[i]]
    inv_order[order[i]]=i
  end
#  p inv_order

  return inv_order

end

def in_xyz_range(x,xyz_range)
  return xyz_range[0][0] <= x[0] && x[0] <= xyz_range[1][0] \
  && xyz_range[0][1] <= x[1] && x[1] <= xyz_range[1][1] \
  && xyz_range[0][2] <= x[2] && x[2] <= xyz_range[1][2]
end

def xyzrange2xyrange(xyz_range,str_axis)

  axis=get_axisid(str_axis)

  xy_range=[]
  xy_range << [ xyz_range[0][axis[1]],xyz_range[0][axis[2]] ]
  xy_range << [ xyz_range[1][axis[1]],xyz_range[1][axis[2]] ]

  return xy_range

end

def atomdata2circ(idat,atom,cb,elem,xyz_range,rate_r2c,str_axis,linewidth)

  axis=get_axisid(str_axis)
  order=get_atomorder(str_axis,atom)
  inv_order=get_invorder(order)

  circle=[]
  for i in 0..atom.size-1
    j=inv_order[i]
    if in_xyz_range(atom[j].x,xyz_range) then
      r=elem[atom[j].sp].rad*rate_r2c
      if idat == 0
        c=elem[atom[j].sp].color
      else
        c=val2col(atom[j].data[idat-1],cb)
      end
      circle<<$type_circ.new([atom[j].x[axis[1]],atom[j].x[axis[2]]],r,linewidth,c)
    end
  end

  return circle

end

def bonddata2line(idat,avec,atom,bond,cb,xyz_range,str_axis,linewidth)

  axis=get_axisid(str_axis)

  line=[]
  for i in 0..bond.size-1
#    p [i,bond[i]]
    id0=bond[i].id[0]-1
    id1=bond[i].id[1]-1
    if ! avec.nil?
      a0=bond[i].cell[0]*avec[0][axis[0]]
      a0+=bond[i].cell[1]*avec[1][axis[0]]
      a0+=bond[i].cell[2]*avec[2][axis[0]]
      a1=bond[i].cell[0]*avec[0][axis[1]]
      a1+=bond[i].cell[1]*avec[1][axis[1]]
      a1+=bond[i].cell[2]*avec[2][axis[1]]
      a2=bond[i].cell[0]*avec[0][axis[2]]
      a2+=bond[i].cell[1]*avec[1][axis[2]]
      a2+=bond[i].cell[2]*avec[2][axis[2]]
    else
      a0=0.0
      a1=0.0
      a2=0.0
    end
    if in_xyz_range(atom[id0].x,xyz_range) && in_xyz_range(atom[id1].x,xyz_range)
      if idat == 0
        c=[0.0,0.0,0.0]
      else
        c=val2col(bond[i].data[idat-1],cb)
      end
      xi=[ atom[id0].x[axis[1]], atom[id0].x[axis[2]] ]
      xj=[ atom[id1].x[axis[1]]+a1, atom[id1].x[axis[2]]+a2 ]
      line<<$type_line.new(xi,xj,linewidth,c)
      if a1 != 0.0 || a2 != 0.0
        xi=[ atom[id0].x[axis[1]]-a1, atom[id0].x[axis[2]]-a2 ]
        xj=[ atom[id1].x[axis[1]], atom[id1].x[axis[2]] ]
        line<<$type_line.new(xj,xi,linewidth,c)
      end
    end
  end

  return line

end


def avec2box(avec,str_axis,linewidth)

  axis=get_axisid(str_axis)

  c=[0.0, 0.0, 0.0]

  x=[]
  x[0]=[0.0, 0.0]
  x[1]=[ avec[0][axis[1]], avec[0][axis[2]] ]
  x[2]=[ avec[1][axis[1]], avec[1][axis[2]] ]
  x[3]=[ avec[2][axis[1]], avec[2][axis[2]] ]
  x[4]=[ avec[0][axis[1]]+avec[1][axis[1]], avec[0][axis[2]]+avec[1][axis[2]] ]
  x[5]=[ avec[1][axis[1]]+avec[2][axis[1]], avec[1][axis[2]]+avec[2][axis[2]] ]
  x[6]=[ avec[2][axis[1]]+avec[0][axis[1]], avec[2][axis[2]]+avec[0][axis[2]] ]
  x[7]=[ avec[0][axis[1]]+avec[1][axis[1]]+avec[2][axis[1]], avec[0][axis[2]]+avec[1][axis[2]]+avec[2][axis[2]] ]

  box=$type_box.new(x,linewidth,c)

  return box

end
