import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.RandomAccessFile;

public class Base62Test {

	public static void main(String[] args) 
	{		
		Test();
	}
	
	private static void Test()
	{
				
		String workPath = "C:\\Documents and Settings\\Administrator\\workspace\\Base62";
 		
	    String fileNameRB = workPath + "\\Test\\lena.jpg";
	    
	    String fileNameWB = workPath + "\\Test\\decodedTest.jpg";
	        
	    String fileNameWT = workPath + "\\Test\\encodedTest.txt";

        try
        {
        	// encode 
        	RandomAccessFile rbFile = new RandomAccessFile(fileNameRB, "r");        	       	
        	BufferedWriter wtFile = new BufferedWriter(new FileWriter(new File(fileNameWT)));        	                                                
        	int rFileLength = (int)rbFile.length();
	        rbFile.seek(0);
            byte[] buf = new byte[rFileLength];
            rbFile.read(buf);                               
            String encodedStr = Base62.base62Encode(buf);
            wtFile.write(encodedStr);            	       	             	       
        	wtFile.close();
        	rbFile.close();
        	buf = null;
        	
        	// decode
        	RandomAccessFile wbFile = new RandomAccessFile(fileNameWB, "rw");         	
        	File file = new File(fileNameWT);
        	FileReader rtFile = new FileReader(fileNameWT);
        	int len = (int) file.length();
        	char[] chars = new char[len];
        	rtFile.read(chars);        	 
        	byte[] decodedArr = Base62.base62Decode(chars);
        	wbFile.write(decodedArr);        	
        	rtFile.close();             	
        	wbFile.close();        	        	
        	decodedArr = null;
        	
        }
		catch (IOException ex) {
			String errMsg = ex.getMessage();
	
		}
	}

}
