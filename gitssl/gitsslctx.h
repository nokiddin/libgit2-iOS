
#ifndef _gitsslctx_h
#define _gitsslctx_h

#ifdef GIT_SSL
#define GIT_OPENSSL 1
#endif



#ifdef GIT_SSL
# include <openssl/ssl.h>
#endif

SSL_CTX *ssl_ctx(void);

#endif


