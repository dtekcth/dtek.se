from django.urls import path

from django.views.generic import TemplateView
from django.views.generic import RedirectView
from django.contrib.staticfiles.templatetags.staticfiles import static

# from . import views

app_name = 'homepage'
urlpatterns = [
    path("", TemplateView.as_view(template_name='homepage/index/index.html'), name='index'),
    path("newsletter", TemplateView.as_view(template_name='homepage/newsletter.html'), name='newsletter'),
    path("documents", TemplateView.as_view(template_name='homepage/documents.html'), name='documents'),
    path('studiesocial-hjalp', RedirectView.as_view(url=static('homepage/studiesociala-natverket.pdf')), name='studiesocial-hjalp'),
]

