
<%def name="categories_option_tags(records, name_prefix='', selected_item=None)">
    <% selected_str = "" %>
    %for category in records:
      %if category.id == selected_item:
        <% selected_str = "selected" %>
      %else:
        <% selected_str = "" %>
      %endif

      %if name_prefix:
        <option value="${category.id}" ${selected_str}>${name_prefix}${category.name}</option>
      %else:
        <option value="${category.id}" ${selected_str}>${category.name}</option>
      %endif
      
      %if len(category.sub_categories)>0:
        ${categories_option_tags(category.sub_categories, name_prefix + category.name + ' -> ', selected_item)}
      %endif
    %endfor 
</%def>

<%def name="file_uploader(APP_NAME, item_type, item_id)">
    <style type="text/css">
      @import "${dojo_url_prefix}/dojox/form/resources/UploaderFileList.css";
    </style>
    <script type="application/x-javascript"><![CDATA[
    function refresh_file_list() {
      require(["dojo/dom", "dojo/request", "dojo/json", "dojo/_base/array"],
          function(dom, request, JSON, arrayUtil){
            
            // Request the JSON data from the server
            request.get("/${APP_NAME}/file_list/${item_type}/${item_id}", {
                // Parse data from JSON to a JavaScript object
                handleAs: "json"
            }).then(function(data){
                // Display the data sent from the server
                var html = '<h3 class="bg-primary">Uploaded files</h3><table class="table table-striped table-hover table-condensed">';
                var image_exts = ['png', 'jpg', 'jpeg', 'gif', 'bmp'];
                
                for (idx in data) {
                  filename = data[idx];
                  file_ext = filename.toLowerCase().split(".").pop();
                  //console.log(file_ext);
                  var url = '/${APP_NAME}/static/${item_type}_images/${item_id}/' + filename;
                  html += '<tr><td><a href="' + url + '">' + url;
                  if (-1 != image_exts.indexOf(file_ext)) {
                    html += '<br /><img src="' + url + '" style="width: 100px; height: 50px;" class="img-thumbnail" />';
                  }
                  html += '</a></td></tr>';
                  
                }
                html += "</table>";
     
                dom.byId('uploaded_files').innerHTML = html;
            },
          function(error){
              // Display the error returned
              resultDiv.innerHTML = error;
          });
        });
    }
    
    require(["dojo/dom", "dojo/domReady!"],
      function(dom){
        refresh_file_list(); 
      }
    );
    //]]>
    </script>
    <div type="file" id="image_uploader" multiple="true" data-dojo-type="dojox/form/Uploader"
         data-dojo-props="
              label: 'Select files to upload',
              url: '/${APP_NAME}/upload_image/${item_type}/${item_id}',
              uploadOnSelect: true">
      <script type="dojo/connect" event="onComplete">
        refresh_file_list();
      </script>
    </div>
    <div id="files" data-dojo-type="dojox/form/uploader/FileList" data-dojo-props="uploaderId: 'image_uploader'"></div>

    <div id="uploaded_files"></div>  
</%def>