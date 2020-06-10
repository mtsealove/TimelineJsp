package Crawling;

import java.util.Arrays;

// 과목 객체
public class Subject {
    String ID, Name, Div, Time, Professor, Room;
    int Point, Max;
    String[] Day;
    int Weight = 0;

    public Subject(String week, String ID, String name, String div, String time, String professor, String room, int point, int max) {
        setDay(week);
        this.ID = ID;
        Name = name;
        Div = div;
        Time = time;
        Professor = professor;
        Room = room;
        Point = point;
        Max = max;
    }

    private void setDay(String week) {
        week = week.trim();
        week.replace(" ", "");
        this.Day = week.split(",");
    }

    public void setWeight(int weight) {
        Weight = weight;
    }

    public String[] getDay() {
        return Day;
    }

    public int getWeight() {
        return Weight;
    }

    public String getName() {
        return Name;
    }

    public String getID() {
        return ID;
    }

    public String getDiv() {
        return Div;
    }

    public String getTime() {
        return Time;
    }

    public String getProfessor() {
        return Professor;
    }

    public String getRoom() {
        return Room;
    }

    public int getPoint() {
        return Point;
    }

    public int getMax() {
        return Max;
    }

    @Override
    public String toString() {
        return  ID +
                "|" + Name+
                "|" + Div +
                "|" + Time +
                "|" + Professor +
                "|" + Room +
                "|" + Point +
                "|" + Max +
                "|" + Arrays.toString(Day) +
                "|" + Weight +
                ";;";
    }
}
