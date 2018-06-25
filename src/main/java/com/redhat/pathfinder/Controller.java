package com.redhat.pathfinder;

import java.io.IOException;
import java.net.URL;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Properties;
import java.util.Random;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.core.Response;

import org.apache.commons.io.IOUtils;
import org.bson.Document;
import org.bson.codecs.BsonTypeClassMap;
import org.bson.codecs.DocumentCodec;
import org.bson.codecs.configuration.CodecRegistries;
import org.bson.codecs.configuration.CodecRegistry;
import org.codehaus.jackson.JsonGenerationException;
import org.codehaus.jackson.map.JsonMappingException;

import com.mongodb.MongoClient;
import com.mongodb.MongoCredential;
import com.mongodb.ServerAddress;
import com.mongodb.client.MongoDatabase;
import com.redhat.pathfinder.charts.Chart2Json;
import com.redhat.pathfinder.charts.DataSet2;

@Path("/pathfinder/")
public class Controller{
  
  static Properties properties=null;
  public static String getProperty(String name) throws IOException{
//    if (null==properties){
//      properties = new Properties();
//      properties.load(Controller.class.getClassLoader().getResourceAsStream("pathfinder-ui.properties"));
//    }
    System.out.println("request for property '"+name+"'");
    System.out.println(" - System.getProperty("+name+")='"+System.getProperty(name)+"'");
    System.out.println(" - System.getenv("+name+")='"+System.getenv(name)+"'");
    
    
//    if (null!=properties.getProperty(name)){
//      return properties.getProperty(name);
//    }else{
      return System.getenv(name);
//    }
  }
  
  class ApplicationAssessmentSummary{
    String question;
    String answer;
    String rating;
    public ApplicationAssessmentSummary(String q, String a, String r){
      this.question=q;
      this.answer=a;
      this.rating=r;
    }
    public String getQuestion(){return question;}
    public String getAnswer(){return answer;}
    public String getRating(){return rating;}
  }
  
  class dependencyTree{
    String from;
    String to;
    public dependencyTree(String f, String t){
      this.from=f;
      this.to=t;
    }
    public String getQuestion(){return from;}
    public String getAnswer(){return to;}
  }  
  
  public static void main(String[] asd) throws Exception{
//    System.out.println(new Controller().viewAssessmentSummary("56f3529a-ed8f-4b07-a4f9-47fa3072d843", "44f51762-7f25-4694-bf69-e31432b6e501", "2d0f1f7f-6819-4439-be69-e114dd8c257b").getEntity());
    new Controller().getApps();
  }
  public Response getApps(){
    MongoCredential credential = MongoCredential.createCredential("userS1K", "pathfinder", "JBf2ibxFbqYAmAv0".toCharArray());
    MongoClient c = new MongoClient(new ServerAddress("localhost", 9191), Arrays.asList(credential));
    MongoDatabase db = c.getDatabase("pathfinder");
    
    CodecRegistry codecRegistry = CodecRegistries.fromRegistries(MongoClient.getDefaultCodecRegistry());
    final DocumentCodec codec = new DocumentCodec(codecRegistry, new BsonTypeClassMap());

    for (String name : db.listCollectionNames()) {
      System.out.println("CollectionName: "+name);
    }
    for(Document d:db.getCollection("assessments").find()){
      System.out.println(d.toJson(codec));
    }
    
//    for(Document d:db.getCollection("customer").find()){
//      System.out.println(d.toJson(codec));
////      Class.forName(className)
////      try{
////        Object x=Json.newObjectMapper(true).readValue(d.toJson(codec), Class.forName(d.getString("_class")));
////        System.out.println("X = "+x);
////      }catch (Exception e){
////        e.printStackTrace();
////      }
////      d.get("_class");
//    }
    
//    String mongoURI=String.format("mongodb://%s:%s@%s:%s/%s", "userS1K","JBf2ibxFbqYAmAv0","localhost","9191","pathfinder");
//    MongoClient c=new MongoClient(mongoURI);
//    MongoDatabase db=c.getDatabase("pathfinder");
    
    c.close();
    return null;
  }
  
  
  /* called from "viewAssessment.jsp" to be displayed on the datatable */
  @GET
  @Path("/customers/{customerId}/applications/{appId}/assessments/{assessmentId}/viewAssessmentSummary")
  public Response viewAssessmentSummary(@PathParam("customerId") String customerId, @PathParam("appId") String appId, @PathParam("assessmentId") String assessmentId) throws JsonGenerationException, JsonMappingException, IOException{
    
    //parse the application-survey.js file into a json object structure
    //get the answers from the assessment
    //match the two as output to the datatable onscreen
    
    mjson.Json x=getSurvey();
    
    //MOCKED CODE, when the colors are put into the surveyjs source this can be removed
    Random r=new Random();
    String[] ratingsCfg=new String[]{"UNKNOWN","RED","AMBER","AMBER","GREEN","GREEN","GREEN","GREEN"};
    
    List<ApplicationAssessmentSummary> result=new ArrayList<ApplicationAssessmentSummary>();
    for(mjson.Json p:x.asJsonList()){
      for(mjson.Json q:p.at("questions").asJsonList()){
        
        String answerText="";
        String answerRating="";
        
        if (q.at("type").asString().equals("radiogroup")){
          List<String> answers=new ArrayList<String>();
          for(mjson.Json a:q.at("choices").asJsonList())
            answers.add(a.asString());
          
          //fix these mocked answers
          int randomIndex=0 + r.nextInt((answers.size()-1 - 0) + 1);
          String answerIdx=answers.get(randomIndex).split("\\|")[0];
          if (answerIdx.contains("-")) answerIdx=answerIdx.split("-")[0];
          answerText=answers.get(randomIndex).split("\\|")[1];
          //
          
          answerRating=ratingsCfg[Integer.parseInt(answerIdx)];
          
          result.add(new ApplicationAssessmentSummary(q.at("title").asString(), answerText, answerRating));
        }else if (q.at("type").asString().equals("rating")){
          // leave this out since it's things like "Select the app..."
        }
      }
    }
    return Response.status(200).entity(Json.newObjectMapper(true).writeValueAsString(result)).build();
  }
  
  
//  private mjson.Json tmpSurveyCache=null;
  private mjson.Json getSurvey() throws JsonGenerationException, JsonMappingException, IOException{
//    if (tmpSurveyCache==null){
      String raw=IOUtils.toString(new URL("http://pathfinder-frontend-vft-dashboard.int.open.paas.redhat.com/pathfinder-ui/assets/js/application-survey.js").openStream());
      int start=raw.indexOf("pages: [{")+7;
      int end=raw.indexOf("}],")+2;
      String x=raw.substring(start, end);
      System.out.println(x);
//      x="[]";
      return mjson.Json.read(x);
//      tmpSurveyCache=mjson.Json.read(raw.substring(start, end));
//    }
//    return tmpSurveyCache;
  }
  
