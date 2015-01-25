<%inherit file="/base.mako"/>
<%namespace name="util" file="util.mako" />

<%!
dojo_url_prefix = "http://ajax.googleapis.com/ajax/libs/dojo/1.10.1"
%>

<%def name="title()">
Edit Content
</%def>


<%def name="extra_head()">
    ## extra_head should be defined in project's base.mako
    
    <style type="text/css">
      @import "${dojo_url_prefix}/dojox/form/resources/UploaderFileList.css";
      @import "${dojo_url_prefix}/dojox/editor/plugins/resources/css/Save.css";
      @import "${dojo_url_prefix}/dojox/editor/plugins/resources/css/Preview.css";
      @import "${dojo_url_prefix}/dojox/editor/plugins/resources/css/ShowBlockNodes.css";
      @import "${dojo_url_prefix}/dojox/editor/plugins/resources/css/InsertEntity.css";
      @import "${dojo_url_prefix}/dojox/editor/plugins/resources/css/PageBreak.css";
      @import "${dojo_url_prefix}/dojox/editor/plugins/resources/css/Breadcrumb.css";
      @import "${dojo_url_prefix}/dojox/editor/plugins/resources/css/FindReplace.css";
      @import "${dojo_url_prefix}/dojox/editor/plugins/resources/css/InsertAnchor.css";
      @import "${dojo_url_prefix}/dojox/editor/plugins/resources/css/Breadcrumb.css";
      @import "${dojo_url_prefix}/dojox/editor/plugins/resources/css/TextColor.css";
      @import "${dojo_url_prefix}/dojox/editor/plugins/resources/css/CollapsibleToolbar.css";
      @import "${dojo_url_prefix}/dojox/editor/plugins/resources/css/Blockquote.css";
      @import "${dojo_url_prefix}/dojox/editor/plugins/resources/css/InsertAnchor.css";
      @import "${dojo_url_prefix}/dojox/editor/plugins/resources/css/PasteFromWord.css";
      @import "${dojo_url_prefix}/dojox/editor/plugins/resources/editorPlugins.css";
      @import "${dojo_url_prefix}/dojox/editor/plugins/resources/css/Smiley.css";
      @import "${dojo_url_prefix}/dojox/editor/plugins/resources/css/StatusBar.css";
      @import "${dojo_url_prefix}/dojox/editor/plugins/resources/css/SafePaste.css";
    </style>
     
    <script >
        
        // Load the editor and all its plugins.
        require([
        "dijit/Editor",
    
        // Commom plugins
        "dijit/_editor/plugins/FullScreen",
        "dijit/_editor/plugins/LinkDialog",
        "dijit/_editor/plugins/Print",
        "dijit/_editor/plugins/ViewSource",
        "dijit/_editor/plugins/FontChoice",
        //"dijit/_editor/plugins/TextColor",
        "dijit/_editor/plugins/NewPage",
        "dijit/_editor/plugins/ToggleDir",
    
        //Extension (Less common) plugins
        "dojox/editor/plugins/ShowBlockNodes",
        "dojox/editor/plugins/ToolbarLineBreak",
        "dojox/editor/plugins/Save",
        "dojox/editor/plugins/InsertEntity",
        "dojox/editor/plugins/Preview",
        "dojox/editor/plugins/PageBreak",
        "dojox/editor/plugins/PrettyPrint",
        "dojox/editor/plugins/InsertAnchor",
        "dojox/editor/plugins/CollapsibleToolbar",
        "dojox/editor/plugins/Blockquote",
        "dojox/editor/plugins/InsertAnchor",
    
        // Experimental Plugins
        "dojox/editor/plugins/NormalizeIndentOutdent",
        "dojox/editor/plugins/FindReplace",
        "dojox/editor/plugins/TablePlugins",
        "dojox/editor/plugins/TextColor",
        "dojox/editor/plugins/Breadcrumb",
        "dojox/editor/plugins/PasteFromWord",
        "dojox/editor/plugins/Smiley",
        "dojox/editor/plugins/NormalizeStyle",
        "dojox/editor/plugins/StatusBar",
        "dojox/editor/plugins/SafePaste",
        ]);
    
    function submit_form(blog_action) {
      var editor = dijit.byId("_content_body");
      document.getElementById('body').value = editor.attr("value");
      document.getElementById('blog_action').value=blog_action;
      document.blog_form.submit();
      
    }
    
    function preview(){
      
    }
    
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
    </script>
