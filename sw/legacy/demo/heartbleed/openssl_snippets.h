#include <stdlib.h>
#include <string.h>


//#define OPENSSL_NO_BIO
//#define OPENSSL_NO_NEXTPROTONEG
//
//struct ssl_st
//	{
//	/* protocol version
//	 * (one of SSL2_VERSION, SSL3_VERSION, TLS1_VERSION, DTLS1_VERSION)
//	 */
//	int version;
//	int type; /* SSL_ST_CONNECT or SSL_ST_ACCEPT */
//
//	//const SSL_METHOD *method; /* SSLv3 */ // SONATA
//
//	/* There are 2 BIO's even though they are normally both the
//	 * same.  This is so data can be read and written to different
//	 * handlers */
//
//#ifndef OPENSSL_NO_BIO
//	BIO *rbio; /* used by SSL_read */
//	BIO *wbio; /* used by SSL_write */
//	BIO *bbio; /* used during session-id reuse to concatenate
//		    * messages */
//#else
//	char *rbio; /* used by SSL_read */
//	char *wbio; /* used by SSL_write */
//	char *bbio;
//#endif
//	/* This holds a variable that indicates what we were doing
//	 * when a 0 or -1 is returned.  This is needed for
//	 * non-blocking IO so we know what request needs re-doing when
//	 * in SSL_accept or SSL_connect */
//	int rwstate;
//
//	/* true when we are actually in SSL_accept() or SSL_connect() */
//	int in_handshake;
//	//int (*handshake_func)(SSL *); // SONATA
//
//	/* Imagine that here's a boolean member "init" that is
//	 * switched as soon as SSL_set_{accept/connect}_state
//	 * is called for the first time, so that "state" and
//	 * "handshake_func" are properly initialized.  But as
//	 * handshake_func is == 0 until then, we use this
//	 * test instead of an "init" member.
//	 */
//
//	int server;	/* are we the server side? - mostly used by SSL_clear*/
//
//	int new_session;/* Generate a new session or reuse an old one.
//	                 * NB: For servers, the 'new' session may actually be a previously
//	                 * cached session or even the previous session unless
//	                 * SSL_OP_NO_SESSION_RESUMPTION_ON_RENEGOTIATION is set */
//	int renegotiate;/* 1 if we are renegotiating.
//	                 * 2 if we are a server and are inside a handshake
//	                 * (i.e. not just sending a HelloRequest) */
//
//	int quiet_shutdown;/* don't send shutdown packets */
//	int shutdown;	/* we have shut things down, 0x01 sent, 0x02
//			 * for received */
//	int state;	/* where we are */
//	int rstate;	/* where we are when reading */
//
//	BUF_MEM *init_buf;	/* buffer used during init */
//	void *init_msg;   	/* pointer to handshake message body, set by ssl3_get_message() */
//	int init_num;		/* amount read/written */
//	int init_off;		/* amount read/written */
//
//	/* used internally to point at a raw packet */
//	unsigned char *packet;
//	unsigned int packet_length;
//
//	struct ssl2_state_st *s2; /* SSLv2 variables */
//	struct ssl3_state_st *s3; /* SSLv3 variables */
//	struct dtls1_state_st *d1; /* DTLSv1 variables */
//
//	int read_ahead;		/* Read as many input bytes as possible
//	               	 	 * (for non-blocking reads) */
//
//	/* callback that allows applications to peek at protocol messages */
//	void (*msg_callback)(int write_p, int version, int content_type, const void *buf, size_t len, SSL *ssl, void *arg);
//	void *msg_callback_arg;
//
//	int hit;		/* reusing a previous session */
//
//	X509_VERIFY_PARAM *param;
//
//#if 0
//	int purpose;		/* Purpose setting */
//	int trust;		/* Trust setting */
//#endif
//
//	/* crypto */
//	STACK_OF(SSL_CIPHER) *cipher_list;
//	STACK_OF(SSL_CIPHER) *cipher_list_by_id;
//
//	/* These are the ones being used, the ones in SSL_SESSION are
//	 * the ones to be 'copied' into these ones */
//	int mac_flags; 
//	EVP_CIPHER_CTX *enc_read_ctx;		/* cryptographic state */
//	EVP_MD_CTX *read_hash;		/* used for mac generation */
//#ifndef OPENSSL_NO_COMP
//	COMP_CTX *expand;			/* uncompress */
//#else
//	char *expand;
//#endif
//
//	EVP_CIPHER_CTX *enc_write_ctx;		/* cryptographic state */
//	EVP_MD_CTX *write_hash;		/* used for mac generation */
//#ifndef OPENSSL_NO_COMP
//	COMP_CTX *compress;			/* compression */
//#else
//	char *compress;	
//#endif
//
//	/* session info */
//
//	/* client cert? */
//	/* This is used to hold the server certificate used */
//	struct cert_st /* CERT */ *cert;
//
//	/* the session_id_context is used to ensure sessions are only reused
//	 * in the appropriate context */
//	unsigned int sid_ctx_length;
//	unsigned char sid_ctx[SSL_MAX_SID_CTX_LENGTH];
//
//	/* This can also be in the session once a session is established */
//	SSL_SESSION *session;
//
//	/* Default generate session ID callback. */
//	GEN_SESSION_CB generate_session_id;
//
//	/* Used in SSL2 and SSL3 */
//	int verify_mode;	/* 0 don't care about verify failure.
//				 * 1 fail if verify fails */
//	int (*verify_callback)(int ok,X509_STORE_CTX *ctx); /* fail if callback returns 0 */
//
//	void (*info_callback)(const SSL *ssl,int type,int val); /* optional informational callback */
//
//	int error;		/* error bytes to be written */
//	int error_code;		/* actual code */
//
//#ifndef OPENSSL_NO_KRB5
//	KSSL_CTX *kssl_ctx;     /* Kerberos 5 context */
//#endif	/* OPENSSL_NO_KRB5 */
//
//#ifndef OPENSSL_NO_PSK
//	unsigned int (*psk_client_callback)(SSL *ssl, const char *hint, char *identity,
//		unsigned int max_identity_len, unsigned char *psk,
//		unsigned int max_psk_len);
//	unsigned int (*psk_server_callback)(SSL *ssl, const char *identity,
//		unsigned char *psk, unsigned int max_psk_len);
//#endif
//
//#ifndef OPENSSL_NO_SRP
//	SRP_CTX srp_ctx; /* ctx for SRP authentication */
//#endif
//
//	SSL_CTX *ctx;
//	/* set this flag to 1 and a sleep(1) is put into all SSL_read()
//	 * and SSL_write() calls, good for nbio debuging :-) */
//	int debug;	
//
//	/* extra application data */
//	long verify_result;
//	CRYPTO_EX_DATA ex_data;
//
//	/* for server side, keep the list of CA_dn we can use */
//	STACK_OF(X509_NAME) *client_CA;
//
//	int references;
//	unsigned long options; /* protocol behaviour */
//	unsigned long mode; /* API behaviour */
//	long max_cert_list;
//	int first_packet;
//	int client_version;	/* what was passed, used for
//				 * SSLv3/TLS rollback check */
//	unsigned int max_send_fragment;
//#ifndef OPENSSL_NO_TLSEXT
//	/* TLS extension debug callback */
//	void (*tlsext_debug_cb)(SSL *s, int client_server, int type,
//					unsigned char *data, int len,
//					void *arg);
//	void *tlsext_debug_arg;
//	char *tlsext_hostname;
//	int servername_done;   /* no further mod of servername 
//	                          0 : call the servername extension callback.
//	                          1 : prepare 2, allow last ack just after in server callback.
//	                          2 : don't call servername callback, no ack in server hello
//	                       */
//	/* certificate status request info */
//	/* Status type or -1 if no status type */
//	int tlsext_status_type;
//	/* Expect OCSP CertificateStatus message */
//	int tlsext_status_expected;
//	/* OCSP status request only */
//	STACK_OF(OCSP_RESPID) *tlsext_ocsp_ids;
//	X509_EXTENSIONS *tlsext_ocsp_exts;
//	/* OCSP response received or to be sent */
//	unsigned char *tlsext_ocsp_resp;
//	int tlsext_ocsp_resplen;
//
//	/* RFC4507 session ticket expected to be received or sent */
//	int tlsext_ticket_expected;
//#ifndef OPENSSL_NO_EC
//	size_t tlsext_ecpointformatlist_length;
//	unsigned char *tlsext_ecpointformatlist; /* our list */
//	size_t tlsext_ellipticcurvelist_length;
//	unsigned char *tlsext_ellipticcurvelist; /* our list */
//#endif /* OPENSSL_NO_EC */
//
//	/* draft-rescorla-tls-opaque-prf-input-00.txt information to be used for handshakes */
//	void *tlsext_opaque_prf_input;
//	size_t tlsext_opaque_prf_input_len;
//
//	/* TLS Session Ticket extension override */
//	TLS_SESSION_TICKET_EXT *tlsext_session_ticket;
//
//	/* TLS Session Ticket extension callback */
//	tls_session_ticket_ext_cb_fn tls_session_ticket_ext_cb;
//	void *tls_session_ticket_ext_cb_arg;
//
//	/* TLS pre-shared secret session resumption */
//	tls_session_secret_cb_fn tls_session_secret_cb;
//	void *tls_session_secret_cb_arg;
//
//	SSL_CTX * initial_ctx; /* initial ctx, used to store sessions */
//
//#ifndef OPENSSL_NO_NEXTPROTONEG
//	/* Next protocol negotiation. For the client, this is the protocol that
//	 * we sent in NextProtocol and is set when handling ServerHello
//	 * extensions.
//	 *
//	 * For a server, this is the client's selected_protocol from
//	 * NextProtocol and is set when handling the NextProtocol message,
//	 * before the Finished message. */
//	unsigned char *next_proto_negotiated;
//	unsigned char next_proto_negotiated_len;
//#endif
//
//#define session_ctx initial_ctx
//
//	STACK_OF(SRTP_PROTECTION_PROFILE) *srtp_profiles;  /* What we'll do */
//	SRTP_PROTECTION_PROFILE *srtp_profile;            /* What's been chosen */
//
//	unsigned int tlsext_heartbeat;  /* Is use of the Heartbeat extension negotiated?
//	                                   0: disabled
//	                                   1: enabled
//	                                   2: enabled, but not allowed to send Requests
//	                                 */
//	unsigned int tlsext_hb_pending; /* Indicates if a HeartbeatRequest is in flight */
//	unsigned int tlsext_hb_seq;     /* HeartbeatRequest sequence number */
//#else
//#define session_ctx ctx
//#endif /* OPENSSL_NO_TLSEXT */
//	};
//
//
//typedef struct ssl_st SSL;

