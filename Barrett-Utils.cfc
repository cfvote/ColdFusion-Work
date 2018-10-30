component displayName="Barretts Utils" hint="Some useful functions I've made at work that could be reused" {
   
    /*  NOTE: A lot of these are modified from their original usage to strip out company information,
            not all have been thoroughly tested since rewrite. 
    */

    public void function init(){
        variables.newLine = Chr(13) & Chr(10);
        variables.divider = repeatString("-", 75);
    }
    
    private void function getThisCFName(){
        return listFirst(listLast(getMetadata(this).path, "\\"), ".");
    }
    
    private void function classNameOutput(required any obj, boolean toConsole=true){
        if(toConsole){
            writeDump(getMetadata(obj).getName(), 'console');
        } else{
            writeDump(getMetadata(obj).getName());
        }
    }

    private void function jsonOutput(required any obj, boolean toConsole=false){
        if(toConsole){
            writeDump(deserializeJSON(serializeJSON(obj)), 'console');
        } else{
            writeDump(deserializeJSON(serializeJSON(obj)));
        }
    }

    /*  Map web service json response to Java Bean with Jackson mapper(Java Object) and return bean array
        classPath - Intended bean to map
        jsonStr   - Serialized JSON string from web service response 
    */
    private array function jacksonMapBeans(required string classPath, required string jsonStr){
        var beanArray = arrayNew(1);
        var jsonArr = arrayNew(1);
        var jacksonMapper = getJacksonMapper();
        var class = createObject('java', 'java.lang.Class').forName(classPath);
        jsonArr.append(deserializeJSON(jsonStr), true);
        for(var i = 1; i <= arrayLen(jsonArr); i++){
            beanArray.append(jacksonMapper.readValue(serializeJson(jsonArr[i]), class));
        }
        return beanArray;
    }

    /*  Sorts an array of structures by specified key*/
    public function sortArrOfStruct(arr, key, sortType, sortOrder, delimiter){
        var tmp = arrayNew(1);
        for(var i = 1; i <= arrayLen(arr); i++){
            tmp.append(arr[i][key] & delimiter & i);
        }
        tmp.sort(sortType, sortOrder);
        var sorted = arrayNew(1);
        for(var j = 1; j <= arrayLen(tmp); j++){
            sorted.append(arr[tmp[j].Split(delimiter)[2]]);
        }
        return sorted;
    }

    public string function pow(required string base, required string power){
        if(arguments.power == 0){
            return 1;
        } 
        return arguments.base * pow(arguments.base, --arguments.power);
    }

    /*Add a simple array to an xml node, expects simple types*/
    public function addArrayToXmlNode(arr, rootNode, parentNode, childName, value){
        for(var i = 1; arrayLen(arr) > 0 && i <= arrayLen(arr); i++){
            parentNode.XmlChildren[i] = XmlElemNew(rootNode, childName);
            parentNode.XmlChildren[i].XmlText = arr[i].find(value);
        }
    }

    /*  Creates an xml doc with an array of structs converted to a single xml node with children
        convertArrOfStructToXml(arrOfStruct, 'response', 'vehicles', vehicle', {'_id': 'ID', 'config': 'style'}); 
    */
    private function convertArrOfStructToXml(arrOfStruct, docName, nodeName, childName, keyAdjustments = {}){
        var myDoc = XmlNew();
        myDoc.xmlRoot = XmlElemNew(myDoc, docName);
        myDoc.docName.XmlChildren[1] = XmlElemNew(myDoc, nodeName);

        for(var i = 1; i <= arrayLen(arrOfStruct); i++){
            myDoc.response.nodeName.XmlChildren[i] = XmlElemNew(myDoc, childName);
            var j = 1;
            for(var key in arrOfStruct[i]){
                for(var adjustment in keyAdjustments){
                    if(adjustment EQ key){
                        key = adjustment;
                    }
                }
                myDoc.docName.nodeName.xmlChildren[i].xmlChildren[j] = XmlElemNew(myDoc, key);
                if(!IsArray(arrOfStruct[i][key])){
                    myDoc.docName.nodeName.xmlChildren[i].xmlChildren[j].XmlText = arrOfStruct[i][key];
                }
                j++;
            }
        }
        return myDoc;
    }

    /* Convert Xml to array of structs based on keyPairs struct given
        convertXmlToArrOfStructs(myXmlDoc, 'Vehicles', 'Vehicle', {'employeeID': 'ID', 'testAmount':'amount'});
    */
    public function convertXmlToArrOfStructs(xml, arrName, elemName, keyPairs){
        var arr = arrayNew(1);
        var elements = xmlSearch(dom, '//*:' & arrName & '/*:' & elemName);
        for(var i = 1; i <= arrayLen(elements); i++){
            var s = structNew();
            for(var key in keyPairs){
                s[key] = xmlSearch(elements[i], 'string(*:' & keyPairs[key] & ')');
            }
            arr.append(s);
        }
        return arr;
    }

    /*  Builds a query string based on parameters for a URL
        buildQueryString({'param1':'1234', 'param2':'', 'param3':'qwerty'}, 'http://test.com/');
        http://test.com/?param1=1234&param3=qwerty
    */
    public function buildQueryString(queryParams = '', url = ''){
        for(var key in queryParams){
            if(queryParams[key] NEQ ''){
                url = url & ((url EQ '') ? '?' & key & '=' & queryParams[key] : '&' & key & '=' & queryParams[key]);
            }
        }
        return url;
    }
    
    /* Send HTTP requests
        var httpService = makeHttpService('GET', reqUrl, [{type='header' name='apiKey',
            value=config.apiKey }, {type='body', name='ID', value=ID }]);
        httpService.send().getPrefix().FileContent;
    */
    private http function makeHttpService(required string method, required string reqUrl, array params=[]){
        var httpService = new http();
        httpService.setTimeOut(450);
        httpService.setCharset('utf-8');
        httpService.setMethod(method);
        httpService.setUrl(reqUrl);
        for(var i = 1; i <= arrayLen(params); i++){
            httpService.addParam(type=params[i].type, name=params[i].name, value=params[i].value);
        }
        return httpService;
    }

    /*Search array of structs for a key, only goes one layer deep in the structs*/
    private function searchArrOfStructs(required array arrOfStruct, required string key){
        var index = ArrayFind(arrOfStruct.config.specs, function(s){
            return s.key == key;
        });
        if(index > 0 && StructKeyExists(arrOfStruct[index], key)){
            return arrOfStruct[index][key];
        }
        return '';
    }

    private string function stringifyStruct(required struct x){
        local.out = '';
        for(local.key in arguments.x){
            local.out = local.out & local.key & ':' & arguments.x[local.key] & variables.newLine;
        }
        return local.out;
    }

    /* Display a string and replace specifed characters with html tags using options struct
        options = {   '{': '<b>', '}': '</b>'  }; 
    */
    private void function displayStringHtml(required string output, required string delimiter, struct options){
        local.htmlOut = output.split(arguments.delimiter);
        for(local.piece in htmlOut){
            for(local.o in arguments.options){
                local.piece = replace(local.piece, local.o, arguments.options[local.o], 'all');
            }
            local.piece = replace(local.piece, ' ', '&nbsp;', 'all');
            local.piece = replace(local.piece, variables.divider, '<hr />', 'all');
            local.piece = replace(local.piece, variables.newLine, '<br />', 'all');
            writeOutput("#local.piece#");   
        }
    }
    
     private boolean function foundDuplicateId(required array struct, required string key){
        if(arrayLen(struct) != 0){
            for(var i = 1; i <= arrayLen(struct); i++){
                for(var j = (i+1); j <= arrayLen(struct); j++){
                    if(struct[i][key] == struct[j][key]){
                        return true;
                    }
                }
            }
        }
        return false;
    }
}


//               Misc. Snippets

/*  Try/Catch Email Error Snippet:
    try{ var i = 5 / 0; } 
    catch(any e){ sendGatewayMessage('errorHandler', {e='Something.cfc failed line #', m=e}); } 
*/

/* Create config object for injection
    config = createobject('component','<>.config');
    config.init(xmlparse(expandpath('<>.xml')));
*/

/* Component init -> dependency inject config file
    public function init(required <>.config config){
        //setup things in variables scope if needed...
        return this;
    }
*/
