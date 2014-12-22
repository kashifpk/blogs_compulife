<%def name="get_flag(iso_code, resolution)">
  <img src="/geoip/static/flags_iso/${'{res}/{iso}.png'.format(res=resolution, iso=iso_code.lower())}" alt="image ${iso_code}" />
</%def>

<%def name="show_details(lookup)">
  <table class="table table-condensed table-striped table-responsive table-hover">
    <tr>
      <td>City</td>
      <td>${lookup.city.name}</td>
    </tr>
    <tr>
      <td>State/Provide</td>
      <td>${lookup.subdivisions.most_specific.name}</td>
    </tr>
    <tr>
      <td>Country</td>
      <td style="vertical-align: middle;">
      ${get_flag(lookup.country.iso_code, 48)}<br />
      ${lookup.country.name} (${lookup.country.iso_code})</td>
    </tr>
    
  </table>
</%def>