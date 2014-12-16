"Dates related functions"

from datetime import datetime, timedelta


def process_date_range(date_from, date_to):
    """
    Given a date range in string format (yyyy-mm-dd), returns date objects

        - date_to is inclusive
        - if just date_from is given sets date_to = date_from + 1 day
    """

    if not date_to:
        date_to = date_from

    date_from = datetime.strptime(date_from, '%Y-%m-%d')
    date_to = datetime.strptime(date_to, '%Y-%m-%d') + timedelta(days=1)

    return (date_from, date_to)