// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui/draggable
//= require jquery-ui/droppable
//= require_tree .
//= require jquery.qtip
//= require jquery.tokeninput
//= require bootstrap/transition
//= require bootstrap/alert
//= require bootstrap/dropdown
//= require moment/moment-with-locales

$(document).ready(function () {
  // Replace default titles on images with link by qTip tooltips
  $('a [title!=""], a[title!=""], [data-content!=""], [data-title!=""]').each(function () {
    $(this).qtip({
      content: {
        text: $(this).data('content') || true,
        title: $(this).data('title') || false
      },
      style: {
        classes: 'qtip-todc-bootstrap',
        tip: {
          width: 12
        }
      },
      show: {
        solo: true
      },
      position: {
        adjust: {
          method: 'shift'
        },
        my: 'top center',
        at: 'bottom center',
        viewport: $(window)
      }
    })
  })
})
