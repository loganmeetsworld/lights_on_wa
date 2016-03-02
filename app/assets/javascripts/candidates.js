// Flash notification fade in and out
$(function() {
   $('.flash').delay(500).fadeIn('normal', function() {
      $(this).delay(2500).fadeOut();
   });
});

// Sweet alert login page
$(document).ready(function() {
  $('#login').click(function(event){
    swal({
      title: "LOGIN TO SAVE CANDIDATES",
      text: "<div class='btn-group'><a class='btn btn-default disabled'><i class='fa fa-github fa-2x' style='width:30px; height:32px'></i></a><a class='btn btn-default btn-lg' href='/auth/github' style='width:12em'> Sign in with Github</a></div>  <br /><br /><div class='btn-group'><a class='btn btn-info disabled'><i class='fa fa-twitter fa-2x' style='width:30px; height:32px'></i></a><a class='btn btn-info btn-lg' href='/auth/twitter' style='width:12em'> Sign in with Twitter</a></div>",
      confirmButtonText: "No thanks!",
      confirmButtonColor: "gray",
      html: true
    });
  });
});