# Notey

A basic API for posting messages.

## Users

Users have a `username` and an `api_key`. You'll need to manually create your first user via rails console. Make your first user an `admin`. The `api_key` will be generated for you.

```ruby
u = User.new(username: 'jakealbaugh', admin: true)
u.save!
u.api_key 
# => 'HASH'
```

## API
### Auth
Any private, owner, or admin request needs to be authorized by providing a `username` and `api_key`.

```json
"auth": {
  "username":"USERNAME",
  "api_key":"API_KEY"
}
```

```bash
curl -v -H "Accept: application/json" -H "Content-type: application/json" -X WHATEVER -d '{"data": {},"auth":{"username":"USERNAME","api_key":"API_KEY"}}' http://localhost:3000/whatever
```

### Keys
#### Admin
##### `GET /keys`
Get all user keys.

```bash
curl -v -H "Accept: application/json" -H "Content-type: application/json" -X GET -d '{"auth":{"username":"USERNAME","api_key":"API_KEY"}}' http://localhost:3000/keys
```

##### `GET /keys/:username`
Get a specific user's `api_key` by `username`.

```bash
curl -v -H "Accept: application/json" -H "Content-type: application/json" -X GET -d '{"auth":{"username":"USERNAME","api_key":"API_KEY"}}' http://localhost:3000/keys/jake
```

### Users
#### Public
##### `GET /users`
Index of latest 20 users and their notes.

#### Admin
##### `POST /users`
Create a new user by providing a `username`.

```json
"user": {
  "username": "doug"
}
```

```bash
curl -v -H "Accept: application/json" -H "Content-type: application/json" -X POST -d ' {"user":{"username":"doug"},"auth":{"username":"USERNAME","api_key":"API_KEY"}}' http://localhost:3000/users
```

##### `DELETE /users/:username`
Delete a specific user by `username`.

```bash
curl -v -H "Accept: application/json" -H "Content-type: application/json" -X DELETE -d '{"auth":{"username":"USERNAME","api_key":"API_KEY"}}' http://localhost:3000/users/jake
```

### Notes
#### Public
##### `GET /notes`
Index of latest 20 notes.

#### Private
##### `POST /notes`
Create a new note by providing a `message`, optionally providing a hex `color`, or `image_url`.

```json
"note": {
  "message": "Hello World",
  "color": "#FB0",
  "image_url": "path/to/image.jpg",
}
```

```bash
curl -v -H "Accept: application/json" -H "Content-type: application/json" -X POST -d ' {"note":{"message":"Hello World"},"auth":{"username":"USERNAME","api_key":"API_KEY"}}' http://localhost:3000/notes
```

#### Owner/Admin
##### `PUT /notes/:hashid`
Update a note by providing a new `message`.

```json
"note": {
  "message": "Hello World"
}
```

```bash
curl -v -H "Accept: application/json" -H "Content-type: application/json" -X PUT -d ' {"note":{"message":"Hello World"},"auth":{"username":"USERNAME","api_key":"API_KEY"}}' http://localhost:3000/notes/abc123
```

##### `DELETE /notes/:hashid`
Delete a note by `hashid`.

```bash
curl -v -H "Accept: application/json" -H "Content-type: application/json" -X DELETE -d '{"auth":{"username":"USERNAME","api_key":"API_KEY"}}' http://localhost:3000/notes/1jd12
```



## Slack
You can have a Slack team create notes via a channel.

Create an `outgoing-webhook` integration in Slack, customize it.

Set the webhook url to `http://your-app.com/slack`.

Add the Slack token to your production env variable `SLACK_TOKENS`, and be sure that the value is an array `['SLACK_TEAM_1_TOKEN', 'SLACK_TEAM_2_TOKEN']`.

You can customize the response in `NotesController#slack`.

By default, notey looks for a color at the beginning of a string and an image url in the entire string.