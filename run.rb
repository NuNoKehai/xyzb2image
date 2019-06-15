require 'rubygems'
require 'cairo'
require "read_xyz"
require "read_bond"
require "draw_colorbar"
require "data2shape"
require "val2col"
require "shape2image"

filename_config=ARGV[0]
if filename_config.nil?
  filename_config="xyzb2image.config"
end

line_config=IO.readlines(filename_config)

l=0
# input files
l=l+2
filename_xyz=line_config[l].strip
l=l+2
filename_bond=line_config[l].strip

#output files
l=l+3
filename_image=line_config[l].strip
l=l+2
filename_cbbox_xyz=line_config[l].strip
l=l+2
filename_cbbox_bond=line_config[l].strip

#options
l=l+3
str_axis=line_config[l].split[0]

l=l+2
xyz_range=[]
xyz_range<<[line_config[l].split[0].to_f,line_config[l+1].split[0].to_f,line_config[l+2].split[0].to_f]
xyz_range<<[line_config[l].split[1].to_f,line_config[l+1].split[1].to_f,line_config[l+2].split[1].to_f]

l=l+4
idat_xyz=line_config[l].split[0].to_i
cb_xyz=$type_colorbar.new( \
  line_config[l].split[1],line_config[l].split[2].to_f,line_config[l].split[3].to_f)
l=l+2
cbbox_xyz=$type_cbbox.new( \
  line_config[l].split[0].to_i,line_config[l].split[1].to_i, \
  line_config[l].split[2].to_i,line_config[l].split[3].to_i )
l=l+2
idat_bond=line_config[l].split[0].to_i
cb_bond=$type_colorbar.new( \
  line_config[l].split[1],line_config[l].split[2].to_f,line_config[l].split[3].to_f)
l=l+2
cbbox_bond=$type_cbbox.new( \
line_config[l].split[0].to_i,line_config[l].split[1].to_i, \
line_config[l].split[2].to_i,line_config[l].split[3].to_i )
l=l+2
rate_x2i=line_config[l].strip.to_f
l=l+2
rate_r2c=line_config[l].strip.to_f
l=l+2
elem={}
for i in l..line_config.size-1
  sym=line_config[i].split[0]
  rad=line_config[i].split[1].to_f
  red=line_config[i].split[2].to_f
  green=line_config[i].split[3].to_f
  blue=line_config[i].split[4].to_f
  elem[sym]=$type_elem.new(rad,[red,green,blue])
end

# Read input files
num_atom=read_num_atom(filename_xyz)
atom=read_xyz_unit(filename_xyz,num_atom,0)
if filename_bond != ""
  num_bond=read_num_bond(filename_bond,0)
  avec=read_avec_bond(filename_bond,0)
  bond=read_bond_unit(filename_bond,num_bond,0)
end

# convert data
if ! avec.nil?
  box=avec2box(avec,str_axis,0.5)
end
circle=atomdata2circ(idat_xyz,atom,cb_xyz,elem,xyz_range,rate_r2c,str_axis,0.3)
line=bonddata2line(idat_bond,avec,atom,bond,cb_bond,xyz_range,str_axis,2)

xy_range=xyzrange2xyrange(xyz_range,str_axis)

#draw atomic coordinates
width = rate_x2i*(xy_range[1][0]-xy_range[0][0])
height = rate_x2i*(xy_range[1][1]-xy_range[0][1])
image = cairo_imagesurface_general(filename_image, width, height)
context = Cairo::Context.new(image)
if ! line.nil?
  context_add_line(context,xy_range,line,rate_x2i,width,height)
end
if ! box.nil?
  context_add_box(context,xy_range,box,rate_x2i,width,height)
end
if ! circle.nil?
  context_add_circle(context,xy_range,circle,rate_x2i,width,height)
end
context_finish_general(filename_image,context)

#output color bars
if idat_xyz > 0
  create_cbbox(filename_cbbox_xyz,cb_xyz,cbbox_xyz)
end
if idat_bond > 0
  create_cbbox(filename_cbbox_bond,cb_bond,cbbox_bond)
end