// from code -------------------------------

typedef struct ssl3_record_st
	{
/*r */	int type;               /* type of record */
/*rw*/	unsigned int length;    /* How many bytes available */
/*rw*/	unsigned int orig_len;  /* How many bytes were available before padding
				   was removed? This is used to implement the
				   MAC check in constant time for CBC records.
				 */
/*r */	unsigned int off;       /* read/write offset into 'buf' */
/*rw*/	unsigned char *data;    /* pointer to the record data */
/*rw*/	unsigned char *input;   /* where the decode bytes are */
/*r */	unsigned char *comp;    /* only used with decompression - malloc()ed */
/*r */  unsigned long epoch;    /* epoch number, needed by DTLS1 */
/*r */  unsigned char seq_num[8]; /* sequence number, needed by DTLS1 */
	} SSL3_RECORD;

// Not from code -------------------------------

typedef struct ssl_st SSL;

struct ssl3_state_st
	{
		SSL3_RECORD rrec;	/* each decoded record goes in here */
		int (*ssl_dispatch_alert)(SSL *s);
	};


struct ssl_st {
	int version;
	struct ssl3_state_st *s3; /* SSLv3 variables */

	int rwstate;

	unsigned int tlsext_hb_pending; /* Indicates if a HeartbeatRequest is in flight */
	unsigned int tlsext_hb_seq;     /* HeartbeatRequest sequence number */

