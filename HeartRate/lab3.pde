import controlP5.*;
import processing.serial.*;

ControlP5 cp5;
Serial myPort;
HashMap<String, Integer> colors;
controlP5.Textarea hr_text;
controlP5.Textarea zone_text;
controlP5.Textarea riddleHR_text, riddleRESP_text;
controlP5.Textarea musHR_text, musRESP_text;
controlP5.Textarea base_hr_text;
HeartRate heartRate;
Chart hrChart;
BufferedReader reader;
Clock time;
float inByte;

long time_last_read = 0;
long start_time;
boolean riddle, music, hr_changed, retrieved_hr_avg = false;
boolean use_file = true;

void setup (){
  frameRate(100);
  if (use_file) {
    reader = createReader("hr_data.txt");
    try {
      use_file = reader.ready();
    } catch (Exception e) {
      e.printStackTrace();
      use_file = false;
    }
  }

  time = Clock.systemUTC();
  cp5 = new ControlP5(this);

  colors = new HashMap<String, Integer>();
  colors.put("red", #FF0000);
  colors.put("orange", #FFA500);
  colors.put("green", #00FF00);
  colors.put("blue", #00BFFF);
  colors.put("grey", #F0F8FF);
  colors.put("pink", #FFB6C1);
  colors.put("white", #FFFFFF);


  hrChart = cp5.addChart("hr chart")
            .setPosition(220, 15)
            .setSize(980, 600)
            .setRange(0, 1023)
            .setView(Chart.LINE) // use Chart.LINE, Chart.PIE, Chart.AREA, Chart.BAR_CENTERED
            .setStrokeWeight(2.5)
            ;

  hrChart.addDataSet("heart_rate");
  hrChart.setData("heart_rate", new float[490]);
  hrChart.setColors("heart_rate",#FFFFFF);
  hrChart.getColor().setBackground(#000000);
  size(1200,615);
  background(0x444444);
  Tabs.addTabs(cp5, createFont("arial",30));

/***************************************************************************************************/  
/**********************GLOBAL*****************************************************************************/
/***************************************************************************************************/
        
  
  
  cp5.addTextlabel("Avg HR label")
    .setFont(createFont("arial", 20))
    .setPosition(10, 510)
    .setValue("BASE HR:")
    ;
    
  base_hr_text = cp5.addTextarea("Avg HR")
    .setFont(createFont("arial", 20))
    .setPosition(160, 510)
    .setText("N/A")
    ;

  cp5.getController("Avg HR label").moveTo("global");
  base_hr_text.moveTo("global");
  
  

  cp5.addTextlabel("HR label")
    .setFont(createFont("arial",20))
    .setPosition(10, 535)
    .setValue("HR:");
    
  hr_text = cp5.addTextarea("HR")
    .setFont(createFont("arial",20))
    .setPosition(160,535)
    ;
    
  cp5.getController("HR label").moveTo("global");
  hr_text.moveTo("global");


  heartRate = new HeartRate(hr_text, hrChart, zone_text);
  reset();
  
  cp5.getController("hr chart").moveTo("global");
  
  
  cp5.addButton("Reset")
  .setPosition(10,100)
  .setSize(200,30)
  ; 
  cp5.getController("Reset").moveTo("global");
  
  cp5.addButton("Start")
  .setPosition(10, 50)
  .setSize(200,30)
  ;
  cp5.getController("Start").moveTo("global");

  
/***************************************************************************************************/
/*******************STRESS MODE********************************************************************************/
/***************************************************************************************************/

    
  cp5.addButton("MusicStart")
  .setPosition(10,100)
      .setSize(190,25)
      .setCaptionLabel("Music Start")
      ;
    
  cp5.getController("MusicStart").moveTo("Fitness Mode");
    
  
  cp5.addTextlabel("HRMus")
  .setFont(createFont("arial",20))
  .setPosition(10, 160)
  .setValue("Avg HR:");
  musHR_text = cp5.addTextarea("MusHR")
  .setFont(createFont("arial", 20))
  .setPosition(100, 160)
  .setText("N/A")
  ;
  cp5.getController("HRMus").moveTo("Fitness Mode");
  musHR_text.moveTo("Fitness Mode");
  

  
  cp5.addButton("RiddleStart")
  .setPosition(10,230)
  .setSize(190,25)
  .setCaptionLabel("Riddle Start")
  ;
  
  
  cp5.getController("RiddleStart").moveTo("Fitness Mode");
  
  
  cp5.addTextlabel("RiddleLabel")
  .setFont(createFont("arial",20))
  .setPosition(10, 290)
  .setValue("Avg HR:");
  riddleHR_text = cp5.addTextarea("riddleHR")
    .setFont(createFont("arial", 20))
    .setPosition(100, 290)
    .setText("N/A")
    ;  
  cp5.getController("RiddleLabel").moveTo("Fitness Mode");
  riddleHR_text.moveTo("Fitness Mode");
  
  music = true;
  riddle = true;
    
    
    
/***************************************************************************************************/
/*******************MEDITATION MODE********************************************************************************/
/***************************************************************************************************/
  cp5.addButton("MeditationButt")
      .setPosition(5,100)
      .setSize(200,25)
      .setCaptionLabel("Start Meditation")
      ;

  cp5.getController("MeditationButt").moveTo("Meditation Mode");

/***************************************************************************************************/
/***************************************************************************************************/
/***************************************************************************************************/
}

public void draw(){
  background(0x444444);

  /*
  if (musicE == true){
    int avg = getAvgHr();
    int br_avg = getAvgBr();
    musHR_text.setText(Float.toString(avg));
    musRESP_text.setText(Integer.toString(br_avg));
    println("retrieved avg hr and resp rate");
    println(resp_avg);
   // hrChart.setColors("heart_rate", colors.get("white"));
    //respChart.setColors("heart_rate", colors.get("white"));
    musicE = false;
  }
  
  if (riddleE == true ){
    
    int avg = getAvgHr();
    riddleHR_text.setText(Float.toString(avg));
    riddleRESP_text.setText(Integer.toString(br_avg));
    retrieved_hr_avg = true;
    println("retrieved avg hr and resp rate");
    println(resp_avg);
    //hrChart.setColors("heart_rate", colors.get("white"));
   // respChart.setColors("heart_rate", colors.get("white"));
    riddleE = false;
  }
  */

  if (use_file && (time_last_read == 0 || time.millis() - time_last_read > 20)) { // limit reading from file to every 20ms (sample rate our test data ran at)
    inByte = readFromFile();
    heartRate.inputData(inByte);
    time_last_read = time.millis();
  } else if (!use_file && hr_changed) {
    heartRate.inputData(inByte);
    hr_changed = false;
  }
  

  if (!retrieved_hr_avg && time.millis() - start_time > 30000) {
    int avg = heartRate.getAvgHr();
    base_hr_text.setText(Integer.toString(avg));
    retrieved_hr_avg = true;
    println("retrieved avg hr");
    hrChart.setColors("heart_rate", colors.get("white"));
  }



}

public void controlEvent(ControlEvent theEvent) {
  if (theEvent.isTab()) {
    println("got an event from tab : "+theEvent.getTab().getName()+" with id "+theEvent.getTab().getId());
  }
}


public void RiddleStart() {
  if (riddle) {
    riddle = false;
  } else {
    riddle = true;
  }
}

public void MusicStart() {
  if (music) {
    music = false;
    cp5.getController("RiddleStart")
      .setCaptionLabel("Riddle Stop");
  } else{
    music = true;
    cp5.getController("MusicStart")
      .setCaptionLabel("Music Start");
  }
}

public void reset() {
  heartRate.reset();
  start_time = time.millis();
  retrieved_hr_avg = false;
  base_hr_text.setText("N/A");
  hrChart.setColors("heart_rate", colors.get("white"));
}

float readFromFile() {
  try {
    String line = reader.readLine();
    String array[] = line.split(",");
    if (array.length != 3) {
      return -1.0;
    }
    String hrString = array[2];
    float inByte = float(hrString);
    if (!Float.isNaN(inByte)) {
      hr_changed = true;
      return inByte;
    } else {
      return -1.0;
    }
  } catch (Exception e) {
    e.printStackTrace();
    reader = createReader("hr_data.txt");
    hr_changed = false;
    return -1.0;
  }
}

void serialEvent (Serial myPort) {
  // get the ASCII string:
  String hrString = myPort.readStringUntil('\n');
  if (hrString != null) {
    String array[] = hrString.split(",");
    if (array.length != 3) {
      println("input line was incorrect");
      return;
    }
    
    hrString = array[2];
    hrString = trim(hrString);

    // If leads off detection is true notify with blue line
    if (hrString.equals("!")) { 
      stroke(0, 0, 0xff); //Set stroke to blue ( R, G, B)
      inByte = 512;  // middle of the ADC range (Flat Line)
    }
    // If the data is good let it through
    else {
      stroke(0xff, 0, 0); //Set stroke to red ( R, G, B)
      inByte = float(hrString); 
    }
    //Map and draw the line for new data point
    //  inByte = map(inByte, 0, 1023, 0, height);
    //  inByteResp = map(inByteResp, 0, 1023, 0, height);
    // at the edge of the screen, go back to the beginning:
    hr_changed = true;
  }
}