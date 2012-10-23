void writeFiles(){
  /*
  Writing report file
  */
  String filename = selectOutput();
  println("Writing report");
  PrintWriter report;
  report = createWriter(filename+"_report.txt");
  
  report.println("Merged clouds " + cloud1filename + " and " + cloud2filename);
  report.println();report.println();
  report.println("Selected points in " + cloud1filename + ":");
  for(int i=0;i<cloud1PointsList.size(); i++){
    report.println(cloud1PointsList.get(i));
  }
  report.println();
  report.println("Selected points in " + cloud2filename + ":");
  for(int i=0;i<cloud2PointsList.size(); i++){
    report.println(cloud2PointsList.get(i));
  }
  report.println();
  report.println("Rotation matrix:");
  for(int i=0; i<R.length; i++){
    report.println(formatter.format(R[i][0]) + ", " + formatter.format(R[i][1]) + ", " + formatter.format(R[i][2]));
  }
  report.println();
  report.println("Translation parameters:");
  report.println("X: " + formatter.format(T[0]) + ", Y: " + formatter.format(T[1]) + ", Z: " + formatter.format(T[2]));
  report.println();
  report.println("Diff matrix:");
  for(int i=0; i<diff.length; i++){
    report.println(formatter.format(diff[i][0]) + ", " + formatter.format(diff[i][1]) + ", " + formatter.format(diff[i][2]));
  }
  report.println();
  report.println("Residuals:");
  report.println("X: " + formatter.format(res[0]) + ", Y: " + formatter.format(res[1]) + ", Z: " + formatter.format(res[2]));
  report.flush();
  report.close();
  
  /*
  Writing merged pointcloud
  */
  println("writing output cloud");
  PrintWriter output;
  output = createWriter(filename+".txt");
  //Start by copying cloud 2 to the new file
  String[] raw = loadStrings(cloud2abspath);
  for (int i = 0; i < raw.length; i++) {
    output.println(raw[i]);
  }
  //Then write transformed cloud:
  for(int i=0; i<cloud1.length/3;i++){
    output.println(formatter.format(f3.get(i*3+0)) + " " + formatter.format(f3.get(i*3+1)) + " " + formatter.format(f3.get(i*3+2)) + " " +
      cloud1col[i*3+0] + " " + cloud1col[i*3+1] + " " + cloud1col[i*3+2]);
  }
  
  output.flush();
  output.close();
}
