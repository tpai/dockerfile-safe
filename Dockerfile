FROM debian:11-slim AS base

WORKDIR /app

# Add user with uid and gid
RUN addgroup --gid 1000 app
RUN adduser --gecos "" --uid 1000 --ingroup app --shell /bin/sh --disabled-password app

FROM base

# Assign permission to source code
COPY --chown=0:app --chmod=750 main.sh /app

USER 1000:1000

CMD ["sh", "main.sh"]
