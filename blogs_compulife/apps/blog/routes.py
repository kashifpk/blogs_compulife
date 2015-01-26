from . import APP_NAME, PROJECT_NAME, APP_BASE


def application_routes(config):

    config.add_static_view('static', 'static', cache_max_age=3600)
    config.add_route(APP_NAME + '.home', '/')
    config.add_route(APP_NAME + '.save_blog', '/save')
    config.add_route(APP_NAME + '.upload_image', '/upload_image/{item_type}/{item_id}')
    config.add_route(APP_NAME + '.file_list', '/file_list/{item_type}/{item_id}')
    config.add_route(APP_NAME + '.add_blog', '/new')
    config.add_route(APP_NAME + '.add_blog_rst', '/new_rst')
    config.add_route(APP_NAME + '.categories', '/categories')
    config.add_route(APP_NAME + '.posts', '/posts')
    config.add_route(APP_NAME + '.edit_content', '/edit/{item_type}/{item_id}')
    config.add_route(APP_NAME + '.preview_content', '/preview/{item_type}/{item_id}')
    config.add_route(APP_NAME + '.view_blog', '/*slugs')
