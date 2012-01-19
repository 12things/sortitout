// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
document.observe("dom:loaded", function(event) {
  if($('posts')) { new Post(); }
  if($('carbon')) { new Carbon(); }
  if($('notice')) { $('notice').fade({duration: 0.5, delay: 10}); }
});

var Post = Class.create({
  initialize: function() {
    this.submitting = false;
    this.input = $('post_original_body');
    
    document.on("click", 'a.reply', function(event, el) {
      this.input.setValue("@"+el.getAttribute("data-post-id")+" ");
      this.input.focus();
      event.stop();
    }.bind(this));
    
    document.on("click", '#new-posts-bar', function(event, el) {
      new Ajax.Request(el.getAttribute("data-href-refresh"));
      event.stop();      
    });
    
    document.on("click", 'a.vote', function(event, el) {
      new Ajax.Request(el.getAttribute("href"));
      event.stop();
    });

    document.on("click", 'a.filter_hot', function(event, el) {
      el.toggleClassName('active');
      if(el.hasClassName('active')) {
        $$('article.cold').invoke('hide');
      } else {
        $$('article.cold').invoke('show');
      }
      event.stop();
    });

    document.on("click", 'a.filter_new', function(event, el) {
      el.toggleClassName('active');
      if(el.hasClassName('active')) {
        $$('article:not(.new)').invoke('hide');
      } else {
        $$('article:not(.new)').invoke('show');
      }
      event.stop();
    });

    document.on("click", 'a.post_link', function(event, el) {
      this.input.value = el.getAttribute('href');
      Carbon.instance.hide();
      this.input.focus();
      event.stop();
    }.bind(this));
    
    document.on("ajax:before", "#new_post", function(event, el) {
      if(this.input.value.empty()) {
        event.stop();
      } else {
        this.submitting = true;
        this.timer.stop();
        el.down('img.loading').show();
        $('post_submit').disabled = true;        
      }
    }.bind(this));

    document.on("ajax:success", "#new_post", function(event, el) {
      this.submitting = false;
      this.timer.registerCallback();
      el.down('img.loading').hide();
      $('post_submit').disabled = false;
      $('new_post').addClassName('compact');
      $('posts').addClassName('compact_input');
    }.bind(this));
    
    this.input.on('focus', function(event) {
      $('new_post').removeClassName('compact');
      $('posts').removeClassName('compact_input');
    });
    
    this.timer = new PeriodicalExecuter(this.checkForNew.bind(this), 10);
  },
  checkForNew: function() {
    var highestId = 0;
    $('posts').select('article').each(function(el) {
      var id = parseInt(el.getAttribute('data-post-id'));
      
      if(id > highestId) {
        highestId = id;
      }
    });
    new Ajax.Request($('new-posts-bar').getAttribute('data-href-check'), {
      parameters: {highest_id: highestId}
    });
  }
});
Object.extend(Post, {
  
});

var Carbon = Class.create({
  initialize: function() {
    Carbon.instance = this;
    this.duration = 0.2;
    this.el = $('carbon');
    this.content = $('carbon-content').down('div.body');
    document.on('click', 'a.carbon-close', this.hide.bind(this));
    document.observe('keydown', this.keyControls.bind(this));
    document.on('click', 'a.carbon-load', this.load.bind(this));
  },
  show: function(event) {
    $$('body').first().addClassName('carbon');
    this.el.appear({duration: this.duration});
    if(event) { event.stop(); }
  },
  hide: function(event) {
    this.el.fade({duration: this.duration, afterFinish: function() {
      $$('body').first().removeClassName('carbon');
    }});
    if(event) { event.stop(); }
  },
  keyControls: function(event) {
    if(this.el.visible) {
      if(event.which==Event.KEY_ESC) {
        this.hide();
      }      
    }
  },
  load: function(event) {
    this.show();
    this.el.down('img.loading').show();
    //this.content.hide();
    var params = event.element().hasAttribute('data-carbon-params') ? event.element().getAttribute('data-carbon-params').evalJSON() : null;

    new Ajax.Request(event.element().getAttribute('data-carbon-href'), {
      method: typeof(params.method)=='undefined' ? 'POST' : params.method,
      parameters: params,
      onSuccess: function(transport) {
        this.content.update(transport.responseText);
        //this.content.show();
        this.el.down('img.loading').hide();
      }.bind(this)
    });    
    if(event) { event.stop(); }
  }
  
});
Object.extend(Post, {
  instance: null
});

