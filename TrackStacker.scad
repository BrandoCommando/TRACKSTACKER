part="xcross";

bottom_magnet=[8,3];
side_magnet=[6.1,2.2];
triad_len=17.32;
text="PBD";
text_depth=-1;
text_size=18;
text_font="";

if(part=="bend")
  bend();
else if(part=="funnel")
  funnel(1);
else if(part=="R10")
  right(10,5,1);
else if(part=="R20")
  right(20,10,2);
else if(part=="R30")
  right(30,15,3);
else if(part=="4510")
  curve(45,10,5,1);
else if(part=="4520")
  curve(45,20,10.4,2);
else if(part=="4530")
  curve(45,30,15,3);
else if(part=="S20")
  straight(20);
else if(part=="S40")
  straight(40);
else if(part=="S80")
  straight(80);
else if(part=="S160")
  straight(160);
else if(part=="cross")
  cross();
else if(part=="criss_cross")
  criss_cross();
else if(part=="xcross")
  xcross();
else if(part=="xcross45")
  xcross45();
else if(part=="chaos_box_inner")
  chaos_box(1);
else if(part=="chaos_box_outer")
  chaos_box(0);
else if(part=="bucket")
  bucket();
else if(part=="bucket_return")
  bucket([100,60,40],0,text,bank=1,carousel=1);
else if(part=="y")
  why();
else if(part=="button")
  button();
else if(part=="Z1")
  zlift(1);
else if(part=="Z2")
  zlift(2);
else if(part=="Z3")
  zlift(3);
else if(part=="triad")
  triad();
else {
  *translate([0,0,10]) rotate([0,90])
  rotate_extrude(angle=45,$fn=96) intersection() {
    translate([0,-20]) square([50,40]);
    translate([10,0]) rotate([0,0,90]) end_profile();
  }
}
module xcross() {
  criss_cross(lead=[0,0],1,1);
}
module xcross45() {
  criss_cross(lead=[0,0],1,1);
  *translate([-40,15]) why();
  *translate([5,30]) curve(90,10,5,0,0);
  translate([0,30]) straight(5);
  mirror([1,0]) mirror([0,1,0]) difference() {
//    mirror([0,1]) linear_extrude(
    curve(25,5,5,1,3)
      mirror([0,1]) curve(25,5,5,0,2);
    *translate([12,0,-9.51]) cylinder(d=bottom_magnet[0]+.1,h=bottom_magnet[1]+1,$fn=80);
  }
}

