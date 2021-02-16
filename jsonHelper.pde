//Json heler class using processing built-in functions
class jsonHelper {

  //jsonObject
  JSONObject jsonObj;

//Constructors
  public jsonHelper() {
  }
  public jsonHelper(JSONObject _obj) {
    jsonObj = _obj;
  }

//Get attribute
  String getAttribute(String _name, char _type) {
    String res = null;
    
    //Switch based on type because we can't get a int as a string for some reason
    switch(_type) {
    case 's':
      res = jsonObj.getString(_name);
      break;
    case 'i':
      res = Integer.toString(jsonObj.getInt(_name));
      break;
    case 'f':
      res = Float.toString(jsonObj.getFloat(_name));
      break;
    case 'b':
      res = Boolean.toString(jsonObj.getBoolean(_name));
      break;
    }

    //Return it all as a string anyway since they're easier to work with
    return res;
  }

//Get object on key
  JSONObject getObject(String _name) {
    return jsonObj.getJSONObject(_name);
  }

//Get array on key
  JSONArray getArray(String _name) {
    return jsonObj.getJSONArray(_name);
  }

//Get object attribute
  String getObjectAttribute(String _name, char _type, String _objName) {
    jsonHelper jh = new jsonHelper(getObject(_objName));
    return jh.getAttribute(_name, _type);
  }
}
