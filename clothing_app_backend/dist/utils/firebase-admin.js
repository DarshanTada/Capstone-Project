"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.admin = void 0;
exports.admin = require("firebase-admin");
exports.admin.initializeApp({
    credential: exports.admin.credential.cert({
        type: "service_account",
        project_id: "capstone-clothingapp",
        private_key_id: "b57404cf740a18afb4bef9aa5879a9c2871d6edd",
        private_key: "-----BEGIN PRIVATE KEY-----\nMIIEuwIBADANBgkqhkiG9w0BAQEFAASCBKUwggShAgEAAoIBAQC259n06GUPtC0/\nmMNztpGl8azGmX0Jbk7eO/zEJNgos/Rb31pwZfZJQ+2ANbR+GwLan3qa4Ki7ob+u\nErI9mWJ0Dba/S3O9/3mNDcR36QcAecMjeUVyNVxuaFkjDBNEZfUTxSECXiTwBsPS\n/traMdulJFBkAQ0cGREAp9sK/LmI8p3BAmHeVpr9AWAq6zSnLjlaajDSFYE5yd44\niRVhVxbWi7kEGz0BEg3k3hMOhqAdMrS58D2n4/kX6IiM8IxeXkfV0rxFAI2peTtp\n92wUUb3wooVlcZjkoc7oTolWQpsfyUSbwuk50OZdnKI1qpTszZPY3Tl8v/rVMmN5\nevNOB6X7AgMBAAECgf8jPzVr/LInqeZjsGH56oomxcEwhGOUGFhv0HTlV4mlo7LI\nrEIWvDoPObKLAnkbKW64sq2YgF1ZIH0lDnVKvu7kw7/JHWvbMWA7I8FjWi9Uks0I\nCQFZAO95rKIrdChCW2OJwR3wrDPHYtuvIsMJ8+cKlp+R+0yLcvPT1y+0Q6ooDu/M\nFLfkPp4BlcHJ30HFb2vtDZEnqxjQHeLlu8v+6NtuZmVL+c22lIJfNdYlagTnfTTv\nFUm9XAM0vP5cGT2n8lBGvJq5GvFzZPu4H73Gii+ULE9FibFCF9gRS/paKEnzRXff\nu6D0CPppR5mIOrbKEMu+ECDRBtKNoEpxd6EVDgECgYEA8Njvcg0UbEQDYXhDnhw5\nj72IGb9nBRZuAKzYZp3u7AFjWSP17/L51JAlWyUj4PBk3gTkXlaS5S27hcr63czj\nWW/Yfzq4Kl9nHk6NgOmkcAlYWIG16UkK58G/Mpa3pq5+piKwOq/wZydCxR7cbMjp\ni//nQ4FwyrWi/VhXuobJhDsCgYEAwmm2UNMuPrfxYtBBTEkX/H6+qsApt+krQ4a+\nYJmv2X8RDmwOSzWd/QoRlTJ2pU59serkqp2GQWm9RbVficmWw7p5ILVNlEvHNnaI\nZMTk2yA86pT09CApZlESj+vQRukx9e9hXt6mCrvukDpJa4C1wDHoy10ZtcNJShgD\nte01CUECgYBCcod1PtiQmh8YqBZ3q6/R0WeYOu9QPwTwWL+HaDE/mY5wTHSQ08dL\nds1nnRKN/6TEgDMFN/tlET34Rqz5vopG5Y2kZG3k+tc3TFLL6yn74wgluvuWNhm1\nIQYADgbzDJdSfKWEO4Am5XUNb1s/BBszDdIfFLoqovwpy1LA2mkEewKBgQC04gZv\nTQ1J7Xr5pSocACYBFyvvUrt+EcPfIA8hcdzbUA5ejMr/zvMf665QUpNxWoY4c4Qt\n+kJfujIQGaC6YoWTtnvcotN7lsXTNpXQrCECgAwtdkoymXnraKMMpSszzuRdHkxK\nKH30nsZoCtMk4qw4Fjeyfvzc0MXv2kgZjIo8AQKBgFm1n8oBEfoMNLbtmq7Vp/is\nFY1tVQgQSZDLvfKNpemYedmIW0ttxYcIDTs0LLER4pg7XIe1SsV7OZ46dWtZ4c8U\nf4t/XhVi5U9TMWsjioj9IA3psJoyC3sVOLKE+LzLrjLKePaVbMCfSvTmTvVaS9f1\nspY2JofqKakXxuj+DaV3\n-----END PRIVATE KEY-----\n",
        client_email: "firebase-adminsdk-fbsvc@capstone-clothingapp.iam.gserviceaccount.com",
        client_id: "107983235935750306338",
        auth_uri: "https://accounts.google.com/o/oauth2/auth",
        token_uri: "https://oauth2.googleapis.com/token",
        auth_provider_x509_cert_url: "https://www.googleapis.com/oauth2/v1/certs",
        client_x509_cert_url: "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc%40capstone-clothingapp.iam.gserviceaccount.com",
        universe_domain: "googleapis.com",
    }),
});
