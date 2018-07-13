<!---Testing file for upgrading Penton vehicle lookup API to new Restful version from old SOAP version--->

<cfscript> 

    config = createobject('component','goodville.config').init(xmlparse(expandpath('/environment/agentssite.xml')));
    newPentonConnector = createObject('component', 'goodville.gateway.vehicle.penton.PentonRestConnector').init(config);
    oldPentonConnector = createObject('component', 'goodville.gateway.vehicle.penton.PentonConnector').init(config);
    //utils = createObject('component', 'Barrett-Utils');

    year = '2012';
    //make = 'KENWORTH';
    make = 'HYUNDAI';
    //model = 'W900';
    model = '';
    //vin = '1M2P267C5RM021388';      //Just made today with new Penton API
    //vin = '3GNAL2EK9CS592441';      //Grabs cache from old Penton API
    vin = '1G2ZG57N994149566';
    truckBody = 'Light Duty';
    //quoteId = '14A6F065-A0C7-4580-88AC-ECB1E3A39D2A';
    quoteId = '40B6ACA4-0680-4385-9CD5-03498AC8C2F6';
    

    // Test Old Penton Connector
        vinResponse = oldPentonConnector.getVehInfoFromVin(vin);
        ymmResponse = oldPentonConnector.getVehInfoFromYearMakeModel(year, make, model, '');
        tbResponse = oldPentonConnector.getVehInfoFromTruckBody(year, truckBody);
        writeDump(vinResponse);
        writeDump(ymmResponse.response);
        writeDump(tbResponse);
    
    //Test New Penton Connector
        vinResponse = newPentonConnector.getVehInfoFromVin(vin);
        ymmResponse = newPentonConnector.getVehInfoFromYearMakeModel(year, make, model, '');
        tbResponse = newPentonConnector.getVehInfoFromTruckBody(year, truckBody);
        writeDump('-------PentonRestConnector.getVinInfoFromVin()-------------');
        writeDump(vinResponse);
        writeDump('-------PentonRestConnector.getVinInfoFromYearMakeModel()-------------');
        writeDump(ymmResponse);
        writeDump(tbResponse);
    
    //Test Commercial Vehicle Lookup
        cvl = createObject('component', 'goodville.gateway.vinmaster.CommercialVehicleLookup').init(config);

        cvlResponse = cvl.getVehInfoFromVIN(vin);
        writeDump('-------getVinInfoFromVin()-------------');
        writeDump(cvlResponse);
        cvlResponse = cvl.getVehInfoFromYearMakeModel(year, make, model, quoteId, '', ''); // (year, make, model, quoteId, returnType, filterType)
        //cvlResponse = cvl.getVehInfoFromYearMakeModel('2010', '', '', quoteId, '', '');
        writeDump('-------getVehInfoFromYearMakeModel(year)-------------');
        writeDump(cvlResponse);
        
        cvlResponse = cvl.getVehInfoFromTruckBody(year, truckBody, quoteId);
        writeDump('--------getVehInfoFromTruckyBody() ------------');
        writeDump(cvlResponse);
</cfscript>