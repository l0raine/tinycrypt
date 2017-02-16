

	static inline uint32_t xorf(uint32_t x, uint32_t y, uint32_t z)
	{
		return x ^ y ^ z;
	}

	static inline uint32_t ff1(uint32_t x, uint32_t y, uint32_t z)
	{
		return (x & y) ^ (x & z) ^ (y & z);
	}

	static inline uint32_t gg1(uint32_t x, uint32_t y, uint32_t z)
	{
		return (x & y) ^ (~x & z);
	}

	static inline uint32_t p0(uint32_t x)
	{
		return x ^ rotatel32(x, 9) ^ rotatel32(x, 17);
	}

	static inline uint32_t p1(uint32_t x)
	{
		return x ^ rotatel32(x, 15) ^ rotatel32(x, 23);
	}


	void update(const uint8_t* data, size_t len)
	{
		if (pos && pos + len >= 64)
		{
			memcpy(&m[0] + pos, data, 64 - pos);
			transform(&m[0], 1);
			len -= 64 - pos;
			total += (64 - pos) * 8;
			data += 64 - pos;
			pos = 0;
		}
		if (len >= 64)
		{
			size_t blocks = len / 64;
			size_t bytes = blocks * 64;
			transform(data, blocks);
			len -= bytes;
			total += (bytes)* 8;
			data += bytes;
		}
		memcpy(&m[0] + pos, data, len);
		pos += len;
		total += len * 8;
	}

	void init()
	{
		H[0] = 0x7380166f;
		H[1] = 0x4914b2b9;
		H[2] = 0x172442d7;
		H[3] = 0xda8a0600;
		H[4] = 0xa96f30bc;
		H[5] = 0x163138aa;
		H[6] = 0xe38dee4d;
		H[7] = 0xb0fb0e4e;
		pos = 0;
		total = 0;
	};

	void transform(const uint8_t* mp, uint64_t num_blks)
	{
		for (uint64_t blk = 0; blk < num_blks; blk++)
		{
			uint32_t M[16];
			for (uint32_t i = 0; i < 64 / 4; i++)
			{
				M[i] = swap_uint32((reinterpret_cast<const uint32_t*>(mp)[blk * 16 + i]));
			}

			uint32_t W[68];
			uint32_t W2[64];
      
			for (int t = 0; t <= 15; t++)
				W[t] = M[t];
			
      for (int t = 16; t <= 67; t++)
				W[t] = p1(W[t - 16] ^ 
                  W[t -  9] ^ 
        rotatel32(W[t -  3], 15)) ^ 
        rotatel32(W[t - 13],  7) ^ 
                  W[t -  6];
			
      for (int t = 0; t <= 63; t++)
				W2[t] = W[t] ^ W[t + 4];

			uint32_t a = H[0];
			uint32_t b = H[1];
			uint32_t c = H[2];
			uint32_t d = H[3];
			uint32_t e = H[4];
			uint32_t f = H[5];
			uint32_t g = H[6];
			uint32_t h = H[7];


			for (int t = 0; t <= 15; t++)
			{
				uint32_t ss1 = 
        rotatel32((rotatel32(a, 12) + 
        e + rotatel32(0x79cc4519, t)), 7);
        
				uint32_t ss2 = ss1 ^ rotatel32(a, 12);
				uint32_t tt1 = xorf(a, b, c) + d + ss2 + W2[t];
				uint32_t tt2 = xorf(e, f, g) + h + ss1 + W[t];
				d = c;
				c = rotatel32(b, 9);
				b = a;
				a = tt1;
				h = g;
				g = rotatel32(f, 19);
				f = e;
				e = p0(tt2);

			}
			for (int t = 16; t <= 63; t++)
			{
				uint32_t ss1 = rotatel32((rotatel32(a, 12) + 
        e + rotatel32(0x7a879d8a, t)), 7);
        
				uint32_t ss2 = ss1 ^ rotatel32(a, 12);
				uint32_t tt1 = ff1(a, b, c) + d + ss2 + W2[t];
				uint32_t tt2 = gg1(e, f, g) + h + ss1 + W[t];
        
				d = c;
				c = rotatel32(b, 9);
				b = a;
				a = tt1;
				h = g;
				g = rotatel32(f, 19);
				f = e;
				e = p0(tt2);

			}

			H[0] ^= a;
			H[1] ^= b;
			H[2] ^= c;
			H[3] ^= d;
			H[4] ^= e;
			H[5] ^= f;
			H[6] ^= g;
			H[7] ^= h;
		}
	}

	void final(uint8_t* hash)
	{
		m[pos++] = 0x80;
		if (pos > 56)
		{
			memset(&m[0] + pos, 0, 64 - pos);
			transform(&m[0], 1);
			pos = 0;
		}
		memset(&m[0] + pos, 0, 56 - pos);
		uint64_t mlen = swap_uint64(total);
		memcpy(&m[0] + (64 - 8), &mlen, 64 / 8);
		transform(&m[0], 1);
		for (int i = 0; i < 8; i++)
		{
			H[i] = swap_uint32(H[i]);
		}
		memcpy(hash, H, 32);
	}

