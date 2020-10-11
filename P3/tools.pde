// ************************************ IMAGES & VIDEO 
int pictureCounter=0, frameCounter=0;
Boolean filming=false, change=false;
PImage myFace; // picture of author's face, should be: data/pic.jpg in sketch folder
void snapPicture() {saveFrame("PICTURES/P"+nf(pictureCounter++,3)+".jpg"); }

// ******************************************COLORS 
color black=#000000, white=#FFFFFF, // set more colors using Menu >  Tools > Color Selector
   lred=#FF8394, red=#FF0000, dred=#D80209,
   lgreen=#89FC7A, green=#1CE802, dgreen=#0E8100,
   lblue=#7487FF, blue=#2946FC, dblue=#041FC9,
   lbrown=#FAB96A, brown=#FF8D00, dbrown=#9D5803,
   lmagenta=#F9A5FF, magenta=#ED03FF, dmagenta=#8D0298, 
   lyellow=#FFF57E, yellow=#FCE800, dyellow=#B7A804, 
   lcyan=#98FCFF, cyan=#03F9FF, dcyan=#00979B, 
   grey=#818181, 
   orange=#FFA600, 
   metal=#B5CCDE, 
   lime=#C3F583, 
   pink=#FCC4FA,  sand=#FFEEC4,
   lightWood=#F5DEA6, darkWood=#D8BE7A;
void pen(color c, float w) {stroke(c); strokeWeight(w);}

// ******************************** TEXT , TITLE, and USER's GUIDE
Boolean scribeText=true; // toggle for displaying of help text
void scribe(String S, float x, float y) {fill(0); text(S,x,y); noFill();} // writes on screen at (x,y) with current fill color
void scribeHeader(String S, int i) {fill(0); text(S,10,20+i*20); noFill();} // writes black at line i
void scribeHeaderRight(String S) {fill(0); text(S,width-7.5*S.length(),20); noFill();} // writes black on screen top, right-aligned
void scribeFooter(String S, int i) {fill(0); text(S,10,height-10-i*20); noFill();} // writes black on screen at line i from bottom
void scribeAtMouse(String S) {fill(0); text(S,mouseX,mouseY); noFill();} // writes on screen near mouse
void scribeMouseCoordinates() {fill(black); text("("+mouseX+","+mouseY+")",mouseX+7,mouseY+25); noFill();}
