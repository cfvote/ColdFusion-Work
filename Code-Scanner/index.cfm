<html>
    <body>
        <h2>Code Scanner Testing</h2>
        <br /> <br />
        <cfscript>
            local.scanner = createObject('component', 'Code-Scanner').init();
            local.basePath = 'c:\source\cfmx\wwwroot\test\barrett\'; 

            writeOutput('<h1>ColdFusion Test</h1>');
            local.scanOptions = {
                scanType: 'ColdFusion',
                outPath: local.basePath & 'Code-Scanner\resultsCF',
                scanTarget: [
                    'C:\source\cfmx\wwwroot\test\barrett\',
                    'C:\source\cfmx\wwwroot\agents\business\quote\',
                    'C:\source\cfmx\wwwroot\agents\business\quote\'
                ],
                excludeContaining: [],
                showHtml: true
            };
            local.scanner.scan(local.scanOptions);
            

            /*writeOutput('<h1>JavaScript Test</h1>');
            local.scanOptions = {
                scanType: 'Javascript',
                outPath: local.basePath & 'Code-Scanner\resultsJS',
                scanTarget: [
                    'C:\source\cfmx\wwwroot\javascript\goodville\quoting\',
                    'C:\source\cfmx\wwwroot\javascript\goodville\common'
                ],
                excludeContaining: [
                    '_combined'
                ],
                showHtml: true
            };
            local.scanner.scan(local.scanOptions);*/

        </cfscript>
    </body>
</html>