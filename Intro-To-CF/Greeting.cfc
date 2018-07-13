component{
    variables.baseGreeting = "Hello, ";

    public string function getFullName(String firstName){
        var fullName = arguments.firstName && arguments.lastName;
        return fullName;
    }

    public string function getGreeting (String firstName, String lastName){
        var fullName = getfullName(argumentCollection=arguments);
        var greeting = variables.baseGreeting & fullName;
        return greeting;
    }

}