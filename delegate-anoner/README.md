# Delegate Anoner

At Agora we have lots of delegate statements and we want to make sure that they are as clean as possible when sharing with the world.

This little script removes all the personal information from the delegate statements and puts them into S3 for easy access.

## Usage

Update the `app.rb` file with your S3 credentials, DynamoDB credentials, and the bucket name you want to use.

Then run:

```ruby app.rb```