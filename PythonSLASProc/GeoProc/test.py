from GeoPoint import *
from GeoVector import *
from GeoPlane import *
from GeoPolygon import *    
from GeoFace import *
from GeoPolygonProc import *

print("GeoPoint.py Test");

p0 = GeoPoint(1, 2, 3)
p1 = GeoPoint(4, 5, 6)
p2 = p0 + p1
str1 = str(p2.x) + "," + str(p2.y) + ',' + str(p2.z)
print(str1 + "\r\n")


print("GeoVector.py Test");

v1 = GeoVector(GeoPoint(1, 2, 3), GeoPoint(4, 6, 8))
v2 = GeoVector(GeoPoint(1, 2, 3), GeoPoint(15, 17, 29))
v3 = v2 * v1
str1 = str(v3.x) + ',' + str(v3.y) + ',' + str(v3.z)
print(str1 + "\r\n")


print("GeoPlane.py Test");

p1 = GeoPoint( - 27.28046,  37.11775,  - 39.03485)
p2 = GeoPoint( - 44.40014,  38.50727,  - 28.78860)
p3 = GeoPoint( - 49.63065,  20.24757,  - 35.05160)
p4 = GeoPoint( - 32.51096,  18.85805,  - 45.29785)
p5 = GeoPoint( - 23.59142,  10.81737,  - 29.30445)
p6 = GeoPoint( - 18.36091,  29.07707,  - 23.04144)
p7 = GeoPoint( - 35.48060,  30.46659,  - 12.79519)
p8 = GeoPoint( - 40.71110,  12.20689,  - 19.05819)
plInst = GeoPlane.Create(p1, p2, p3)
str1 = str(plInst.a) + ',' + str(plInst.b) + ',' + str(plInst.c) + ',' + str(plInst.d) + "\r\n"
plInst1 = GeoPlane(plInst.a, plInst.b, plInst.c, plInst.d)
str1 = str1 + str(plInst1.a) + ',' + str(plInst1.b) + ',' + str(plInst1.c) + ',' + str(plInst1.d) + "\r\n"
negInst = -plInst
str1 = str1 + str(negInst.a) + ',' + str(negInst.b) + ',' + str(negInst.c) + ',' + str(negInst.d) + "\r\n"
value1 = plInst * p4 # p4 is in triangle plane p1, p2, p3, abs(value1) < MaxError
value2 = plInst * p5 # p5 is not in triangle plane p1, p2, p3, abs(value2) > MaxError
str1 = str1 + str(value1) + "\r\n" + str(value2) + "\r\n"
print(str1 + "\r\n")


print("GeoPolygon.py Test");

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
str1 = str(gpInst.n) + "\r\n"
for pt in gpInst.v:
    str1 = str1 + str(pt.x) + ","
print(str1 + "\r\n")

print("GeoFace.py Test");

p1 = GeoPoint( - 27.28046,  37.11775,  - 39.03485)
p2 = GeoPoint( - 44.40014,  38.50727,  - 28.78860)
p3 = GeoPoint( - 49.63065,  20.24757,  - 35.05160)
p4 = GeoPoint( - 32.51096,  18.85805,  - 45.29785)
p5 = GeoPoint( - 23.59142,  10.81737,  - 29.30445)
p6 = GeoPoint( - 18.36091,  29.07707,  - 23.04144)
p7 = GeoPoint( - 35.48060,  30.46659,  - 12.79519)
p8 = GeoPoint( - 40.71110,  12.20689,  - 19.05819)
gp = [p1, p3, p5, p7];
idx = [1,3,5,7]
gpInst = GeoFace(gp, idx)
str1 = str(gpInst.n) + "\r\n"
count = len(gp)
for i in range(0, count):
    str1 = str1 + str(idx[i]) + ":" + str(gp[i].x) + ","
print(str1 + "\r\n")


print("Utility.py Test");

a1 = []
a1.append(1)
a1.append(2)
a1.append(3)
a2 = [];
a2.append(4)
a2.append(5)
a2.append(6)
listList = []
listList.append(a1)
listList.append(a2)
listItem1 = [2, 3, 1];
listItem2 = [2, 3, 6];
contain1 = Utility.ContainsList(listList, listItem1)
contain2 = Utility.ContainsList(listList, listItem2)
print(str(contain1) + ', ' + str(contain2) + "\r\n")
 
 
print("GeoPolygonProc.py Test");

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
gppInst = GeoPolygonProc(gpInst)
str1 = str(gppInst.x0) + ',' + str(gppInst.x0) + ','
str1 = str1 + str(gppInst.y0) + ',' + str(gppInst.y0) + ','
str1 = str1 + str(gppInst.z0) + ',' + str(gppInst.z0) + "\r\n"
str1 = str1 + str(gppInst.MaxDisError) + "\r\n"
str1 = str1 + str(gppInst.NumberOfFaces)
print(str1)
for i in range(0, gppInst.NumberOfFaces):
    str2 = ""
    str2 = str2 + str(gppInst.FacePlanes[i].a) + ',' + str(gppInst.FacePlanes[i].b) + ','
    str2 = str2 + str(gppInst.FacePlanes[i].c) + ',' + str(gppInst.FacePlanes[i].d)
    print(str2)
insidePoint = GeoPoint( - 28.411750,     25.794500,      - 37.969000)
outsidePoint = GeoPoint( - 28.411750,    25.794500,      - 50.969000)
b1 = gppInst.PointInside3DPolygon(insidePoint.x, insidePoint.y, insidePoint.z)
b2 = gppInst.PointInside3DPolygon(outsidePoint.x, outsidePoint.y, outsidePoint.z);
str3 = str(b1) +',' + str(b2)
print(str3)
 
