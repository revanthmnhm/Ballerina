// Copyright (c) 2018 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied. See the License for the
// specific language governing permissions and limitations
// under the License.

package TravelAgency.AirlineReservation;

import ballerina.net.http;

// Available flight classes
const string ECONOMY = "Economy";
const string BUSINESS = "Business";
const string FIRST = "First";

// Service endpoint
endpoint http:ServiceEndpoint airlineEP {
port:9091
};

// Airline reservation service to reserve airline tickets
@http:serviceConfig { basePath:"/airline"}
service<http: Service > airlineReservationService bind airlineEP {

    // Resource to reserve a ticket
    @http:resourceConfig {methods:["POST"], path:"/reserve", consumes:["application/json"],
                          produces:["application/json"]}
reserveTicket (endpoint client, http:Request request) {
http:Response response = {};
json name;
json arrivalDate;
json departDate;
json preferredClass;

        // Try parsing the JSON payload from the request
var payload, entityErr = request.getJsonPayload();
if(payload != null) {
   name = payload.Name;
arrivalDate = payload.ArrivalDate;
                      departDate = payload.DepartureDate;
preferredClass = payload.Preference;
                         }

        // If payload parsing fails, send a "Bad Request" message as the response
                         if ( entityErr != null || name == null || arrivalDate == null || departDate == null || preferredClass == null) {
            response.statusCode = 400;
            response.setJsonPayload({"Message":"Bad Request - Invalid Payload"});
_ = client -> respond( response);
            return;
        }

        // Mock logic
        // If request is for an available flight class, send a reservation successful status
        string preferredClassStr = preferredClass.toString().trim();
        if (preferredClassStr.equalsIgnoreCase(ECONOMY) || preferredClassStr.equalsIgnoreCase(BUSINESS) ||
            preferredClassStr.equalsIgnoreCase(FIRST)) {
            response.setJsonPayload({"Status":"Success"});
        }
        else {
            // If request is not for an available flight class, send a reservation failure status
            response.setJsonPayload({"Status":"Failed"});
        }
        // Send the response
                     _ = client-> respond( response);
    }
}
