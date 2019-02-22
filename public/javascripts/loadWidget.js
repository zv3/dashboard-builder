var NV_PATH = '/';
var NV_STATIC = 'http://cdn.netvibes.com';
var NV_HOST = "www.netvibes.com";
var NV_MODULES = "nvmodules.netvibes.com";
var NV_AVATARS = "avatars.netvibes.com";
var NV_ECO = "eco.netvibes.com";
var NV_ECO_API = "api.eco.netvibes.com";
var NV_API = "rest.netvibes.com";
var NV_API_PATH = "/rest";

if (typeof UWA == "undefined" || !UWA) var UWA = {};

if (typeof UWA.Environments == "undefined" || !UWA.Environments) UWA.Environments = {};

UWA.BlogWidget = function(parameters) {

  this.inline = false;
  
  this.elements = {};
  
  this.datas = {};
  
  // this.commUrl = 'http://' + document.location.hostname + '/uwa.html';
  
  this.configuration = {
    title: 'Default title',
    height: '250',
    borderWidth: '1',
    color: "#aaaaaa",
    displayTitle: true,
    displayFooter: true,
    autoresize: false
  }
  
  for(key in parameters) {
    this[key] = parameters[key];
  }
  
  if(typeof this.id == "undefined") {
    this.id = "uwa" + Math.ceil(Math.random() * 1000);
  }
  
  if(typeof this.container != "object") {
    console.log("no valid container defined");
  }
  
  if(typeof this.moduleUrl != "string") {
    console.log("no moduleUrl defined");
  }
  
  this.renderWidget();
  
  this.updateLayout();
  
  if(this.inline == true) {
    UWA.Environments[this.id] = new UWA.Environment();
    UWA.Environments[this.id].map(this.id, this.moduleUrl, { body : this.elements['body'], title : this.elements['title'] } );
  }
  
}

