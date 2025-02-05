FROM elixir:1.16-alpine

RUN apk update --no-cache & apk add --no-cache git 

WORKDIR /app

COPY mix.exs mix.lock ./
RUN mix deps.get --only prod

ENV POSTGRES_HOST=postgres

COPY . .
RUN mix compile

CMD ["mix", "phx.server"]