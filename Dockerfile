FROM node:22-bookworm-slim

WORKDIR /app

RUN apt-get update \
    && apt-get install -y --no-install-recommends openssl ca-certificates python3 make g++ \
    && rm -rf /var/lib/apt/lists/*

RUN npm install -g npm@10.8.2 --no-audit --no-fund

COPY package.json ./

RUN npm install --package-lock=false --ignore-scripts --no-audit --no-fund

RUN npm rebuild argon2 --no-audit --no-fund

COPY prisma ./prisma

RUN ./node_modules/.bin/prisma generate

COPY . .

EXPOSE 3000

CMD ["sh", "-c", "npx prisma migrate deploy && node src/server.js"]
