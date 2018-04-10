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

static class Tabs {
    public static void addTabs(ControlP5 cp5, PFont pfont) {
        ControlFont font = new ControlFont(pfont,18);
        cp5.addTab("Stress Mode")
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
            
        cp5.getTab("Stress Mode")
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