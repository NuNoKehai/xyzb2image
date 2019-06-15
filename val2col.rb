$type_colorbar=Struct.new(:type, :vmin, :vmax)

def val2col(val,cb)

  rgb=[1.0,1.0,1.0]

#  p val
#  p cb

  if cb.type == "WR"
    col = (val-cb.vmin)/(cb.vmax-cb.vmin)
    if 0.0 <= col && col < 1.0
      rgb[1]=1-col ; rgb[2]=1-col
    elsif 1.0 <= col
      rgb[1]=0.0 ; rgb[2]=0.0
    end
  elsif cb.type == "WB"
    col = (val-cb.vmin)/(cb.vmax-cb.vmin)
    if 0.0 <= col && col < 1.0
      rgb[0]=col ; rgb[1]=col
      elsif 1.0 < col
      rgb[0]=0.0 ; rgb[1]=0.0
    end
  elsif cb.type == "BWR"
    v0=(cb.vmin+cb.vmax)/2
    col=(val-v0)/(cb.vmax-v0)
#    p [col,val]
    if col<=-1.0
      rgb[0]=0.0 ; rgb[1]=0.0
    elsif -1.0 < col && col < 0.0
      rgb[0]=1.0+col ; rgb[1]=1.0+col
    elsif 0.0 <= col && col <1.0
      rgb[1]=1.0-col ; rgb[2]=1.0-col
    else
      rgb[1]=0.0 ; rgb[2]=0.0
    end
  elsif cb.type == "hue_RB"
    rgb=val2col_hsv(val,cb.vmin,cb.vmax,0,240)
  elsif cb.type == "hue_RM"
    rgb=val2col_hsv(val,cb.vmin,cb.vmax,0,300)
  end

  return rgb

end

def val2col_hsv(val,vmin,vmax,huemin,huemax)

  rgb=[1.0,1.0,1.0]

  if vmin==vmax
    hue=(huemin+huemax)/2
    hue=hue%360
  else
    hue=huemin+val/(vmax-vmin)*(huemax-huemin)
    hue=hue%360
  end
  if 0 <= hue && hue < 60
    #    p "1",hue.to_i
    rgb[0]=1
    rgb[1]=hue/60
    rgb[2]=0
  elsif 60 <= hue && hue < 120
    #     p "2",hue.to_i
    rgb[0]=1.0-(hue-60)/60
    rgb[1]=1
    rgb[2]=0
  elsif 120 <= hue && hue < 180
    #     p "3",hue.to_i
    rgb[0]=0
    rgb[1]=1
    rgb[2]=(hue-120)/60
  elsif 180 <= hue && hue < 240
    #     p "4",hue.to_i
    rgb[0]=0
    rgb[1]=1-(hue-180)/60
    rgb[2]=1
  elsif 240 <= hue && hue < 300
    #     p "5",hue.to_i
    rgb[0]=(hue-240)/60
    rgb[1]=0
    rgb[2]=1
  else
    #     p "6",hue.to_i
    rgb[0]=1
    rgb[1]=0
    rgb[2]=1.0-(hue-300)/60
  end
  return rgb

end