UWA.BlogWidget.prototype = {
  
  /* simple layout setters */
  
  setConfiguration: function(configuration) {
    for(key in configuration) {
      this.configuration[key] = configuration[key];
    }
    this.updateLayout();
  },
  
  setBorderWidth: function(width) {
    this.configuration['borderWidth'] = width;
    this.updateLayout();
  },
  
  setColor: function(color) {
    this.configuration['color'] = color;
    this.updateLayout();
  },
  
  setTitle: function(title) {
    this.configuration['title'] = title;
    this.updateLayout();
  },
  
  setHeight: function(height) {
    this.configuration['height'] = height;
    this.updateLayout();
  },
  
  /*
  setAutoresize: function(autoresize, commUrl) {
    if(autoresize == this.configuration['autoresize']) return true;
    this.configuration['autoresize'] = autoresize;
    if(typeof commUrl != "undefined") this.commUrl = commUrl;
    if(this.inline == false) this.updateIframeUrl();
  },
  */
  
  setCommUrl: function(url) {
    this.commUrl = url;
    if(this.inline == false) this.updateIframeUrl();
  },
  
  setDatas: function(datas) {
    this.datas = datas;
    if(this.inline == false) this.updateIframeUrl();
    else {
      if(UWA.Environments[this.id].widget) {
        UWA.Environments[this.id].widget.data = datas;
        UWA.Environments[this.id].widget.callback("onRefresh");
      } else {
        UWA.Environments[this.id].data = datas;
      }
    }
  },
  
  setPreferencesValues: function(values) {
    this.setDatas(values);
  },
  
  displayTitle: function(display) {
    this.configuration['displayTitle'] = display;
    this.updateLayout();
  },
  
  displayFooter: function(display) {
    this.configuration['displayFooter'] = display;
    this.updateLayout();
  },
  
  updateIframeUrl: function() {
    
    if(this.configuration['autoresize']) {
      //iframeUrl += '&autoresize=1';
      //iframeUrl += '&commUrl=' + this.commUrl;
      this.elements['iframe'].width = '100%';
      this.elements['iframe'].setAttribute('scrolling', 'no');
    } else {
      this.elements['iframe'].setAttribute('height', this.configuration['height']);
      this.elements['iframe'].width = '99%';
      this.elements['iframe'].setAttribute('scrolling', 'auto');
    }
    var iframeUrl = this.getIframeUrl();
    this.elements['iframe'].src = iframeUrl;
  },
  
  getIframeUrl: function() {
    var iframeUrl = 'http://' + NV_HOST + '/api/uwa/frame/blog.php?id=' + this.id + '&moduleUrl=' + this.moduleUrl;
    for(key in this.datas) {
      iframeUrl += '&' + key + '=' + this.datas[key];
    }
    return iframeUrl;
  },
  
  updateLayout: function() {
    var padding = '10px'; // this.configuration['padding'] + 'px'
    // padding
    this.elements['title'].style.padding = padding;
    this.elements['footer'].style.padding = padding;
    // border width
    this.container.style.borderWidth = this.configuration['borderWidth'] + 'px';
    // color
    this.container.style.borderColor = this.configuration['color'];
    this.elements['title'].style.background = this.configuration['color'];
    // title
    this.elements['title'].innerHTML = this.configuration['title'];
    // height
    if(this.inline == false &&  this.configuration['autoresize'] == false) {
      this.elements['iframe'].height = this.configuration['height'];
    }
    // display title
    if(this.configuration['displayTitle']) this.elements['title'].style.display = 'block';
    else this.elements['title'].style.display = 'none';
    // display footer
    if(this.configuration['displayFooter']) this.elements['footer'].style.display = 'block';
    else this.elements['footer'].style.display = 'none';
  },
  
  renderWidget: function() {
    
    this.elements['body'] = document.createElement('div');
    
    this.elements['title'] = document.createElement('div');
    this.elements['title'].innerHTML = this.configuration['title'];

    if(this.inline != false) {
      this.elements['body'].style.padding = '10px';
    }
    
    this.elements['footer'] = document.createElement('div');
    this.elements['footer'].className = 'footer';
    this.elements['footer'].innerHTML = '<img width="150" height="12" src="http://' + NV_HOST + '/api/uwa/powered.png" />';
    
    this.container.innerHTML = '';
    this.container.style.borderStyle = 'solid';
    
    this.container.appendChild(this.elements['title']);
    this.container.appendChild(this.elements['body']);
    this.container.appendChild(this.elements['footer']);
      
    this.body = this.elements['body'];
    
    if(this.inline == false) {
      
      this.elements['iframe'] = document.createElement('iframe');
      this.elements['iframe'].setAttribute('frameBorder', 0);
      this.elements['iframe'].setAttribute('id', 'frame_' + this.id);
      
      this.elements['body'].appendChild(this.elements['iframe']);
      
      this.updateIframeUrl();
    }
    
  },
  
  getConfigurationJS: function() {
    return this.getJS(this.configuration);
  },
  
  getDatasJS: function() {
    return this.getJS(this.datas);
  },
  
  /* light jsification inspired by JSON.toString() */
  getJS: function(object) {
    var a = ['{ '], b, i, v;
    for (i in object) {
      v = object[i];
      if (b) { a.push(', '); }
      a.push("'", i, "'", ':');
      switch(typeof v) {
        case 'string':
          a.push("'", v, "'");
          break;
        default:
          a.push(v);
          break;
      }
      b = true;
    }
    a.push(' }');
    return a.join('');
  },
  
  getCode: function() {
    
    var code = '<script type="text/javascript" src="http://' + NV_HOST + '/js/UWA/load.js.php?env=BlogWidget"></script>' + "\n";
   
    code += '<script type="text/javascript">' + "\n";
    
    code += '// create a new div container' + "\n";
    code += 'var wid = "uwa_" + Math.ceil(Math.random() * 1000);' + "\n";
    code += 'document.write(\'<div id="\' + wid + \'"></div>\');' + "\n";
    code += '// instanciate and create the blog widget' + "\n";
    code += 'var BW = new UWA.BlogWidget( { id: wid, container: document.getElementById(wid), moduleUrl: "' + this.moduleUrl + '" } );' + "\n";
    code += '// init blog widget configuration' + "\n";
    code += 'BW.setConfiguration(' + this.getConfigurationJS() + ');' + "\n";
    if(this.datas.length > 0) { // not ok with an object
      code += '// set widget datas' + "\n";
      code += 'BW.setPreferencesValues(' + this.getDatasJS() + ');' + "\n";
    }
    
    code += '</script>';
    
    return code;
    
  },
  
  setProxy: function(name, url) {
    UWA.proxies[name] = url;
  }

}
