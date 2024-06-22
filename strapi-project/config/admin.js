module.exports = ({ env }) => ({
  auth: {
    secret: env('ADMIN_JWT_SECRET','defaultAdminSecret'),
  },
  apiToken: {
    salt: env('API_TOKEN_SALT', 'defaultApiSalt'),
  },
  transfer: {
    token: {
      salt: env('TRANSFER_TOKEN_SALT', 'defaultApiSalt'),
    },
  },
  flags: {
    nps: env.bool('FLAG_NPS', true),
    promoteEE: env.bool('FLAG_PROMOTE_EE', true),
  },
});
