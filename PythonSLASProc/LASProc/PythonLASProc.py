import struct
import sys
sys.path.append('../GeoProc')

from GeoPoint import *
from GeoPolygon import *
from GeoPolygonProc import *

print('Start Processing ...')

try:

    # prepare GeoPolygonProc instance
    p1 = GeoPoint( - 27.28046,  37.11775,  - 39.03485)
    p2 = GeoPoint( - 44.40014,  38.50727,  - 28.78860)
    p3 = GeoPoint( - 49.63065,  20.24757,  - 35.05160)
    p4 = GeoPoint( - 32.51096,  18.85805,  - 45.29785)
    p5 = GeoPoint( - 23.59142,  10.81737,  - 29.30445)
    p6 = GeoPoint( - 18.36091,  29.07707,  - 23.04144)
    p7 = GeoPoint( - 35.48060,  30.46659,  - 12.79519)
    p8 = GeoPoint( - 40.71110,  12.20689,  - 19.05819)
    gp = [p1, p2, p3, p4, p5, p6, p7, p8];        
    gpInst = GeoPolygon(gp)    
    procInst = GeoPolygonProc(gpInst)    

    # open files
    rbFile = open('../LASInput/cube.las', 'rb')    
    wbFile = open('../LASOutput/cube_inside.las', 'wb')    
    wtFile = open('../LASOutput/cube_inside.txt', 'w')
    
    # read LAS public header
    rbFile.seek(96)

    r_point_offset = rbFile.read(4)
    r_variable_len_num = rbFile.read(4)
    r_record_type = rbFile.read(1)
    r_record_len = rbFile.read(2)
    r_record_num = rbFile.read(4)

    rbFile.seek(131)
    r_x_scale = rbFile.read(8)
    r_y_scale = rbFile.read(8)
    r_z_scale = rbFile.read(8)
    r_x_offset = rbFile.read(8)
    r_y_offset = rbFile.read(8)
    r_z_offset = rbFile.read(8)

    point_offset = struct.unpack('I', r_point_offset)
    record_len = struct.unpack('H', r_record_len)
    record_num = struct.unpack('L', r_record_num)    
    x_scale = struct.unpack('d', r_x_scale)
    y_scale = struct.unpack('d', r_y_scale)
    z_scale = struct.unpack('d', r_z_scale)
    x_offset = struct.unpack('d', r_x_offset)
    y_offset = struct.unpack('d', r_y_offset)
    z_offset = struct.unpack('d', r_z_offset)
    
    # read LAS header
    rbFile.seek(0)
    buf = rbFile.read(point_offset[0])

    # write LAS header 
    wbFile.write(buf)
   
    insideCount = 0
  
    # read points
    for i in range(0, record_num[0]):
                            
        record_loc = int(point_offset[0]) + int(record_len[0]) * int(i)
            
        rbFile.seek(record_loc)
                
        xi = struct.unpack('l', rbFile.read(4))
        yi = struct.unpack('l', rbFile.read(4))
        zi = struct.unpack('l', rbFile.read(4))
       
        x = (int(xi[0]) * x_scale[0]) + x_offset[0]
        y = (int(yi[0]) * y_scale[0]) + x_offset[0]
        z = (int(zi[0]) * z_scale[0]) + z_offset[0]

        if (x > procInst.x0 and x < procInst.x1 and
            y > procInst.y0 and y < procInst.y1 and
            z > procInst.z0 and z < procInst.z1):
            if (procInst.PointInside3DPolygon(x, y, z)):                

                # read point record
                rbFile.seek(record_loc)
                buf = rbFile.read(record_len[0])

                # write binary point record
                wbFile.write(buf)

                #write text point record
                wtFile.write("%15.6f %15.6f %15.6f\n" % ( x, y, z) )

                insideCount = insideCount + 1
            
    # update point number of ground LAS
    wbFile.seek(107)
    wbFile.write(struct.pack('i', insideCount))
    
finally:
    wbFile.close()
    wtFile.close()
    rbFile.close()
    print('Completed.');
