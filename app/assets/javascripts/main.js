// this is main js
 var currentpupp = 0
 var draftedpupps = []
           var arrofpicarrays = []
          var arrofpicsindexes = []

 $(document).ready( function() {


    var timeout
    var timeouttran
         $('#div-arr-left').addClass('no_op')
 var  pupimagesdivs = $('#puppy_pics_caroussel').children()
 var  pupsheetdivs = $('#puppy_sheet_caroussel').children()
       $(pupimagesdivs[currentpupp]).removeClass('hidden')
       $(pupsheetdivs[currentpupp]).removeClass('hidden')
       $(pupimagesdivs[currentpupp]).addClass('animated fadeInLeft')
       $(pupsheetdivs[currentpupp]).addClass('animated fadeInLeft') 
     //  $(pupimagesdivs[currentpupp]).show();
     /* 
                 // fadeIn   fadeOut
     */ 


    function ajaxeditdraft() { 

      var p1,p2,p3
      draftedpupps[0] == undefined ? p1 = -1 : p1 = draftedpupps[0]
      draftedpupps[1] == undefined ? p2 = -1 : p2 = draftedpupps[1]
      draftedpupps[2] == undefined ? p3 = -1 : p3 = draftedpupps[2]


    
$.ajax( {
    type :"POST", 
    async :true, 
    url : '/editteam.json',
    dataType: 'json',
    contentType: "application/json; charset=utf-8",
    data: JSON.stringify( { team : { pup1: p1, pup2: p2, pup3: p3, user_id: $('#user_id').html() } }) ,
    success: function(data) {  
          if (data.id) {
            console.log('updated ok')
             arrange_thumbs()
            }
          else 
         {   
             console.log('updated not ok')
            }
               },
    error: function(error) {
                console.log('updated not ok')
                }
        });  

}



 
  function changeslide() {
      clearTimeout(timeouttran);
        var  imagediv = $(pupimagesdivs[currentpupp])  
        var imageelements = $(imagediv).children(0)
        var picindex =  arrofpicsindexes[currentpupp]  
        var nextpicarray = arrofpicarrays[currentpupp]
      //  console.log(nextpicarray + " >>> currentpicindex >>>" + arrofpicsindexes[currentpupp]) 
        var imageelement = imageelements[picindex]
        $(imageelement).animate({opacity:0}, 600);

    timeouttran =    setTimeout(function(){  
    
    var nextpicindex = arrofpicsindexes[currentpupp]
         picindex >= nextpicarray.length - 1 ? nextpicindex = 0 : nextpicindex++
        arrofpicsindexes[currentpupp] = nextpicindex
       // console.log('nextpicindex ' + nextpicindex + ' >>> nextpic >>>' + nextpicarray[nextpicindex] )
       imageelement = imageelements[nextpicindex]
        $(imageelement).animate({opacity:1}, 600);
   }, 150);
    timeout =    setTimeout(function(){ changeslide(); }, 3000);
      
  }
      
$('#see_all_link').on('click', function() { 

    "http://"+window.location.hostname +'/edit?pps=' + draftedpupps[0] + '-' + draftedpupps[1] + '-' + draftedpupps[2]; 

})

  $('#prev').on('click',previouspupp)  
  $('#next').on('click', nextpupp)      
  $('#done_draft').on('click', createteam) 
function previouspupp() {

       clearTimeout(timeout);
    timeout =    setTimeout(function(){ changeslide(); }, 3000);
      
       if(currentpupp > 0) {
       
       	console.log('prev')
       $(pupimagesdivs[currentpupp]).addClass('animated fadeOutLeft');
       $(pupsheetdivs[currentpupp]).addClass('animated fadeOutLeft');
       $(pupimagesdivs[currentpupp]).one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', function(e) { removeClass(pupimagesdivs[currentpupp], 'prev') } );
      } 

      if(currentpupp > 1) {
         $('#div-arr-left').addClass('full_op')
         $('#div-arr-right').addClass('full_op')
          $('#div-arr-left').removeClass('no_op')
         $('#div-arr-right').removeClass('no_op')
         
      }
      else {         
         $('#div-arr-left').addClass('no_op')
         $('#div-arr-left').removeClass('full_op')          
       }
    
}

function nextpupp() { 


       clearTimeout(timeout);
    timeout =    setTimeout(function(){ changeslide(); }, 3000);
        
       if(currentpupp < pupimagesdivs.length-1) {
        console.log('next')
        
       $(pupimagesdivs[currentpupp]).addClass('animated fadeOutRight');
       $(pupsheetdivs[currentpupp]).addClass('animated fadeOutRight');	
       $(pupimagesdivs[currentpupp]).one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', function(e) { removeClass(pupimagesdivs[currentpupp], 'next')} );
      }

      if (currentpupp < pupimagesdivs.length-2) {

        $('#div-arr-right').addClass('full_op')
         $('#div-arr-left').addClass('full_op')
          $('#div-arr-right').removeClass('no_op')
         $('#div-arr-left').removeClass('no_op')
      }
      else { 
        $('#div-arr-right').addClass('no_op')
        $('#div-arr-right').removeClass('full_op')
       

      }
}
 
function removeClass(el, prevnext) { 
         
         console.log('removeClass---> currentpupp: ' + currentpupp);
             $(pupsheetdivs[currentpupp]).addClass('hidden')
             $(pupimagesdivs[currentpupp]).addClass('hidden')
             $(pupimagesdivs[currentpupp]).removeClass('animated fadeInLeft fadeInRight fadeOutLeft fadeOutRight shown');
             $(pupsheetdivs[currentpupp]).removeClass('animated fadeInLeft fadeInRight fadeOutLeft fadeOutRight shown');
       
      if (prevnext == 'prev') {   
            currentpupp--
            if (currentpupp < 0) { currentpupp = 0; } 
            console.log('removeClass---> nextpupp: ' + currentpupp);
            $(pupsheetdivs[currentpupp]).removeClass('animated fadeOutLeft fadeOutRight hidden');
            $(pupimagesdivs[currentpupp]).removeClass('animated fadeOutLeft fadeOutRight hidden');
            $(pupimagesdivs[currentpupp]).addClass('animated fadeInRight shown')
            $(pupsheetdivs[currentpupp]).addClass('animated fadeInRight shown')
                   }
      else  { 
            currentpupp++ 
            if(currentpupp > pupimagesdivs.length-1) { currentpupp = pupimagesdivs.length-1 } 
            console.log('removeClass---> nextpupp: ' + currentpupp);
            $(pupsheetdivs[currentpupp]).removeClass('animated fadeOutLeft fadeOutRight hidden');
            $(pupimagesdivs[currentpupp]).removeClass('animated fadeOutLeft fadeOutRight hidden');
            $(pupimagesdivs[currentpupp]).addClass('animated fadeInLeft shown')
            $(pupsheetdivs[currentpupp]).addClass('animated fadeInLeft shown')
       }                 
}


	$(document).on('keydown', function(evt) {
		if (evt.keyCode == 37) {
			previouspupp();
		}
		if (evt.keyCode == 39) {
			nextpupp();
		}
	 })

 $('.draftbutton').on('click', function () { 
   var pup_id = $(this).attr('id');

   draft_controller(pup_id, this)
});  

           

 function draft_controller(pup_id, el) { 
     pid = parseInt(pup_id)
  console.log('pupp to add: ' + pup_id + ' indexOf>>> ' + draftedpupps.indexOf(pid) )

  if (draftedpupps.length <= 3 && draftedpupps.indexOf(pid) == -1 ) 
      {  
      draftedpupps.push(pid)
      arrange_thumbs()
      ajaxeditdraft()
      var lefttochoose = 3 - draftedpupps.length
      $('#choosemore').html('Choose ' + lefttochoose + ' more')     
      }
 }


 function remove_pupp(pup_id) { 
   if (draftedpupps.indexOf(pup_id) > -1) {
    $( '#remove_div_'+ draftedpupps.length ).off();
    draftedpupps.splice( draftedpupps.indexOf(pup_id) ,1)
    arrange_thumbs()
     var lefttochoose = 3 - draftedpupps.length
      $('#choosemore').html('choose ' + lefttochoose + ' more')
      }    
      ajaxeditdraft()           
  }

function createteam() { 
    $('#done_draft').off()
$.ajax( {
    type :"POST", 
    async :true, 
    url : '/createteam.json',
    dataType: 'json',
    contentType: "application/json; charset=utf-8",
    data: JSON.stringify( { team : { TEAM_NAME : 'MyTeam', TEAM_DESCRIPTION: 'd', pup1: draftedpupps[0], pup2: draftedpupps[1], pup3: draftedpupps[2], user_id: $('#user_id').html() } }) ,
    success: function(data) {  
          if (data.action == 'create') {
             window.location.href = "/vote?tid="+data.id;   
            }
          else 
         {   
              window.location.href = "/created?tid="+data.id;
            }
               },
    error: function(error) {
               $('#done_draft').on('click', createteam) 
                }
        });  
}


 function arrange_thumbs() { 
  console.log('length of draftedpupps: ' +  draftedpupps.length )
    var i = 0

    if(draftedpupps.length == 3 && draftedpupps[0] > -1 && draftedpupps[1] > -1 && draftedpupps[2] > -1 ) {
     $('#done_draft').removeClass('no_op')  
    $('#done_draft').addClass('animated fadeInDown')

    }
    else {
       $('#done_draft').removeClass('animated fadeInDown')
       $('#done_draft').addClass('no_op')
    }

    $.each( draftedpupps, function(index, pupp) {
      if(pupp > -1) {
     var k  = i + 1
     console.log(' NAME OF DRAFTED PUPP: '+  $('#name_'+ pupp));
     $('#pupp_thumb_name_'+ k).html( $('#name_'+pupp).html() )
     $('#pupp_thumb_'+ k ).attr('src', '/assets/' + $('#thumb_'+pupp).html())
     $('#remove_div_'+ k ).attr('puppid', pupp )
     $('#remove_div_'+ k ).addClass('drafted') 
     $('#thumb_div_'+ k ).addClass('thumb-chosen-team') 
     $('#thumb_div_'+ k ).removeClass('thumb-empty')
     $('#remove_div_'+k).off()
     $('#remove_div_'+k).on('mouseenter', function () { 
      // console.log('mouseenter')
      $(this).removeClass('no_op');
      $(this).addClass('full_op');
      });

     $('#remove_div_'+k).on('mouseleave', function () { 
    // console.log('mouseout')
     $(this).addClass('no_op');
     $(this).removeClass('full_op');
    });

    $('#remove_div_'+k).on('click', function () { 
  //  console.log('mouseout')
    remove_pupp(pupp)
    });      
    i++;
    }
    })

     for (i ; i < 3; i++) {
      var k = i + 1
      console.log('removing PUPP:' + k);
     $('#pupp_thumb_name_'+ k).html('')
     $('#pupp_thumb_'+ k).attr('src', '/assets/empty_pupp.jpg' ) 
      $('#remove_div_'+ k ).attr('puppid', '' )
     $('#remove_div_'+ k ).removeClass('drafted shown')
      $('#remove_div_'+ k ).addClass('no_op')
       $('#thumb_div_'+ k ).removeClass('thumb-chosen-team') 
     $('#thumb_div_'+ k ).addClass('thumb-empty')
  }
 }
//alert(window.location.pathname)
 if (window.location.pathname == "/draft" )
{ clearTimeout(timeout);
  timeout =    setTimeout(function(){ changeslide(); }, 3000); }

  arrange_thumbs()
 
 });