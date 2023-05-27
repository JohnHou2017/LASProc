package GeoProc;

import java.util.ArrayList;
import java.util.Collections;

public class Utility {
	
	public static boolean ContainsList(ArrayList<ArrayList<Integer>> list, ArrayList<Integer> listItem)
    {
        Collections.sort(listItem);

        for (int i = 0; i < list.size(); i++)
        {

        	ArrayList<Integer> temp = list.get(i);

            if (temp.size() == listItem.size())
            {
                
                Collections.sort(temp);

                if (temp.equals(listItem))
                {
                    return true;
                }

            }
        }

        return false;
    }
}
