# # Uso de debian para cloudwatch
# FROM debian:latest as build

# RUN apt-get update &&  \
#     apt-get install -y ca-certificates curl && \
#     rm -rf /var/lib/apt/lists/*

# RUN curl -O https://s3.amazonaws.com/amazoncloudwatch-agent/debian/amd64/latest/amazon-cloudwatch-agent.deb && \
#     dpkg -i -E amazon-cloudwatch-agent.deb && \
#     rm -rf /tmp/* && \
#     rm -rf /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-config-wizard && \
#     rm -rf /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl && \
#     rm -rf /opt/aws/amazon-cloudwatch-agent/bin/config-downloader

# COPY ./amazon-cloudwatch-agent.json /opt/aws/amazon-cloudwatch-agent/etc/
# # Use the official Node.js Alpine image as the base image
FROM node:20-alpine

# Set the working directory
WORKDIR /usr/src/app

# Install Chromium
ENV CHROME_BIN="/usr/bin/chromium-browser" \
    PUPPETEER_SKIP_CHROMIUM_DOWNLOAD="true" \
    NODE_ENV="production"
RUN set -x \
    && apk update \
    && apk upgrade \
    && apk add --no-cache \
    udev \
    ttf-freefont \
    chromium

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./
# COPY --from=build /opt/aws/amazon-cloudwatch-agent /opt/aws/amazon-cloudwatch-agent

# Install the dependencies
RUN npm ci --only=production --ignore-scripts

# Copy the rest of the source code to the working directory
COPY . .

# Expose the port the API will run on
EXPOSE 3000

# Start the CloudWatch Agent
# CMD ["/opt/aws/amazon-cloudwatch-agent/bin/start-amazon-cloudwatch-agent && npm start"]
CMD ["npm", "start"]
