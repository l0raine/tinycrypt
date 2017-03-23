; Listing generated by Microsoft (R) Optimizing Compiler Version 16.00.40219.01 

	TITLE	c:\hub\tinycrypt\block\aes\aes.c
	.686P
	.XMM
	include listing.inc
	.model	flat

INCLUDELIB LIBCMT
INCLUDELIB OLDNAMES

PUBLIC	_gf_mul2
; Function compile flags: /Ogspy
;	COMDAT _gf_mul2
_TEXT	SEGMENT
_w$ = 8							; size = 4
_gf_mul2 PROC						; COMDAT
; File c:\hub\tinycrypt\block\aes\aes.c
; Line 36
	mov	ecx, DWORD PTR _w$[esp-4]
	and	ecx, -2139062144			; 80808080H
; Line 38
	mov	eax, ecx
	xor	eax, DWORD PTR _w$[esp-4]
	shr	ecx, 7
	imul	ecx, 27					; 0000001bH
	add	eax, eax
	xor	eax, ecx
; Line 39
	ret	0
_gf_mul2 ENDP
_TEXT	ENDS
PUBLIC	_gf_mulinv
; Function compile flags: /Ogspy
;	COMDAT _gf_mulinv
_TEXT	SEGMENT
_x$ = 8							; size = 1
_gf_mulinv PROC						; COMDAT
; Line 45
	push	ebx
; Line 46
	mov	bl, BYTE PTR _x$[esp]
; Line 48
	test	bl, bl
	je	SHORT $LN1@gf_mulinv
; Line 52
	push	1
	xor	dl, dl
	call	_gf_mul2
	xor	al, 1
	mov	bl, al
	jmp	SHORT $LN16@gf_mulinv
$LL7@gf_mulinv:
	movzx	eax, bl
	push	eax
	inc	dl
	call	_gf_mul2
	xor	bl, al
$LN16@gf_mulinv:
	pop	ecx
; Line 53
	cmp	bl, BYTE PTR _x$[esp]
	jne	SHORT $LL7@gf_mulinv
; Line 55
	add	dl, 2
; Line 57
	mov	bl, 1
	je	SHORT $LN1@gf_mulinv
; Line 55
	neg	dl
	movzx	edx, dl
$LL3@gf_mulinv:
; Line 58
	movzx	eax, bl
	push	eax
	call	_gf_mul2
	xor	bl, al
	dec	edx
	pop	ecx
	jne	SHORT $LL3@gf_mulinv
$LN1@gf_mulinv:
; Line 61
	mov	al, bl
	pop	ebx
; Line 62
	ret	0
_gf_mulinv ENDP
_TEXT	ENDS
PUBLIC	_SubByte
; Function compile flags: /Ogspy
;	COMDAT _SubByte
_TEXT	SEGMENT
_x$ = 8							; size = 1
_enc$ = 12						; size = 4
_SubByte PROC						; COMDAT
; Line 70
	cmp	DWORD PTR _enc$[esp-4], 1
	jne	SHORT $LN5@SubByte
; Line 72
	push	DWORD PTR _x$[esp-4]
	call	_gf_mulinv
	pop	ecx
	push	4
	mov	cl, al
	pop	edx
$LL4@SubByte:
; Line 75
	rol	cl, 1
; Line 76
	xor	al, cl
	dec	edx
	jne	SHORT $LL4@SubByte
; Line 78
	xor	al, 99					; 00000063H
; Line 91
	ret	0
$LN5@SubByte:
; Line 81
	mov	al, BYTE PTR _x$[esp-4]
	xor	al, 99					; 00000063H
; Line 82
	rol	al, 1
; Line 83
	mov	cl, al
; Line 84
	rol	al, 2
; Line 86
	mov	dl, al
	rol	dl, 3
; Line 87
	xor	dl, cl
	xor	dl, al
; Line 88
	movzx	eax, dl
	push	eax
	call	_gf_mulinv
	pop	ecx
; Line 91
	ret	0
_SubByte ENDP
_TEXT	ENDS
PUBLIC	_SubWord
; Function compile flags: /Ogspy
;	COMDAT _SubWord
_TEXT	SEGMENT
_x$ = 8							; size = 4
_SubWord PROC						; COMDAT
; Line 96
	push	esi
	push	edi
; Line 98
	push	4
	xor	esi, esi
	pop	edi
$LL3@SubWord:
; Line 101
	push	1
	push	DWORD PTR _x$[esp+8]
	call	_SubByte
