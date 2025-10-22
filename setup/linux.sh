#!/bin/bash
echo "Creating AWS .env file for Linux..."

# Check if AWS CLI is available
if ! command -v aws &> /dev/null; then
    echo "ERROR: AWS CLI not found. Please install AWS CLI first."
    exit 1
fi

# Get AWS credentials from AWS CLI
AWS_ACCESS_KEY_ID=$(aws configure get aws_access_key_id 2>/dev/null)
AWS_SECRET_ACCESS_KEY=$(aws configure get aws_secret_access_key 2>/dev/null)
AWS_DEFAULT_REGION=$(aws configure get region 2>/dev/null)

# Check if credentials were found
if [ -z "$AWS_ACCESS_KEY_ID" ]; then
    echo "ERROR: No AWS credentials found. Run 'aws configure' first."
    exit 1
fi

# Set default region if not configured
if [ -z "$AWS_DEFAULT_REGION" ]; then
    AWS_DEFAULT_REGION="us-east-1"
fi

# Create .env file
cat > .env << EOF
AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION
EOF

# Add session token if available
if [ ! -z "$AWS_SESSION_TOKEN" ]; then
    echo "AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN" >> .env
fi

echo "Done! .env file created with AWS credentials."
echo "Check .env file for your credentials."