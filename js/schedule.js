/* This file provides various helper functions that help
 * with lectures. This parses /schedule.json in order
 * to provide useful information.
 */

 schedule = null;

 /* Load schedule from JSON file and store it into global variable */
 function loadSchedule() {
    var req = new XMLHttpRequest();
    req.responseType = 'json';
    req.open('GET', "https://prenoc.cz/schedule.json", true);
    req.onload  = function() {
       var jsonResponse = req.response;
       schedule = JSON.parse(jsonResponse);
    };
    req.send(null);
 }

 /* Get  */
 function getNextLectures() {

}
