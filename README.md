# MyFlix (Netflix copycat)

This is a Netflix copycat project.

It uses several external APIs:

* AWS S3 to upload and fetch images and video files
* Stripe to manage payments

As well as non-blocking background jobs for common non-critical task (like sending email notifications) via:

* Sidekiq and Redis
* ElasticSearch

## Features:

* User accounts (sign in, sign up, password reset)
* Invite-a-friend
* Follow other users
* Add new videos
* Rate and comment
