# README

## Installation:

```
bundle install
bundle exec rake db:create
bundle exec rake db:migrate
bundle exec rails s
```

## Run specs:

```
bundle exec rspec
```

## Request examples

### POST request (create)

The default secret key specified in `.env` file is `my$ecretK3y`.

You can generate the JWT token for the POST request using rails console:

```
payload = { score: 1, touchpoint: 'feedback', respondent_class: 'seller', respondent_id: 1, object_class: 'realtor', object_id: 1}
secret = ENV.fetch('HMAC_SECRET') # Or secret = 'my$ecretK3y'
token = JWT.encode(payload, secret)
=> "eyJhbGciOiJIUzI1NiJ9.eyJzY29yZSI6MSwidG91Y2hwb2ludCI6ImZlZWRiYWNrIiwicmVzcG9uZGVudF9jbGFzcyI6InNlbGxlciIsInJlc3BvbmRlbnRfaWQiOjEsIm9iamVjdF9jbGFzcyI6InJlYWx0b3IiLCJvYmplY3RfaWQiOjF9.uIufRCWU0yl_hEtxcT9pfeQiJKuIFopRUbbBDlWKkAg"
```

Then you can use this token to create the new record:

```
curl --request POST "http://127.0.0.1:3000/api/net_promoter_scores" --header "Content-Type: application/json" --data '{"token":"eyJhbGciOiJIUzI1NiJ9.eyJzY29yZSI6MSwidG91Y2hwb2ludCI6ImZlZWRiYWNrIiwicmVzcG9uZGVudF9jbGFzcyI6InNlbGxlciIsInJlc3BvbmRlbnRfaWQiOjEsIm9iamVjdF9jbGFzcyI6InJlYWx0b3IiLCJvYmplY3RfaWQiOjF9.uIufRCWU0yl_hEtxcT9pfeQiJKuIFopRUbbBDlWKkAg"}'
```

And another one:

```
curl --request POST "http://127.0.0.1:3000/api/net_promoter_scores" --header "Content-Type: application/json" --data '{"token":"eyJhbGciOiJIUzI1NiJ9.eyJzY29yZSI6NSwidG91Y2hwb2ludCI6ImZlZWRiYWNrIiwicmVzcG9uZGVudF9jbGFzcyI6InNlbGxlciIsInJlc3BvbmRlbnRfaWQiOjIsIm9iamVjdF9jbGFzcyI6InJlYWx0b3IiLCJvYmplY3RfaWQiOjJ9.159R8eTQ6_OQJvTRhDIi286xESAp2Nf4c1cgfVIhlrM"}'
```

### GET request (index)

There isn't any authentication, because it wasn't expected by the task. So you can just call the API endpoint. For the two records created by the POST requests:

```
curl "http://127.0.0.1:3000/api/net_promoter_scores?touchpoint=feedback"

{"net_promoter_scores":[{"id":1,"score":1,"touchpoint":"feedback","respondent_class":"seller","respondent_id":1,"object_class":"realtor","object_id":1,"created_at":"2020-01-25T22:20:36.483Z","updated_at":"2020-01-25T22:20:36.483Z"},{"id":2,"score":5,"touchpoint":"feedback","respondent_class":"seller","respondent_id":2,"object_class":"realtor","object_id":2,"created_at":"2020-01-25T23:19:03.012Z","updated_at":"2020-01-25T23:19:03.012Z"}]}
```

The required parameter is `touchpoint`.

The optional parameters are: `object_class` and `respondent_class`.

## Technology decisions:

The main idea of this service is to receive 6 params and save the record.
4 of these params are identifying the records in another application. To be sure that these records exist and the request is valid we can use different approaches:

1) Synchronize the database between two applications. It could be event sourcing or just copying the database. This approach is complex, needs a lot of engineering work and generates a lot of problems with synchronization.
2) We can make an additional request to the core application to check the data. But it'll increase the complexity of the whole system and adds additional relation. Also, this will increase the response time because we have to do an additional request. And in case of any problems with the core app, our service will not work.
3) Somehow validate the data sended by the user based on this data.

And for the last approach we can easily use JSON Web Tokens:
1) The core application generates the payload and encode it with the secret key.
2) Our service receives the only one parameter - JWT.
3) Service decode the payload, and get all necessary data.

In this case, we have to syncronize only the list of fields, encryption algorithm, and the secret key. And we can be sure that request payload is generated by the core app. At least if we can be sure that our secret keys are really secret.
