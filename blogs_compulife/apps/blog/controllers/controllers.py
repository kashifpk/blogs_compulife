from pyramid.view import view_config
from pyramid.httpexceptions import (HTTPFound, HTTPNotFound,
                                    HTTPNotAcceptable, HTTPBadRequest)
from sqlalchemy.exc import IntegrityError

from ..models import (
    db,
    Category, Post, Comment
    )

from .. import APP_NAME, PROJECT_NAME, APP_BASE
from docutils.core import publish_parts
from os import path, mkdir
from glob import glob
from ...visit_counter.lib import count_visit

import logging
log = logging.getLogger(__name__)


@view_config(route_name=APP_NAME+'.home',
             renderer='%s:templates/list.mako' % APP_BASE)
def my_view(request):
    return {'APP_BASE': APP_BASE}


def _get_title_and_content_fields(item_type):
    
    content_map = dict(category=('name', 'header'), blog=('title', 'body'))
    return content_map[item_type]


def _get_record(item_type, item_id=None, request=None, msg=''):
    "Returns Category or Post record based on item type"
    
    
    if not item_id:
        item_id = request.params.get('id', None)
        
        if not item_id:
            raise HTTPNotFound(msg)

    rec = None
    type_map = dict(category=Category, blog=Post)
    
    if item_type in type_map:
        rec = db.query(type_map[item_type]).filter_by(id=int(item_id)).first()
        if not item_id:
            raise HTTPNotFound(msg)

    return rec


@view_config(route_name=APP_NAME+'.categories',
             renderer='%s:templates/categories.mako' % APP_BASE)
def categories_view(request):
    "Categories custom CRUD interface"

    action = request.GET.get('action', 'add')
    category = None

    if 'add' == action and 'POST' == request.method:
        category = Category(name=request.POST['name'],
                            slug=request.POST['slug'],
                            description=request.POST['description'])

        if '' != request.POST.get('parent_category', ''):
            category.parent_category = int(request.POST['parent_category'])

        db.add(category)
        request.session.flash("category {name} added!".format(
            name=category.name))

    elif 'edit' == action and 'GET' == request.method:
        try:
            category = _get_record(item_type='category', item_id=None,
                                   request=request,
                                   msg="Cannot edit, category not found.")
        except HTTPNotFound as exp:
            return exp

    elif 'edit' == action and 'POST' == request.method:

        action = 'add'
        try:
            category = _get_record(item_type='category', item_id=None,
                                   request=request,
                                   msg="Cannot update, category not found.")
            
            category.name = request.POST['name']
            category.slug = request.POST['slug']
            category.description = request.POST['description']

            if '' != request.POST.get('parent_category', ''):
                category.parent_category = int(request.POST['parent_category'])

            request.session.flash("category {name} updated!".format(
                name=category.name))

        except HTTPNotFound as exp:
            return exp

    elif 'delete' == action:
        try:
            category = _get_record(item_type='category', item_id=None,
                                   request=request,
                                   msg="Cannot delete, category not found.")
            
            db.delete(category)
            db.flush()

            request.session.flash("category {name} deleted!".format(
                name=category.name))

        except HTTPNotFound as exp:
            return exp
        except IntegrityError:
            return HTTPNotAcceptable(
                detail="Cannot delete category as it has dependent records\n")

    categories = Category.get_tree()
    log.debug(categories)

    return {'APP_BASE': APP_BASE, 'APP_NAME': APP_NAME,
            'categories': categories, 'action': action, 'category': category}


@view_config(route_name=APP_NAME+'.posts',
             renderer='%s:templates/posts.mako' % APP_BASE)
