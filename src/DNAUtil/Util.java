package DNAUtil;

import Crawling.Subject;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.Set;

public class Util {
    ArrayList<Subject> wholeSubjects;
    final int MaxCount;
    private final int NumOfGeneration = 10; // 세대당 유전자 수

    public Util(ArrayList<Subject> subjects, int maxCount) {
        this.wholeSubjects = subjects;
        MaxCount = maxCount;
    }

    // 유전자 랜덤 생성
    public ArrayList<Subject>[] generateDna() {
        // 유전자 목록 10개의 객체
        ArrayList<Subject>[] DNA = new ArrayList[NumOfGeneration];
        for (int i = 0; i < NumOfGeneration; i++) {
            ArrayList<Subject> d = new ArrayList<>();

            Set<Integer> idx = new HashSet<>();
            // 최대 과목 수가 될때까지 랜덤으로 입력
            while (idx.size() < MaxCount) {
                int index = (int) (Math.random() * wholeSubjects.size());
                idx.add(index);
            }
            // 랜덤하게 생성된 중복없는 인덱스를 통해 1세대 유전자 생성
            for (int index : idx) {
                d.add(wholeSubjects.get(index));
            }
            DNA[i] = d;
        }
        return DNA;
    }

    // 하나의 유전자에 대한 적합도 계산
    private int fitness(ArrayList<Subject> subjects) {
        ArrayList<String> days = new ArrayList<>();
        ArrayList<String> names = new ArrayList<>();
        int weight = 0;

        for (Subject subject : subjects) {
            // 과목명 중복 확인
            if (names.contains(subject.getName())) {
                return 0;
            } else {
                names.add(subject.getName());
            }

            // 시간대 중복 확인
            for (String day : subject.getDay()) {
                // 중복된 시간대가 있다면 0 반환
                if (Timeline.overlap(days, day)) {
                    return 0;
                } else {
                    days.add(day);
                }
            }
            // 사용자가 설정한 가중치 추가
            weight += subject.getWeight();
        }
        return weight;
    }

    // 돌연변이 생성
    private ArrayList<Subject> mutation(ArrayList<Subject> subjects) {
        int r = (int) (Math.random() * 10) + 1;
        // 50%의 확률로 돌연변이 생성
        if (r >= 6) {
            // 기존에 있는 시간표 순서를 바꾸는 것은 의미가 없기 때문에 기존에 없는 시간표 추가
            int idx = (int) (Math.random() * subjects.size());
            // 랜덤하게 하나 제거

            if (subjects.size() > MaxCount) {
                subjects.remove(idx);
            } else {
                subjects = generateDna()[0];
            }
            // 50%의 확률로 추가
            if (Math.random() * 10 > 5) {
                while (true) {
                    // 랜덤으로 중복되지 않는 시간표 생성
                    int rand = (int) (Math.random() * wholeSubjects.size());
                    if (!subjects.contains(wholeSubjects.get(rand))) {
                        subjects.add(wholeSubjects.get(rand));
                        break;
                    }
                }
            }
            return subjects;
        } else { // 50% 확률로 기존 유전자 반환
            return subjects;
        }
    }

    // 적합도 계산 후 새로운 자손 생성
    public ArrayList<Subject>[] reproduction(ArrayList<Subject>[] pick) {
        int[] fits = new int[NumOfGeneration];

        for (int i = 0; i < NumOfGeneration; i++) {
            // 적합도 계산
            fits[i] = fitness(pick[i]);
        }
        // 모든 적합도가 0으로 계산되는 경우 방지
        int fitSum = 0;
        for (int fit : fits) {
            fitSum += fit;
        }
        System.out.println("fitSum: " + fitSum);
        // 새로운 유전자를 만들어 재귀 호출
        if (fitSum == 0) {
            return reproduction(generateDna());
        }
        // 1위 유전자 가져오기
        int max = fits[0], maxIdx = 0;
        for (int i = 1; i < NumOfGeneration; i++) {
            if (fits[i] > max) {
                max = fits[i];
                maxIdx = i;
            }
        }
        ArrayList<Subject> first = pick[maxIdx];
        fits[maxIdx] = -1; // 2번째 순위를 구하기 위해 이미 사용한 적합도를 제외

        // 2위 유전자 가져오기
        max = fits[0];
        maxIdx = 0;
        for (int i = 1; i < NumOfGeneration; i++) {
            if (fits[i] > max) {
                max = fits[i];
                maxIdx = i;
            }
        }
        ArrayList<Subject> second = pick[maxIdx];

        // 돌연변이 생성 후 반환
        ArrayList<Subject>[] result = new ArrayList[NumOfGeneration];
        for (int i = 0; i < NumOfGeneration; i++) {
            if (i < 5) {
                result[i] = mutation(first);
            } else {
                result[i] = mutation(second);
            }
        }
        return result;
    }

    // 모든 적합도가 비슷한지 판단
    public boolean balanced(ArrayList<Subject>[] subjects) {
        int[] fits = new int[NumOfGeneration];
        // 각 적합도의 차이
        int diff = 0;

        for (int i = 0; i < NumOfGeneration; i++) {
            fits[i] = fitness(subjects[i]);
        }
        for (int i = 0; i < NumOfGeneration; i++) {
            for (int j = 0; j < NumOfGeneration; j++) {
                if (i != j) {
                    diff += Math.abs(fits[i] - fits[j]);
                }
            }
        }
        for(ArrayList<Subject> subjects1:subjects) {
            if(fitness(subjects1)==0) {
                return false;
            }
        }
        if (diff < 10) {
            return true;
        } else {
            return false;
        }
    }
}