; Line 103
	shr	DWORD PTR _x$[esp+12], 8
	movzx	eax, al
	or	esi, eax
	ror	esi, 8
	dec	edi
	pop	ecx
	pop	ecx
	jne	SHORT $LL3@SubWord
; Line 105
	pop	edi
	mov	eax, esi
	pop	esi
; Line 106
	ret	0
_SubWord ENDP
_TEXT	ENDS
PUBLIC	_SubBytes
; Function compile flags: /Ogspy
;	COMDAT _SubBytes
_TEXT	SEGMENT
_state$ = 8						; size = 4
_enc$ = 12						; size = 4
_SubBytes PROC						; COMDAT
; Line 111
	push	esi
; Line 114
	mov	esi, DWORD PTR _state$[esp]
	push	edi
	push	16					; 00000010H
	pop	edi
$LL3@SubBytes:
; Line 115
	movzx	eax, BYTE PTR [esi]
	push	DWORD PTR _enc$[esp+4]
	push	eax
	call	_SubByte
	mov	BYTE PTR [esi], al
	pop	ecx
	inc	esi
	dec	edi
	pop	ecx
	jne	SHORT $LL3@SubBytes
; Line 117
	pop	edi
	pop	esi
	ret	0
_SubBytes ENDP
_TEXT	ENDS
PUBLIC	_ShiftRows
; Function compile flags: /Ogspy
;	COMDAT _ShiftRows
_TEXT	SEGMENT
tv220 = -4						; size = 4
_state$ = 8						; size = 4
_enc$ = 12						; size = 4
_ShiftRows PROC						; COMDAT
; Line 122
	push	ebp
	mov	ebp, esp
	push	ecx
; Line 126
	mov	edx, DWORD PTR _state$[ebp]
	push	ebx
	push	edi
	xor	edi, edi
	mov	DWORD PTR tv220[ebp], edi
$LL20@ShiftRows:
; Line 127
	xor	eax, eax
; Line 129
	mov	ecx, edi
	cmp	edi, 16					; 00000010H
	jae	SHORT $LN6@ShiftRows
$LL8@ShiftRows:
; Line 131
	movzx	ebx, BYTE PTR [ecx+edx]
	or	eax, ebx
	add	ecx, 4
	ror	eax, 8
	cmp	ecx, 16					; 00000010H
	jb	SHORT $LL8@ShiftRows
$LN6@ShiftRows:
; Line 134
	cmp	DWORD PTR _enc$[ebp], 1
	jne	SHORT $LN5@ShiftRows
; Line 135
	push	32					; 00000020H
	pop	ecx
	sub	ecx, DWORD PTR tv220[ebp]
; Line 136
	jmp	SHORT $LN21@ShiftRows
$LN5@ShiftRows:
; Line 137
	mov	ecx, DWORD PTR tv220[ebp]
$LN21@ShiftRows:
	rol	eax, cl
; Line 140
	mov	ecx, edi
	cmp	edi, 16					; 00000010H
	jae	SHORT $LN10@ShiftRows
$LL3@ShiftRows:
; Line 141
	mov	BYTE PTR [ecx+edx], al
	add	ecx, 4
; Line 142
	shr	eax, 8
	cmp	ecx, 16					; 00000010H
	jb	SHORT $LL3@ShiftRows
$LN10@ShiftRows:
; Line 126
	add	DWORD PTR tv220[ebp], 8
	inc	edi
	cmp	DWORD PTR tv220[ebp], 32		; 00000020H
	jb	SHORT $LL20@ShiftRows
	pop	edi
	pop	ebx
; Line 145
	leave
	ret	0
_ShiftRows ENDP
_TEXT	ENDS
PUBLIC	_MixColumn
; Function compile flags: /Ogspy
;	COMDAT _MixColumn
_TEXT	SEGMENT
_w$ = 8							; size = 4
_MixColumn PROC						; COMDAT
; Line 154
	mov	edx, DWORD PTR _w$[esp-4]
	push	esi
	mov	esi, edx
	ror	esi, 8
	mov	eax, esi
	xor	eax, edx
	push	eax
	call	_gf_mul2
	pop	ecx
	mov	ecx, edx
	rol	ecx, 16					; 00000010H
	xor	eax, ecx
	rol	edx, 8
	xor	eax, edx
	xor	eax, esi
	pop	esi
; Line 155
	ret	0
_MixColumn ENDP
_TEXT	ENDS
PUBLIC	_MixColumns
; Function compile flags: /Ogspy
;	COMDAT _MixColumns
_TEXT	SEGMENT
_state$ = 8						; size = 4
_enc$ = 12						; size = 4
_MixColumns PROC					; COMDAT
; Line 158
	push	esi
	push	edi
