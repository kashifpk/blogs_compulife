pyckapps.visit_counter
=======================

Pluggable page visit counting app for PyCK framework. This app goes under the apps folder in a pyck project and cannot be used standalone(without modification). If you're using git to manage your project you can put this app's repo as a subtree without your project.

For example you can add this as a subtree to your PyCK project like::


    git remote add VC git@github.com:kashifpk/pyckapps.visit_counter.git
    git subtree add --prefix myproject/apps/visit_counter VC master

Later if you want to pull latest changes (any updates to the app) you can do::

    git subtree pull --prefix myproject/apps/visit_counter VC master
