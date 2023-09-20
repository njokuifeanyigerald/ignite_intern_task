# Use an official Node.js runtime as a parent image
FROM node:lts

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install app dependencies
RUN npm install

# Copy your application code into the container
COPY . .

# Expose the port your app is listening on
EXPOSE 3000

# Define the command to run your application
CMD ["node", "app.js"]
