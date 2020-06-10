package Crawling;

import com.sun.org.apache.bcel.internal.generic.ARETURN;
import org.openqa.selenium.By;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.openqa.selenium.support.ui.Select;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.concurrent.TimeUnit;
import java.util.logging.Handler;

public class Craw {
    private String search = "https://sg.gachon.ac.kr/main?attribute=timeTable&gbn=P&lang=ko";
    private WebElement element;
    private WebDriver driver;
    String[] colleges, majors;

    //   기본 드라이어 및 크롤링 객체 생성
    public Craw() {
        System.setProperty("webdriver.chrome.driver", "/home/ubuntu/chromedriver");
        ChromeOptions options = new ChromeOptions();
        options.setCapability("ignoreProtectedModeSettings", true);
        options.addArguments("headless");
        driver = new ChromeDriver(options);
        driver.get(search);
        element = driver.findElement(By.id("p_univ_cd"));
        String college = element.getText();
        college = college.trim();
        college.replace(" ", "");
        this.colleges = college.split("\n");
    }

    public String[] getColleges() {
        return colleges;
    }

    // 선택에 따른 학부 리스트 반환
    public String[] getMajors(int idx) {
        Select select = new Select(driver.findElement(By.id("p_univ_cd")));
        select.selectByIndex(idx);
        element = driver.findElement(By.id("p_maj_cd"));
        String major = element.getText().trim();
        major.replace(" ", "");
        this.majors = major.split("\n");
        return this.majors;
    }

    // 단과대학 및 학부 선택으로 시간표 크롤링
    public ArrayList<Subject> getSubjects(int collegeIdx, int majorIdx) {
        ArrayList<Subject> subjectArrayList = new ArrayList<>();
        Select collegeSelect = new Select(driver.findElement(By.id("p_univ_cd")));
        Select majorSelect = new Select(driver.findElement(By.id("p_maj_cd")));
        collegeSelect.selectByIndex(collegeIdx);
        majorSelect.selectByIndex(majorIdx);
        try {
            TimeUnit.SECONDS.sleep(5);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        driver.findElement(By.xpath("//button[text()='조회']")).click();
        try {
            TimeUnit.SECONDS.sleep(5);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        List<WebElement> trs = driver.findElements(By.xpath("//table[@id='gridLecture']/tbody/tr"));
        System.out.println("subject cnt: " + trs.size());

        for (WebElement tr : trs) {
            List<WebElement> tds = tr.findElements(By.tagName("td"));
            if (!tds.get(0).getText().equals("")) {
                String Week = tds.get(1).getText();
                String ID = tds.get(2).getText();
                String Name = tds.get(3).getText();
                String Div = tds.get(6).getText();
                int Point = Integer.parseInt(tds.get(7).getText());
                int Max = Integer.parseInt(tds.get(8).getText());
                String Time = tds.get(9).getText();
                String Professor = tds.get(10).getText();
                String Room = tds.get(11).getText();
                Subject subject = new Subject(Week, ID, Name, Div, Time, Professor, Room, Point, Max);
                subjectArrayList.add(subject);
            }
        }
        return subjectArrayList;
    }

    public void close() {
        this.driver.close();
    }
}