def posts_view(request):
    "Blog posts custom CRUD interface"

    action = request.GET.get('action', 'add')
    post = None

    if 'add' == action and 'POST' == request.method:
        post = Post(title=request.POST['title'],
                    slug=request.POST['slug'],
                    keywords=request.POST['keywords'])
        
        if 'y' != request.POST.get('comments_allowed', 'n'):
            post.comments_allowed = False
    
        if '' != request.POST.get('category_id', ''):
            post.category_id = int(request.POST['category_id'])
        
        db.add(post)
        request.session.flash("post {name} added!".format(
            name=post.title))

    elif 'edit' == action and 'GET' == request.method:
        try:
            post = _get_record(item_type='post', item_id=None,
                                   request=request,
                                   msg="Cannot edit, post not found.")
        except HTTPNotFound as exp:
            return exp

    elif 'edit' == action and 'POST' == request.method:

        action = 'add'
        try:
            post = _get_record(item_type='post', item_id=None,
                                   request=request,
                                   msg="Cannot update, post not found.")
            
            post.name = request.POST['name']
            post.slug = request.POST['slug']
            post.description = request.POST['description']

            if '' != request.POST.get('parent_post', ''):
                post.parent_post = int(request.POST['parent_post'])

            request.session.flash("post {name} updated!".format(
                name=post.name))

        except HTTPNotFound as exp:
            return exp

    elif 'delete' == action:
        try:
            post = _get_record(item_type='post', item_id=None,
                                   request=request,
                                   msg="Cannot delete, post not found.")
            
            db.delete(post)
            db.flush()

            request.session.flash("post {name} deleted!".format(
                name=post.name))

        except HTTPNotFound as exp:
            return exp
        except IntegrityError:
            return HTTPNotAcceptable(
                detail="Cannot delete post as it has dependent records\n")

    categories = Category.get_tree()
    posts = db.query(Post).order_by(Post.updated.desc())
    
    return {'APP_BASE': APP_BASE, 'APP_NAME': APP_NAME,
            'posts': posts, 'categories': categories,
            'action': action, 'post': post}


def _save_post(request, rst):
    "Code for saving a blog post, used by save_blog and add_blog"

    if rst:
        post = Post(title=request.POST['title'],
                    slug=request.POST['slug'],
                    keywords=request.POST['keywords'],
                    rst_source=request.POST['body'],
                    body=publish_parts(request.POST['body'],
                                       writer_name='html')['html_body'])
    else:
        post = Post(title=request.POST['title'],
                    slug=request.POST['slug'],
                    keywords=request.POST['keywords'],
                    body=request.POST['body'])

    if 'y' != request.POST.get('comments_allowed', 'n'):
        post.comments_allowed = False

    if '' != request.POST.get('category_id', ''):
        post.category_id = int(request.POST['category_id'])


    if 'publish' == request.POST['blog_action']:
        post.published = True

    # TODO, add user ID

    db.add(post)


@view_config(route_name=APP_NAME+'.save_blog', renderer="json")
def save_blog(request):
    "Allows saving the blog post via AJAX"

    if 'POST' == request.method:
        _save_post(request, rst=True)

    return {"status": 200, "msg": "OK"}


@view_config(route_name=APP_NAME+'.add_blog',
             renderer='%s:templates/add_blog.mako' % APP_BASE)
def add_blog(request):

    if 'POST' == request.method:
        _save_post(request, rst=False)

        request.session.flash("Post added!")
        return HTTPFound(location=request.route_url('admin.PostCRUD_list'))

    categories = Category.get_tree()

    return {'APP_BASE': APP_BASE, 'APP_NAME': APP_NAME,
            'categories': categories}


@view_config(route_name=APP_NAME+'.add_blog_rst',
             renderer='%s:templates/add_blog_rst.mako' % APP_BASE)
def add_blog_rst(request):

    if 'POST' == request.method:
        _save_post(request, rst=True)

        request.session.flash("Post added!")
        return HTTPFound(location=request.route_url('admin.PostCRUD_list'))

    categories = Category.get_tree()

    return {'APP_BASE': APP_BASE, 'APP_NAME': APP_NAME,
            'categories': categories}


