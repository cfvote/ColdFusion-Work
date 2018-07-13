<html>
    <body>
    
        Function example: <br />
        <cffunction name="getFullName" output="false" access="public" returnType="string">
            <cfargument name="firstName" type="string" required="false" default ="" />
            <cfargument name="lastName" type="string" required="false" default ="" />

            <cfset fullName = arguments.firstName & " " & arguments.lastName />
            <cfreturn fullName />
        </cffunction>

        <cfset x = getFullName("Barrett", "Otte") />
        Full name is: <cfoutput>#x#</cfoutput> <br/>


        Using a component: <br />
        <cfset Greeting = CreateObject("Component", "MyFirstComponent.cfc") />
        <cfset myGreeting = Greeting.getGreeting(firstName="Barrett", lastName="Otte") />
        <cfoutput>#myGreeting#</cfoutput>


    </body>
</html>