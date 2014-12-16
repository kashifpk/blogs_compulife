<%inherit file="/base.mako"/>
<%namespace name="charting" file="charting.mako" />
<%namespace name="date_search" file="_date_search.mako" />

<%def name="title()">
Visit records
</%def>

${date_search.search_controls(date_from, date_to)}

<div class="row">
  <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
${charting.bar_chart(data=stats, div_name='bar_chart', width='100%', height=str(len(stats)*50) + 'px')}
  </div>
</div>

<table class="table table-striped table-condensed">
  <caption class="bg-primary" style="font-size: larger; font-weight: bold;">
    Visit log for ${date_from}
    %if date_to:
      to ${date_to}
    %endif
  </caption>
  <thead>
    <tr class="bg-info" style="font-weight: bold;">
      <th>Timestamp</th>
      <th>Client IP</th>
      <th>URL</th>
      <th>Browser (User Agent)</th>
    </tr>
  </thead>
  <tbody>
    %for rec in records:
      <tr>
        <td>${rec.timestamp}</td>
        <td>${rec.source_ip}</td>
        <td>${rec.url}</td>
        <td>${rec.user_agent}</td>
      </tr>
    %endfor
  </tbody>
</table>



<!--<div>
  <div class="middle align-center">
    <p class="app-welcome">
    <img src="${request.static_url(APP_BASE + ':static/webapp.png')}" />  Welcome to visit_counter app
    </p>
  </div>
</div>-->
