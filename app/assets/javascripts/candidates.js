// Sweet alert login page
$(document).ready(function() {
  $('#login').click(function(event){
    swal({
      title: "login",
      text: "<div class='btn-group'><a class='btn btn-default disabled'><i class='fa fa-github fa-2x' style='width:30px; height:32px'></i></a><a class='btn btn-default btn-lg' href='/auth/github' style='width:12em'> Sign in with Github</a></div>  <br /><br /><div class='btn-group'><a class='btn btn-info disabled'><i class='fa fa-twitter fa-2x' style='width:30px; height:32px'></i></a><a class='btn btn-info btn-lg' href='/auth/twitter' style='width:12em'> Sign in with Twitter</a></div>",
      confirmButtonText: "cancel",
      confirmButtonColor: "gray",
      html: true
    });
  });
});