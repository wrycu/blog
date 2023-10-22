#!/bin/bash
git pull
JEKYLL_ENV=production bundle exec jekyll build
cp -R _site/* /var/www/html/
