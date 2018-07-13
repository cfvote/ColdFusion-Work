<html>
    <body>

    <!-- 
        An Attempt at 'Functional' notes to look back on 
        http://www.learncfinaweek.com/
        https://cfdocs.org/functions
    -->
    
        <cfset test = "This is a test" />
        <h1> <cfdump var = "#test#" /> </h1>
        

        <!-- Variables and Some Small Built in Functions: -->
        <hr />
        <cfdump var = "1 + 2" /> <br />
        <cfdump var = "#1 + 2#" /> <br />
        <cfdump var = "1 + 2 = #1 + 2#"/> <br />
        <cfset userBirthDate = "07/04/1996" />
        <cfdump var = "#userBirthDate#" />
        <cfset dateToday = "Today's date is: " />
        <cfset dateToday = dateToday & now() />  
        <br /> 
        <cfdump var = "#dateToday#"/>

        <br />
        <cfset dateToday = "Today is: #now()#" />
        <cfoutput>#dateToday#</cfoutput>

        <br /> <br />
        <cfset dateArray = [dateFormat(now(), "short"), dateFormat(dateadd('d', 1, now()), "short"), dateFormat(dateadd('d', 2, now()), "short")]/>
        <cfdump var = "#dateArray#" />

        <br /> <br />
        <cfset dateStruct = {today=dateFormat(now(), "short"), tomorrow=dateFormat(dateadd('d', 1, now()), "short"), later=dateFormat(dateadd('d', 2, now()), "short")} />
        <cfdump var = "#dateStruct#" />

        <br /> <br />
        <cfsavecontent variable="emailContent">
            This is a test paragraph
                using cfsavecontent
        </cfsavecontent>
        <cfoutput>#emailContent#</cfoutput>


        <!-- Arrays  NOTE: Indexing starts at 1, not 0 -->
        <hr />
        <cfset randomThings = ["This is a test", 42, now()] />
        <cfdump var = "#randomThings#" />
        
        <cfset anotherArray = ["Test", dateFormat(dateadd('d', 1, now()))] />
        <br /> <h4>Looping Array:</h4>
        <ul>
            <cfloop array=#anotherArray# index="i">
                <li><cfoutput>#i#</cfoutput></li>
            </cfloop>
        </ul>      


        <!-- Structs -->
        <hr />
        <cfset someStruct = structNew() />
        <cfset computerStruct = {} />
        <cfset computerStruct["cpu"] = "Intel i7 7700k" />
        <cfset computerStruct["gpu"] = "Nvidia GTX 1080" />
        <cfset computerStruct["ram"] = "Corsair Vengeance" />
        <cfdump var = "#computerStruct#" />

        <br />
        <cfloop collection="#computerStruct#" item="component">
            <cfoutput>#computerStruct[component]# --- #component# </cfoutput> <br/>
        </cfloop>


        <!-- Queries  (Commented out because there is no database)
            <cfquery name="computerQuery" dataSource = "component">
                SELECT name, price
                FROM computerStore
                WHERE price < 150
            </cfquery>
        -->


        <!-- 
            MISC NOTES:
                - http://localhost:8500/test/barrett/{filename}
                - Remember to start coldfusion! (c:/ColdFusion11/Barrett/bin/cfstart)
        -->
    </body>
</html>