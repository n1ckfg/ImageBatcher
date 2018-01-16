import java.awt.Desktop;

int counter = 0;
boolean firstRun = true;
String openFilePath = "render";
String folderPath;
File dataFolder;
ArrayList imgNames;
String fileName = "frame";
boolean filesLoaded = false;
PImage img;
PGraphics targetImg;
boolean updateScreen = true;

//~~~~~~~~~~~~~~~~~~~~~~~~
//choose folder dialog, Processing 2 version

void loadFiles() {
  chooseFolderDialog();
  filesLoadedChecker();
}

void chooseFolderDialog(){
    selectFolder("Choose a PNG, JPG, GIF, or TGA sequence.","chooseFolderCallback");  // Opens file chooser
}

void chooseFolderCallback(File selection){
    if (selection == null) {
      println("No folder was selected.");
      exit();
    } else {
      folderPath = selection.getAbsolutePath();
      println(folderPath);
      countFrames(folderPath);
    }
}

void countFrames(String usePath) {
    imgNames = new ArrayList();
    //loads a sequence of frames from a folder
    dataFolder = new File(usePath); 
    String[] allFiles = dataFolder.list();
    for (int j=0;j<allFiles.length;j++) {
      if (
        allFiles[j].toLowerCase().endsWith("png") ||
        allFiles[j].toLowerCase().endsWith("jpg") ||
        allFiles[j].toLowerCase().endsWith("jpeg") ||
        allFiles[j].toLowerCase().endsWith("gif") ||
        allFiles[j].toLowerCase().endsWith("tga")){
          imgNames.add(usePath+"/"+allFiles[j]);
        }
    }
    if(imgNames.size()<=0){
      exit();
    }else{
      // We need this because Processing 2, unlike Processing 1, will not automatically wait to let you pick a folder!
      String s;
      if (imgNames.size() == 1) {
        s = "image";
      } else {
        s = "images";
      }
      println("FOUND " + imgNames.size() + " " + s);
      filesLoaded = true;
    }
}

void filesLoadedChecker() {
  // We need this because Processing 2, unlike Processing 1, will not automatically wait to let you pick a folder!
  while(!filesLoaded){
    try{
      if(imgNames.size() > 0) img = loadImage((String) imgNames.get(0));
    }catch(Exception e){ 
      filesLoaded = false;
    }
  }
}
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//reveal folder, processing 2 version

void openAppFolderHandler(){
  if(System.getProperty("os.name").equals("Mac OS X")){
    try{
      print("Trying OS X Finder method.");
      //open(sketchPath(openFilePath));
      Desktop.getDesktop().open(new File(sketchPath("") + "/" + openFilePath));
    }catch(Exception e){ }
  }else{
    try{
      print("Trying Windows Explorer method.");
      Desktop.getDesktop().open(new File(sketchPath("") + "/" + openFilePath));
    }catch(Exception e){ }
  }
}

//run at startup if you want to use app data folder--not another folder.
//This accounts for different locations and OS conventions
void scriptsFolderHandler(){
  String s = openFilePath;
  if(System.getProperty("os.name").equals("Mac OS X")){
    try{
      print("Trying OS X Finder method.");
      openFilePath = dataPath("") + "/" + s;
    }catch(Exception e){ }
  }else{
    try{
      print("Trying Windows Explorer method.");
      openFilePath = sketchPath("") + "/data/" + s;
    }catch(Exception e){ }
  }
}

void saveGraphics(PGraphics pg,boolean last){
  try{
    String savePath = openFilePath + "/" + fileName + "_" + zeroPadding(counter+1,imgNames.size()) + ".png";
    pg.save(savePath); 
    println("SAVED " + savePath);
  }catch(Exception e){
    println("Failed to save file.");  
  }
  if(last) {
    openAppFolderHandler();
    exit();
  }
}

void nextImage(int _n){
  String imgFile = (String) imgNames.get(_n);
  img = loadImage(imgFile);
  println("RENDERING frame " + (counter+1) + " of " + imgNames.size());
}

String zeroPadding(int _val, int _maxVal){
  String q = ""+_maxVal;
  return nf(_val,q.length());
}

float tween(float v1, float v2, float e) {
  v1 += (v2-v1)/e;
  return v1;
}

void prepGraphics() {
  targetImg = createGraphics(img.width, img.height, P2D);
}

void fileSetup() {
  Settings settings = new Settings("settings.txt");
  loadFiles();
  nextImage(counter);
  if (updateScreen) surface.setSize(img.width, img.height);
}

void fileFirstRun() {
  if (firstRun) {
    prepGraphics();
    firstRun = false;
  }
}

void fileLoop() {
  if (updateScreen) image(targetImg,0,0);
  if (counter<imgNames.size()-1) {
    saveGraphics(targetImg, false); //don't exit
    counter++;
    nextImage(counter);
    prepGraphics();
  } else {
    saveGraphics(targetImg, true); //exit
  }
}