; Line 161
	xor	edi, edi
$LL4@MixColumns:
; Line 164
	cmp	DWORD PTR _enc$[esp+4], 0
	mov	eax, DWORD PTR _state$[esp+4]
	lea	esi, DWORD PTR [eax+edi*4]
	mov	edx, DWORD PTR [esi]
	jne	SHORT $LN1@MixColumns
; Line 165
	mov	eax, edx
	rol	eax, 16					; 00000010H
	xor	eax, edx
; Line 166
	push	eax
	call	_gf_mul2
	push	eax
	call	_gf_mul2
	pop	ecx
	pop	ecx
; Line 167
	xor	edx, eax
$LN1@MixColumns:
; Line 169
	push	edx
	call	_MixColumn
	inc	edi
	pop	ecx
	mov	DWORD PTR [esi], eax
	cmp	edi, 4
	jb	SHORT $LL4@MixColumns
; Line 171
	pop	edi
	pop	esi
	ret	0
_MixColumns ENDP
_TEXT	ENDS
PUBLIC	_AddRoundKey
; Function compile flags: /Ogspy
;	COMDAT _AddRoundKey
_TEXT	SEGMENT
_state$ = 8						; size = 4
_w$ = 12						; size = 4
_rnd$ = 16						; size = 4
_AddRoundKey PROC					; COMDAT
; Line 178
	mov	eax, DWORD PTR _rnd$[esp-4]
	mov	ecx, DWORD PTR _state$[esp-4]
	shl	eax, 4
	add	eax, DWORD PTR _w$[esp-4]
	push	esi
	push	16					; 00000010H
; Line 180
	sub	eax, ecx
	pop	esi
$LL3@AddRoundKe:
; Line 181
	mov	dl, BYTE PTR [eax+ecx]
	xor	BYTE PTR [ecx], dl
	inc	ecx
	dec	esi
	jne	SHORT $LL3@AddRoundKe
	pop	esi
; Line 183
	ret	0
_AddRoundKey ENDP
_TEXT	ENDS
PUBLIC	_aes_setkey
; Function compile flags: /Ogspy
;	COMDAT _aes_setkey
_TEXT	SEGMENT
_rcon$ = -4						; size = 4
_ctx$ = 8						; size = 4
_key$ = 12						; size = 4
_aes_setkey PROC					; COMDAT
; Line 188
	push	ebp
	mov	ebp, esp
	push	ecx
; Line 194
	mov	eax, DWORD PTR _key$[ebp]
	push	esi
	mov	esi, DWORD PTR _ctx$[ebp]
	push	edi
	push	8
	pop	edi
	mov	DWORD PTR _rcon$[ebp], 1
	mov	ecx, esi
	sub	eax, esi
	mov	edx, edi
	push	ebx
$LL9@aes_setkey:
; Line 195
	mov	ebx, DWORD PTR [eax+ecx]
	mov	DWORD PTR [ecx], ebx
	add	ecx, 4
	dec	edx
	jne	SHORT $LL9@aes_setkey
	pop	ebx
$LL6@aes_setkey:
; Line 200
	mov	edx, DWORD PTR [esi+28]
; Line 201
	mov	eax, edi
	and	eax, -2147483641			; 80000007H
	jns	SHORT $LN16@aes_setkey
	dec	eax
	or	eax, -8					; fffffff8H
	inc	eax
$LN16@aes_setkey:
	jne	SHORT $LN3@aes_setkey
; Line 202
	ror	edx, 8
; Line 203
	push	edx
	call	_SubWord
	xor	eax, DWORD PTR _rcon$[ebp]
; Line 204
	push	DWORD PTR _rcon$[ebp]
	mov	edx, eax
	call	_gf_mul2
	pop	ecx
	mov	DWORD PTR _rcon$[ebp], eax
	jmp	SHORT $LN17@aes_setkey
$LN3@aes_setkey:
; Line 205
	cmp	eax, 4
	jne	SHORT $LN1@aes_setkey
; Line 206
	push	edx
	call	_SubWord
	mov	edx, eax
$LN17@aes_setkey:
	pop	ecx
$LN1@aes_setkey:
; Line 208
	mov	eax, DWORD PTR [esi]
	xor	eax, edx
	mov	DWORD PTR [esi+32], eax
	inc	edi
	add	esi, 4
	cmp	edi, 60					; 0000003cH
	jl	SHORT $LL6@aes_setkey
	pop	edi
	pop	esi
; Line 210
	leave
	ret	0
