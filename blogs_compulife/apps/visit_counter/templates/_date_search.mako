<%def name="search_controls(default_date_from=None, default_date_to=None)">
  <script type="text/javascript">
    function view_details() {
      require(["dojo/dom", "dojo/date/locale"], function(dom, locale){
              var date_from = locale.format(dijit.byId('date_from').value, {formatLength: 'full', selector:'date', datePattern:'yyyy-MM-dd'});
              //console.log(date_from);
              
              var url = '/visit_counter/details/' + date_from;
              
              if (dijit.byId('date_to').value) {
                var date_to = locale.format(dijit.byId('date_to').value, {formatLength: 'full', selector:'date', datePattern:'yyyy-MM-dd'});
                //console.log(date_to);
                url += '/' + date_to
              }
              
              window.location.href = url;
          });
    }
  </script>
  
  <div class="row">
    <div class="col-xs-12 col-sm-12 col-md-3 col-lg-3">
      <label for="date_from">Start date</label><br />
      <input data-dojo-props="constraints: {}" data-dojo-type="dijit/form/DateTextBox"
             id="date_from" name="date_from" type="text" value="${default_date_from}" />
    </div>
    
    <div class="col-xs-12 col-sm-12 col-md-3 col-lg-3">
      <label for="date_to">End date (optional)</label><br />
      <input data-dojo-props="constraints: {}" data-dojo-type="dijit/form/DateTextBox"
             id="date_to" name="date_to" type="text" value="${default_date_to}" />
    </div>
    
    <div class="col-xs-12 col-sm-12 col-md-3 col-lg-3">
      <br />
      <button class="btn btn-sm btn-primary" onclick="view_details();">View detailed log</button>
    </div>
  </div>

</%def>