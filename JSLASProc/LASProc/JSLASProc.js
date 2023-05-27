var offset_to_point_data_value, record_num, record_len;
var x_scale, y_scale, z_scale, x_offset, y_offset, z_offset;

function GetLASFile()
{
   var files = document.getElementById("LASFiles").files;

   if ( ! files.length)
   {
      alert('Please select a LAS file!');
      return;
   }

   var file = files[0];

   return file;
}

function AppendInfoInPage(infoStr)
{
   var node = document.getElementById('infoID');
   var newNode = document.createElement('div');
   newNode.appendChild(document.createTextNode(infoStr));
   node.appendChild(newNode);
}

function MakeTextFile(str)
{
   var blobData = new Blob([str],
   {
      type : 'text/plain'
   }
   );
   textFile = window.URL.createObjectURL(blobData);
   return textFile;
}

function MakeBinaryFile(bytesArray)
{
   var blobData = new Blob(bytesArray,
   {
      type : "octet/stream"
   }
   );
   binFile = window.URL.createObjectURL(blobData);
   return binFile;
}

function ActiveTextDownloadLink(downloadID, downloadStr)
{
   var downloadLink = document.getElementById(downloadID);
   downloadLink.href = MakeTextFile(downloadStr);
   downloadLink.style.display = 'block';
}

function ActiveBinaryDownloadLink(downloadID, downloadBytesArray)
{
   var downloadLink = document.getElementById(downloadID);
   downloadLink.href = MakeBinaryFile(downloadBytesArray);
   downloadLink.style.display = 'block';
}

function WriteInsidePointsFile(procInst, lasBuffer)
{
   AppendInfoInPage("First 10 Inside Points:");

   var insideCount = 0;

   var lasTextStr = "";

   var lasInsideBytes = [];
   lasInsideBytes.length = 0;

   for(var i = 0; i < record_num; i ++ )
   {

      var record_loc = offset_to_point_data_value + record_len * i;

      var coorBuffer = lasBuffer.slice(record_loc, record_loc + 12);

      var dv = new DataView(coorBuffer);
      var littleEndian = true;

      // Record coordinates
      var pos = 0;
      var x = dv.getInt32(pos, littleEndian);
      pos += 4;
      var y = dv.getInt32(pos, littleEndian);
      pos += 4;
      var z = dv.getInt32(pos, littleEndian);

      // Actual coordinates
      var ax = (x * x_scale) + x_offset;
      var ay = (y * y_scale) + y_offset;
      var az = (z * z_scale) + z_offset;

      // Filter out the points outside of boundary to reduce computing
      if(ax > procInst.x0 && ax < procInst.x1 &&
      ay > procInst.y0 && ay < procInst.y1 &&
      az > procInst.z0 && az < procInst.z1)
      {
         // Main Process to check if the point is inside of the cube
         if(procInst.PointInside3DPolygon(ax, ay, az))
         {
            var coorStr = ax.toFixed(6) + ', ' + ay.toFixed(6) + ', ' + az.toFixed(6);

            if(insideCount < 10)
            {
               AppendInfoInPage(coorStr);
            }

            // Write the actual coordinates of inside point to text file
            lasTextStr += coorStr + "\r\n";

            // Get point record
            var recordBuffer = lasBuffer.slice(record_loc, record_loc + record_len);

            // Write inside point LAS record
            lasInsideBytes.push(recordBuffer);

            insideCount ++ ;
         }
      }
   }

   AppendInfoInPage("Total Inside Points Count: " + insideCount);
   AppendInfoInPage("Total Points Count: " + record_num);

   // Get LAS header
   var headerBuffer = lasBuffer.slice(0, offset_to_point_data_value);

   // Update total point number with actual writting count
   var dv = new DataView(headerBuffer);
   dv.setUint32(107, insideCount, true);

   // Write LAS header in front
   lasInsideBytes.unshift(headerBuffer);

   ActiveTextDownloadLink('insideTextLink', lasTextStr);

   ActiveBinaryDownloadLink('insideLASLink', lasInsideBytes);

}

function ProcLASFileHeader(lasBuffer)
{
   // LAS Header part 1
   var partBuffer = lasBuffer.slice(96, 96 + 15);

   // html5 DataView
   var dv = new DataView(partBuffer);
   var littleEndian = true;
   var pos = 0;
   offset_to_point_data_value = dv.getUint32(pos, littleEndian);
   pos += 4;
   var variable_len_num = dv.getUint32(pos, littleEndian);
   pos += 4;
   var record_type_c = dv.getUint8(pos, littleEndian);
   pos += 1;
   record_len = dv.getUint16(pos, littleEndian);
   pos += 2;
   record_num = dv.getUint32(pos, littleEndian);

   // LAS Header part 2
   partBuffer = lasBuffer.slice(131, 131 + 8 * 6);
   dv = new DataView(partBuffer);
   pos = 0;
   x_scale = dv.getFloat64(pos, littleEndian);
   pos += 8;
   y_scale = dv.getFloat64(pos, littleEndian);
   pos += 8;
   z_scale = dv.getFloat64(pos, littleEndian);
   pos += 8;
   x_offset = dv.getFloat64(pos, littleEndian);
   pos += 8;
   y_offset = dv.getFloat64(pos, littleEndian);
   pos += 8;
   z_offset = dv.getFloat64(pos, littleEndian);
   pos += 8;

   // Verify the result via displaying them in page
   AppendInfoInPage("offset_to_point_data_value: " + offset_to_point_data_value +
                    ", record_len: " + record_len +
                    ", record_num: " + record_num);
   AppendInfoInPage("x_scale: " + x_scale + ", y_scale: " + y_scale + ", z_scale: " + z_scale +
                    ", x_offset: " + x_offset + ", y_offset: " + y_offset + ", z_offset: " + z_offset);

}

function LASProc()
{
   var p1 = new GeoPoint( - 27.28046,  37.11775,  - 39.03485);
   var p2 = new GeoPoint( - 44.40014,  38.50727,  - 28.78860);
   var p3 = new GeoPoint( - 49.63065,  20.24757,  - 35.05160);
   var p4 = new GeoPoint( - 32.51096,  18.85805,  - 45.29785);
   var p5 = new GeoPoint( - 23.59142,  10.81737,  - 29.30445);
   var p6 = new GeoPoint( - 18.36091,  29.07707,  - 23.04144);
   var p7 = new GeoPoint( - 35.48060,  30.46659,  - 12.79519);
   var p8 = new GeoPoint( - 40.71110,  12.20689,  - 19.05819);

   var gp = [p1, p2, p3, p4, p5, p6, p7, p8];

   var gpInst = new GeoPolygon(gp);

   var procInst = new GeoPolygonProc(gpInst);

   // Get LAS file object via html file selector
   // Javascript does not be allowed to open a file from file system as default
   var lasFile = GetLASFile();

   // html5 FileReader is Asynchronous
   var lasFileReader = new FileReader();

   // Asynchronous read, process the result till the read is done
   lasFileReader.readAsArrayBuffer(lasFile);

   // process the result buffer till Asynchronous readAsArrayBuffer is done
   lasFileReader.onloadend = function(evt)
   {
      var lasBuffer = lasFileReader.result;

      ProcLASFileHeader(lasBuffer);

      WriteInsidePointsFile(procInst, lasBuffer);
   }

}
