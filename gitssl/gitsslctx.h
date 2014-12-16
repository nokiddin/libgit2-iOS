
#ifndef _gitsslctx_h
#define _gitsslctx_h


#include "global.h"


#ifdef GIT_SSL
# include <openssl/ssl.h>
#endif

SSL_CTX *ssl_ctx(void);

#endif


