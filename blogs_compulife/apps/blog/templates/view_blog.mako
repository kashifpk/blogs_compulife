<%inherit file="/base.mako"/>
<%namespace name="util" file="util.mako" />

<%def name="title()">
${blog.title|n}
</%def>

<%def name="extra_head()">
<meta name="keywords" content="${blog.keywords}" />

<link rel="stylesheet" href="${request.static_url(APP_BASE + ':static/pygments_native.css')}" />

</%def>

%if blog.category.header:
<div class="row">
  ${blog.category.header|n}
</div>
%endif

<div class="row">
  <h1>${blog.title|n}</h1>
  ${blog.body|n}
</div>