@view_config(route_name=APP_NAME+'.upload_image', renderer="json")
def upload_image(request):
    "Allows saving the blog post via AJAX"

    ret = []
    
    item_type = request.matchdict['item_type']
    item_id = request.matchdict['item_id']
    
    here = path.dirname(path.abspath(__file__))
    upload_folder = path.join(here, '../static/{}_images/'.format(item_type))
    if not path.isdir(upload_folder):
        return HTTPBadRequest(detail="Upload folder {} not found".format(upload_folder))
    
    upload_folder = path.join(upload_folder, item_id)
    if not path.exists(upload_folder):
        mkdir(upload_folder)
    
    if 'POST' == request.method:
        print(request.POST)
        for fieldname, field in request.POST.items():
            if 'uploadedfiles[]' == fieldname:
                print(field)
                print(dir(field))
                print(field.filename)
                print(field.length)
                print(field.type)
                
                filename = path.join(path.realpath(upload_folder), field.filename)
                print(filename)
                file_data = field.file.read()
                open(filename, 'wb').write(file_data)
                file_dict = {'file': request.static_url(APP_BASE + ':static/blog_images/' + field.filename),
                             'name': field.filename,
                             'width': 250, 'height': 250,
                             'type': field.type, 'size': 1000,
                             'uploadType': request.POST['uploadType']}
                ret.append(file_dict)

    #$htmldata['file'] = $download_path . $name;
    #$htmldata['name'] = $name;
    #$htmldata['width'] = $width;
    #$htmldata['height'] = $height;
    #$htmldata['type'] = $type;
    #$htmldata['uploadType'] = $uploadType;
    #$htmldata['size'] = filesize($file);
    #$htmldata['additionalParams'] = $postdata;
    #$data = $json->encode($htmldata);
    #trace($data);
    #print $data;
    #return $data;
    return ret


@view_config(route_name=APP_NAME+'.file_list', renderer="json")
def file_list(request):
    "Return list of files uploaded for given item type and id"

    ret = []
    
    item_type = request.matchdict['item_type']
    item_id = request.matchdict['item_id']
    
    here = path.dirname(path.abspath(__file__))
    upload_folder = path.join(here, '../static/{}_images/'.format(item_type))
    if not path.isdir(upload_folder):
        return HTTPBadRequest(detail="Upload folder {} not found".format(upload_folder))
    
    upload_folder = path.join(upload_folder, item_id)
    if path.exists(upload_folder):
        files = glob(upload_folder + '/*')
        for filename in files:
            filename = path.basename(filename)
            if not filename.startswith('.'):
                ret.append(filename)
    
    return ret


@view_config(route_name=APP_NAME+'.edit_content',
             renderer='%s:templates/edit_content.mako' % APP_BASE)
def edit_content(request):
    "Allows saving content"

    item_type = request.matchdict['item_type']
    item_id = int(request.matchdict['item_id'])
    item_content = ''
    item_title = ''
    
    f_title, f_content = _get_title_and_content_fields(item_type)
    
    rec = _get_record(item_type, item_id)
    if rec:
        item_title = getattr(rec, f_title)
        item_content = getattr(rec, f_content)
    
    if 'POST' == request.method:
        
        if request.POST['item_action'] in ('save', 'save_return'):
            
            setattr(rec, f_content, request.POST['body'])
            item_contet = request.POST['body']
            
            db.add(rec)
            request.session.flash("Content updated!")
            
            if 'save_return' == request.POST['item_action']:
                if 'category' == item_type:
                    return HTTPFound(location=request.route_url(APP_NAME + '.categories'))
                elif 'blog' == item_type:
                    return HTTPFound(location=request.route_url(APP_NAME + '.posts'))
    
    return dict(APP_BASE=APP_BASE, APP_NAME=APP_NAME,
                item_content=item_content, item_title=item_title,
                record=rec, item_type=item_type, item_id=item_id)


@view_config(route_name=APP_NAME+'.preview_content')
def preview_content(request):
    "Allows saving the blog post via AJAX"

    if 'POST' == request.method:
        _save_post(request, rst=True)

    return {"status": 200, "msg": "OK"}


@view_config(route_name=APP_NAME+'.view_blog',
             renderer='%s:templates/view_blog.mako' % APP_BASE)
def view_blog(request):
    "Match the slugs in the url and display appropriate blog entry if found"

    # TODO: category display when only category slug is given
    slugs = list(request.matchdict.get('slugs', []))
    #print(slugs)
    blog_post = Post.match_by_slugs(slugs)

    if not blog_post:
        return HTTPNotFound("Sorry this blog does not exist")

    count_visit(request)

    extra_css = None
    if blog_post.rst_source:   # this is a reStructuredText post
        extra_css = publish_parts(blog_post.rst_source, writer_name='html')['stylesheet']

    return {'APP_BASE': APP_BASE, 'APP_NAME': APP_NAME, 'blog': blog_post,
            'extra_css': extra_css}