module linear_extrude2(height=5,center=false,convexity=3,twist=0,slices=20,scale=1.0,$fn=16) {
  linear_extrude(height=height,center=center,convexity=convexity,twist=twist,slices=slices,scale=scale,$fn=$fn) children(0);
  if($children>1)
    translate([0,0,height/(center?2:1)]) children([1:$children-1]);
}
module rotate_extrude2(angle=360,convexity=3,$fn=16) {
  rotate_extrude(angle=abs(angle),convexity=convexity,$fn=$fn) children(0);
  if($children>1)
    rotate([-90,-90,angle]) children([1:$children-1]);
}
module curvez(angle=45,radius=10,lead=10,holes=-1,ends=1) {
  holes=holes>-1?holes:max(1,floor(radius/12));
  translate([lead,0]) rotate([0,0,90]) rotate([90,0])
  difference() {
    union() {
      translate([0,0,-lead]) linear_extrude(lead,convexity=3) end_profile();
      translate([0,angle>0?radius:-radius]) rotate([-angle,0]) translate([0,angle>0?-radius:radius,0]) mirror([0,0,0]) {
        difference() {
          linear_extrude(lead,convexity=3) end_profile();
          if(ends!=0&&ends!=3)
            translate([0,0,lead]) mirror([0,0,1]) end_features();
        }
        if($children>0)
          translate([0,0,lead]) rotate([-90,-90]) children();
      }
      translate([0,0,0]) rotate([90,0,180]) translate([0,0,angle>0?radius:-radius]) rotate([0,angle>0?90:-90]) rotate_extrude(angle=abs(angle),convexity=3,$fn=80) intersection() {
        translate([radius,0])
          rotate([0,0,angle>0?90:-90]) end_profile();
        translate([0,-20]) square([25+radius,40]);
      }
    }
    if(ends) {
    if(ends!=2)
    translate([0,0,-lead-.01]) end_features();
    }
  }
}
module curve(angle=45,radius=10,lead=10,holes=-1,ends=1) {
  holes=holes>-1?holes:max(1,floor(radius/12));
  translate([lead,-radius]) rotate([0,0,90]) rotate([90,0])
  difference() {
    union() {
      translate([radius,0,-lead]) linear_extrude(lead,convexity=3) end_profile();
      rotate([0,-angle]) translate([radius,0,lead]) mirror([0,0,1]) {
        linear_extrude(lead,convexity=3) end_profile();
        if($children>0)
          mirror([1,0]) rotate([-90,0,0]) rotate([0,0,90]) children();
      }
      rotate([-90,180,0]) rotate([0,0,180-angle]) rotate_extrude(angle=angle,convexity=3,$fn=80) intersection() {
        translate([radius,0])
          end_profile();
        translate([0,-10]) square([25+radius,20]);
      }
    }
    if(ends) {
    if(ends!=2)
    translate([radius,0,-lead-.01]) end_features();
    if(ends!=3)
    rotate([0,-angle]) translate([radius,0,lead+.01]) mirror([0,0,1]) end_features();
    if(holes==1)
       rotate([0,-angle/4]) translate([radius,-9.51,lead]) rotate([-90,0]) cylinder(d=bottom_magnet[0]+.1,h=bottom_magnet[1]+.1,$fn=64);
    else if(holes==2)
      for(r=[-40,-5]) rotate([0,r]) translate([radius,-10]) rotate([-90,0]) cylinder(d=bottom_magnet[0]+.1,h=bottom_magnet[1]+1,$fn=64);
    else if(holes>1)
      for(r=[-45:45/(holes-1):0]) rotate([0,r]) translate([radius+.75,-9.51]) rotate([-90,0]) cylinder(d=bottom_magnet[0]+.1,h=bottom_magnet[1]+.1,$fn=64);
      }
  }
}
module dip(angle=20,radius=10) {
  echo(str("Dip height = ",radius/(sin(angle)+cos(angle))*2));
  union() {
  translate([0,0,-.01]) linear_extrude(.02) children();
  translate([0,-radius,0]) rotate([90,0,90]) rotate_extrude2(angle=angle ,$fn=64) {
    translate([radius,0]) children();
    translate([0,radius,-.01]) linear_extrude(.02) children();
    translate([0,radius])
    rotate([90,0,90]) mirror([1,0]) translate([-radius,0,-.01]) rotate_extrude2(angle=angle*2,$fn=64) {
      translate([radius,0]) children();
      translate([0,radius,-.01]) linear_extrude(.02) children();
      translate([0,radius]) rotate([-90,0,90]) mirror([1,0]) translate([-radius,0]) rotate_extrude(angle=-angle,$fn=64) translate([radius,0]) children();
    }
   }
  }
}
module criss_cross(lead=0,under=0,holes=1,ends=1) {
  z=1;
  zang=50;
  lead1=is_list(lead)?lead[0]:lead;
  zlen1=1.5+lead1;
  zlen2=5;
  tlen=40+lead1*2;
  lead2=is_list(lead)&&len(lead)>1?lead[1]:10+lead;
//  zlen2=53.3;
  bw=z==1?30:(z==2?49.9:70);
  bh=z==1?24:(z==2?48:72);
  difference() {
    union() {
      translate([0,-12.5,-9.5]) cube([tlen,25,9.5]);
      if(lead2>2.5) mirrory() translate([tlen/2,tlen/2]) rotate([0,0,0]) rotate([90,0]) translate([0,0,lead2]) mirror([0,0,1]) {
        linear_extrude(lead2) end_profile(0);
      }
      translate([tlen/2,10,5.5]) rotate([90,0]) rotate([0,0,180]) rotate_extrude(angle=180,convexity=3) translate([5.5,0]) square([2,20]);
  rotate([0,0,90]) rotate([90,0])
  difference() {
    mirrorz(tlen) union() {
      linear_extrude(zlen1,convexity=4) end_profile();
      translate([0,10,zlen1]) {
        rotate([90,0,-90]) rotate_extrude(angle=zang,convexity=4,$fn=64) translate([10,0]) rotate([0,0,90]) end_profile();
        rotate([-zang,0]) translate([0,-10]) {
          linear_extrude(zlen2,convexity=4) end_profile();
          translate([0,-10,zlen2]) {
            rotate([90,0,-90]) rotate_extrude(angle=-zang,convexity=4,$fn=64) translate([-10,0]) rotate([0,0,90]) end_profile();
          }
        }
      }
    }
    }
   }
   if(lead2<2.5) {
    mirrory() translate([tlen/2,12.51]) rotate([0,0,0]) rotate([90,0])
        translate([0,0,2.52+abs(lead2)]) mirror([0,0,1]) linear_extrude(2.52+abs(lead2),scale=[1.0,1.2]) offset(0.5,$fn=20) end_profile(0);
   }
   if(ends) {
    mirrory() translate([tlen/2,tlen/2]) rotate([0,0,0]) rotate([90,0])     translate([0,0,10-lead2]) 
          end_features();
    mirrorx(tlen) rotate([0,90]) rotate([0,0,90]) end_features();
   }
     translate([tlen/2,10,5.5]) rotate([90,0]) translate([0,0,-.01]) { 
       translate([0,0,-5]) cylinder(d=11,h=5+lead2+.02,$fn=64);
       translate([0,0,lead2]) dip(angle=30,radius=10.02) circle(d=11,$fn=64);
       translate([0,0,25.02+lead2*2]) mirror([0,0,1]) cylinder(d=11,h=5+lead2+.02,$fn=64);
       //cylinder(d=11,h=20.02+lead2*2,$fn=64);
     }
     if(holes){
     mirrorx(tlen)
      translate([11,0,-9.51]) cylinder(d=bottom_magnet[0]+.1,h=bottom_magnet[1]+1,$fn=80);
      if(lead2>5)
     mirrory() translate([20,20-11,-9.51]) cylinder(d=bottom_magnet[0]+.1,h=bottom_magnet[1]+1,$fn=80);
   }
  }
}
module zlift(z=1) {
  *#import("STX_Z1.stl");
  *#import("STX_Z2.stl");
  *#import("STX_Z3.stl");
  zang=50;
  zlen1=5.15;
  zlen2=z==1?22:(z==2?53.3:84.6);
//  zlen2=53.3;
  bw=z==1?30:(z==2?49.9:70);
  bh=z==1?24:(z==2?48:72);
  difference() {
    union() {
      translate([5,-12.5,-9.5]) rotate([-90,0]) linear_extrude(25,convexity=3) {
        mirror([0,1]) {
          square([33,10]);
          polygon([[0,0],[bw-1,bh],[bw+5,bh],[bw,bh-6.2],[bw,0]]);
        }
      }
  
  rotate([0,0,90]) rotate([90,0])
  difference() {
    union() {
      linear_extrude(zlen1,convexity=4) end_profile();
      translate([0,10,zlen1]) {
        rotate([90,0,-90]) rotate_extrude(angle=zang,convexity=4,$fn=64) translate([10,0]) rotate([0,0,90]) end_profile();
        rotate([-zang,0]) translate([0,-10]) {
          linear_extrude(zlen2,convexity=4) end_profile();
          translate([0,-10,zlen2]) {
            rotate([90,0,-90]) rotate_extrude(angle=-zang,convexity=4,$fn=64) translate([-10,0]) rotate([0,0,90]) end_profile();
            rotate([zang,0]) translate([0,10]) linear_extrude(zlen1) end_profile();
          }
        }
      }
    }
    end_features();
    translate([0,10,zlen1]) {
        rotate([-zang,0]) translate([0,-10]) {
          translate([0,-10,zlen2]) {
            rotate([zang,0]) translate([0,10,zlen1]) mirror([0,0,1]) end_features(0);
          }
        }
      }
   }
   }
   if(z==3) {
    translate([0,-12.51]) rotate([-90,0]) linear_extrude(26,convexity=4) mirror([0,1]) offset(-1)  hull() {
      translate([23.5,4.5]) circle(r=4,$fn=32);
      translate([60.7,4.5]) circle(r=4,$fn=32);
      polygon([[64.7,52],[60.9,55.6],[55,37]]);
    }
   }
    #for(x=[12,(bw-15)/2+12,bw-3]) translate([x,0,-9.51]) cylinder(d=bottom_magnet[0]+.1,h=bottom_magnet[1]+.1,$fn=64);
    }
}
module button(body=0) {
  if(body==1) {
    import("STX_IB2_body.stl");
    if(side_magnet[0] != 6.1)
      mirrorx(40) #mirrory() translate([0,8,-.5]) rotate([0,90,0]) difference() {
        cylinder(d=7,h=side_magnet[1],$fn=48);
        translate([0,0,-.01]) cylinder(d=side_magnet[0]+.1,h=side_magnet[1]+.1,$fn=64);
      }
    mirrory() translate([20,6,-9.5]) difference() {
      cylinder(d=9,h=3,$fn=48);
      translate([0,0,-.01]) cylinder(d=bottom_magnet[0]+.1,h=bottom_magnet[1]+.1,$fn=64);
    }
  } else {
    import("STX_IB2_bat.stl");
  *import("STX_IB2_cover.stl");
    mirrory() translate([20,6,-0.55]) difference() {
      cylinder(d=9,h=3,$fn=48);
      translate([0,0,-.01]) cylinder(d=bottom_magnet[0]+.1,h=bottom_magnet[1]+.1,$fn=64);
    }
  }
}
module why() {
  *#import("STX_MD1.stl");
  
  
  dang=36;
  dlen=17.5;
  difference() {
    union() {
    *#translate([dlen-3.5,0,5]) sphere(d=10,$fn=80);
    rotate([0,0,90]) rotate([90,0]) {
      linear_extrude(9,convexity=3) end_profile(0);
    }
    mirrory() translate([9,-12.5]) rotate([0,0,90-dang]) {
      rotate_extrude(angle=dang,convexity=3,$fn=96) translate([12.5,0]) end_profile(0);
      rotate([0,0,90]) mirror([1,0]) rotate([0,0,90]) rotate([90,0]) union() {
        linear_extrude(dlen,convexity=4) translate([-12.5,0]) end_profile(0);
        translate([0,0,dlen]) mirror([1,0]) rotate([0,180-dang]) rotate([-90,dang,0]) translate([-25,0]) {
          rotate_extrude(angle=dang,convexity=4,$fn=64) translate([12.5,0]) end_profile(0);
          rotate([0,0,90+dang]) rotate([90,0,90]) translate([-12.5,0]) difference() {
            linear_extrude(2.145) end_profile(0);
            translate([0,0,2.145]) mirror([0,0,1]) {
              end_features();
              translate([0,-9.51,11]) rotate([-90,0]) cylinder(d=bottom_magnet[0]+.1,h=bottom_magnet[1]+.1,$fn=64);
            }
          }
        }
      }
    }
      for(pos=[[14.2,10.5],[14.2,-10.5],[25,0]]) translate(pos) translate([0,0,8]) cylinder(d=5,h=3,$fn=48);
    }
    for(pos=[[14.2,10.5],[14.2,-10.5],[25,0]]) translate(pos) translate([0,0,-9.51]) {
      cylinder(d=2,h=20.52,$fn=20);
      mirrorz(20.52) cylinder(d1=3,d2=2,h=.5,$fn=20);
    }
    rotate([0,0,90]) rotate([90,0]) {
          end_features();
      translate([0,-9.51,11]) rotate([-90,0]) cylinder(d=bottom_magnet[0]+.1,h=bottom_magnet[1]+.1,$fn=64);
      translate([0,5.5,-.01]) cylinder(d=11,h=9.02,$fn=80);
    }
    mirrory() translate([9,-12.5]) rotate([0,0,90-dang]) {
      rotate_extrude(angle=dang,convexity=3,$fn=96) translate([12.5,5.5]) circle(d=11,$fn=80);
      rotate([0,0,90]) mirror([1,0]) rotate([0,0,90]) rotate([90,0]) union() {
        translate([0,0,-.01]) linear_extrude(dlen+.02,convexity=4) translate([-12.5,5.5]) circle(d=11,$fn=80);
        translate([0,0,dlen]) mirror([1,0]) rotate([0,180-dang]) rotate([-90,dang,0]) translate([-25,0]) {
          rotate_extrude(angle=dang,convexity=4,$fn=64) translate([12.5,5.5]) circle(d=11,$fn=80);
          rotate([0,0,90+dang]) rotate([90,0,90]) translate([-12.5,0]) {
            translate([0,0,2.145]) mirror([0,0,1]) {
              translate([0,5.5,-.01]) cylinder(d=11,h=2.2,$fn=80);
              translate([0,-9.51,11]) rotate([-90,0]) cylinder(d=bottom_magnet[0]+.1,h=bottom_magnet[1]+.1,$fn=64);
            }
          }
          }
        }
      }
  }
}
module chaos_box(insert=0) {
  *#translate([-60,-45]) import("STX_CHAOS_BOX.stl");
  
