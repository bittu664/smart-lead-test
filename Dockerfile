FROM node:lts AS base

WORKDIR /app

COPY . .
RUN npm install 


FROM node:lts-buster-slim

WORKDIR /app
 
COPY --from=base  /app/ ./

EXPOSE 4000

CMD ["npm", "start"]
