#ifdef GIT_SSL

#include "gitsslctx.h"
#include "global.h"

#include <openssl/ssl.h>


SSL_CTX *ssl_ctx(void)
{
    return git__ssl_ctx;
}
#endif

