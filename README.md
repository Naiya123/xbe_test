# XBE Application
## Application setup & Technical Architecture

# Technical Stack:

| Plugin | README |
| ------ | ------ |
| Database | Postgresql 12.11 |
| Language | Ruby 2.7.0 |
| Framework | Ruby on Rails 6.0.5.1 |
| Background processing | Redis / Sidekiq | 

# Overall Approach and Flow
![image](https://drive.google.com/uc?export=view&id=1bRoxdHs94ga3i5V8poW8h6L8mPgxnzsd)

There are two ways to detect changes on database tables.
1. A set of insert/update/delete triggers create a notification event whenever anything changes in your table, using the created/changed/deleted ID as the payload.
2. A background process checks for notifications periodically and then loads the changed record from the database to do the web service call.

The second option is resource consuming as you have to iterate periodically even if there is no change in tables so we are going with the first option.

It's a publisher-subscriber kind of model where we write migration which adds a trigger to a model/table and then in our Listner rake task, listen to those trigger's notifications.

In migration, we have written a procedure which uses `NOTIFY/pg_notify` and `LISTEN` function of Postgres and setup table and channel accordingly to notify on the listening channel. Then we have to set this procedure to get trigger on table's insert, update and delete operation. We are also preparing payload as per the action and passing this payload to use in background job.

In rake task, we have setup listener according to our database notifier channel. There are three different handler blockes which will execute on different events like `start`, `notify` and `timeout`. 

One can add any logic or background job call inside this blocks. In demo app, we have setup a sidekiq job to get executed and update associated record inserted.

This approach is generalize so one can add such trigger to multiple classes and can have their own separate channels to listen updates.

# Setup Steps
```
$ git clone git@github.com:Naiya123/xbe_test.git
$ cd xbe_test
$ bundle install
$ rails db:create
$ rails db:migrate
```
Please make sure to setup database.yml correctly and after finish this, test app is running fine on `http://localhost:3000`

I have added one rake task `rake db_listner:run` which one have to run on new window. It will start listening on separate process for any database related changes on which you have setup trigger.

## Run Specs
```
$ rspec
```

> In case you get any issue with database then setup test database by running similar commands like dev environment but by specifying `RAILS_ENV=test`
