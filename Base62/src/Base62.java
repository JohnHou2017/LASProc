///////////////////////////////////////
// Author: John Jiyang Hou
//
// Date:   Feb, 2016
//
// Email:  jyhou69@gmail.com
//
// Description: 
//
// A Base62 Encoding implementation.
// The method is modified from Base64 encoding schema and uses a special char as a flag in CODES
// to minimize encoding size inflation rate.
// The Base62 has maximum index value 61 which is a byte value between 5 bits and 6 bits.
// This Base62 feature makes its encoding not be capable of a fixed bits grouping.
// In this implementation, the essential part is using one code as a special flag to indicate
// special 6 bits value 61, 62, 63 which is index in Base64 CODES
//
// Char '9' is used as the special prefix flag to indicate 61, 62 and 63.
// 61 : '9A'
// 62 : '9B'
// 63 : '9C'
//
// This is a variable length group method rather than fixed 4 char groups for 3 bytes in Base64.	
//
// Improve: 
// Statistical analysis for which 3 bytes group have minimum distribution with a 6 bits grouping.
// Current method simply uses a fixed 3 index value group 61, 62, 63 as the special char index.
// it should be replaced with minimum byte value distribution based on 
// the 6 bits byte value in the input byte array.
// by this way, the encoding inflation rate will be most down to close the Base64 encoding.
//
// Reference: https://en.wikipedia.org/wiki/Base64
//
// Base64 Encoding Schema:
// Text content 	  M 	        a 	        n
// ASCII 	          77 (0x4d) 	97 (0x61) 	110 (0x6e)
// Bit pattern 	      01001101 	    01100001 	01101110
// Index 	          19 	22 	        5 	      46
// Base64-encoded 	  T 	W 	        F 	      u
//
// Base64 Codes:
// CODES = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
//

import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;

public class Base62 
{
	
	private static final String CODES = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

	private static final char CODEFLAG = '9';
	
	private static StringBuilder out = new StringBuilder(); 
	
	private static Map<Character, Integer> CODEMAP = new HashMap<Character, Integer>();		
	
	private static void Append(int b)
	{
		if(b < 61)
		{
			out.append(CODES.charAt(b));
		}
		else
		{						
			
			out.append(CODEFLAG);
				
			out.append(CODES.charAt(b-61));
		}
	}	
    
    public static String base62Encode(byte[] in)       
    {    	
    	      
    	// Reset output StringBuilder
    	out.setLength(0);
    	
    	//
        int b;        
        
        // Loop with 3 bytes as a group
        for (int i = 0; i < in.length; i += 3)  {
            
        	// #1 char
        	b = (in[i] & 0xFC) >> 2;                
            Append(b);
            
            b = (in[i] & 0x03) << 4;
            if (i + 1 < in.length)      {
            	
            	// #2 char
                b |= (in[i + 1] & 0xF0) >> 4;
            	Append(b);
                
                b = (in[i + 1] & 0x0F) << 2;
                if (i + 2 < in.length)  
                {
                	
                	// #3 char
                    b |= (in[i + 2] & 0xC0) >> 6;
                	Append(b);
                    
                	// #4 char
                    b = in[i + 2] & 0x3F;
                    Append(b);
                    
                } 
                else  
                {         
                	// #3 char, last char
                    Append(b);                                        
                }
            } 
            else 
            {      
            	// #2 char, last char
                Append(b);                
            }
        }

        return out.toString();
    }
    
    public static byte[] base62Decode(char[] inChars)    {
    	    	
    	// Map for special code followed by CODEFLAG '9' and its code index
    	CODEMAP.put('A', 61);
		CODEMAP.put('B', 62);
		CODEMAP.put('C', 63);		
		
		ArrayList<Byte> decodedList = new ArrayList<Byte>();
		
		// 6 bits bytes
		int[] unit = new int[4];
		
    	int inputLen = inChars.length;
    	
    	// char counter
    	int n = 0;
    	
    	// unit counter
    	int m = 0;
    	
    	// regular char
    	char ch1 = 0;
    	
    	// special char
    	char ch2 = 0;  
    	
    	Byte b = 0;
    	
    	while (n < inputLen)
    	{    		
    		ch1 = inChars[n];
    		if (ch1 != CODEFLAG)
    		{
    			// regular code    			
    			unit[m] = CODES.indexOf(ch1);
    			m++;
    			n++;
    		}
    		else
    		{
    			n++;
    			if(n < inputLen)
    			{
    				ch2 = inChars[n];
    				if(ch2 != CODEFLAG)
    				{
    					// special code index 61, 62, 63, 64    					    					
    					unit[m] = CODEMAP.get(ch2);
    					m++;
    					n++;
    				}
    			}
    		}    	
    		
    		// Add regular bytes with 3 bytes group composed from 4 units with 6 bits.
    		if(m == 4)
    		{    			
    			b = new Byte((byte) ((unit[0] << 2) | (unit[1] >> 4)));
    			decodedList.add(b);
    			b = new Byte((byte) ((unit[1] << 4) | (unit[2] >> 2)));
    			decodedList.add(b);                    
    			b = new Byte((byte) ((unit[2] << 6) | unit[3]));
    			decodedList.add(b);
    			
    			// Reset unit counter
    			m = 0;
    		}
    	}
    	
    	// Add tail bytes group less than 4 units
    	if(m != 0)
    	{
    		if(m == 1)
    		{
    			b = new Byte((byte) ((unit[0] << 2) ));
    			decodedList.add(b);
    		}
    		else if(m == 2)
    		{
    			b = new Byte((byte) ((unit[0] << 2) | (unit[1] >> 4)));
				decodedList.add(b);
    		}
    		else if (m == 3)
    		{
    			b = new Byte((byte) ((unit[0] << 2) | (unit[1] >> 4)));
    			decodedList.add(b);
    			b = new Byte((byte) ((unit[1] << 4) | (unit[2] >> 2)));
    			decodedList.add(b); 
    		}
    	}
    	
        Byte[] decodedObj = decodedList.toArray(new Byte[decodedList.size()]);
        
        byte[] decoded = new byte[decodedObj.length];

        // Convert object Byte array to primitive byte array
        for(int i = 0; i < decodedObj.length; i++) {
        	decoded[i] = (byte)decodedObj[i];
        	
        }
        
        return decoded;
    }
    
}