	void (*msg_callback)(int write_p, int version, int content_type, const void *buf, size_t len, SSL *ssl, void *arg);
	void *msg_callback_arg;
};

#define OPENSSL_malloc malloc
#define OPENSSL_free free

void OPENSSL_assert(bool statement) {
	if (!statement) {
		putstr("Assert failed\n");
		while (true) {};
	}
}

// So random it's not random anymore
int RAND_pseudo_bytes(unsigned char *buf, int num) {
	for (size_t i = 0; i < num; ++i) buf[i] = i;
	return 0;
}

void dtls1_stop_timer(SSL *s) {};


int do_dtls1_write(SSL *s, int type, const unsigned char *buf, unsigned int len, int create_empty_fragment)
	{
	return 0;
	}


// from code -------------------------------

#define n2s(c,s)	((s=(((unsigned int)(c[0]))<< 8)| \
			    (((unsigned int)(c[1]))    )),c+=2)
#define s2n(s,c)	((c[0]=(unsigned char)(((s)>> 8)&0xff), \
			  c[1]=(unsigned char)(((s)    )&0xff)),c+=2)

#define TLS1_HB_REQUEST		1
#define TLS1_HB_RESPONSE	2
#define TLS1_RT_HEARTBEAT		24
#define SSL3_RT_MAX_PLAIN_LENGTH		16384
#define SSL_NOTHING	1


