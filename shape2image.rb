include Math

require 'rubygems'
require 'cairo'
require "data2shape"

def read_suffix(filename)

  index_period=filename.rindex(".")
  suffix=filename[index_period+1..filename.size-1]

  return suffix

end

def cairo_imagesurface_general(filename_image, width, height)

  suffix_image=read_suffix(filename_image)

  if suffix_image.casecmp("pdf")==0
     surface = Cairo::PDFSurface.new(filename_image, width, height)
  elsif suffix_image.casecmp("svg")==0
    surface = Cairo::SVGSurface.new(filename_image, width, height)
  else
    format = Cairo::FORMAT_ARGB32
    surface = Cairo::ImageSurface.new(format, width, height)
  end

  return surface

end

def context_finish_general(filename_image,context)

  suffix_image=read_suffix(filename_image)

  if suffix_image.casecmp("pdf")==0 || suffix_image.casecmp("svg")==0
    context.target.finish
  elsif suffix_image.casecmp("png")==0
    context.target.write_to_png(filename_image)
  end

end

def context_add_box(context,xy_range,box,xunit,width,height)

  context.set_line_width(box.w)
  context.set_source_rgb(box.c[0], box.c[1], box.c[2])
# line 01
  context.move_to( xunit*(box.x[0][0]-xy_range[0][0]), height-xunit*(box.x[0][1]-xy_range[0][1]) )
  context.line_to( xunit*(box.x[1][0]-xy_range[0][0]), height-xunit*(box.x[1][1]-xy_range[0][1]) )
  context.stroke
# line 02
  context.move_to( xunit*(box.x[0][0]-xy_range[0][0]), height-xunit*(box.x[0][1]-xy_range[0][1]) )
  context.line_to( xunit*(box.x[2][0]-xy_range[0][0]), height-xunit*(box.x[2][1]-xy_range[0][1]) )
  context.stroke
# line 03
  context.move_to( xunit*(box.x[0][0]-xy_range[0][0]), height-xunit*(box.x[0][1]-xy_range[0][1]) )
  context.line_to( xunit*(box.x[3][0]-xy_range[0][0]), height-xunit*(box.x[3][1]-xy_range[0][1]) )
  context.stroke
# line 14
  context.move_to( xunit*(box.x[1][0]-xy_range[0][0]), height-xunit*(box.x[1][1]-xy_range[0][1]) )
  context.line_to( xunit*(box.x[4][0]-xy_range[0][0]), height-xunit*(box.x[4][1]-xy_range[0][1]) )
  context.stroke
# line 24
  context.move_to( xunit*(box.x[2][0]-xy_range[0][0]), height-xunit*(box.x[2][1]-xy_range[0][1]) )
  context.line_to( xunit*(box.x[4][0]-xy_range[0][0]), height-xunit*(box.x[4][1]-xy_range[0][1]) )
  context.stroke
# line 25
  context.move_to( xunit*(box.x[2][0]-xy_range[0][0]), height-xunit*(box.x[2][1]-xy_range[0][1]) )
  context.line_to( xunit*(box.x[5][0]-xy_range[0][0]), height-xunit*(box.x[5][1]-xy_range[0][1]) )
  context.stroke
# line 35
  context.move_to( xunit*(box.x[3][0]-xy_range[0][0]), height-xunit*(box.x[3][1]-xy_range[0][1]) )
  context.line_to( xunit*(box.x[5][0]-xy_range[0][0]), height-xunit*(box.x[5][1]-xy_range[0][1]) )
  context.stroke
# line 36
  context.move_to( xunit*(box.x[3][0]-xy_range[0][0]), height-xunit*(box.x[3][1]-xy_range[0][1]) )
  context.line_to( xunit*(box.x[6][0]-xy_range[0][0]), height-xunit*(box.x[6][1]-xy_range[0][1]) )
  context.stroke
# line 16
  context.move_to( xunit*(box.x[1][0]-xy_range[0][0]), height-xunit*(box.x[1][1]-xy_range[0][1]) )
  context.line_to( xunit*(box.x[6][0]-xy_range[0][0]), height-xunit*(box.x[6][1]-xy_range[0][1]) )
  context.stroke
# line 47
  context.move_to( xunit*(box.x[4][0]-xy_range[0][0]), height-xunit*(box.x[4][1]-xy_range[0][1]) )
  context.line_to( xunit*(box.x[7][0]-xy_range[0][0]), height-xunit*(box.x[7][1]-xy_range[0][1]) )
  context.stroke
# line 57
  context.move_to( xunit*(box.x[5][0]-xy_range[0][0]), height-xunit*(box.x[5][1]-xy_range[0][1]) )
  context.line_to( xunit*(box.x[7][0]-xy_range[0][0]), height-xunit*(box.x[7][1]-xy_range[0][1]) )
  context.stroke
# line 67
  context.move_to( xunit*(box.x[6][0]-xy_range[0][0]), height-xunit*(box.x[6][1]-xy_range[0][1]) )
  context.line_to( xunit*(box.x[7][0]-xy_range[0][0]), height-xunit*(box.x[7][1]-xy_range[0][1]) )
  context.stroke

end

def context_add_line(context,xy_range,line,xunit,width,height)

  for i in 0..line.size-1
    context.set_line_width(line[i].w)
#    context.set_source_rgba(line[i].c[0], line[i].c[1], line[i].c[2],0.8)
    context.set_source_rgb(line[i].c[0], line[i].c[1], line[i].c[2])
    x1draw=(line[i].x1[0]-xy_range[0][0])*xunit
    y1draw=height-(line[i].x1[1]-xy_range[0][1])*xunit
    context.move_to(x1draw, y1draw)
    x2draw=(line[i].x2[0]-xy_range[0][0])*xunit
    y2draw=height-(line[i].x2[1]-xy_range[0][1])*xunit
    context.line_to(x2draw, y2draw)
    context.stroke
  end

end

def context_add_circle(context,xy_range,circle,xunit,width,height)

  for i in 0..circle.size-1
    xdraw=(circle[i].x[0]-xy_range[0][0])*xunit
    ydraw=height-(circle[i].x[1]-xy_range[0][1])*xunit
    rdraw=circle[i].r*xunit
    context.set_source_rgb(circle[i].c[0], circle[i].c[1], circle[i].c[2])
    context.arc(xdraw, ydraw, rdraw, 0, 2 * Math::PI)
    context.fill
    if circle[i].w > 0.0
      context.set_line_width(circle[i].w)
      context.set_source_rgb(0, 0, 0)
      context.arc(xdraw, ydraw, rdraw, 0, 2 * Math::PI)
      context.stroke
    end
  end

end
