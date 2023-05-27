import java.nio.ByteBuffer;
import java.nio.ByteOrder;

public class Utility {
	
	// Convert Big-Endian JAVA byte[] to Little-Endian number		
	
	public static int GetUInt32(byte[] byte4)
	{
		if(byte4.length == 4)			
			return ByteBuffer.wrap(byte4).order(ByteOrder.LITTLE_ENDIAN ).getInt();
		else
			return 0;
	}
	
	public static int GetUInt16(byte[] byte2)
	{
		if(byte2.length == 2)
			return (byte2[1] & 0xff) * 8 + (byte2[0] & 0xff);			
		else
			return 0;
	}
	
	public static int GetUByte(byte byte1)
	{		
		return (byte1 & 0xff);		
	}
	
	public static double getDouble(byte[] byte8)
	{
		if(byte8.length == 8)
			return ByteBuffer.wrap(byte8).order(ByteOrder.LITTLE_ENDIAN ).getDouble();
		else
			return 0;
	}
	
	public static byte[] GetIntBytes(int num)
	{
		return ByteBuffer.allocate(4).order(ByteOrder.LITTLE_ENDIAN).putInt(num).array();
	}
	
}
