
<!-- This file will be a reference to anything weird/unique with ColdFusion that I should remember -->
<!-- Most of this will be typing syntax, like learning any other language -->

<html>
    <body>

    <cfset stringVar = 'testing'/>
    The string { <cfdump var = '#stringVar#'> } is <cfdump var = '#len(stringVar)#'> characters long. <br />

    <!-- <cfset nullVar = ""/>  NOPE -->
    <!-- <cfset nullVar = {} /> NOPE -->
    <cfset nullVar = javacast("null", 0) />
    Is the null variable null? :  <cfoutput> #isNull(nullVar)# </cfoutput> <br />

    <cfset someArray = [1, 2, 3, 4, 5] />
    <cfdump var = '#someArray#'> This array is length <cfoutput> #arrayLen(someArray)# </cfoutput> <br />

    <cfset num1 = 1 />
    Is num1 = 1 ? 
    <cfif num1 EQ 1>
        Yes it is. 
    <cfelse>
        No it is not.
    </cfif>
    <br />

    <!-- 
        ==          IS, EQUAL, EQ
        !=          IS NOT, NOT EQUAL, NEQ
        >, >= ...   GT, LT, GTE, LTE
    -->

    <cfset switchVar = 'Tuesday'>
    <cfswitch expression='#switchVar#'>
        <cfcase value="Monday">
            Something something something
        </cfcase>
        <cfcase  value="Tuesday"> 
            It is <cfoutput>#switchVar#</cfoutput> Neat
        </cfcase>
        <cfdefaultcase>
            The default case
        </cfdefaultcase>
    </cfswitch>
    <br />

    <cfset switchVar2 = 2/>
    <cfswitch expression='#switchVar2#'>
        <cfcase value="1$2$3" delimiters="$">
            The value is either 1, 2, or 3.
        </cfcase>
        <cfdefaultcase>
            The value was not 1, 2, or 3.
        </cfdefaultcase>
    </cfswitch>
    <br />

    <cfscript>
        x = 4;
        y = (x == 4) ? 12345 : 67890;
        writeOutput(y);
    </cfscript>
    <br />

    <cfloop from="0" to="10" index="i">
        <cfoutput>#i#^2 = #i^2# </cfoutput><br />
    </cfloop>
    <br />

    <cfset myArray= ['asd', 'qwe', 'zxc', 'rty']/>
    Some random keys:
    <ul>
        <cfloop array='#myArray#' index='x'>
            <li><cfoutput>#x#</cfoutput></li>
        </cfloop>
    </ul>
    <br />

    <cfset testStruct = { name='Barrett Otte', id=12345, dob='07/04/1996'} />
    <cfloop collection="#testStruct#" item="key">
        <cfoutput>#key#: #testStruct[key]#<br /> </cfoutput>
    </cfloop>
    <br />

    cfscript loop over struct test: <br />
    <cfscript>
        for(key in testStruct){
            writeOutput('#key#: #testStruct[key]# <br />');
        }    
    </cfscript>
    <br />


    Create JSON string from struct:
    <cfset someStruct = {
        items: {
            item1: {name: 'something', price: 123},
            item2: {name: 'asdfgh', price: 11111},
            item3: {name: 'qweqweqwe', price: 8989}
        },
        users: {    
            user1: {id: 1, email: 'test@test.com'},
            user2: {id: 123, email: 'barrettotte@gmail.com'},
            user3: {id: 456, email: '123@test.com'}
        }
    }/>
    <cfset someJSONVar = serializeJSON(someStruct)/> <br />
    <cfdump var='#someJSONVar#' />

    



    </body>
</html>