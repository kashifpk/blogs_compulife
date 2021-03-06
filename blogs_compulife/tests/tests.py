import unittest
import transaction

from pyramid import testing
from ..models import db, User, Base
from . import TestBase, FunctionalTestBase


class TestSite(TestBase):
    "Unit and Integration tests"

    def test_record_add(self):
        with transaction.manager:
            record = User(user_id=u'testuser', password=u'testpass')
            db.add(record)

    def test_record_fetch(self):
        user = db.query(User).first()
        self.assertIsNotNone(user)
        self.assertEquals(user.user_id, u'testuser')

    def test_homepage(self):
        from ..controllers.controllers import homepage

        request = testing.DummyRequest()
        response = homepage(request)

        self.assertEqual(response['project'], 'blogs_compulife')


class TestSiteFunctional(FunctionalTestBase):
    "Functional tests for the project"

    def test_get_login(self):
        res = self.app.get('/login')
        self.assertEqual(res.status_int, 200)

