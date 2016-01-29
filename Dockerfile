FROM ruby:2.2.4-onbuild
EXPOSE 9000
CMD bundle exec puma -p 9000 -w 4 --preload
