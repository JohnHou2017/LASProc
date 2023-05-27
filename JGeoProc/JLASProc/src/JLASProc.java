import java.util.ArrayList;
import java.io.IOException;
import java.io.RandomAccessFile;
import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.File;

import GeoProc.*;

public class JLASProc {

	public static void main(String[] args) {
		
		ArrayList<GeoPoint> CubeVertices = new ArrayList<GeoPoint>();
         
		CubeVertices.add(new GeoPoint(-27.28046,  37.11775,  -39.03485));
		CubeVertices.add(new GeoPoint(-44.40014,  38.50727,  -28.78860));
		CubeVertices.add(new GeoPoint(-49.63065,  20.24757,  -35.05160));
		CubeVertices.add(new GeoPoint(-32.51096,  18.85805,  -45.29785));
		CubeVertices.add(new GeoPoint(-23.59142,  10.81737,  -29.30445));
		CubeVertices.add(new GeoPoint(-18.36091,  29.07707,  -23.04144));
		CubeVertices.add(new GeoPoint(-35.48060,  30.46659,  -12.79519));
		CubeVertices.add(new GeoPoint(-40.71110,  12.20689,  -19.05819));
        
        // Create polygon instance 
        GeoPolygon polygonInst = new GeoPolygon(CubeVertices);

        // Create main process instance 
        GeoPolygonProc procInst = new GeoPolygonProc(polygonInst);

        // Get cube boundary 
        double xmin = procInst.getX0();
        double xmax = procInst.getX1();
        double ymin = procInst.getY0();
        double ymax = procInst.getY1();
        double zmin = procInst.getZ0();
        double zmax = procInst.getZ1();
        
        String workPath = "C:\\Documents and Settings\\Administrator\\workspace\\JLASProc";
        		
        String fileNameRB = workPath + "\\LASInput\\cube.las";
        String fileNameWB = workPath + "\\LASOutput\\cube_inside.las";
        String fileNameWT = workPath + "\\LASOutput\\cube_inside.txt";

        try
        {
        	
        	RandomAccessFile rFile = new RandomAccessFile(fileNameRB, "r");
        	RandomAccessFile wbFile = new RandomAccessFile(fileNameWB, "rw");
        	
        	BufferedWriter wtFile = new BufferedWriter(new FileWriter(new File(fileNameWT)));
        	        	
        	// Read LAS public header
        	        	        	
        	byte[] byte8 = new byte[8];
        	byte[] byte4 = new byte[4];
        	byte[] byte2 = new byte[2];
        	
        	rFile.seek(96);
        	
        	// JAVA byte[] is Big-Endian byte order as default, the LAS file is Little-Endian data
        	// byte[] array must convert back to Little-Endian to compose the number
        	rFile.read(byte4);        	
        	int offset_to_point_data_value = Utility.GetUInt32(byte4);
        	
        	rFile.read(byte4);        	
            int variable_len_num = Utility.GetUInt32(byte4);
            
            byte record_type_c = rFile.readByte();
            int record_type = Utility.GetUByte(record_type_c);
            
            rFile.read(byte2);
            int record_len = Utility.GetUInt16(byte2);
            
            rFile.read(byte4);            
            int record_num = Utility.GetUInt32(byte4);
            
            rFile.seek(131);
            
            rFile.read(byte8);
            double x_scale = Utility.getDouble(byte8);
            rFile.read(byte8);
            double y_scale = Utility.getDouble(byte8);
            rFile.read(byte8);
            double z_scale = Utility.getDouble(byte8);
            rFile.read(byte8);
            double x_offset = Utility.getDouble(byte8);
            rFile.read(byte8);
            double y_offset = Utility.getDouble(byte8);
            rFile.read(byte8);
            double z_offset = Utility.getDouble(byte8);
            
            // Get LAS header
	        rFile.seek(0);
            byte[] bufHeader = new byte[offset_to_point_data_value];
            rFile.read(bufHeader);
            
            // Copy LAS header
            wbFile.write(bufHeader);

            byte[] bufRecord = new byte[record_len];

            int insideCount = 0;
            
            // Process point records
	        for(int i=0;i<record_num;i++)
	        {	

		        int record_loc = (int)(offset_to_point_data_value + record_len * i);

                rFile.seek(record_loc);			        

		        // Record coordinates
                rFile.read(byte4);
                long x = Utility.GetUInt32(byte4);
                rFile.read(byte4);
                long y = Utility.GetUInt32(byte4);
                rFile.read(byte4);
                long z = Utility.GetUInt32(byte4);
                		 
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
			        	wtFile.write(String.format("%15.6f %15.6f %15.6f\n", ax, ay, az) );
			        	
                        // Get point record
                        rFile.seek(record_loc);
                        rFile.read(bufRecord);                        

				        // Write to binary LAS file
                        wbFile.write(bufRecord);
				        	
				        insideCount++;
			        }													
		        }
				
	        }
						
	        // Update total record numbers in output binary LAS file header
	        // Convert insideCount to Little-Endian to write back
	        wbFile.seek(107);	        
	        byte[] bytes = Utility.GetIntBytes(insideCount);
            wbFile.write(bytes);
	        	                   
        	rFile.close();
        	wbFile.close();
        	wtFile.close();
        	
        	bufHeader = null;
        	bufRecord = null;
        	byte2 = null;
        	byte4 = null;
        	byte8 = null;
        	      
        }
		catch (IOException ex) {
			String errMsg = ex.getMessage();
		}
        
       
	}

}
