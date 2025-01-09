FROM node:alpine
WORKDIR /app
COPY . .
RUN npm install
COPY package.json  .
EXPOSE 5000
CMD [ "npm" ,"start" ]