  /* pie chart where the aspects are grouped by color */
  // NOT SURE THIS IS EVEN USED ANYMORE
  @GET
  @Path("/customers/{customerId}/applications/{appId}/assessments/{assessmentId}/chart2")
  public Response chart2(@PathParam("customerId") String customerId, @PathParam("appId") String appId, @PathParam("assessmentId") String assessmentId) throws JsonGenerationException, JsonMappingException, IOException{
    
//    mjson.Json x=getSurvey();
    List<String> d=new ArrayList<String>();
    d.add("Architectural Suitability:1:GREEN");
    d.add("Clustering:4:GREEN");
    d.add("Communication:2:GREEN");
    d.add("Compliance:3:GREEN");
    d.add("Application Configuration:4:GREEN");
    d.add("Existing containerisation:0:GREEN");
    d.add("Deployment Complexity :4:GREEN");
    d.add("Dependencies - 3rd party vendor:2:GREEN");
    d.add("Dependencies - Hardware:1:GREEN");
    d.add("Dependencies - (Incoming/Northbound):4:GREEN");
    d.add("Dependencies - Operating system:2:GREEN");
    d.add("Dependencies - (Outgoing/Southbound):5:AMBER");
    d.add("Discovery:3:AMBER");
    d.add("Observability - Application Health:4:AMBER");
    d.add("Observability - Application Logs:3:AMBER");
    d.add("Observability - Application Metrics:3:AMBER");
    d.add("Level of ownership:5:AMBER");
    d.add("Runtime profile:4:RED");
    d.add("Application resiliency:4:RED");
    d.add("Application Security:3:RED");
    d.add("State Management:0:UNKNOWN");
    d.add("Application Testing:3:UNKNOWN");
        
    Map<String,Integer> labels=new HashMap<String, Integer>();
    
    for(String x:d){
      if (!labels.containsKey(x.split(":")[2])) labels.put(x.split(":")[2], 0);
      labels.put(x.split(":")[2], labels.get(x.split(":")[2])+1);
    }
    
    List<String> backgrounds=new ArrayList<String>();
    
    Chart2Json c=new Chart2Json();
    DataSet2 ds=new DataSet2();
    for(Entry<String, Integer> e:labels.entrySet()){
      c.getLabels().add(e.getKey());
      ds.getData().add(e.getValue());
      
      if (e.getKey().equals("RED")) backgrounds.add("rgb(255, 0, 0)");
      if (e.getKey().equals("AMBER")) backgrounds.add("rgb(255, 205, 86)");
      if (e.getKey().equals("GREEN")) backgrounds.add("rgb(0, 128, 0)");
      if (e.getKey().equals("UNKNOWN")) backgrounds.add("rgb(220, 220, 220)");
      
    }
    c.getDatasets().add(ds);
    ds.setBackgroundColor(backgrounds);
    return Response.status(200).entity(Json.newObjectMapper(true).writeValueAsString(c)).build();
  }
  
}
