package DNAUtil;

import java.util.ArrayList;

public class Timeline {
    // A교시, 1교시 겹치는 시간대 출력
    private static ArrayList<String> getOtherTime(String og) {
        String[] div = og.split("");
        String day = div[0];
        ArrayList<String> result = new ArrayList<>();

        switch (div[1]) {
            case "A":
                result.add(day + "1");
                result.add(day + "2");
                break;
            case "B":
                result.add(day + "2");
                result.add(day + "3");
                result.add(day + "4");
                break;
            case "C":
                result.add(day + "5");
                result.add(day + "6");
                break;
            case "D":
                result.add(day + "6");
                result.add(day + "7");
                break;
            case "E":
                result.add(day + "8");
                break;
            case "1":
                result.add(day + "A");
                break;
            case "2":
                result.add(day + "A");
                result.add(day + "B");
                break;
            case "3":
            case "4":
                result.add(day + "B");
                break;
            case "5":
                result.add(day + "C");
                break;
            case "6":
                result.add(day + "C");
                result.add(day + "D");
                break;
            case "7":
                result.add(day + "D");
                break;
            case "8":
                result.add(day + "E");
                break;
        }

        return result;
    }

    // 겹치는지 판단
    public static boolean overlap(ArrayList<String> days, String day) {
        boolean result = false;
        if (days.contains(day)) {
            result = true;
        } else {
            ArrayList<String> others = getOtherTime(day);
            for (String other : others) {
                if (days.contains(other)) {
                    result = true;
                    break;
                }
            }
        }
        return result;
    }
}