  if(insert) {
    !translate([-60,-45]) import("STX_CHAOS_BOX_INSERT.stl");
    insx=2.8;
    insy=1.6;
    %translate([-50+insx,-60+insy,-2.2]) {
      difference() {
        cube([100-insx*2,120-insy*2,14.2]);
        translate([1.2,1.2,1.2]) cube2([100-insx*2-2.4,120-insy*2-2.4,20],7.5,$fn=64);
       }
      translate([1.2,20.25,1.2]) difference() {
        cube([7.5,17,12.2]);
        mirrory(16.2) translate([0,0,0]) translate([5,0,5]) {
           sphere(r=5.75,$fn=64);
          translate([2.5,0]) cylinder(r=7.5,h=10,$fn=64);
          rotate([0,0,45]) rotate([0,90]) {
            #cylinder(r=5.75,h=10,$fn=64);
            translate([-25,0,1]) cube([25,5.75,10]);
          }
        }
      }
    }
  } else
  translate([-50,-60,-9.5]) difference() {
    union() {
      cube([100,120,21.5]);
      mirrorx(100) {
        cube([2.8,120,22.5]);
        for(y=[15:30:120]) translate([-10,y,9.5]) 
          rotate([90,0]) rotate([0,90]) linear_extrude(10,convexity=3) end_profile(0);
      }
    }
    mirrorx(100) for(y=[15:30:120]) translate([-10,y,9.5]) 
        rotate([90,0]) rotate([0,90]) 
        {
          end_features(15);
        }
    translate([2.8,1.6,7.3]) cube([100-2.8*2,120-1.6*2,30]);
    mirrorx(100) mirrory(120) {
      translate([5.55,3.65,-.01]) cylinder(d=2,h=40,$fn=20);
      translate([20,15,-.01]) {
        cylinder(d=4.1,h=20,$fn=36);
        mirrorz(7.32) cylinder(d1=5.5,d2=4.1,h=1,$fn=36);
      }
    }
    for(x=[10:40:90],y=[15:45:105]) translate([x,y,-.01]) cylinder(d=bottom_magnet[0]+.1,h=bottom_magnet[1]+.1,$fn=64);
  }
}
module bucket(dims=[220,60,85],inset=1,text="",bank=0,carousel=0) {
  *#import("MBL.stl");
  translate([-dims[0]/2,-dims[1]/2]) difference() {
    union() {
      rcube(dims,r=5);
      if(carousel)
      {
        translate([-15,0,0]) rcube([30,dims[1],10],7);
        translate([-8,0]) cube([16,14,6]);
      }
    }
    if(bank)
    {
      bankr=5.5;
      maxy=dims[1]-2-bankr-bottom_magnet[1]-.5;
      minx=2+bankr;
      bankz=22;
      bankz2=22;
      hull() {
        for(pos=[[minx,minx,minx],[dims[0]-minx,minx,bankz2],
          [minx,maxy,bankz],
          [dims[0]-minx,maxy,bankz],
          [minx,minx,dims[2]],[dims[0]-minx,minx,dims[2]],
          [minx,maxy,dims[2]],[dims[0]-minx,maxy,dims[2]]
          ])
          translate(pos) sphere(r=bankr,$fn=16);
      }
    } else
    translate([2,2,2]) cube2([dims[0]-4,dims[1]-4.47-bottom_magnet[1],dims[2]+5]);
    if(carousel) translate([7.5,7.5,7.5]) rotate([0,-90]) {
      cylinder(d=11,h=15,$fn=48);
      translate([0,0,15]) rotate([-90,0]) {
        sphere(d=11,$fn=48);
        rotate([0,90]) cylinder(d=11,h=10,$fn=48);
        cylinder(d=11,h=dims[1]-15,$fn=48);
        translate([0,-5.5,0]) cube([11,11,dims[1]-15]);
        translate([0,0,dims[1]-15]) {
          sphere(d=11,$fn=48);
          rotate([0,90]) cylinder(d=11,h=10,$fn=48);
        }
      }
    }
    
    translate([-.01,20,dims[2]-15]) mirror([0,0,1]) rotate([0,90]) linear_extrude(dims[0]+.02,convexity=3) {
      difference() {
        translate([8,-7]) square([7.01,7.01]);
        translate([8,-7]) circle(r=7,$fn=48);
      }
      hull() {
        translate([5,5]) circle(r=5,$fn=48);
        translate([0,5]) square([10,dims[1]]);
        translate([5,0]) square([20,dims[1]+5]);
      }
    }
    if(inset) {
      translate([dims[0]/2-13,0,16.5]) translate([13,-.01,24]) mirror([0,0,1]) rotate([-90,0]) linear_extrude(0.81,scale=[0.99,0.95],convexity=3) translate([-dims[0]/2+12.5,-17]) rsquare([dims[0]-25,34],6);
      fholes=5;
      fdist=(dims[0]-60) / (fholes-1);
      for(x=[30:fdist:dims[0]-30]) translate([x,0,40.5]) rotate([-90,0]) cylinder(d=side_magnet[0],h=3,$fn=48);
    }
    else if(text!=""&&text_depth>0) {
      translate([dims[0]/2,text_depth-.01,(dims[2]-15)/2]) rotate([90,0]) linear_extrude(text_depth,convexity=3) text(text, size=text_size, font=text_font, halign="center", valign="center");
    }
    hholes=ceil((dims[0]-40) / 15);
    hdist=(dims[0]-40) / (hholes-1);
    for(x=[20:hdist:dims[0]-20],z=dims[2]>50?[12,dims[2]-27]:[12]) translate([x,dims[1]-bottom_magnet[1],z]) rotate([-90,0]) cylinder(d=bottom_magnet[0]+.1,h=10,$fn=64);
    translate([20,-.01,dims[2]-15]) mirror([0,0,1]) rotate([-90,0]) linear_extrude(3.02,convexity=3) {
      rsquare([dims[0]-40,20]);
      mirrorx(dims[0]-40) translate([-7,8]) difference() {
        square([7.01,7.01]);
        circle(r=7,$fn=48);
      }
    }
  }
  if(text!=""&&text_depth<0)
    translate([0,dims[1]/-2,(dims[2]-15)/2]) rotate([90,0]) linear_extrude(-text_depth,convexity=3) text(text, size=text_size, font=text_font, halign="center", valign="center");
}
module bend(angle=60,radius=0,lead=10.1) {
  *#import("STX_TE.stl");
  translate([lead,0])
  difference() {
    union() {
      translate([0,-12.5,0]) for(r=[0,angle]) mirror(r>0?[1,0,0]:[0,0]) rotate([0,0,r])
        translate([-lead,0]) translate([0,12.5,0]) rotate([0,0,90]) rotate([90,0])
          linear_extrude(lead,convexity=3) end_profile();
      translate([0,-12.5]) rotate([0,0,90-angle]) rotate_extrude(angle=angle,convexity=3,$fn=96) translate([12.5,0]) end_profile();
    }
    translate([0,-12.5,0]) for(r=[0,angle]) mirror(r>0?[1,0,0]:[0,0]) rotate([0,0,r])
      translate([-lead,0]) translate([0,12.5,0]) rotate([0,0,90]) rotate([90,0]) union() {
      end_features();
      translate([0,-9.51,10.5]) rotate([-90,0]) cylinder(d=bottom_magnet[0]+.1,h=bottom_magnet[1]+.1,$fn=64);
    }
  }
}
module funnel(size=1) {
  if(size==1) {
    translate([0,0,9.5]) import("STX_F1.stl");
    mirrory() translate([0,8,9]) rotate([0,90]) difference() {
      cylinder(d=8,h=4,$fn=64);
      translate([0,0,-.01]) {
        cylinder(d=side_magnet[0],h=side_magnet[1]+0.05,$fn=48);
      }
    }
    for(x=[16.5,32.5,48.5]) translate([x,0]) difference() {
      cylinder(d=9,h=4,$fn=64);
      translate([0,0,-.01]) {
        cylinder(d=bottom_magnet[0]+.1,h=bottom_magnet[1]+.1,$fn=64);
        cylinder(d1=bottom_magnet[0]+0.8,d2=bottom_magnet[0]+.1,h=0.4,$fn=64);
      }
    }
  } else if(size==2) {
    translate([0,0,9.5]) import("STX_F2.stl");
    mirrory() translate([0,8,9]) rotate([0,90]) difference() {
      cylinder(d=8,h=4,$fn=64);
      translate([0,0,-.01]) {
        cylinder(d=side_magnet[0],h=side_magnet[1]+0.05,$fn=48);
      }
    }
    for(x=[20.5,42.5,64.5]) for(y=x==64.5?[-22,0,22]:[0]) translate([x,y]) difference() {
      cylinder(d=9,h=4,$fn=64);
      translate([0,0,-.01]) {
        cylinder(d=bottom_magnet[0]+.1,h=bottom_magnet[1]+.1,$fn=64);
        cylinder(d1=bottom_magnet[0]+0.8,d2=bottom_magnet[0]+.1,h=0.4,$fn=64);
      }
    }
  }
}
module tee() {
  len=triad_len;
  hoff=[-7.8,10];
  difference() {
    for(r=[0,90,-90]) rotate([0,0,r])
      translate([-len,0]) rotate([0,0,90]) rotate([90,0])
        linear_extrude(len,convexity=3) end_profile();
    for(r=[0,90,-90]) rotate([0,0,r])
      translate([-len,0]) rotate([0,0,90]) rotate([90,0]) union() {
      end_features();
      translate([0,5.5]) cylinder(d=11,h=len,$fn=80);
      translate([0,-9.51,10.5]) rotate([-90,0]) cylinder(d=bottom_magnet[0]+.1,h=bottom_magnet[1]+.1,$fn=64);
      *translate([hoff[0],-10,hoff[1]]) 
          rotate([-90,0]) cylinder(d=1.75,h=22,$fn=40);
    }
  }
  *for(r=[0,90,-90]) rotate([0,0,r])
      translate([-len,0])
        translate([hoff[1],hoff[0],9.5]) difference() {
          cylinder(d=4,h=1.5,$fn=64);
          translate([0,0,-.01])
          cylinder(d=1.75,h=1.52,$fn=40);
        }
}
module cross() {
  len=20;
  hoff=[-8,12];
  difference() {
    for(r=[0:90:359]) rotate([0,0,r])
      translate([-len,0]) rotate([0,0,90]) rotate([90,0])
        linear_extrude(len,convexity=3) end_profile(0);
    for(r=[0:90:359]) rotate([0,0,r])
      translate([-len,0]) rotate([0,0,90]) rotate([90,0]) union() {
      end_features();
      translate([0,5.5,-.01]) cylinder(d=11,h=len+.02,$fn=80);
      translate([0,-9.51,10.5]) rotate([-90,0]) cylinder(d=bottom_magnet[0]+.1,h=bottom_magnet[1]+.1,$fn=64);
      translate([hoff[0],-10,hoff[1]]) 
          rotate([-90,0]) cylinder(d=1.75,h=22,$fn=40);
    }
  }
  for(r=[0:90:359]) rotate([0,0,r])
      translate([-len,0])
        translate([hoff[1],hoff[0],9.5]) difference() {
          cylinder(d=4,h=1.5,$fn=64);
          translate([0,0,-.01])
          cylinder(d=1.75,h=1.52,$fn=40);
        }
}
module triad() {
  *#translate([-triad_len,0]) import("STX_TRD.stl");
  len=triad_len;
  difference() {
    for(r=[0:120:359]) rotate([0,0,r])
      translate([-len,0]) rotate([0,0,90]) rotate([90,0])
        linear_extrude(len,convexity=3) end_profile();
    for(r=[0:120:359]) rotate([0,0,r])
      translate([-len,0]) rotate([0,0,90]) rotate([90,0]) union() {
      end_features();
      translate([0,5.5]) cylinder(d=11,h=len,$fn=80);
      translate([0,-9.51,10.5]) rotate([-90,0]) cylinder(d=bottom_magnet[0]+.1,h=bottom_magnet[1]+.1,$fn=64);
      translate([-7.21,-10,11.6]) 
          rotate([-90,0]) cylinder(d=1.75,h=22,$fn=40);
    }
  }
  for(r=[0:120:359]) rotate([0,0,r])
      translate([-len,0])
        translate([11.6,-7.21,9.5]) difference() {
          cylinder(d=4,h=1.5,$fn=64);
          translate([0,0,-.01])
          cylinder(d=1.75,h=1.52,$fn=40);
        }
}

