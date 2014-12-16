from ..models import Visit, db
from sqlalchemy import func

import sys
PY3 = sys.version > '3'

if PY3:
    from urllib.parse import urlparse
else:
    from urlparse import urlparse



def count_visit(request, url=None):
    "Inserts a record in visits model for current URL (excluding querystring)"

    if not url:
        url = urlparse(request.current_route_url()).path

    visit = Visit(source_ip=request.client_addr,
                  user_agent=request.user_agent,
                  url=url)
    db.add(visit)


#def get_stats(date=None, limit=10):
#    "Return overall stats or stats for a given date if a date is given"
#
#    query = db.query(Visit.url, func.count(Visit.id))
#    if date:
#        query = query.filter()
#    stats = query.group_by(Visit.url).order_by(func.count(Visit.id).desc()).limit(limit).all()
#
#    return stats
#
