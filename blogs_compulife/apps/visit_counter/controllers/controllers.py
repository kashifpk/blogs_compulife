from datetime import datetime
from pyramid.view import view_config
from pyramid.exceptions import HTTPNotFound
from ..models import db, Visit, History
from .. import APP_NAME, PROJECT_NAME, APP_BASE


@view_config(route_name=APP_NAME+'.home', renderer='%s:templates/stats.mako' % APP_BASE)
def stats(request):
    "Display stats summary"

    recs = Visit.get_stats()
    url_stats = Visit.get_url_stats()
    today = datetime.today().date().strftime("%Y-%m-%d")

    return {'APP_BASE': APP_BASE, 'stats': recs, 'url_stats': url_stats, 'today': today}


@view_config(route_name=APP_NAME+'.details', renderer='%s:templates/details.mako' % APP_BASE)
@view_config(route_name=APP_NAME+'.details_range', renderer='%s:templates/details.mako' % APP_BASE)
def details(request):

    date_to = None
    date_from = request.matchdict.get('date', None)   # yyyy-mm-dd format

    if not date_from:
        date_from = request.matchdict.get('date_from', None)
        date_to = request.matchdict.get('date_to', None)

    records = Visit.get_records(date_from, date_to)

    if not records:
        return HTTPNotFound("No records found for the given date/date range")

    url_stats = Visit.get_url_stats(date_from, date_to, limit=None, sort=False)

    return {'APP_BASE': APP_BASE, 'records': records, 'stats': url_stats,
            'date_from': date_from, 'date_to': date_to}


@view_config(route_name=APP_NAME+'.daily_status', renderer='%s:templates/list.mako' % APP_BASE)
def daily_stats(request):
    return {'APP_BASE': APP_BASE}
