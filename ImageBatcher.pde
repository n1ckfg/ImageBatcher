void setup() {
  size(50,50,P2D);
  fileSetup();
  setupShaders();
}

void draw() {
  fileFirstRun();
  
  targetImg.beginDraw();
  targetImg.image(exampleProcess(img),0,0);
  targetImg.filter(shader);
  targetImg.endDraw();
  
  fileLoop();
}

PImage exampleProcess(PImage _img) {
  _img.loadPixels();
  for (int i=0; i<_img.pixels.length; i++) {
    float r = red(_img.pixels[int(random(100))]); 
    float g = green(_img.pixels[i]); 
    float b = blue(_img.pixels[i]); 
    
    r = abs(255 - r);
    g = abs(255 - g);
    b = abs(255 - b);
    
    color c = color(r,g,b);
    _img.pixels[i] = c;
  }
  _img.updatePixels();
  return _img;
}