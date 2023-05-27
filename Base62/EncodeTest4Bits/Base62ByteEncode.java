import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.RandomAccessFile;
import java.util.ArrayList;
import java.util.Arrays;

public class Base62ByteEncode {
	public static void Test()
	{
		String[] Base62EncodeTable = {
				"00","01","02","03","04","05","06","07","08","09","0a","0b","0c","0d","0e","0f","0g","0h","0i","0j",
				"0k","0l","0m","0n","0o","0p","0q","0r","0s","0t","0u","0v","0w","0x","0y","0z","0A","0B","0C","0D",
				"0E","0F","0G","0H","0I","0J","0K","0L","0M","0N","0O","0P","0Q","0R","0S","0T","0U","0V","0W","0X",
				"0Y","0Z","10","11","12","13","14","15","16","17","18","19","1a","1b","1c","1d","1e","1f","1g","1h",
				"1i","1j","1k","1l","1m","1n","1o","1p","1q","1r","1s","1t","1u","1v","1w","1x","1y","1z","1A","1B",
				"1C","1D","1E","1F","1G","1H","1I","1J","1K","1L","1M","1N","1O","1P","1Q","1R","1S","1T","1U","1V",
				"1W","1X","1Y","1Z","20","21","22","23","24","25","26","27","28","29","2a","2b","2c","2d","2e","2f",
				"2g","2h","2i","2j","2k","2l","2m","2n","2o","2p","2q","2r","2s","2t","2u","2v","2w","2x","2y","2z",
				"2A","2B","2C","2D","2E","2F","2G","2H","2I","2J","2K","2L","2M","2N","2O","2P","2Q","2R","2S","2T",
				"2U","2V","2W","2X","2Y","2Z","30","31","32","33","34","35","36","37","38","39","3a","3b","3c","3d",
				"3e","3f","3g","3h","3i","3j","3k","3l","3m","3n","3o","3p","3q","3r","3s","3t","3u","3v","3w","3x",
				"3y","3z","3A","3B","3C","3D","3E","3F","3G","3H","3I","3J","3K","3L","3M","3N","3O","3P","3Q","3R",
				"3S","3T","3U","3V","3W","3X","3Y","3Z","40","41","42","43","44","45","46","47"
				};
		
		String workPath = "C:\\Documents and Settings\\Administrator\\workspace\\Base62";
 		
	    String fileNameRB = workPath + "\\Test\\lena.jpg";
	    
	    String fileNameWB = workPath + "\\Test\\decoded.jpg";
	        
	    String fileNameWT = workPath + "\\Test\\encoded.txt";

        try
        {
        	// encode 
        	RandomAccessFile rbFile = new RandomAccessFile(fileNameRB, "r");        	       	
        	BufferedWriter wtFile = new BufferedWriter(new FileWriter(new File(fileNameWT)));        	                                                
        	int rFileLength = (int)rbFile.length();
	        rbFile.seek(0);
            byte[] buf = new byte[rFileLength];
            rbFile.read(buf);                   
            
	        for(int i=0;i<rFileLength;i++)
	        {		        	
	        	wtFile.write(Base62EncodeTable[buf[i] & 0xff]);               
	        }		             	       
        	wtFile.close();
        	rbFile.close();
        	
        	// decode
        	RandomAccessFile wbFile = new RandomAccessFile(fileNameWB, "rw");         	
        	File file = new File(fileNameWT);
        	FileReader rtFile = new FileReader(fileNameWT);
        	int len = (int) file.length();
        	char[] chars = new char[len];
        	rtFile.read(chars);        	        	        	
        	ArrayList<String> Base62EncodeTableList= new ArrayList<String>(Arrays.asList(Base62EncodeTable));
        	for(int i=0; i<len; i+=2)
        	{        		
        		String str = String.valueOf(chars[i]) + String.valueOf(chars[i+1]);
        		int idx = Base62EncodeTableList.indexOf(str);
        		wbFile.writeByte(idx);
        	}
        	rtFile.close();             	
        	wbFile.close();
        	
        	buf = null;        	
        }
		catch (IOException ex) {
			String errMsg = ex.getMessage();
	
		}
	}
}
