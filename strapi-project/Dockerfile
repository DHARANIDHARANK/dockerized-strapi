
FROM node:18

# Create and change to the app directory.
WORKDIR /usr/src/app

# Copy application dependency manifests to the container image.
# A wildcard is used to ensure both package.json AND package-lock.json are copied.
COPY package*.json ./

# Install dependencies.
RUN npm install

# Copy local code to the container image.
COPY . .

# Set environment variables
ENV NODE_ENV production
ENV APP_KEYS=myKeyA,myKeyB
ENV JWT_SECRET=myDefaultSecret
ENV API_TOKEN_SALT=defaultApiSalt



RUN npm run build
# Open port 1337
EXPOSE 1337

# Run the web service on container startup.
CMD [ "npm", "run", "start" ]

