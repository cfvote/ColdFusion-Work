component displayName="Barretts Utils" hint="Some useful functions I've made at work that could be reused" {
   
    /*  NOTE: A lot of these are modified from their original usage to strip out company information,
            not all have been thoroughly tested since rewrite or even look pretty. 
    */


    public void function init(){
        //Convenience variables
        variables.newLine = Chr(13) & Chr(10);
        variables.divider = repeatString("-", 75);
    }


    /* Convert array of structures to a Query object */
    public Query function arrOfStructToQuery(required array arr){
        var q = new Query();
        if(arrayLen(arr) > 0){
            var cols = structKeyArray(arr[1]);
            q = queryNew(arrayToList(cols));
            queryAddRow(q, arrayLen(arr));
            for(var s in arr){
                for(var col in cols){
                    querySetCell(q, col, s[col], i);
                }
            }
        }
        return q;
    }


    /* Return simple HTML table string from database query results */
    public string function drawQueryTable(required Query q, string title='', array excludeCols=arrayNew(1)){
        var outHTML = '';
        savecontent variable = 'outHTML'{
            var size = arguments.q.recordCount;
            var cols = getMetadata(arguments.q);
            writeOutput('<div style="padding:.5em">');
            if(isDefined('arguments.q') && size > 0){
                writeOutput('<h3>#arguments.title#</h3><table class="table table-striped"><thead><tr>');
                for(var col in cols){
                    if(!arguments.excludeCols.contains(col.name)){
                        writeOutput('<th class="tableHeader:first-of-type">#col.name#</th>');
                    }
                }
                writeOutput("</tr><thead/>");
                for(var i = 1; i <= size; i++){
                    writeOutput("<tbody><tr>");
                    for(var col in cols){
                        if(!arguments.excludeCols.contains(col.name)){
                            writeOutput("<td>#queryGetRow(arguments.q, i)[col.name]#</td>");   
                        }
                    }
                    writeOutput("</tr></tbody>");
                }
                writeOutput('</table>');
            }
            writeOutput('</div>');
        }
        return outHTML;
    }


    /* Execute a database query and return result (More of a reference to syntax than an actual utility) */
    public Query function executeDbQuery(required string dataSrc, required string sql, array params){
        var result = '';
        var q = new Query();
        q.setDataSource(arguments.dataSrc);
        for(var param in arguments.params){
            q.addParam(name='#param.colName#', value='#param.value#', cfsqltype='#param.cfsqltype#');
        }
        try{
            result = q.execute(sql='#arguments.sql#');
        } catch(any e){
            errorHandler(e);
        }
        return result; 
    }


    /* Another function to execute a stored procedure from datasource using array of param structs */
    public Query function executeStoredProc(required string procName, required string dataSrc, array params=arrayNew(1)){
        var proc = new storedProc();
        proc.setProcedure(arguments.procName);
        proc.setDatasource(arguments.dataSrc);
        for(var param in arguments.params){
            proc.addParam(
                cfsqltype = param.cfsqltype, value = param.value, dbvarname = param.dbvarname
            );
        }
        proc.addProcResult(name="result", resultset=1);
        return proc.execute().getProcResultSets().result;
    }


    /* Execute stored procedure from data source with an array of param structs (More of a reference to syntax than an actual utility) */
    public any function executeCFStoredProc(required string procName, required string dataSrc, array params=arrayNew(1)){
        var response = '';
        cfstoredproc(procedure="#procName#", datasource="#dataSrc#"){
            cfprocresult(name="response");
            for(var param in params){
                cfprocparam(cfsqltype="#param.cfsqltype#", value="#param.value#", dbvarname="#param.colName#");
            }
        }
        return response;
    }


    /* Write error to log file and/or send to error inbox */
    public void function errorHandler(
        required any cfcatch, string type="information",
        string file="#listFirst(listLast(getMetadata(this).path, "\\"), ".")#",
        boolean sendEmail=true, boolean writeToLog=true)
    {
        if(sendEmail){
            sendGatewayMessage('errorHandler', cfcatch);
        }
        if(writeToLog){
            writeLog(text=cfcatch, type=type, file=file);
        }
	}


    /* Returns query converted to array - Each row is an array element */
    public array function queryToArray(required Query q){
		local.arr = arrayNew(1);
		for(local.row in arguments.q){
			local.arr.append(local.row);
		}
		return local.arr;
    }


    /* Return query as an array of structs */
    public struct function queryToArrOfStruct(required Query q){
        var arr = arrayNew(1);
        var cols = listToArray(q.columnlist);
        for(var row = 1; row <= q.recordcount; row++){
            row = structnew();
            for(var col = 1; col <= arrayLen(cols); col++){
                row[cols[col]] = q[cols[col]][row];
            }
            arr.append(duplicate(row));
        }
        return(arr);
    }


    /* Return a CF Component's name, defaults to current object
        test\somedir\barrett\test.cfc -> [test,somdir,barrett,test.cfc] -> [test,cfc] -> test 
    */
    public string function getComponentName(any obj){
        if(!isDefined('arguments.obj')){
            arguments.obj = this;
        }
        return listFirst(listLast(getMetadata(arguments.obj).path, "\\"), ".");
    }
    

    /* Simply return object's name according to CF metadata */
    public void function classNameOutput(any obj, boolean toConsole=false){
        if(!isDefined('arguments.obj')){
            arguments.obj = this;
        }
        if(arguments.toConsole){
            writeDump(getMetadata(arguments.obj).getName(), 'console');
        } else{
            writeDump(getMetadata(arguments.obj).getName());
        }
    }


    /* WriteDump object as JSON */
    public void function jsonOutput(required any obj, boolean toConsole=false){
        try{
            if(arguments.toConsole){
                writeDump(deserializeJSON(serializeJSON(arguments.obj)), 'console');
            } else{
                writeDump(deserializeJSON(serializeJSON(arguments.obj)));
            }
        } catch(any cfcatch){
            sendGatewayMessage('errorHandler', cfcatch);
        }
    }


    /* WriteDump object as XML */
    public void function xmlOutput(required any obj, boolean toConsole=false){
        try{
            if(toConsole){
                writeDump(deserializeXML(serializeXML(obj)), 'console');
            } else{
                writeDump(deserializeXML(serializeXML(obj)));
            }
        } catch(any cfcatch){
            sendGatewayMessage('errorHandler', cfcatch);
        }
    }


    /*  Map web service json response to Java Bean with Jackson mapper(Java Object) and return bean array
        classPath - Intended bean to map
        jsonStr   - Serialized JSON string from web service response 
    */
    public array function jacksonMapBeans(required string classPath, required string jsonStr){
        var beanArray = arrayNew(1);
        var jsonArr = arrayNew(1);
        var jacksonMapper = getJacksonMapper();
        var class = createObject('java', 'java.lang.Class').forName(classPath);
        jsonArr.append(deserializeJSON(jsonStr), true);
        for(var i = 1; i <= arrayLen(jsonArr); i++){
            beanArray.append(jacksonMapper.readValue(serializeJSON(jsonArr[i]), class));
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


    /* Recursive power function*/
    public numeric function pow(required numeric base, required numeric power){
        if(arguments.power == 0){
            return 1;
        } 
        return arguments.base * pow(arguments.base, --arguments.power);
    }


    /* Add a simple array to an xml node, expects simple types */
    public any function addArrayToXmlNode(arr, rootNode, parentNode, childName, value){
        for(var i = 1; arrayLen(arr) > 0 && i <= arrayLen(arr); i++){
            parentNode.XmlChildren[i] = xmlElemNew(rootNode, childName);
            parentNode.XmlChildren[i].XmlText = arr[i].find(value);
        }
        return parentNode;
    }


    /*  Creates an xml doc with an array of structs converted to a single xml node with children
        arrOfStructToXml(arrOfStruct, 'response', 'vehicles', vehicle', {'_id': 'ID', 'config': 'style'}); 
    */
    public any function arrOfStructToXml(arrOfStruct, docName, nodeName, childName, keyAdjustments = {}){
        var myDoc = xmlNew();
        myDoc.xmlRoot = xmlElemNew(myDoc, docName);
        myDoc.docName.XmlChildren[1] = XmlElemNew(myDoc, nodeName);

        for(var i = 1; i <= arrayLen(arrOfStruct); i++){
            myDoc.response.nodeName.XmlChildren[i] = xmlElemNew(myDoc, childName);
            var j = 1;
            for(var key in arrOfStruct[i]){
                for(var adjustment in keyAdjustments){
                    if(adjustment == key){
                        key = adjustment;
                    }
                }
                myDoc.docName.nodeName.xmlChildren[i].xmlChildren[j] = xmlElemNew(myDoc, key);
                if(!isArray(arrOfStruct[i][key])){
                    myDoc.docName.nodeName.xmlChildren[i].xmlChildren[j].XmlText = arrOfStruct[i][key];
                }
                j++;
            }
        }
        return myDoc;
    }


    /* Convert Xml to array of structs based on keyPairs struct given
        xmlToArrayOfStructs(myXmlDoc, 'Vehicles', 'Vehicle', {'employeeID': 'ID', 'testAmount':'amount'});
    */
    public array function xmlToArrayOfStructs(xml, arrName, elemName, keyPairs){
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
    public string function buildQueryString(queryParams = '', url = ''){
        for(var key in queryParams){
            if(queryParams[key] != ''){
                url &= ((url == '') ? '?' & key & '=' & queryParams[key] : '&' & key & '=' & queryParams[key]);
            }
        }
        return url;
    }
    

    /* Send HTTP requests
        var httpService = makeHttpService('GET', reqUrl, [{type='header' name='apiKey',
            value=config.apiKey }, {type='body', name='ID', value=ID }]);
        httpService.send().getPrefix().FileContent;
    */
    public http function makeHttpService(required string method, required string reqUrl, array params=[]){
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


    /* Search array of structs for a key, only goes one layer deep in the structs */
    public any function searchArrOfStruct(required array arrOfStruct, required string key){
        local.index = arrayFind(arguments.arrOfStruct.config.specs, function(s){
            return s.key == key;
        });
        if(local.index > 0 && structKeyExists(arguments.arrOfStruct[local.index], arguments.key)){
            return arguments.arrOfStruct[local.index][arguments.key];
        }
        return '';
    }


    /* Simple struct toString() */
    public string function stringifyStruct(required struct x){
        local.out = '';
        for(local.key in arguments.x){
            local.out &= local.key & ':' & arguments.x[local.key] & variables.newLine;
        }
        return local.out;
    }


    /* Display a string and replace specifed characters with html tags using options struct
        options = {   '{': '<b>', '}': '</b>'  }; 
    */
    public void function displayStringHtml(required string output, required string delimiter, struct options){
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
    

    /* Find duplicate id according to key in an array of structs */
    public boolean function foundDuplicateId(required array structArr, required string key){
        for(var i = 1; i <= arrayLen(structArr); i++){
            for(var j = (i+1); j <= arrayLen(structArr); j++){
                if(arrayIsDefined(structArr, i) && arrayIsDefined(structArr, j)){
                    if(structKeyExists(structArr[i], key) && structKeyExists(structArr[j], key) && structArr[i][key] == structArr[j][key]){
                        return true;
                    }   
                } else{
                    break;
                }
            }
        }
        return false;
    }
}