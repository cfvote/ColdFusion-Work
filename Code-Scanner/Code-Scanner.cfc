component 
    displayName="Code-Scanner" 
    hint="Scan directories/files for functions and display html and/or write to text file"{

    /*options = {
        scanType: 'ColdFusion',
        outPath: 'c:\source\cfmx\wwwroot\test\barrett\test,
        scanTarget: [
            'c:\source\cfmx\wwwroot\test\barrett\',
            'c:\source\cfmx\wwwroot\test\index.cfm',
            'c:\source\cfmx\wwwroot\agents\business\quote\ac\display.cfc'
        ],
        excludeContaining: [
            '_combined'
        ]
        showHtml: true
    }*/

    public function init(){
        variables.newLine = Chr(13) & Chr(10);
        variables.divider = repeatString("-", 75);
        return this;
    }

    public any function scan(required struct options){
        local.scanResults = arrayNew(1);
        local.dirList = arrayNew(1);
        local.extensions = "";
        if(!arguments.options.outPath.find('.txt')){
            arguments.options.outPath = arguments.options.outPath & '.txt';
        }
        switch(uCase(arguments.options.scanType)){
            case 'CF':  case 'COLDFUSION':  local.extensions = "*.cfm|*.cfc";   break;
            case 'JS':  case 'JAVASCRIPT':  local.extensions = "*.js";          break;
            default:    return;
        }
        for(local.x = 1; local.x <= ArrayLen(arguments.options.scanTarget); local.x++){
            local.fileInfo = getFileInfo(arguments.options.scanTarget[local.x]);
            if(local.fileInfo.type EQ 'directory'){
                local.dirList = directoryList(arguments.options.scanTarget[local.x], true, "path", local.extensions);
            } else if(local.fileInfo.type EQ 'file'){
                local.dirList.append(arguments.options.scanTarget[local.x]);
            } else{
                return;
            }
            for(local.i = 1; local.i <= arrayLen(local.dirList); local.i++){
                if(arrayLen(arguments.options.excludeContaining) > 0){
                    for(local.j = 1; local.j <= arrayLen(arguments.options.excludeContaining); local.j++){
                        if(!find(arguments.options.excludeContaining[local.j], local.dirList[local.i])){
                            local.scanResults.append(scanFile(local.dirList[i], arguments.options.showHtml));
                        }
                    }
                } else{
                    local.scanResults.append(scanFile(local.dirList[i], arguments.options.showHtml));
                }
            }
        }
        if(arguments.options.outPath != ''){
            local.outFile = fileOpen(options.outPath, 'write');
            for(local.result in local.scanResults){
                fileWriteLine(local.outFile, local.result.output);
            }
            fileClose(local.outFile);
        }
        return local.scanResults;
    }

    private any function scanFile(required string scanTarget, required boolean showHtml){
        local.file = fileOpen(arguments.scanTarget, 'read');
        local.resultsStruct = { 
            lineCount: 1, charCount: 0, funcCount: 0, target: arguments.scanTarget, functionArr: arrayNew(1), 
            output: "Scanning {#arguments.scanTarget#} #variables.newLine#"
        };

        while(NOT fileIsEOF(local.file)){
            local.line = trim(fileReadLine(local.file));
            local.func = findFunction(local.line);
            if(len(local.func) > 0){
                local.resultsStruct.functionArr.append(local.func);
                local.resultsStruct.funcCount++;
                local.resultsStruct.output = local.resultsStruct.output &
                    "         #numberFormat(local.resultsStruct.funcCount, '000')#). " &
                    "         Line: #numberFormat(local.resultsStruct.lineCount, '0000')#         " &
                    local.resultsStruct.functionArr[local.resultsStruct.funcCount] & variables.newLine;
            }
            local.resultsStruct.charCount += len(local.line);
            local.resultsStruct.lineCount++;
        }
        local.resultsStruct.output = local.resultsStruct.output &
            "Scanned {#local.resultsStruct.lineCount#} line(s), " &
            "{#local.resultsStruct.charCount#} character(s), and found " &
            "{#local.resultsStruct.funcCount#}"&" function(s)."&"#variables.newLine#" &
            "#variables.newLine##variables.divider##variables.newLine#";
        
        if(showHtml){
            displayHtml(local.resultsStruct.output);
        }
        fileClose(local.file);
        local.resultsStruct.functionArr = arrayToList(local.resultsStruct.functionArr);
        return local.resultsStruct;
    }

    private string function findFunction(required string line){
        local.funcLabels = ['function', 'cffunction'];
        local.accessTypes = ['public', 'private', 'remote'];
        arguments.line = trim(arguments.line);
        //if(preSplitCheck(arguments.line)){
            local.lineSplit = listToArray(arguments.line, " (){}<>");

            for(local.i = 1; local.i <= arrayLen(local.funcLabels); local.i++){
                local.findFunc = local.lineSplit.find(local.funcLabels[local.i]);
                if(local.findFunc > 0){
                    for(local.j = 1; local.j <= arrayLen(local.accessTypes); local.j++){
                        if(finalCheck(arguments.line)){
                            if(local.funcLabels[local.i] == 'cffunction'){
                                return arrayToList(local.lineSplit, " ");
                            } else{
                                local.func = mid(arguments.line, 1, findOneOf('(', arguments.line));
                                return (len(func) > 0) ? (func & ')') : '';
                            }
                        }
                    }
                }
            //}
        }
        return '';
    }

    private boolean function preSplitCheck(required string line){
        local.badPieces = [
            '.forEach', '.each(', '.then(', 'jQuery', '(function(', '.all',
            '.race', '.resolve','.reject', 'return function', 'console.'
        ];
        if(arguments.line == 'function(){'){
            return false;
        }
        local.hasFwdSlash = find('/', arguments.line);
        local.hasFunction = find('function', arguments.line);
        local.hasEqual = find('=', arguments.line);
        local.hasLeftParen = find('(', arguments.line);

        if(find(':', arguments.line)){
            local.tempSplit = listToArray(arguments.line, ':');
            if(arrayLen(local.tempSplit) < 3){
                return false;
            }
        }
        if(mid(arguments.line, 1, local.hasLeftParen) == 'function('){
            return false;
        }
        if(local.hasFwdSlash == 1){
            return false; //get rid of complete comments
        }
        if(local.hasFunction && local.hasFwdSlash && local.hasFwdSlash > local.hasFunction){
            return false; //get rid of comments
        }
        for(local.i = 1; local.i <= arrayLen(local.badPieces); local.i++){
            if(find(local.badPieces[local.i], arguments.line)){
                return false;
            }
        }
        return true;
    }

    private boolean function finalCheck(required string line){
        
        local.badChars = ['$', "'", '&', '!', '['];
        if(find('.', arguments.line) == 1){
            return false;   //get rid of JS .function() and ()
        }
        local.hasComma = find(',', arguments.line);
        local.hasQuote = find('"', arguments.line);
        local.hasColon = find(':', arguments.line);
        local.hasEqual = find('=', arguments.line);

        if(local.hasComma && local.hasColon < find('function', arguments.line)){
            return false;   //functions in structs
        }
        
        if(local.hasColon && local.hasQuote){
            return false;   //functions in structs
        }
        for(local.i = 1; local.i <= arrayLen(local.badChars); local.i++){
            if(find(local.badChars[local.i], arguments.line)){
                return false;
            }
        }
        return true;
    }

    private void function displayHtml(required string output){
        local.htmlOut = output.split(variables.newLine);
        for(var piece in htmlOut){
            local.piece = replace(local.piece, ' ', '&nbsp;', 'all');
            local.piece = replace(local.piece, '{', '<b>', 'all');
            local.piece = replace(local.piece, '}', '</b>', 'all');
            local.piece = replace(local.piece, variables.divider, '<hr />', 'all');
            writeOutput("#local.piece#<br />");   
        }
    }
}