var BASE62CODE = [
		'0','1','2','3','4','5','6','7','8','9',
		'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z',	
		'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'
	];
	
function CreateBase62EncodeTableJS()
{	
	
	var str = "var Base62EncodeTable = [\r";
	
	for(var i=0;i<256;i++)
	{
		var m = Math.floor(i/62);
		var n = i % 62;
		
		if(i == 255)
		{
			str += "'" + m.toString() + BASE62CODE[n] + "'";
		}
		else
		{
			str += "'" + m.toString() + BASE62CODE[n] + "',";
		}
		
		if((i + 1)%20 == 0)
		{
			str += "\r";
		}
	}
	str += "\r];"
	
	return str;
}

function CreateBase62EncodeTableJAVA()
{	
	
	var str = "String[] Base62EncodeTable = {\r";
	
	for(var i=0;i<256;i++)
	{
		var m = Math.floor(i/62);
		var n = i % 62;
		
		if(i == 255)
		{
			str += "\"" + m.toString() + BASE62CODE[n] + "\"";
		}
		else
		{
			str += "\"" + m.toString() + BASE62CODE[n] + "\",";
		}
		
		if((i + 1)%20 == 0)
		{
			str += "\r";
		}
	}
	str += "\r};"
	
	return str;
}

// node Base62EncodeTable.js > Base62EncodeTable.txt
console.log(CreateBase62EncodeTableJS());
console.log(CreateBase62EncodeTableJAVA());
