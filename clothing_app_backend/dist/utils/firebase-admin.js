"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.admin = void 0;
exports.admin = require("firebase-admin");
exports.admin.initializeApp({
    credential: exports.admin.credential.cert({
        "type": "service_account",
        "project_id": "safarpe-9ff17",
        "private_key_id": "72c8f21b602d88e1975e91dc5684a5cea9b16cbf",
        "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDOlwWqDAkhloGi\nJIXfaGdTk8IqlFR93OG/cNiUgIswdP6Z3jPYnuUGasPGAQ5zT5QJ7QkNkU96DH3Q\nJInH07hBEcCFnUmOONJegY1c2JwGuasPmGQzGNgKE/JbLCFSIA3HqRcb4TLFOC5v\nngRNY0VsEoIZO0yx8zJbAy4BD/RaBz+ShNA0TjOgsPUlOuEtyCCpCU+WoQtQs3nD\nL4tZdIOEJ9qz9CGy05jae4wTEzmWTYBy6ZKsBLL5CGrAGe2DdxoULladMcZyQla5\n7qzUdJ9Yjd9D6/hJ0LcNmRY2hUs0D+QBqIDdgCfVqHosgiEtzKyzgqZN4wt8RH55\nt/NSq0mzAgMBAAECggEADofFwLeW/tNIq+BYwCVmOxUl73u+U5nxENd9jDhcUdyw\nuZ7M07wdTK2+tlMFsquStH4FCHzDc8ikIrsnK7Ri/cSjX2J4NXYeqcH/8NtVYg22\nD+M+jO9+5nqPrcT1VQLnJTdp5i6ZNRDmBzi8gbrtO5QzrVWj59I8pPUcy7tVCu3e\nJIxa7R2Oq+2XUObD8fRtBhJnS1bbCFrDBpVwFXJojZJcK76D8wNdSEqg44W5jWNH\njsQYapQTi+KS6VoqmYbXjCkO8fdgO9E4cwiCMp21S8Q1x0+qx8nxMW+oB/38TJ0j\nOL52mV/PjLf3uNDUYvls58XQhC5XIkPJ7d3jT3E2VQKBgQD3yyM32N0UyUzrCJ/4\nVX3hdm6W+w0V8AeHkvoaFTZ9c9FhOCZ9I9AiEjMFQqERP7DrASqJ8NSwgEIdoxoI\nNhmKN7fxbzMZ+99FGaQieC2ivRiktmqGDIezv+wGuVJmlB+o0U+cQNE6le24izMc\nbCdDHF4KBg9iT78iXv2gVqcxNQKBgQDVboyVIz0mM233lyTfh7ZaDNfKwUeS5ePE\nkqalc0+Lt0KwkiyvOGKqpUy1rfNquiTnTdUu9YeyRx4PzdObdFQIfQsQLZ2xszP8\nbKvihO+aeVRubG+kMqMt0vltJQ9VOLKfG3uOnwx0wj3bGyev0p+PWEpGzwNSgHha\nbf0ZH7KURwKBgDkv65fW9+b1MkhH/Etex6eCIrG7jOCUPdifJhNg8+tuEFOElvVo\nj39dfeLn5q5JabZC1aNyLlPxtdCLNNXSToCkrVIOHNgRVgznhwbhf37Ab3CMHPeE\n6sikMX+3w3mjE89tRxdDqkYAFhXyIkCcAU+uu1FK5sAEsZLoI1aeyQVFAoGAJ2sr\ne7/uY0fMX5YCsWYXP7pvgHsCBReAYaXUMWqCnoNSRdo5doMrdejhqgxekK+gcTfm\nz615SmvoGXMiSevKOWcey/Yg0dkPGOfZNxTmS9lsxpgwZlsT2DrG5mmZ01uNYeVp\nhIXLfyUA157ETazQ22CrFzjUnEAt+kWmISXBjbECgYEA78AIEKlOI0njL59DpLGu\n3AeF3c9ea8FJ6APFunCt7cqI0xLmcOoVnlE5rm293DHfdS7lfy1OPUjooaHyN459\nunwNK2eYV6v9SkXFZtO5IDJe5LEI4cRfXp7N1vgxs+hu4IICPIuOd1tJNc6dbGRp\nXAdOjPEqOqIkWM/MKpLJSVI=\n-----END PRIVATE KEY-----\n",
        "client_email": "firebase-adminsdk-gxyzw@safarpe-9ff17.iam.gserviceaccount.com",
        "client_id": "100165782740760626718",
        "auth_uri": "https://accounts.google.com/o/oauth2/auth",
        "token_uri": "https://oauth2.googleapis.com/token",
        "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
        "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-gxyzw%40safarpe-9ff17.iam.gserviceaccount.com"
    }),
});
