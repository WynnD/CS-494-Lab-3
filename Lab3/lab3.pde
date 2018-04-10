import controlP5.*;
import processing.serial.*;

ControlP5 cp5;
Serial myPort;
HashMap<String, Integer> colors;
controlP5.Textarea hr_text;
controlP5.Textarea zone_text;
controlP5.Textarea riddleHR_text, riddleRESP_text;
controlP5.Textarea musHR_text, musRESP_text;
controlP5.Textarea base_hr_text, ibiText;
HeartRate heartRate;
Chart hrChart;
Chart pie;
Slider slider;
BufferedReader reader;
Clock time;
float inByte;

long time_last_read = 0;
long start_time;
boolean riddle = true, music = true, hr_changed, retrieved_hr_avg = false;
boolean use_file = true;
int age;
boolean riddleE =false, musicE = false, start = false;
int BPM, IBI;

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
  } else {
    println("Trying to use serial port");
    try {
    myPort = new Serial(this, Serial.list()[0], 9600);
    myPort.bufferUntil('\n');
    } catch (Exception e) {
      hr_text.setText("NO SERIAL");
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
  
  
  cp5.addTextlabel("IBI")
    .setFont(createFont("arial", 20))
    .setPosition(10, 480)
    .setValue("IBI:")
    ;
    
  ibiText = cp5.addTextarea("IB")
    .setFont(createFont("arial", 20))
    .setPosition(160, 480)
    .setText("N/A")
    ;

  cp5.getController("IBI").moveTo("global");
  ibiText.moveTo("global");
  
  

  cp5.addTextlabel("HR label")
    .setFont(createFont("arial",20))
    .setPosition(10, 535)
    .setValue("BPM");
    
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
  
  
  slider = cp5.addSlider("HR Slider")
     .setPosition(10,560)
     .setSize(200,20)
     .setRange(30,220)
     .setValue(31)
     ;
  cp5.getController("HR Slider").moveTo("global");

  
/***************************************************************************************************/
/*******************STRESS MODE********************************************************************************/
/***************************************************************************************************/

    
  cp5.addButton("MusicStart")
  .setPosition(10,100)
      .setSize(190,25)
      .setCaptionLabel("Music Start")
      ;
    
  cp5.getController("MusicStart").moveTo("Stress Mode");
    
  
  cp5.addTextlabel("HRMus")
  .setFont(createFont("arial",20))
  .setPosition(10, 160)
  .setValue("Avg BPM:");
  musHR_text = cp5.addTextarea("MusHR")
  .setFont(createFont("arial", 20))
  .setPosition(100, 160)
  .setText("N/A")
  ;
  cp5.getController("HRMus").moveTo("Stress Mode");
  musHR_text.moveTo("Stress Mode");
  

  
  cp5.addButton("RiddleStart")
  .setPosition(10,230)
  .setSize(190,25)
  .setCaptionLabel("Riddle Start")
  ;
  
  
  cp5.getController("RiddleStart").moveTo("Stress Mode");
  
  
  cp5.addTextlabel("RiddleLabel")
  .setFont(createFont("arial",20))
  .setPosition(10, 290)
  .setValue("Avg BPM:");
  riddleHR_text = cp5.addTextarea("riddleHR")
    .setFont(createFont("arial", 20))
    .setPosition(100, 290)
    .setText("N/A")
    ;  
  cp5.getController("RiddleLabel").moveTo("Stress Mode");
  riddleHR_text.moveTo("Stress Mode");
  
  music = true;
  riddle = true;
  
  
   cp5.addTextfield("Age")
     .setPosition(10,400)
     .setSize(150,30)
     .setAutoClear(false)
     .setFont(createFont("arial", 20))
     .getCaptionLabel()
     ;
     
       cp5.getController("Age").moveTo("global");
    
    
    
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
  ibiText.setText(Integer.toString(IBI));
  if(BPM > 50){
    cp5.getController("HR Slider").setValue(BPM);

  
  }
  else{
  
    cp5.getController("HR Slider").setValue(31);

  }
  
  slider.setRange(50, heartRate.maxHR)
  .setCaptionLabel(Integer.toString(heartRate.maxHR));


  //text("IBI " + IBI + "mS",600,585);                    // print the time between heartbeats in mS
  //text(BPM + " BPM",600,200);
  
  if (musicE == true){
    int avg = heartRate.getAvgHr();
    //int br_avg = getAvgBr();
    musHR_text.setText(Float.toString(avg));
    //musRESP_text.setText(Integer.toString(br_avg));
    println("retrieved avg hr and resp rate");
   // println(resp_avg);
    hrChart.setColors("heart_rate", colors.get("white"));
    //respChart.setColors("heart_rate", colors.get("white"));
    musicE = false;
  }
  
  if (riddleE == true ){
    
    int avg = heartRate.getAvgHr();
    riddleHR_text.setText(Float.toString(avg));
   // riddleRESP_text.setText(Integer.toString(br_avg));
    retrieved_hr_avg = true;
    println("retrieved avg hr and resp rate");
    //println(resp_avg);
    hrChart.setColors("heart_rate", colors.get("white"));
   // respChart.setColors("heart_rate", colors.get("white"));
    riddleE = false;
  }
  

  if (use_file && (time_last_read == 0 || time.millis() - time_last_read > 20)) { // limit reading from file to every 20ms (sample rate our test data ran at)
    inByte = readFromFile();
    heartRate.inputData(inByte);
    time_last_read = time.millis();
  } else if (!use_file && hr_changed) {
    print("InByte is ");
    println(inByte);
    heartRate.inputData(inByte);
    hr_changed = false;
  }
  

  if ( start == true && time.millis() - start_time > 30000) {
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
    
    cp5.getController("RiddleStart")
      .setCaptionLabel("Riddle Stop");
      
      riddleE = false;
      hrChart.setColors("heart_rate", colors.get("pink"));
      heartRate.prev_heart_rates = new ArrayList<Integer>();
      
      
  } 
  else {
    riddle = true;
    
    cp5.getController("RiddleStart")
      .setCaptionLabel("Riddle Start");
      riddleE = true;
  }
}

public void MusicStart() {
  if (music) {
    music = false;
    cp5.getController("MusicStart")
      .setCaptionLabel("Music Stop");
      musicE = false;
      hrChart.setColors("heart_rate", colors.get("pink"));
      heartRate.prev_heart_rates = new ArrayList<Integer>();

  } else{
    music = true;
    cp5.getController("MusicStart")
      .setCaptionLabel("Music Start");
      musicE = true;
  }
}

public void reset() {
  heartRate.reset();
  start_time = time.millis();
  retrieved_hr_avg = false;
  base_hr_text.setText("N/A");
  hrChart.setColors("heart_rate", colors.get("white"));
}

void starts(){
      hrChart.setColors("heart_rate", colors.get("pink"));
      //respChart.setColors("resp_rate", colors.get("pink"));
      start = true;
      start_time = time.millis();
      heartRate.prev_heart_rates = new ArrayList<Integer>();
     // heartRate.prev_resp = new ArrayList<Float>();
     // heartRate.prev_resp_rates = new ArrayList<Integer>();
      retrieved_hr_avg = false;
      //retrieved_resp_avg_val = false;
     // resp_avg = -1;
     // resp_avg_val = 0;
      heartRate.prev_heart_rates.clear();
      //prev_resp.clear();
      
  }

public void Age(String theText) {
  // automatically receives results from controller input
  println("a textfield event for controller 'Age' : "+theText);
  age = int(theText);
  heartRate.calcZones(age);
}

public void Start (){
  starts();
}

float readFromFile() {
  try {
    String line = reader.readLine();
    String array[] = line.split(",");
    if (array.length != 3) {
      return -1.0;
    }
    String hrString = array[2];
    BPM = int(array[0]);
    IBI = int(array[1]);
    //cp5.getController("HR Slider").setValue(BPM);
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
    
    
    BPM = int(array[0]);
    IBI = int(array[1]);
        //cp5.getController("HR Slider").setValue(BPM);


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