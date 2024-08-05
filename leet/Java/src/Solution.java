import com.sun.tools.javac.Main;

import java.util.HashMap;
import java.util.Stack;

public class Solution {
    public String convert(String s, int numRows) {
        if (numRows == 1) return s;
        int groups = 2*numRows - 2;
        StringBuilder ans = new StringBuilder();
        for (int i = 0; i < numRows; i++) {
            for (int j = 0; j < s.length(); j+= groups) {
                if (j + i >= s.length()) break;
                ans.append(s.charAt(j + i));
                if (i != 0 && i != numRows - 1 && (j + groups - i) < s.length()) {
                    ans.append(s.charAt(j + groups - i));

                }
            }
        }
        return ans.toString();
    }

    public static void main(String[] args) {
        HashMap<Integer, Integer> map = new HashMap<>();
        map.containsKey(1);
        Solution sol = new Solution();
        String s = "PAYPALISHIRING";
        int numRows = 3;
        System.out.println(sol.convert(s, numRows).equals("PAHNAPLSIIGYIR"));
        numRows = 2;
        System.out.println(sol.convert(s, numRows));
    }
}
