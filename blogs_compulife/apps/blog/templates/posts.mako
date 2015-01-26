<%inherit file="/base.mako"/>
<%namespace name="util" file="util.mako" />

<%def name="title()">
Blog Posts
</%def>


<%def name="extra_head()">
## extra_head should be defined in project's base.mako
<script src="${request.static_url(APP_BASE + ':static/common.js')}" type="text/javascript"></script>
</%def>

<form action="${request.route_url(APP_NAME + '.posts')}?action=${action}" name="post_form" id="post_form" method="POST" role="form">

%if 'edit' == action:
<input type="hidden" name="id" id="id" value="${post.id}" />
%endif

<div class="row">
  <div class="col-xs-12 col-sm-12 col-md-8 col-lg-8">
    
    <p>
    <label for="title">Title</label><br />
    <input required="True"
           data-dojo-props=" constraints: {}"
           data-dojo-type="dijit/form/ValidationTextBox"
           id="title"
           name="title"
           type="text"
           onkeyup="document.getElementById('slug').value=slugify(document.getElementById('title').value);"
           value=""> </p>
    
    <p>
    <label for="category_id">Category</label><br />
    <select data-dojo-type="dijit/form/FilteringSelect" id="category_id" name="category_id" required="True">
      <option value=""></option>
      ${util.categories_option_tags(categories)}
      
    </select>
    </p>
    
    <p>
    <label for="slug">Slug</label><br /> <input required=True data-dojo-props=" constraints: {}" data-dojo-type="dijit/form/ValidationTextBox" id="slug" name="slug" type="text" value=""> </p>
    
    <p>
    <label for="keywords">Keywords</label><br /> <input  data-dojo-props=" constraints: {}" data-dojo-type="dijit/form/ValidationTextBox" id="keywords" name="keywords" type="text" value=""> </p>
    
    <p>
    <label for="comments_allowed">Comments Allowed</label><br /> <input checked data-dojo-type="dijit/form/CheckBox" id="comments_allowed" name="comments_allowed" type="checkbox" value="y"> </p>
    
  </div>
<br />

<button class="btn btn-success" type="submit">${action.title()} post</button>

</form>
<br /><br />

<table class="table table-stripped table-hover table-bordered">
  <tr>
    <th>ID</th>
    <th>Title</th>
    <th>Slug</th>
    <th>Keywords</th>
    <th>View count</th>
    <th>Comments?</th>
    <th>Published?</th>
    <th></th>
  </tr>
  %for post in posts:
    <tr>
      <td>${post.id}</td>
      <td>${post.title}</td>
      <td>${post.slug}</td>
      <td>${post.keywords}</td>
      <td>${post.view_count}</td>
      <td>${post.comments_allowed}</td>
      <td>${post.published}</td>
      
      <td>
        <a href="${request.route_url(APP_NAME + '.posts')}?action=edit&id=${post.id}">Edit</a> |
        <a href="${request.route_url(APP_NAME + '.edit_content', item_type='blog', item_id=post.id)}">Edit Content</a> |
        <a href="${request.route_url(APP_NAME + '.posts')}?action=delete&id=${post.id}" class="text-danger">Delete</a>
      </td>
    </tr>
    
  %endfor 
</table>