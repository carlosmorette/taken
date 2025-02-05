FROM elixir:1.16-alpine

WORKDIR /app

COPY mix.exs mix.lock ./
RUN mix deps.get --only prod

COPY . .
RUN mix compile

CMD ["mix", "phx.server"]