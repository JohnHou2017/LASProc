// Constructor
function Utility()
{
}

// public Static method
Utility.ContainsList = function(list, listItem) // List<List<T>> list, List<T> listItem
{

   if(list == null || listItem == null)
   {
      return false;
   }

   listItem.sort();

   for (var i = 0; i < list.length; i ++ )
   {

      var temp = list[i]; // List<T>
      
      if (temp.length == listItem.length)
      {
         temp.sort();

         var itemEqual = true;
         for(var j = 0; j < listItem.length; j ++ )
         {
            if(temp[j] != listItem[j])
            {
               itemEqual = false;
               break;
            }
         }

         if(itemEqual)
         {
            return true;
         }
      }
      else
      {
         return false;
      }
   }

   return false;
}

///////////////////
// Test & Usage
//
/*
var list = [[1, 2, 3], [4, 5, 6]];
var listItem1 = [2, 3, 1];
var listItem2 = [2, 3, 6];
var contain1 = Utility.ContainsList(list, listItem1);
var contain2 = Utility.ContainsList(list, listItem2);
alert(contain1 + '\r' + contain2);
 */
