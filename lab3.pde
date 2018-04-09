import controlP5.*;

  
ControlP5 cp5;

HashMap<String, Integer> colors;
controlP5.Textarea hr_text;
controlP5.Textarea zone_text;
controlP5.Textarea riddleHR_text, riddleRESP_text;
controlP5.Textarea musHR_text, musRESP_text;
controlP5.Textarea base_hr_text, resp_text, resp_base_text;
Chart hrChart, respChart;

boolean riddle = true;
boolean music= true;


void setup (){


  PFont pfont = createFont("arial",30);
  ControlFont font = new ControlFont(pfont,18);
  frameRate(100);

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
            .setSize(980, 300)
            .setRange(1023-900, 900)
            .setView(Chart.LINE) // use Chart.LINE, Chart.PIE, Chart.AREA, Chart.BAR_CENTERED
            .setStrokeWeight(2.5)
            ;

hrChart.addDataSet("heart_rate");
hrChart.setData("heart_rate", new float[490]);
hrChart.setColors("heart_rate",#FFFFFF);
hrChart.getColor().setBackground(#000000);
size(1200,615);
background(0x444444);

Tabs tabs = new Tabs();
tabs.addTabs(cp5);

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
    
    cp5.getController("MusicStart").moveTo("StressMode");
    
    
    cp5.addTextlabel("HRMus")
    .setFont(createFont("arial",20))
    .setPosition(10, 160)
    .setValue("Avg HR:");
    musHR_text = cp5.addTextarea("MusHR")
    .setFont(createFont("arial", 20))
    .setPosition(100, 160)
    .setText("N/A")
    ;
    cp5.getController("HRMus").moveTo("StressMode");
    musHR_text.moveTo("StressMode");
    
  
    
    cp5.addButton("RiddleStart")
    .setPosition(10,230)
    .setSize(190,25)
    .setCaptionLabel("Riddle Start")
    ;
    
    
    cp5.getController("RiddleStart").moveTo("StressMode");
    
    
    cp5.addTextlabel("RiddleLabel")
    .setFont(createFont("arial",20))
    .setPosition(10, 290)
    .setValue("Avg HR:");
  riddleHR_text = cp5.addTextarea("riddleHR")
    .setFont(createFont("arial", 20))
    .setPosition(100, 290)
    .setText("N/A")
    ;  
    cp5.getController("RiddleLabel").moveTo("StressMode");
    riddleHR_text.moveTo("StressMode");
    
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


}

public void controlEvent(ControlEvent theEvent) {
  if (theEvent.isTab()) {
  println("got an event from tab : "+theEvent.getTab().getName()+" with id "+theEvent.getTab().getId());
}
  
}


public void RiddleStart(){
  if(riddle){
    riddle = false;
  }
  else{
    riddle = true;
  }
}

public void MusicStart(){
  if(music){
    music = false;
    cp5.getController("RiddleStart")
      .setCaptionLabel("Riddle Stop");


    
  }
  else{
    music = true;
    cp5.getController("MusicStart")
      .setCaptionLabel("Music Start");
  }
}
