
PFont f;
String baseUrl = "http://api.sandbox.yellowapi.com";
String apiCode = "b4trsn8g2h898uxz3yef6fc8";
String what="";
String where="";
int entered=0;
int id=0;
String name = "";
String thinking = "";
String done = "";
String phone="";
int pagetostart=0;
String URL="";
ArrayList<String> listData= new ArrayList<String>();
void setup(){
  size(550,200);
   f = createFont("Helvetica",16,true);
}
  

void draw(){
  background(130);
    fill(255);
  rect(20,20,500,20);
  fill(255);
  rect(20,60,500,20);
  textFont(f);
  fill(0); 
  text("powered by yellow pages API",300,180);
  text(what+(frameCount/10 % 2 == 0 ? "_" : ""),20,33);
  text(where+(frameCount/10 % 2 == 0 ? "_" : ""),20,73);
    text(done,150,150);
     if(entered==2){
      entered=0;
      thinking="thinking";
      getDetails(what,where, 1);
     
     }

  

}

void keyReleased() {
  if (key != CODED) {
    switch(key) {
    case BACKSPACE:
      if(entered==0){
      what = what.substring(0,max(0,what.length()-1));
      }
       if(entered==1){
      where = where.substring(0,max(0,where.length()-1));
      }
      break;
    case TAB:
      if(entered==0){ 
      what += "    ";
      }
      if(entered==1){ 
      where += "    ";
      }
      break;
    case ENTER:
    entered++;
    case RETURN:
      // comment out the following two lines to disable line-breaks
    // typedText += "\n";
    //  break;
    case ESC:
    case DELETE:
      break;
    default:
    if(entered==0){
      what += key;
    }
    if(entered==1){
      where += key;
    }
    }
  }
}


void getDetails(String what, String where, int page){
 try{
   listData.add(what + "in" + where + "listings");

    delay(1000);
    String Sum = baseUrl + "/FindBusiness/?" + "&what=" + what + "&where=" + where + "&fmt=JSON&pgLen=30" + "&apikey=" + apiCode +"&UID=127.0.0.1";
    processing.data.JSONObject Sumdata = processing.data.JSONObject.parse(join(loadStrings(Sum),""));
    processing.data.JSONObject SumSum = Sumdata.getJSONObject("summary");
    int leng = SumSum.getInt("pageCount");
     pagetostart = SumSum.getInt("currentPage");
    for(int i=page; i<=leng; i++){
          delay(1000);
  String request = baseUrl + "/FindBusiness/?" + "&what=" + what + "&where=" + where + "&fmt=JSON&pgLen=50" + "&pg=" + i + "&apikey=" + apiCode +"&UID=127.0.0.1";
    
 processing.data.JSONObject YPdata  = processing.data.JSONObject.parse(join(loadStrings(request),""));
 
 processing.data.JSONArray YParray = YPdata.getJSONArray("listings");
 int span = YParray.size();
  for(int j=0; j< span; j++){
 processing.data.JSONObject YPobject = YParray.getJSONObject(j);
 
String name = YPobject.getString("name");
int id = YPobject.getInt("id");
processing.data.JSONObject YPaddress = YPobject.getJSONObject("address");
String city = YPaddress.getString("city");
String province = YPaddress.getString("prov");
String street = YPaddress.getString("street");
String postalCode = YPaddress.getString("pcode");
String SEOname1 = name.replace(" ","-");
String SEOname2=SEOname1.replace("---","-");
String SEOname3=SEOname2.replace("'","-");
String SEOcity=city.replace(" ","-");
    delay(1000);
String details = "http://api.sandbox.yellowapi.com/GetBusinessDetails/?listingId=" + id + "&bus-name=" + SEOname3 + "&city=" + SEOcity + "&prov=" + province + "&fmt=JSON&lang=en&UID=127.0.0.1&apikey=" + apiCode;

processing.data.JSONObject YPdetails  = processing.data.JSONObject.parse(join(loadStrings(details),""));
processing.data.JSONArray YPdetailsarray = YPdetails.getJSONArray("phones");
processing.data.JSONObject YPdetailsproducts = YPdetails.getJSONObject("products");
processing.data.JSONArray YPdetailsURLs = YPdetailsproducts.getJSONArray("webUrl");
 URL = YPdetailsURLs.getString(0);
processing.data.JSONObject YPdetailsobject = YPdetailsarray.getJSONObject(0);
 phone = YPdetailsobject.getString("dispNum");

println(name);
println(street);
println(city + ", " + province + ", " + postalCode);
println(phone);
println(URL);
println(" ");

listData.add(name);
listData.add(street);
listData.add(city + ", " + province + ", " + postalCode);
listData.add(phone);
listData.add(URL);
listData.add(" ");

  }
    }
String [] DataData = listData.toArray(new String[listData.size()]);
savedata(DataData);

done = "done";
  }catch(NullPointerException N){
loopBackIn(pagetostart);
}
}
void savedata(String[] Data){
  saveStrings("/BizTrack.txt",Data);
}

void loopBackIn(int pageToStart){
  
  getDetails(what,where,pageToStart+1);
}
  


    
 
