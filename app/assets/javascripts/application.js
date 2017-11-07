// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require_tree .
//= require jquery.validate
//= require jquery-ui
//= require jquery.validate.additional-methods

$(document).ready(function(){

  // set the menu item to active
  routes = {
    '/': '#home',
    '/bootcampers': '#add_campers',
    '/bootcampers/edit': '#edit_campers',
    '/content_management': '#content_management',
    '/learner': '#my_profile',
    '/learning_outcomes': '#learning_outcomes',
    '/faqs': '#faqs',
    '/support': '#support'
  };

  Object.keys(routes).forEach(function(key) {
    if (key === window.location.pathname) {
      $(routes[key]).addClass('active');
    }
  });

  // create vof object
  window.vof = {}

  $(".button-collapse").sideNav();
});
