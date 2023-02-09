     $(document).ready(function() { 
     
   

     })
        // date variables
        
 
 
var date = new Date('Sun Feb 01 2015 15:00:00 GMT-0500 (Eastern Standard Time)');
var dateend =  new Date('Sun Feb 01 2015 17:00:00 GMT-0500 (Eastern Standard Time)');
 
var twoHoursLater = new Date(date + (2*1000*60*60));
today = date.toISOString();
twoHoursLater = dateend.toISOString();
 var clientId = '231062827654-hecn35dme222nr01p4eog5e4m1rsuitp.apps.googleusercontent.com'; //   199698256183-38o5k7lhr0h6bdft89pdut120cfncqhe.apps.googleusercontent.com;
 var apiKey =   'AIzaSyD1VHHYzAHxTJwNkYHzpPGatqPaqkeAIUQ'; //   AIzaSyCcBXkJ4EQRnflT_HReo9srvht8XVViA-I
 var scopes =   'https://www.googleapis.com/auth/calendar';
 
 
// Oauth2 functions
function handleClientLoad() {
gapi.client.setApiKey(apiKey);  
window.setTimeout(checkAuth,1);
}
 
function checkAuth() {
gapi.auth.authorize({client_id: clientId, scope: scopes, immediate: true}, handleAuthResult);
}
 


function signInCallback(authResult) {
   
}
 var alreadyclicked = 0;
// show/hide the 'authorize' button, depending on application state

function handleAuthResult(authResult) {
   $('#google-calendar').off()

if (authResult && !authResult.error) {
      
  if (alreadyclicked==1) { 
getAvailableCalendars()  
  }

  console.log('registering getAvailableCalendars')
 $('#google-calendar').on('click', function() { 

      getAvailableCalendars()     })

  } else { // otherwise, show button
// authorizeButton.style.visibility = 'visible';
//resultPanel.className += ' panel-danger'; // make panel red
 if (authResult.error == 'immediate_failed') {
       console.log('registering authentication')

console.log(authResult.error)
   $('#google-calendar').on('click', function() { 

      handleAuthClick()
      alreadyclicked = 1;
    /*  console.log('authorizing')               
  var additionalParams = {  'clientid' : clientId,
                            'cookiepolicy' : 'single_host_origin',
                            'callback' : handleAuthClick
                             };
      gapi.auth.signIn(additionalParams);  // Will use page level configuration  
  */
            })
  }

    else {
           console.log('authentication failed.....')

  $('#google-calendar').on('click', function(event) { 
       console.log('registering handleclientload')
       alreadyclicked = 1;
       handleClientLoad()
            })
}
// handleAuthClick(e) // setup function to handle button click
}
}
// function triggered when user authorizes app
function handleAuthClick(event) {
  console.log('handling auth click')
gapi.auth.authorize({client_id: clientId, scope: scopes, immediate: false}, handleAuthResult);
return false;
}

// setup event details
var resource = {
"summary": "Puppy Bowl XI",
"start": {
"dateTime": today
},
"end": {
"dateTime": twoHoursLater
}
};

// function load the calendar api and make the api call
function makeApiCall(calendarID) {
gapi.client.load('calendar', 'v3', function() { // load the calendar api (version 3)
var request = gapi.client.calendar.events.insert({
'calendarId': calendarID, // calendar ID
"resource": resource // pass event details with api call
});
// handle the response from our api call
request.execute(function(resp) {
  temp = $('#events').html()
  $('#events').html('<div style="margin-top:25px"><img src="/assets/loader.png"/></div>')

if(resp.status=='confirmed') {
document.getElementById('events').innerHTML = "<div style='padding-top:25px;padding-bottom:25px'><span class='puppy-name'>Event created successfully</span></div>";
} else {

if(resp.message=='Forbidden') {
document.getElementById('events').innerHTML = temp;
alert('you do not have right to add events in this calendar. Try another one')

}
else { 
document.getElementById('events').innerHTML = temp;

}

 }
console.log(resp);
});
});
}


function getAvailableCalendars() {
      alreadyclicked = 0;
      gapi.client.load('calendar', 'v3', function() {
        var request = gapi.client.calendar.calendarList.list();
        request.execute(function(resp) {
            var mydiv = document.createElement('div');
            mydiv.innerHTML = '<span class="puppy-name">Choose a calendar to insert the event:</span><br />'
          for (var i = 0; i < resp.items.length; i++) {
//            console.log(JSON.stringify(resp.items[i]))
            var calendarID = resp.items[i].id;
            var calendarSummary = resp.items[i].summary;
            var a = document.createElement('a');
            a.title = calendarSummary;
            a.innerHTML += a.title + '<br />';
            $(a).addClass('pupinfo-white')
            $(a).addClass('calendar')

            a.href="javascript:makeApiCall('"+calendarID+"')";
            mydiv.appendChild(a);
           
          } 
            console.log(mydiv) 
            $('#events').html(mydiv);
            $('#myModal').modal('show')
        });
      });
    }

    function alrt() {   alert('under construction. Should be over by EOD')} 
