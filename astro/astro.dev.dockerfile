FROM --platform=arm64 node:lts-alpine

WORKDIR /app

COPY frontend .
RUN npm install && npm install -g astro

EXPOSE 3000

CMD ["npm", "run", "dev", "--host", "0.0.0.0", "--port", "3000"]

