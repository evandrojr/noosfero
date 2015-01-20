var siteTourPlugin = (function() {

  var actions = [];
  var userData = {};

  function hasMark(name) {
    return jQuery.cookie("_noosfero_.sitetour." + name) ||
      jQuery.inArray(name, userData.site_tour_plugin_actions)>=0;
  }

  function mark(name) {
    jQuery.cookie("_noosfero_.sitetour." + name, 1, {expires: 365});
    if(userData.login) {
      jQuery.post('/plugin/site_tour/public/mark_action', {action_name: name}, function(data) { });
    }
  }

  function clearAll() {
    jQuery('.site-tour-plugin').removeAttr('data-intro data-intro-name data-step');
  }

  function configureIntro(force) {
    clearAll();
    for(var i=0; i<actions.length; i++) {
      var action = actions[i];

      if(force || !hasMark(action.name)) {
        var el = jQuery(action.selector).filter(function() {
          return jQuery(this).is(":visible") && jQuery(this).css('visibility') != 'hidden';
        });
        el.addClass('site-tour-plugin');
        el.attr('data-intro', action.text);
        el.attr('data-intro-name', action.name);
        if(action.step) {
          el.attr('data-step', action.step);
        }
      }
    }
  }

  return {
    add: function (name, selector, text, step) {
      actions.push({name: name, selector: selector, text: text, step: step});
    },
    start: function(data, force) {
      force = typeof force !== 'undefined' ? force : false;
      userData = data;

      var intro = introJs();
      intro.onafterchange(function(targetElement) {
        var name = jQuery(targetElement).attr('data-intro-name');
        mark(name);
      });
      configureIntro(force);
      intro.start();
    },
    force: function() {
      this.start({}, true);
    }
  }
})();

jQuery( document ).ready(function( $ ) {
  $(window).bind('userDataLoaded', function(event, data) {
    siteTourPlugin.start(data, jQuery.deparam.querystring()['siteTourPlugin']==='force');
  });
});
