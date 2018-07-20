<html>
    <body>
        <h2>Code Scanner</h2>
        <br /> <br />
        <cfscript>
            local.scanner = createObject('component', 'Code-Scanner').init();
            local.basePath = 'c:\source\cfmx\wwwroot\test\barrett\'; 
            local.scanOptions = {
                scanType: 'ColdFusion',
                outPath: local.basePath & 'Code-Scanner\results',
                scanTarget: [
                    //'c:\source\cfmx\wwwroot\test\barrett\'
                    'c:\source\cfmx\wwwroot\agents\business\quote\ac\display.cfc',
                    'c:\source\cfmx\wwwroot\agents\business\quote\bc\display.cfc',
                    'C:\source\cfmx\wwwroot\agents\business\quote\df\display.cfc',
                    'C:\source\cfmx\wwwroot\agents\business\quote\farm\display.cfc',
                    'C:\source\cfmx\wwwroot\agents\business\quote\home\display.cfc',
                    'C:\source\cfmx\wwwroot\agents\business\quote\personalauto\display.cfc',
                    'C:\source\cfmx\wwwroot\agents\business\quote\tc\display.cfc',
                    'C:\source\cfmx\wwwroot\agents\business\quote\up\display.cfc',
                    'C:\source\cfmx\wwwroot\agents\business\quote\wc\display.cfc'
                ],
                showHtml: true
            };
            local.scanner.scan(local.scanOptions);

        </cfscript>
    </body>
</html>