/* This file provides various helper functions that help
 * with lectures. This parses /harmonogram.json in order
 * to provide useful information.
 */

 function loadHarmonogram() {
    var req = new XMLHttpRequest();
    req.responseType = 'json';
    req.open('GET', "/harmonogram.js", true);
    req.onload  = function() {
       var jsonResponse = req.response;
       return jsonResponse;
    };
    req.send(null);
 }
