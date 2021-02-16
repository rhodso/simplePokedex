//Import helper functions because writing is hard
import java.net.*;
import java.io.BufferedReader;
import java.io.InputStreamReader;

//Response helper class because main app looks prettier without this
public class httpResponseHelper {
  
  //Class vars
  boolean debug = true;
  String baseUrl = "https://pokeapi.co/api/v2/pokemon/";

//Constructor does nothing
  public httpResponseHelper() {}

  //Do request method
  JSONObject doRequest(String _pkName) {
    //Start processing request, init vars
    System.out.println("Processing request...\nName: "+ _pkName);
    String requestURL = baseUrl + _pkName;
    String jsonData = "";
    JSONObject jObj = null;

    //Check for cached response
    try {
      jObj = loadJSONObject("data/" + _pkName + ".json");
      log("Using cached response");
      System.out.println("Done processing");
      return jObj;
    }
    //No cache
    catch(Exception e) {
      log("No cached response avalable, performing request");
    }

    try {
      //Make URL and con
      URL url = new URL(requestURL);
      log("url = " + requestURL);
      HttpURLConnection con = (HttpURLConnection) url.openConnection();
      con.setRequestProperty("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36");

      //Tell it to do a get
      con.setRequestMethod("GET");

      //Status code
      int status = con.getResponseCode();
      log("Returned " + status);

      //Handle based on code
      if (status == 200) {
        BufferedReader res = new BufferedReader(new InputStreamReader(con.getInputStream()));
        String inputLine;
        StringBuffer content = new StringBuffer();
        while ((inputLine = res.readLine()) != null) {
          content.append(inputLine);
        }
        jsonData = content.toString();
        log("Got content, parsing into json");

        //Load json data into obj and save
        jObj = parseJSONObject(jsonData);
        jsonHelper jh = new jsonHelper(jObj);
        String pkName = jh.getAttribute("name", 's'); 
        saveJSONObject(jObj, "data/" + pkName + ".json");
        log("Done parsing, making sure it works");

        //Check we can read from file
        log("Attempting to read json file " + pkName + ".json");
        jObj = loadJSONObject("data/" + pkName + ".json");
        log("jObj loaded, testing");

        //Print results
        if (jObj.getInt("id") > 0) {
          log("Test successful");
        } else {
          log("Test unsuccessful");
        }

        //Disconnect connection
        con.disconnect();
        System.out.println("Done processing");
      } else if (status == 404) { //Pokemon not found
        System.out.println("Pokemon doesn't appear to exist in DB");
      } else { //Other error
        System.out.println("Couldn't finish request");
        System.out.println("Status: " + status);
      }
      return jObj;
    }
    catch(Exception e) {
      //Handle exceptions (badly)
      System.out.println(e.toString());
    } 
    finally {
      //Don't repeat
      getInfo = false;
    }
    
    //It shouldn't get here but if it does then something went really wrong
    return null;
  }

  void log(String _msg) {
      System.out.println(_msg);
  }
}
