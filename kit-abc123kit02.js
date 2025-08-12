---
layout: null
permalink: /abc123kit02.js
---
{% assign kit_data = site.data['abc123kit02'] %}
{% comment %}
Font Awesome Kit: {{ kit_data.kit_id }}
User: {{ kit_data.username }}
Allowed Domains: {{ kit_data.allowed_domains | join: ', ' }}
{% endcomment %}

(function() {
  'use strict';
  
  // Kit Configuration
  var kitConfig = {
    id: '{{ kit_data.kit_id }}',
    username: '{{ kit_data.username }}',
    allowedDomains: {{ kit_data.allowed_domains | jsonify }},
    styles: {{ kit_data.styles | jsonify }}
  };
  
  // Domain validation
  function isAllowedDomain() {
    var currentDomain = window.location.hostname;
    return kitConfig.allowedDomains.indexOf(currentDomain) !== -1;
  }
  
  // Load CSS function
  function loadCSS(href, id) {
    var link = document.createElement('link');
    link.rel = 'stylesheet';
    link.type = 'text/css';
    link.href = href;
    if (id) link.id = id;
    document.head.appendChild(link);
  }
  
  // Main initialization
  function initFontAwesome() {
    if (!isAllowedDomain()) {
      console.warn('Font Awesome Kit {{ kit_data.kit_id }} is not authorized for domain: ' + window.location.hostname);
      return;
    }
    
    // Get base URL (assuming CSS files are in the same directory as this JS file)
    var baseUrl = '{{ site.baseurl }}{% unless site.baseurl == "" %}/{% endunless %}';
    
    // Load each configured style
    kitConfig.styles.forEach(function(style) {
      var cssFile = style + '.css';
      var cssUrl = baseUrl + cssFile;
      loadCSS(cssUrl, 'fa-kit-' + style);
    });
    
    // Set global FontAwesome configuration
    window.FontAwesome = window.FontAwesome || {};
    window.FontAwesome.kit = {
      id: kitConfig.id,
      username: kitConfig.username,
      version: '{{ "now" | date: "%Y%m%d%H%M%S" }}'
    };
    
    console.log('Font Awesome Kit {{ kit_data.kit_id }} loaded successfully');
  }
  
  // Initialize when DOM is ready
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initFontAwesome);
  } else {
    initFontAwesome();
  }
  
})();
