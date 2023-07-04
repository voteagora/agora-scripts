require "aws-sdk-dynamodb"
require "aws-sdk-s3"
require "json"

dynamodb = Aws::DynamoDB::Client.new(region: "your-region")
s3 = Aws::S3::Resource.new(region: "your-region")

# Replace 'table-name' with your DynamoDB table name
table_name = "table-name"

# Setup your S3 bucket and filename
bucket_name = "bucket-name"
file_name = "output.json"

params = {
  table_name: table_name,
  projection_expression: "#data",
  expression_attribute_names: {
    "#data" => "data", # replace "data" with your actual JSON column name
  },
}

begin
  # scan DynamoDB table
  result = dynamodb.scan(params)

  File.open(file_name, "w") do |file|
    result.items.each do |item|
      # parse the JSON object
      json_blob = JSON.parse(item["data"])

      # strip out the email, key, and value
      stripped_data = {
        email: json_blob["email"],
        key: json_blob["key"],
        value: json_blob["value"],
      }

      # write to the file
      file.write(stripped_data.to_json + "\n")
    end
  end

  # upload to S3
  obj = s3.bucket(bucket_name).object(file_name)
  obj.upload_file(file_name)
rescue Aws::DynamoDB::Errors::ServiceError => error
  puts "Unable to scan table:"
  puts "#{error.message}"
end
