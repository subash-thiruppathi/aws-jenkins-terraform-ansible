# 1. Use an official, lightweight Node.js image as the base
FROM node:18-alpine

# 2. Set the working directory inside the container
WORKDIR /usr/src/app

# 3. Copy package.json and install dependencies
COPY package*.json ./
RUN npm install

# 4. Copy the rest of your application code
COPY . .

# 5. Expose port 80 to the outside world
EXPOSE 80

# 6. The command to start the server
CMD ["node", "server.js"]