/* Call this to write data in records of type 'type'
 * It will return <= 0 if not all data has been sent or non-blocking IO.
 */
int dtls1_write_bytes(SSL *s, int type, const void *buf, int len)
	{
	int i;

	OPENSSL_assert(len <= SSL3_RT_MAX_PLAIN_LENGTH);
	s->rwstate=SSL_NOTHING;
	i=do_dtls1_write(s, type, buf, len, 0);
	return i;
	}


/// Datagram Transport Layer Security 1, Heartbeat
int
dtls1_process_heartbeat(SSL *s)
	{
	unsigned char *p = &s->s3->rrec.data[0], *pl;
	unsigned short hbtype;
	unsigned int payload;
	unsigned int padding = 16; /* Use minimum padding */

	/* Read type and payload length first */
	hbtype = *p++;
	n2s(p, payload);
	pl = p;

	if (s->msg_callback)
		s->msg_callback(0, s->version, TLS1_RT_HEARTBEAT,
			&s->s3->rrec.data[0], s->s3->rrec.length,
			s, s->msg_callback_arg);

	if (hbtype == TLS1_HB_REQUEST)
		{
		unsigned char *buffer, *bp;
		int r;

		/* Allocate memory for the response, size is 1 byte
		 * message type, plus 2 bytes payload length, plus
		 * payload, plus padding
		 */
		buffer = OPENSSL_malloc(1 + 2 + payload + padding);
		bp = buffer;

		/* Enter response type, length and copy payload */
		*bp++ = TLS1_HB_RESPONSE;
		s2n(payload, bp);
		memcpy(bp, pl, payload);
		bp += payload;
		/* Random padding */
		RAND_pseudo_bytes(bp, padding);

		r = dtls1_write_bytes(s, TLS1_RT_HEARTBEAT, buffer, 3 + payload + padding);

		if (r >= 0 && s->msg_callback)
			s->msg_callback(1, s->version, TLS1_RT_HEARTBEAT,
				buffer, 3 + payload + padding,
				s, s->msg_callback_arg);

		OPENSSL_free(buffer);

		if (r < 0)
			return r;
		}
	else if (hbtype == TLS1_HB_RESPONSE)
		{
		unsigned int seq;

		/* We only send sequence numbers (2 bytes unsigned int),
		 * and 16 random bytes, so we just try to read the
		 * sequence number */
		n2s(pl, seq);

		if (payload == 18 && seq == s->tlsext_hb_seq)
			{
			dtls1_stop_timer(s);
			s->tlsext_hb_seq++;
			s->tlsext_hb_pending = 0;
			}
		}

	return 0;
	}



// ---------------------------------------------------------------------------