module right(radius=10,lead=10,holes=-1) {
  radius=max(10,radius);
  holes=holes>-1?holes:max(1,floor(radius/12));
  translate([lead,-radius]) rotate([0,0,90]) rotate([90,0])
  difference() {
    union() {
      translate([radius,0,-lead]) linear_extrude(lead,convexity=3) end_profile();
      mirror([-1,0,1]) translate([radius,0,-lead]) linear_extrude(lead,convexity=3) end_profile();
      rotate([-90,180,0]) rotate([0,0,90]) rotate_extrude(angle=90,convexity=3,$fn=80) intersection() {
        translate([radius,0])
          end_profile();
        translate([0,-10]) square([25+radius,20]);
      }
    }
    translate([radius,0,-lead-.01]) end_features();
    mirror([-1,0,1]) translate([radius,0,-lead-.01]) end_features();
    if(holes==1)
      rotate([0,-45]) translate([radius-1.8675,-10]) rotate([-90,0]) cylinder(d=bottom_magnet[0]+.1,h=bottom_magnet[1]+1,$fn=64);
    else if(holes==2)
      for(r=[-75,-15]) rotate([0,r]) translate([radius+.75,-10]) rotate([-90,0]) cylinder(d=bottom_magnet[0]+.1,h=bottom_magnet[1]+1,$fn=64);
    else if(holes>1)
      #for(r=[-90:90/(holes-1):0]) rotate([0,r]) translate([radius+.75,-10]) rotate([-90,0]) cylinder(d=bottom_magnet[0]+.1,h=bottom_magnet[1]+1,$fn=64);
  }
}
module straight(len=40,holes=-1) {
  holes=holes>-1?holes:1+floor(len/40);
  rotate([0,0,90]) rotate([90,0])
  difference() {
    linear_extrude(len,convexity=3) end_profile();
    mirrorz(len) {
      end_features();
    }
    if(holes>1)
      for(z=[12:(len-24)/(holes-1):len-12])
        translate([0,-10,z]) rotate([-90,0]) cylinder(d=bottom_magnet[0]+.1,h=bottom_magnet[1]+1,$fn=80);
    else if(holes==1)
      translate([0,-10,len/2]) rotate([-90,0]) cylinder(d=bottom_magnet[0]+.1,h=bottom_magnet[1]+1,$fn=80);
  }
}
module end_features(ball=0) {
  mirrorx() translate([8,-.5,-.01]) cylinder(d=side_magnet[0],h=side_magnet[1]+0.05,$fn=48);
  translate([-1.5,-10,-.01]) cube([3,5.5,5]);
  translate([0,5.5,-.01]) rotate_extrude(convexity=3,$fn=80) {
    translate([5,0]) polygon([[1,0],[0,0],[0,1]]);
  }
  if(ball>0)
    translate([0,5.5,-.01]) cylinder(d=11,h=ball,$fn=80);
}
module end_profile(ball=1) {
  difference() {
    square([25,19],center=true);
    if(ball)
      translate([0,5.5]) circle(d=11,$fn=80);
    mirrorx() translate([13,6]) rotate([0,0,45]) square(10);
  }
}
module mirrorx(off=0)
{
  translate([off/2,0]) for(m=[0,1]) mirror([m,0]) translate([off/-2,0]) children();
}
module mirrory(off=0)
{
  translate([0,off/2,0]) for(m=[0,1]) mirror([0,m,0]) translate([0,off/-2,0]) children();
}
module mirrorz(off=0)
{
  translate([0,0,off/2]) for(m=[0,1]) mirror([0,0,m]) translate([0,0,off/-2]) children();
}
module rsquare(dims,r=5,center=false,$fn=30)
{
  translate(center?[dims[0]/-2,dims[1]/-2]:[0,0])
  hull() for(x=[r,dims[0]-r],y=[r,dims[1]-r]) translate([x,y]) circle(r=r,$fn=$fn);
}
module rcube(dims,r=5,$fn=30)
{
  linear_extrude(dims[2],convexity=3) {
    for(x=[r,dims[0]-r],y=[r,dims[1]-r])
      translate([x,y]) circle(r=r,$fn=$fn);
    translate([0,r]) square([dims[0],dims[1]-r*2]);
    translate([r,0]) square([dims[0]-r*2,dims[1]]);
  }
}
module cube2(dims,r=5,$fn=30)
{
  minkowski() {
    translate([r,r,r]) cube([dims[0]-r*2,dims[1]-r*2,dims[2]-r*2]);
    sphere(r=r,$fn=$fn);
  }
}
module extrusion(length,size=40) {
  linear_extrude(length) extrusion_profile(size);
}
module extrusion_profile(size=40) {
  difference() {
    translate([-size/2,-size/2]) rsquare([size,size],3);
    for(r=[0:3]) rotate([0,0,r*90]) translate([-size/2,-size/2])
    polygon([[15,-.01],[15,5.5],[10,5.5],[10,7.5],[15,12.5],[25,12.5],[30,7.5],[30,5.5],[25,5.5],[25,-.01]]);
  }
}

function inches(in) = 25.4 * in;