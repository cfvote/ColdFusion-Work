component displayName="Barretts Snippets" hint="Some random snippets since CF has awful syntax a lot of the time" {


    /*********** Creating stored procedure object and getting results ***********/
    var sp = new storedproc();
    sp.setDatasource("<some database>");
    sp.setProcedure("<some stored procedure>");
    sp.addParam(type="IN", cfsqltype="CF_SQL_INTEGER", value="<#someInteger#>", dbvarname="<some_col>");
    sp.addParam(type="IN", cfsqltype="CF_SQL_VARCHAR", value="<#someString#>", dbvarname="<some_other_col>");
    sp.addProcResult(name="result", resultSet=1);
    var results = sp.execute();
    var resultSets = results.getProcResultsSets().result;


    /*********** Creating a Query object and calling a user-defined function ***********/
    var someQuery = new query();
    someQuery.setDatasource("<some database>");
    someQuery.addParam(cfsqltype="CF_SQL_CHAR", value="<#someChar#>", name="<some_col>", maxlength=6);
    someQuery.addParam(cfsqltype="CF_SQL_DATE", value="<#someDate#>", name="<some_other_col>");
    var result = someQuery.execute(sql="
        VALUES some_UDF( (:<some_col>), (:<some_other_col>) )
    ").getResult();


    /*********** XXX ***********/
    
}