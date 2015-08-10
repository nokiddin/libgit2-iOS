#ifdef GIT_SSL
#define GIT_OPENSSL 1

#include "gitsslctx.h"

#include <openssl/ssl.h>
extern SSL_CTX* git__ssl_ctx;

SSL_CTX *ssl_ctx(void)
{
    return git__ssl_ctx;
}
#endif