</%def>

<form action="${request.route_url(APP_NAME + '.preview_content', item_type=item_type, item_id=item_id)}" name="content_form" id="content_form" method="POST" role="form">
<div class="row">
  <div class="col-xs-12 col-sm-12 col-md-8 col-lg-8">
    <label for="_content_body">Content</label><br />
    
    <!--<div data-dojo-type="dijit.Editor" style="width:90%;min-height:100px;" id="_content_body" name="_content_body"
         data-dojo-props="extraPlugins:['collapsibletoolbar', 'breadcrumb', 'newpage',
                        {name: 'viewSource', stripScripts: true, stripComments: true}, 
                        'showBlockNodes', '||',
                        {name: 'fullscreen', zIndex: 900}, 'preview', 'print', '|',
                        'findreplace', 'selectAll',  'pastefromword', 'delete', '|',
                        'pageBreak', 'insertHorizontalRule', 'blockquote', '|',
                        'toggleDir', '|',
                        'superscript', 'subscript', 'foreColor', 'hiliteColor', 'removeFormat', '||',
                        'fontName', {name: 'fontSize', plainText: true}, {name: 'formatBlock', plainText: true}, '||',
                        'insertEntity', 'smiley', 'createLink', 'insertanchor', 'unlink', 'insertImage', '|', 
                        {name: 'dojox.editor.plugins.TablePlugins', command: 'insertTable'},
                        {name: 'dojox.editor.plugins.TablePlugins', command: 'modifyTable'},
                        {name: 'dojox.editor.plugins.TablePlugins', command: 'InsertTableRowBefore'},
                        {name: 'dojox.editor.plugins.TablePlugins', command: 'InsertTableRowAfter'},
                        {name: 'dojox.editor.plugins.TablePlugins', command: 'insertTableColumnBefore'},
                        {name: 'dojox.editor.plugins.TablePlugins', command: 'insertTableColumnAfter'},
                        {name: 'dojox.editor.plugins.TablePlugins', command: 'deleteTableRow'},
                        {name: 'dojox.editor.plugins.TablePlugins', command: 'deleteTableColumn'},
                        {name: 'dojox.editor.plugins.TablePlugins', command: 'colorTableCell'},
                        {name: 'dojox.editor.plugins.TablePlugins', command: 'tableContextMenu'}, 
                        //{name: 'dijit._editor.plugins.EnterKeyHandling', blockNodeForEnter: 'P'},
                        'safepaste']">
    </div>-->
  </div>
  <div class="col-xs-12 col-sm-12 col-md-4 col-lg-4">
    
    <div type="file" id="image_uploader" multiple="true" data-dojo-type="dojox/form/Uploader"
    data-dojo-props="
        label: 'Select files to upload',
        url: '/${APP_NAME}/upload_image/${item_type}/${item_id}',
        uploadOnSelect: true">
      <script type="dojo/connect" event="onComplete">
        console.log('Calling refresh');
        refresh_file_list();
      </script>
    </div>
    <div id="files" data-dojo-type="dojox/form/uploader/FileList" data-dojo-props="uploaderId: 'image_uploader'"></div>
    
    <div id="uploaded_files">
      
    </div>
  </div>
</div>

<input type="hidden" name="body" id="body" value="" />
<input type="hidden" name="blog_action" id="blog_action" value="" />

<br /><br />

<div class="row">
  <button class="btn btn-success" onclick="submit_form('save');">Save</button>
  <button class="btn btn-primary" onclick="submit_form('publish');">Publish</button>
  <button class="btn btn-info pull-right" onclick="preview();">Preview</button>
</div>

</form>
