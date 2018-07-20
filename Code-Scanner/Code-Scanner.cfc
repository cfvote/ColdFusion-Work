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

        if(!arguments.options.outPath.find('.txt')){
            arguments.options.outPath = arguments.options.outPath & '.txt';
        }
        for(local.x = 1; local.x <= ArrayLen(arguments.options.scanTarget); local.x++){
            if(arguments.options.scanType == 'ColdFusion'){
                local.fileInfo = getFileInfo(arguments.options.scanTarget[local.x]);
                if(local.fileInfo.type EQ 'directory'){
                    local.dirList = directoryList(arguments.options.scanTarget[local.x], true, "path", "*.cfm|*.cfc");
                } else if(local.fileInfo.type EQ 'file'){
                    local.dirList.append(arguments.options.scanTarget[local.x]);
                } else{
                    return;
                }
                for(local.i = 1; local.i <= arrayLen(local.dirList); local.i++){
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
        arguments.line = replace(arguments.line, '/', '!');
        local.lineSplit = listToArray(arguments.line, " <>(){}[];");

        for(local.i = 1; local.i <= arrayLen(local.funcLabels); local.i++){
            local.findFunc = local.lineSplit.find(local.funcLabels[local.i]);
            if(local.findFunc > 0 && local.findFunc <= 3){
                for(local.j = 1; local.j <= arrayLen(local.accessTypes); local.j++){
                    if(!find('!', arguments.line)){
                        if(local.funcLabels[local.i] == 'cffunction'){
                            return arrayToList(local.lineSplit, " ");
                        } else{
                            return mid(arguments.line, 1, findOneOf('(', arguments.line)) & ')';
                        }
                    }
                }
                //writeOutput(arrayToList(local.lineSplit, " "));
            }
        }
        return '';
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