_aes_setkey ENDP
_TEXT	ENDS
PUBLIC	_aes_encrypt
; Function compile flags: /Ogspy
;	COMDAT _aes_encrypt
_TEXT	SEGMENT
tv423 = -8						; size = 4
_round$ = -1						; size = 1
_ctx$ = 8						; size = 4
_state$ = 12						; size = 4
_enc$ = 16						; size = 4
_aes_encrypt PROC					; COMDAT
; Line 215
	push	ebp
	mov	ebp, esp
	push	ecx
	push	ecx
; Line 219
	cmp	DWORD PTR _enc$[ebp], 1
; Line 221
	mov	ecx, DWORD PTR _ctx$[ebp]
	push	esi
	mov	esi, DWORD PTR _state$[ebp]
	push	edi
	push	16					; 00000010H
	mov	eax, esi
	pop	edi
	jne	SHORT $LN8@aes_encryp
	sub	ecx, esi
$LL13@aes_encryp:
	mov	dl, BYTE PTR [ecx+eax]
	xor	BYTE PTR [eax], dl
	inc	eax
	dec	edi
	jne	SHORT $LL13@aes_encryp
; Line 223
	lea	edi, DWORD PTR [ecx+16]
	mov	DWORD PTR tv423[ebp], 13		; 0000000dH
	mov	BYTE PTR _round$[ebp], 14		; 0000000eH
$LL7@aes_encryp:
; Line 225
	push	1
	push	esi
	call	_SubBytes
; Line 226
	push	1
	push	esi
	call	_ShiftRows
; Line 227
	push	1
	push	esi
	call	_MixColumns
	add	esp, 24					; 00000018H
	push	16					; 00000010H
	mov	eax, esi
	pop	ecx
; Line 228
$LL18@aes_encryp:
	mov	dl, BYTE PTR [edi+eax]
	xor	BYTE PTR [eax], dl
	inc	eax
	dec	ecx
	jne	SHORT $LL18@aes_encryp
; Line 223
	add	edi, 16					; 00000010H
	dec	DWORD PTR tv423[ebp]
	jne	SHORT $LL7@aes_encryp
; Line 231
	jmp	SHORT $LN1@aes_encryp
$LN8@aes_encryp:
; Line 233
	add	ecx, 224				; 000000e0H
	sub	ecx, esi
$LL23@aes_encryp:
	mov	dl, BYTE PTR [ecx+eax]
	xor	BYTE PTR [eax], dl
	inc	eax
	dec	edi
	jne	SHORT $LL23@aes_encryp
; Line 235
	mov	edi, DWORD PTR _ctx$[ebp]
	sub	edi, esi
	mov	BYTE PTR _round$[ebp], 13		; 0000000dH
	add	edi, 208				; 000000d0H
$LL3@aes_encryp:
; Line 237
	push	DWORD PTR _enc$[ebp]
	push	esi
	call	_SubBytes
; Line 238
	push	DWORD PTR _enc$[ebp]
	push	esi
	call	_ShiftRows
	add	esp, 16					; 00000010H
	push	16					; 00000010H
	mov	eax, esi
	pop	ecx
; Line 239
$LL28@aes_encryp:
	mov	dl, BYTE PTR [edi+eax]
	xor	BYTE PTR [eax], dl
	inc	eax
	dec	ecx
	jne	SHORT $LL28@aes_encryp
; Line 240
	push	DWORD PTR _enc$[ebp]
	push	esi
	call	_MixColumns
	dec	BYTE PTR _round$[ebp]
	pop	ecx
	sub	edi, 16					; 00000010H
	cmp	BYTE PTR _round$[ebp], 0
	pop	ecx
	ja	SHORT $LL3@aes_encryp
$LN1@aes_encryp:
; Line 244
	push	DWORD PTR _enc$[ebp]
	push	esi
	call	_SubBytes
; Line 245
	push	DWORD PTR _enc$[ebp]
	push	esi
	call	_ShiftRows
; Line 246
	movzx	eax, BYTE PTR _round$[ebp]
	shl	eax, 4
	add	eax, DWORD PTR _ctx$[ebp]
	add	esp, 16					; 00000010H
	push	16					; 00000010H
	mov	ecx, esi
	sub	eax, esi
	pop	esi
$LL33@aes_encryp:
	mov	dl, BYTE PTR [eax+ecx]
	xor	BYTE PTR [ecx], dl
	inc	ecx
	dec	esi
	jne	SHORT $LL33@aes_encryp
	pop	edi
	pop	esi
; Line 247
	leave
	ret	0
_aes_encrypt ENDP
_TEXT	ENDS
END
