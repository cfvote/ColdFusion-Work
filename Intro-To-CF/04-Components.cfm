
<!-- Introduction to CF components -->
<html>
    <body>
        <cfset componentDir = '#getDirectoryFromPath(getCurrentTemplatePath())#'/>
        <cfscript>
            Greeting = createObject("component", "Greeting.cfc");
            myGreeting = Greeting.getGreeting(firstName="Barrett", lastName="Otte");
            writeOutput(myGreeting);
        </cfscript>
    </body>
</html>