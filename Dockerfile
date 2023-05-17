FROM node:alpine as builder

WORKDIR /build

ADD ./front_src .
RUN npm install -g pnpm &&\
 pnpm config set registry https://registry.npmmirror.com &&\
 pnpm install &&\
 pnpm build


FROM python:3.10.8

ENV DEBIAN_FRONTEND noninteractive

WORKDIR /app

RUN sed -i 's|security.debian.org/debian-security|mirrors.ustc.edu.cn/debian-security|g' /etc/apt/sources.list &&\
      sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list && apt update -y && apt install -y libcap2-bin &&\
        setcap 'cap_net_bind_service=+ep' $(realpath $(which python3))

ADD . .
RUN python3 -m pip install -r requirements.txt -i https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple

COPY --from=builder /build/dist/ /app/docker/front_dist/

ENTRYPOINT ["sh", "/app/docker/entrypoint.sh"]
