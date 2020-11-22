FROM nginx:alpine

# BUILD Websockify (C version) & cleanup
RUN apk add --no-cache --virtual .build-deps git openssl-dev musl-dev gcc make && \
    git clone https://github.com/novnc/websockify-other.git /wsckfy && \
    cd /wsckfy/c && \
    make && \
    mv /wsckfy/c/websockify /bin/websockify && \
    rm -rf /wsckfy && \
    apk del .build-deps && \
    cd /

# GET noVNC & cleanup
RUN wget -qO- https://github.com/novnc/noVNC/archive/v1.2.0.tar.gz | \
    tar xz -C /usr/share/nginx/html --strip 1 && \
    rm -rf /usr/share/nginx/html/vendor/browser-es-module-loader/dist/babel-worker.js && \
    rm -rf /usr/share/nginx/html/docs && \
    rm -rf /usr/share/nginx/html/snap && \
    rm -rf /usr/share/nginx/html/tests 

# Inject noVNC customizations (JS)
RUN echo "window.addEventListener('load', () => {\
UI.forceSetting('resize', 'remote');\
UI.forceSetting('show_dot', true);\
UI.forceSetting('reconnect', true);\
UI.forceSetting('reconnect_delay', 100);\
UI.connect();\
})" >> /usr/share/nginx/html/app/ui.js

# Inject noVNC customizations (CSS: hide toolbar)
RUN echo "#noVNC_control_bar_anchor {display:none !important;}" >> \
/usr/share/nginx/html/app/styles/base.css

COPY nginx.conf /etc/nginx/nginx.conf
COPY start.sh /start.sh

# CONFIGURE default VNC endpoint
ENV VNC_SERVER=localhost \
    VNC_PORT=5900

# START
CMD sh /start.sh
