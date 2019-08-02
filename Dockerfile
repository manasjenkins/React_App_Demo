FROM nginx:alpine
RUN apk update && apk add curl && rm -rf /var/cache/apk/*
ADD ./build /usr/share/nginx/html
HEALTHCHECK --interval=10s --timeout=3s \ 
   CMD curl --fail http://localhost:80/ || exit 1
ENTRYPOINT ["nginx", "-g", "daemon off;"]