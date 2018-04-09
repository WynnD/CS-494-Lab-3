/***************************************************************************************************/
/*******************************************TABS********************************************************/
/***************************************************************************************************/
/* cp5.addTab("Fitness Mode")
    .setValue(0)
    .setPosition(10,10)
    .setSize(200,30)
    .getCaptionLabel()
    .setFont(font)
    ;*/

import controlP5.*;

class Tabs {
    private PFont pfont = createFont("arial",30);
    private ControlFont font = new ControlFont(pfont,18);
    public void addTabs(ControlP5 cp5) {
        cp5.addTab("StressMode")
            .setValue(100)
            .setPosition(10,60)
            .setSize(200,30)
            .getCaptionLabel()
            .setFont(font)
            ;
            
        cp5.addTab("Meditation Mode")
            .setPosition(10,110)
            .setSize(200,30)
            .setValue(0)
            .getCaptionLabel()
            .setFont(font);
            
        /*   cp5.getTab("Fitness Mode")
            .activateEvent(true)
            .setId(1)
            ;*/
            
            cp5.getTab("StressMode")
            .activateEvent(true)
            .setId(2)
            ;
        cp5.getTab("Meditation Mode")
            .activateEvent(true)
            .setId(3)
            ;
            
        cp5.getTab("default").hide();        
    }
}
