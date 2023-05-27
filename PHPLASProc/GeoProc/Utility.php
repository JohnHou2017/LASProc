<?php
class Utility
{
	// public Static method
	public static function ContainsList($listList, $listItem) // listList: [[]] list, listItem: []
	{

	   if($listList == null || $listItem == null)
	   {
		  return false;
	   }

	   sort($listItem);

	   for ($i = 0; $i < count($listList); $i ++ )
	   {
   
		  $temp = $listList[$i]; 		  		  
		  
		  if (count($temp) == count($listItem))
		  {			  
			  
			 sort($temp);

			 $itemEqual = true;
			 for($j = 0; $j < count($listItem); $j ++ )
			 {
				if($temp[$j] != $listItem[$j])
				{
				   $itemEqual = false;
				   break;
				}
			 }

			 if($itemEqual)
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

}
?>


