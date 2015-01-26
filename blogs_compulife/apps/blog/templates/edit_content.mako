<%inherit file="/base.mako"/>
<%namespace name="util" file="util.mako" />

<%!
dojo_url_prefix = "http://ajax.googleapis.com/ajax/libs/dojo/1.10.1"
%>

<%def name="title()">
Edit ${item_type.title()} Content
</%def>


<%def name="extra_head()">
    ## extra_head should be defined in project's base.mako
    
    <style type="text/css">
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
    
    function submit_form(item_action) {
      var editor = dijit.byId("_content_body");
      document.getElementById('body').value = editor.attr("value");
      document.getElementById('item_action').value=item_action;
      document.blog_form.submit();
      
    }
    
    function preview(){
      
    }
    
    </script>
</%def>

<h1>Editing content for ${item_type} ${item_title}</h1><br />


  
<div class="row">
  <div class="col-xs-12 col-sm-12 col-md-8 col-lg-8">
    <form action="${request.route_url(APP_NAME + '.edit_content', item_type=item_type, item_id=item_id)}" name="content_form" id="content_form" method="POST" role="form">
    <label for="_content_body">Content</label><br />
    
    <div data-dojo-type="dijit.Editor" style="width:100%;min-height:100px;" id="_content_body"
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
      %if item_content:
        ${item_content}
      %endif
    </div>
    
    <input type="hidden" name="body" id="body" value="" />
    <input type="hidden" name="item_action" id="item_action" value="" />
    
    <br /><br />
    
    <div class="row">
      <button class="btn btn-success" onclick="submit_form('save');">Save</button>
      <button class="btn btn-success" onclick="submit_form('save_return');">Save and Return</button>
      <button class="btn btn-primary pull-right" onclick="preview();">Preview</button>
    </div>
    
    </form>
  </div>
  <div class="col-xs-12 col-sm-12 col-md-4 col-lg-4">
    ${util.file_uploader(APP_NAME, item_type, item_id)}
  </div>
</div>


