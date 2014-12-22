"GeoIP controllers"

from pyramid.view import view_config
from pyramid.httpexceptions import HTTPInternalServerError
from .. import APP_NAME, APP_BASE
from ..lib.geoip import ip_lookup


@view_config(route_name=APP_NAME+'.home',
             renderer='%s:templates/geoip_lookup.mako' % APP_BASE)
def geoip_home(request):
    "Home page"

    ip_address = request.GET.get('ip', None)
    lookup_response = None

    if ip_address:
        try:
            lookup_response = ip_lookup(request, ip_address)
        except RuntimeError as exp:
            return HTTPInternalServerError(str(exp))

    return {'APP_BASE': APP_BASE, 'APP_NAME': APP_NAME,
            'lookup': lookup_response}
