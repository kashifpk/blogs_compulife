"GeoIP controllers"

from pyramid.view import view_config
from pyramid.httpexceptions import HTTPInternalServerError
from .. import APP_NAME, APP_BASE
from ..lib.geoip import GeoIP


@view_config(route_name=APP_NAME+'.home',
             renderer='%s:templates/geoip_lookup.mako' % APP_BASE)
def geoip_home(request):
    "Home page"

    ip_address = request.GET.get('ip', None)
    lookup_response = None

    if ip_address:
        db_location = request.registry.settings.get('geoip_db', None)
        if not db_location:
            return HTTPInternalServerError("GeoIP database location not provided in settings")

        geo = GeoIP(db_location)
        lookup_response = geo.ip_lookup(ip_address)

    return {'APP_BASE': APP_BASE, 'APP_NAME': APP_NAME,
            'lookup': lookup_response}
