<%inherit file="/base.mako"/>

<%namespace name="geoip" file="_geoip.mako" />

<%def name="title()">
GeoIP Translate
</%def>

<form action="${request.route_url(APP_NAME + '.home')}" method="GET" class="form-inline" role="form">
<div class="row">
  <div class="center-block col-xs-12 col-sm-12 col-md-12 col-lg-12" style="text-align: center">
  
    <input type="text" class="form-control" name="ip" placeholder="Enter IP Address" value="${ip}" />
    <button type="submit" class="btn btn-primary">Geo Locate IP</button>
  
  </div>
</div>
</form>

%if lookup:
  <div class="panel panel-default">
    <div class="panel-heading">
      <h3 class="panel-title">GeoIP lookup for ${ip}</h3>
    </div>
    <div class="panel-body">
      ${geoip.show_details(lookup)}
    </div>
  </div>
%endif
