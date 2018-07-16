component displayName="Barretts Utils" hint="Some useful functions I've made at work that could be reused"{
   
    /*  NOTE: A lot of these are modified from their original usage, not all have been tested since rewrite. */

    
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
        var httpService = useHttpService(reqUrl, [{type='header' name='apiKey',
            value=config.apiKey }, {type='body', name='ID', value=ID }], 'GET');
        httpService.send().getPrefix().FileContent;
    */
    public function useHttpService(reqUrl, params=[], method='GET'){
        local.httpService = new http();
        local.httpService.setTimeOut(450);
        local.httpService.setCharset('utf-8');
        local.httpService.setMethod(method);
        local.httpService.setUrl(reqUrl);
        for(var i = 1; i <= arrayLen(params); i++){
            local.httpService.addParam(type=params[i].type, name=params[i].name, value=params[i].value);
        }
        return local.httpService;
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


}


/*  Try/Catch Email Error Snippet:
    try{ var i = 5 / 0; } 
    catch(any e){ sendGatewayMessage('errorHandler', {e='Something.cfc failed line #', m=e}); } 
*/

/* Create config object for injection
    config = createobject('component','<>.config');
    config.init(xmlparse(expandpath('/<>/<>.xml')));
*/

/* Component init -> dependency inject config file
    public function init(required <>.config config){
        //setup things in variables scope if needed...
        return this;
    }
*/

