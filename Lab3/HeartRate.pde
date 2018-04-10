import java.time.Clock;
import controlP5.*;

class HeartRate {

  private ArrayList prev_heart_rates, hrList;
  private long start_time, beat_time, beat_length, last_beat;
  private Clock time;
  private controlP5.Textarea hr_text, zone_text;
  private boolean beat;
  private Chart hr_chart;
  private float second_last_hr_datapoint, last_hr_datapoint = 0;
  private int[] zones;
  private int hr;
  public int maxHR;

  public HeartRate(controlP5.Textarea hr_text, Chart hr_chart, controlP5.Textarea zone_text) {
    this.hr_text = hr_text;
    this.hr_chart = hr_chart;
    this.zone_text = zone_text;
    zones = new int[5];
    time = Clock.systemUTC();
    last_beat = 0;
    beat = false;
    reset();
  }

  public void calcZones(int age) {
    maxHR = 220 - age;
    for (int i = 0; i < 5; ++i) {
      zones[i] = int((220-age)*(i+5)*0.1);
    }
  }

  public void inputData(float inByte) {

    if (!beat && inByte > 700) {
      beat = true;
      beatStart();
    }
  
    if (beat && inByte < 700) {
      beat = false;
    }

    float smoothed_val = smoothHrVal(inByte);
    hr_chart.push("heart_rate", inByte);
    hr_changed = false;
  }
  


  

  public void beatStart() {
    long beat_time = time.millis();

    if (last_beat != 0) {
      beat_length = beat_time - last_beat;
      hr = calcHr();
      hr_text.setText(Integer.toString(hr));
      setChartColor(hr);
    }

    last_beat = beat_time;
  }

  public long getLastBeat() {
    return last_beat;
  }

  public int getAvgHr() {
    int sum = 0;
    for (Object hr : prev_heart_rates.toArray()) {
      sum += (int) hr;
    }
    int n = prev_heart_rates.size();
    if (n == 0) {
      return -1;
    }
    return sum/prev_heart_rates.size();
  }

  int calcHr() {
    double sec_per_beat = beat_length/1000.0;
    Double min_per_beat = sec_per_beat/60.0;
   // hr = (int)(1/min_per_beat);
    hr = BPM;
    if (hr < 220) {
      println("cached hr");
      prev_heart_rates.add(hr);
      return hr;
    } else {
      return -1;
    }
  }

  void reset(){
    prev_heart_rates = new ArrayList<Integer>();
    start_time = time.millis();
  }

  void setChartColor(int hr) {
    String[] colors_array = {"grey", "blue", "green", "orange", "red"};
    String[] zones_array = {"very light", "light", "moderate", "hard", "maximum"};
    for (int i = 0; i < zones.length; ++i) {
      if (hr < zones[i]) {
        hrChart.setColors("heart_rate", colors.get(colors_array[i]));
        //slider.setColors("heart_rate", colors.get(colors_array[i]));
        //zone_text.setText(zones_array[i]);
        return;
      }
    }
  }
  
  void setSliderColor(){
        String[] colors_array = {"grey", "blue", "green", "orange", "red"};
        for (int i = 0; i < zones.length; ++i) {
      if (BPM < zones[i]) {
        slider.setColorValue(colors.get(colors_array[i]));
        //slider.setColors("heart_rate", colors.get(colors_array[i]));
        //zone_text.setText(zones_array[i]);
        return;
      }
    }
  }

  float smoothHrVal(float newVal) {
    float smoothed_val;
    if (last_hr_datapoint != 0) {
      if (second_last_hr_datapoint != 0) {
        smoothed_val = (second_last_hr_datapoint+last_hr_datapoint*2+newVal*3)/6;
        second_last_hr_datapoint = last_hr_datapoint;
      } else {
        smoothed_val = newVal;
        second_last_hr_datapoint = last_hr_datapoint;
      }
    } else {
      smoothed_val = newVal;
    }
    last_hr_datapoint = newVal;

    return smoothed_val;
  }
}