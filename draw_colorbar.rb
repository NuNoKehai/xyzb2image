require 'rubygems'
require 'cairo'
require "val2col"

$type_cbbox=Struct.new(:width, :height, :nscale, :nsubscale)

def create_cbbox(filename_cbbox,cb,cbbox)

	format = Cairo::FORMAT_ARGB32
	surface = Cairo::PDFSurface.new(filename_cbbox, cbbox.width, cbbox.height)
	context = Cairo::Context.new(surface)

	dx=cbbox.width/100
	dv=(cb.vmax-cb.vmin)/100

#  p cb.type
#  p [cb.vmin,val2col(cb.vmin,cb)]
#  p [cb.vmax,val2col(cb.vmax,cb)]

	for i in 0..100
		xtemp=dx*i
		value=cb.vmin+dv*i
		c=val2col(value,cb)
#    p [xtemp,value,c]
		context.set_source_rgb(c[0], c[1], c[2])
		if i == 0
  		context.rectangle(xtemp, 0, dx/2+1, cbbox.height)
    elsif i == 100
			context.rectangle(xtemp-dx/2-1, 0, dx/2+1, cbbox.height)
	  else
			context.rectangle(xtemp-dx/2-1, 0, dx+2, cbbox.height)
		end
		context.fill
	end

	context.set_line_width(0.5)
	context.set_source_rgb(0,0,0)
	context.move_to(0,cbbox.height)
	context.line_to(cbbox.width,cbbox.height)
	context.stroke

	num=cbbox.nscale*cbbox.nsubscale
	dx=cbbox.width/num
	dv=(cb.vmax-cb.vmin)/num

	for i in 0...num+1
		xtemp=dx*i
		vtemp=cb.vmin+dv*i
		if i%cbbox.nsubscale==0
			dy=12
		else
			dy=6
		end
		context.move_to(xtemp,cbbox.height-dy/2)
		context.line_to(xtemp,cbbox.height+dy/2)
		context.stroke
	end

end
