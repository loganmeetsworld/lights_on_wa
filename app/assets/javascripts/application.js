// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//

//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require handlebars
//= require mustache
//= require stream_table
//= require stream_sorting
//= require sweetalert
//= require_tree .

$(function() {
   $('.flash').delay(500).fadeIn('normal', function() {
      $(this).delay(2500).fadeOut();
   });
});

var Candidates = function() {
};

Candidates.prototype.loginAlert = function(){
  swal({
    title: "Login to save candidates.",
    text: "<div class='btn-group'><a class='btn btn-default disabled'><i class='fa fa-github fa-2x' style='width:30px; height:32px'></i></a><a class='btn btn-default btn-lg' href='/auth/github' style='width:12em'> Sign in with Github</a></div>  <br /><br /><div class='btn-group'><a class='btn btn-info disabled'><i class='fa fa-twitter fa-2x' style='width:30px; height:32px'></i></a><a class='btn btn-info btn-lg' href='/auth/twitter' style='width:12em'> Sign in with Twitter</a></div>",
    html: true,
  }, function() {
      window.location.reload();
  });
};

$(document).ready(function() {
  var candidates = new Candidates();
  $('#login').click(function(event){
    candidates.loginAlert();
  });
});