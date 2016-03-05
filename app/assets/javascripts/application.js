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
//= require metrics-graphics-rails
//= require jquery_ujs
//= require jquery-ui
//= require handlebars
//= require mustache
//= require stream_table
//= require stream_sorting
//= require sweetalert
//= require candidates
//= require_tree .
  
// Flash notification fade in and out
$(function() {
   $('.flash').delay(500).fadeIn('normal', function() {
      $(this).delay(2500).fadeOut();
   });
});

