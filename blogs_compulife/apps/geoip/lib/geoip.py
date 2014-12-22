"GeoIP related code"

import geoip2.database
from collections import OrderedDict


class GeoIP(object):
    "Allow Geo information fetching from a GeoIP database for given IP Addresses"

    def __init__(self, db_location):
        self.db_location = db_location
        self.db = geoip2.database.Reader(db_location)

    def __del__(self):
        self.db.close()

    def _ip_lookup(self, ip_address):
        "Lookup geo info for a single ip"

        try:
            response = self.db.city(ip_address)
        except geoip2.errors.AddressNotFoundError:
            return None

        return response

    def ip_lookup(self, ip_request):
        "Look up geo info for one or multipe (list/tuple) ips"

        response = None
        if type(ip_request) in (list, tuple):
            response = OrderedDict()
            for ip_address in ip_request:
                response[ip_address] = self._ip_lookup(ip_address)
        else:
            response = self._ip_lookup(ip_request)

        return response


def ip_lookup(request, ip_addresses):
    "shortcut function for creating GeoIP class and doing ip lookup"

    db_location = request.registry.settings.get('geoip_db', None)
    if not db_location:
        raise RuntimeError("GeoIP database location not provided in settings")

    geo = GeoIP(db_location)
    lookup_response = geo.ip_lookup(ip_addresses)

    return lookup_response
