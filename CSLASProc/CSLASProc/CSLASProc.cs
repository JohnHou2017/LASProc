using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using System.IO;
using GeoProc;

namespace LASProc
{
    class CSLASProc
    {
               
        static void Main(string[] args)
        {
            List<GeoPoint> CubeVertices = new List<GeoPoint>()
            {  
	            new GeoPoint(-27.28046,         37.11775,        -39.03485),
	            new GeoPoint(-44.40014,         38.50727,        -28.78860),
	            new GeoPoint(-49.63065,         20.24757,        -35.05160),
	            new GeoPoint(-32.51096,         18.85805,        -45.29785),
	            new GeoPoint(-23.59142,         10.81737,        -29.30445),
	            new GeoPoint(-18.36091,         29.07707,        -23.04144),
	            new GeoPoint(-35.48060,         30.46659,        -12.79519),
	            new GeoPoint(-40.71110,         12.20689,        -19.05819)
            };

            // Create polygon instance 
            GeoPolygon polygonInst = new GeoPolygon(CubeVertices);

            // Create main process instance 
            GeoPolygonProc procInst = new GeoPolygonProc(polygonInst);

            // Get cube boundary 
            double xmin = 0, xmax = 0, ymin = 0, ymax = 0, zmin = 0, zmax = 0;
            procInst.GetBoundary(ref xmin, ref xmax, ref ymin, ref ymax, ref zmin, ref zmax);
           
            // Offset bytes and data types are based on LAS 1.2 Format 
            
            string fileNameRB = Directory.GetCurrentDirectory() + "..\\..\\..\\..\\LASInput\\cube.las";
            string fileNameWB = Directory.GetCurrentDirectory() + "..\\..\\..\\..\\LASOutput\\cube_inside.las";
            string fileNameWT = Directory.GetCurrentDirectory() + "..\\..\\..\\..\\LASOutput\\cube_inside.txt";

            using (BinaryReader reader = new BinaryReader(File.Open(fileNameRB, FileMode.Open)))
            using (BinaryWriter writerWB = new BinaryWriter(File.Open(fileNameWB, FileMode.Create)))
            using (StreamWriter writerWT = new StreamWriter(fileNameWT, false))
            {
                int insideCount = 0;

                // Read LAS public header

                reader.BaseStream.Seek(96, SeekOrigin.Begin);
                UInt32 offset_to_point_data_value = reader.ReadUInt32();
                UInt32 variable_len_num = reader.ReadUInt32();
                Byte record_type_c = reader.ReadByte();
                int record_type = record_type_c;
                UInt16 record_len = reader.ReadUInt16();
                UInt32 record_num = reader.ReadUInt32();

                reader.BaseStream.Seek(131, SeekOrigin.Begin);
                double x_scale = reader.ReadDouble();
                double y_scale = reader.ReadDouble();
                double z_scale = reader.ReadDouble();
                double x_offset = reader.ReadDouble();
                double y_offset = reader.ReadDouble();
                double z_offset = reader.ReadDouble();
                		        		
		        // Get LAS header
		        reader.BaseStream.Seek(0, SeekOrigin.Begin);
                byte[] bufHeader = new byte[offset_to_point_data_value];
                bufHeader = reader.ReadBytes((int)offset_to_point_data_value);
                
                // Copy LAS header
                writerWB.Write(bufHeader);

                byte[] bufRecord = new byte[record_len];

                // Process point records
		        for(int i=0;i<record_num;i++)
		        {	

			        int record_loc = (int)(offset_to_point_data_value + record_len * i);

                    reader.BaseStream.Seek(record_loc, SeekOrigin.Begin);			        

			        // Record coordinates
                    long x = reader.ReadInt32();
                    long y = reader.ReadInt32();
                    long z = reader.ReadInt32();			 

			        // Actual coordinates
			        double ax = (x*x_scale)+x_offset;
			        double ay = (y*y_scale)+y_offset;
			        double az = (z*z_scale)+z_offset;	
										       			        					
			        // Filter out the points outside of boundary to reduce computing
			        if(ax>xmin && ax<xmax && ay>ymin && ay<ymax && az>zmin && az<zmax)
			        {					
				        // Main Process to check if the point is inside of the cube				
				        if(procInst.PointInside3DPolygon(ax, ay, az))
				        {										
					        // Write the actual coordinates of inside point to text file
                            writerWT.WriteLine("{0:0.000000} {1:0.000000} {2:0.000000}", ax, ay, az);

                            // Get point record
                            reader.BaseStream.Seek(record_loc, SeekOrigin.Begin);
                            bufRecord = reader.ReadBytes((int)record_len);

					        // Write to binary LAS file
                            writerWB.Write(bufRecord);
					        	
					        insideCount++;
				        }													
			        }
					
		        }
							
		        // Update total record numbers in output binary LAS file		        
                writerWB.BaseStream.Seek(107, SeekOrigin.Begin);
                writerWB.Write(insideCount);
		        	
            }

        }
    }
}
