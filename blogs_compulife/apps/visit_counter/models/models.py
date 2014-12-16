from datetime import datetime, timedelta
from sqlalchemy import Column, Integer, Unicode, DateTime, Date
from sqlalchemy import func, cast

from . import db, Base
from ..lib.dates import process_date_range


class Visit(Base):
    "Page Visit"

    __tablename__ = 'visits'

    id = Column(Integer, primary_key=True)
    timestamp = Column(DateTime, default=datetime.utcnow)
    source_ip = Column(Unicode(50))
    user_agent = Column(Unicode(200))
    url = Column(Unicode(2000))

    @classmethod
    def get_records(cls, date_from, date_to=None):
        """
        Return records for a date range. Date values are strings.

            - date_to is inclusive
            - if just date_from is given, only records for that date are returned
        """

        date_from, date_to = process_date_range(date_from, date_to)

        return db.query(Visit).filter(Visit.timestamp >= date_from,
                                      Visit.timestamp < date_to).all()

    @classmethod
    def get_stats(cls, date_from=None, date_to=None, limit=100):
        """
        Return overall stats/summary or stats for a given date range if given

        - date_to is inclusive
            - if just date_from is given, only records for that date are returned
        """

        query = db.query(cast(Visit.timestamp, Date),
                         func.count(Visit.id))

        if date_from:
            date_from, date_to = process_date_range(date_from, date_to)
            query = query.filter(Visit.timestamp >= date_from,
                                 Visit.timestamp < date_to)

        query = query.group_by(cast(Visit.timestamp, Date))
        query = query.order_by(cast(Visit.timestamp, Date))

        if limit:
            query = query.limit(limit)

        stats = query.all()

        return stats

    @classmethod
    def get_url_stats(cls, date_from=None, date_to=None, limit=10, sort=True):
        """
        Return overall stats/summary or stats for a given date range if given

        - date_to is inclusive
            - if just date_from is given, only records for that date are returned
        """

        query = db.query(Visit.url, func.count(Visit.id))

        if date_from:
            date_from, date_to = process_date_range(date_from, date_to)
            query = query.filter(Visit.timestamp >= date_from,
                                 Visit.timestamp < date_to)

        query = query.group_by(Visit.url)

        if sort:
            query = query.order_by(func.count(Visit.id).desc())

        if limit:
            query = query.limit(limit)

        stats = query.all()

        return stats


class History(Base):
    """
    Stores history of visits per day. It's intentionally created ignoring normalization
    as after a day passes it's visit count won't be changed so it's better to store it
    in history
    """

    __tablename__ = 'history'

    date = Column(Date, primary_key=True)
    url = Column(Unicode(2000), primary_key=True)
    visit_count = Column(Integer, default=0)


