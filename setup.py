import os
import sys

from setuptools import setup, find_packages

here = os.path.abspath(os.path.dirname(__file__))
README = open(os.path.join(here, 'README.txt')).read()
CHANGES = open(os.path.join(here, 'CHANGES.txt')).read()

requires = [
    'PyCK',
    'pyramid',
    'SQLAlchemy',
    'transaction',
    'pyramid_mako',
    'pyramid_tm',
    'pyramid_debugtoolbar',
    'zope.sqlalchemy',
    'webtest',
    'waitress',
    'wtforms',
    'wtdojo'
]

if sys.version_info[:3] < (2, 5, 0):
    requires.append('pysqlite')

# Requires from subapps
from blogs_compulife.apps import enabled_apps
for enabled_app in enabled_apps:
    if hasattr(enabled_app, 'app_requires'):
        for requirement in enabled_app.app_requires:
            if requirement not in requires:
                requires.append(requirement)

setup(
    name='blogs_compulife',
    version='0.0',
    description='blogs_compulife',
    long_description=README + '\n\n' + CHANGES,
    classifiers=[
        "Programming Language :: Python",
        "Framework :: PyCK",
        "Topic :: Internet :: WWW/HTTP",
        "Topic :: Internet :: WWW/HTTP :: WSGI :: Application",
    ],
    author='',
    author_email='',
    url='',
    keywords='web PyCK framework pylons pyramid',
    packages=find_packages(),
    include_package_data=True,
    zip_safe=False,
    test_suite='blogs_compulife',
    install_requires=requires,
    entry_points="""\
    [paste.app_factory]
    main = blogs_compulife:main
    [console_scripts]
    blogs_compulife_populate = blogs_compulife.scripts.populate:main
    blogs_compulife_newapp = blogs_compulife.scripts.newapp:main
    """,
)
