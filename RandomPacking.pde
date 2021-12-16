// Random Packing
// Andrin Rehmann, 2019

ArrayList<Shape> g_shapes;
ArrayList<Vector> g_points;

// Set the distance to other squares
float offset = 0.01;

// Color 
float red = 0;
float green = 220;

// Set maximal shape size (s x s)
float size = 700;

void setup(){
  background(0);
  size(1000,1000);
  stroke(255);
  strokeWeight(1);
  
  g_shapes = new ArrayList<Shape>();
  g_points = new ArrayList<Vector>();
}

void draw(){
  
  // Color animation
  red += (255 - red) * 0.003;
  green -= green * 0.003;
  // Decrease size over time since empty space gets smaller
  // Could probably be derived probabilistically
  if (size > 40)
    size-= 0.2;
    
  stroke(120,red,green);
  
  Shape instance;
  // In each frame add twenty new shapes
  for (int i = 0; i < 20; i++){
    do{
      instance = new Shape(
        random(1,size),
        random(1,size), 
        new Vector(random(width),random(height))
      );
    }
    // Only add shapes which do not intersect other shapes
    while(!instance.testAndAdd(g_points, g_shapes));
  }
 
  
}

class Shape{
  ArrayList<Vector> corners;
  ArrayList<Vector> vis;
  
  Shape(float w, float h, Vector pos){
    
    corners = new ArrayList<Vector>();
    
    // Add cornerpoints of new shape
    corners.add(pos.copy().add(-w/2,-h/2)); 
    corners.add(pos.copy().add(w/2,-h/2));
    corners.add(pos.copy().add(w/2,h/2));
    corners.add(pos.copy().add(-w/2,h/2));
  
    // Visual represenation with additional offset
    vis = new ArrayList<Vector>();
    
    // Add corner points of visual representation
    // Small offset increases distance to other shapes
    vis.add(corners.get(0).copy().add(offset*w,offset*h));
    vis.add(corners.get(1).copy().add(-offset*w,offset*h));
    vis.add(corners.get(2).copy().add(-offset*w,-offset*h));
    vis.add(corners.get(3).copy().add(offset*w,-offset*h));
  }
  
  void draw(){
    for (int i = 0; i < vis.size(); i++) {
      Vector a = vis.get(i);
      Vector b = vis.get((i+1)%vis.size());
      line(a.x(), a.y(), b.x(), b.y());
    }
  }
  
  // Check weather shapes encloses a point
  boolean doesEnclose(Vector point) {
    int j = 0;
      
    for (int i = 0; i < corners.size(); i++){
      
      Vector a = corners.get(i);
      Vector b = corners.get((i+1)%corners.size());
      
      if (point.isLeft(a,b))
        j++;
      
    }
    
    return j == corners.size();
  }
  
  // Test weather shape intersect any points, if no add it to global array, otherwise return false
  boolean testAndAdd(ArrayList<Vector> points, ArrayList<Shape> shapes) {
    
    // Check if any point is inside this shape
    for (Vector pointInstance : points) 
      if (doesEnclose(pointInstance))
        return false;
        
   
    for (Shape shapeInstance : shapes){
      // Check if any corner point is inside other shape
      for (Vector corner : corners)
        if (shapeInstance.doesEnclose(corner))
          return false;
      
      // Check if any line intersects with other lines
      for (int i = 0; i < corners.size(); i++){
         
        Vector a = corners.get(i);
        Vector b = corners.get((i+1)%corners.size());  
         
        for (int j = 0; j < shapeInstance.corners.size(); j++){
          
          Vector c = shapeInstance.corners.get(j);
          Vector d = shapeInstance.corners.get((j+1)%shapeInstance.corners.size());  
           
          if (linesDoIntersect(a,b,c,d))
            return false;
            
         }
      }
    }
    
    // update data structure
    for (Vector corner : corners)
      points.add(corner);
      
    shapes.add(this);
    
    // draw shape
    this.draw();
    
    return true;
  }
  
  // Copy-pasta line intersection https://stackoverflow.com/questions/4543506/algorithm-for-intersection-of-2-lines
  boolean linesDoIntersect(Vector p0, Vector p1, Vector p2, Vector p3)
  {
    double s1_x, s1_y, s2_x, s2_y;
    s1_x = p1.x - p0.x;  
    s1_y = p1.y - p0.y;
    s2_x = p3.x - p2.x; 
    s2_y = p3.y - p2.y;

    double s, t;
    s = (-s1_y * (p0.x - p2.x) + s1_x * (p0.y - p2.y)) / (-s2_x * s1_y + s1_x * s2_y);
    t = ( s2_x * (p0.y - p2.y) - s2_y * (p0.x - p2.x)) / (-s2_x * s1_y + s1_x * s2_y);

    return (s >= 0 && s <= 1 && t >= 0 && t <= 1);

  }
}

// Detect any key pressed and store screenshot
void keyPressed(){
  saveFrame("line-######.png");
}
