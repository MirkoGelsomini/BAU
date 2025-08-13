# dashboard/Dockerfile

FROM node:18

WORKDIR /app
COPY package*.json dashboard.js ./

COPY src/ src/

RUN npm install

CMD ["node", "dashboard.js"]
