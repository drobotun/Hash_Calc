unit GOST2012Hash;

interface

uses Windows, SysUtils, Classes;


function GOST2012_HashFileToString(const FileName: string;
                                         hashSize : integer) : string;

implementation

type

   IVTable = array [0..63] of byte;
   PiTable = array [0..255] of byte;
    ATable = array [0..63] of int64;
  TauTable = array [0..63] of byte;
    CTable = array [0..11, 0..63] of byte;

type TGOST2012_Context =
  record
    buffer : array [0..63] of byte;
      hash : array [0..63] of byte;
         h : array [0..63] of byte;
         N : array [0..63] of byte;
     Sigma : array [0..63] of byte;
       v_0 : array [0..63] of byte;
     v_512 : array [0..63] of byte;
     buf_size : cardinal;
    hash_size : cardinal;
  end;

type
  PGOST2012_Context = ^TGOST2012_Context;
{var
  CTX : TGOST2012_Context; }

const
  //значения подстановки Pi
  Pi : PiTable = (
    252, 238, 221,  17, 207, 110,  49,  22,
    251, 196, 250, 218,  35, 197,   4,  77, 
    233, 119, 240, 219, 147,  46, 153, 186, 
     23,  54, 241, 187,  20, 205,  95, 193, 
    249,  24, 101,  90, 226,  92, 239,  33, 
    129,  28,  60,  66, 139,   1, 142,  79, 
      5, 132,   2, 174, 227, 106, 143, 160, 
      6,  11, 237, 152, 127, 212, 211,  31, 
    235,  52,  44,  81, 234, 200,  72, 171, 
    242,  42, 104, 162, 253,  58, 206, 204, 
    181, 112,  14,  86,   8,  12, 118,  18, 
    191, 114,  19,  71, 156, 183,  93, 135, 
     21, 161, 150,  41,  16, 123, 154, 199, 
    243, 145, 120, 111, 157, 158, 178, 177, 
     50, 117,  25,  61, 255,  53, 138, 126, 
    109,  84, 198, 128, 195, 189,  13,  87, 
    223, 245,  36, 169,  62, 168,  67, 201, 
    215, 121, 214, 246, 124,  34, 185,   3, 
    224,  15, 236, 222, 122, 148, 176, 188, 
    220, 232,  40,  80,  78,  51,  10,  74, 
    167, 151,  96, 115,  30,   0,  98,  68, 
     26, 184,  56, 130, 100, 159,  38,  65, 
    173,  69,  70, 146,  39,  94,  85,  47, 
    140, 163, 165, 125, 105, 213, 149,  59, 
      7,  88, 179,  64, 134, 172,  29, 247, 
     48,  55, 107, 228, 136, 217, 231, 137, 
    225,  27, 131,  73,  76,  63, 248, 254, 
    141,  83, 170, 144, 202, 216, 133,  97, 
     32, 113, 103, 164,  45,  43,   9,  91, 
    203, 155,  37, 208, 190, 229, 108,  82, 
     89, 166, 116, 210, 230, 244, 180, 192, 
    209, 102, 175, 194,  57,  75,  99, 182);

  //матрица линейного преобразования A
  A : Atable = (
    $8e20faa72ba0b470,
    $47107ddd9b505a38,
    $ad08b0e0c3282d1c,
    $d8045870ef14980e,
    $6c022c38f90a4c07,
    $3601161cf205268d,
    $1b8e0b0e798c13c8,
    $83478b07b2468764,
    $a011d380818e8f40,
    $5086e740ce47c920,
    $2843fd2067adea10,
    $14aff010bdd87508,
    $0ad97808d06cb404,
    $05e23c0468365a02,
    $8c711e02341b2d01,
    $46b60f011a83988e,
    $90dab52a387ae76f,
    $486dd4151c3dfdb9,
    $24b86a840e90f0d2,
    $125c354207487869,
    $092e94218d243cba,
    $8a174a9ec8121e5d,
    $4585254f64090fa0,
    $accc9ca9328a8950,
    $9d4df05d5f661451,
    $c0a878a0a1330aa6,
    $60543c50de970553,
    $302a1e286fc58ca7,
    $18150f14b9ec46dd,
    $0c84890ad27623e0,
    $0642ca05693b9f70,
    $0321658cba93c138,
    $86275df09ce8aaa8,
    $439da0784e745554,
    $afc0503c273aa42a,
    $d960281e9d1d5215,
    $e230140fc0802984,
    $71180a8960409a42,
    $b60c05ca30204d21,
    $5b068c651810a89e,
    $456c34887a3805b9,
    $ac361a443d1c8cd2,
    $561b0d22900e4669,
    $2b838811480723ba,
    $9bcf4486248d9f5d,
    $c3e9224312c8c1a0,
    $effa11af0964ee50,
    $f97d86d98a327728,
    $e4fa2054a80b329c,
    $727d102a548b194e,
    $39b008152acb8227,
    $9258048415eb419d,
    $492c024284fbaec0,
    $aa16012142f35760,
    $550b8e9e21f7a530,
    $a48b474f9ef5dc18,
    $70a6a56e2440598e,
    $3853dc371220a247,
    $1ca76e95091051ad,
    $0edd37c48a08a6d8,
    $07e095624504536c,
    $8d70c431ac02a736,
    $c83862965601dd1b,
    $641c314b2b8ee083);

  //значения перестановки Tau
  Tau : TauTable = (
    0, 8,  16, 24, 32, 40, 48, 56,
    1, 9,  17, 25, 33, 41, 49, 57,
    2, 10, 18, 26, 34, 42, 50, 58,
    3, 11, 19, 27, 35, 43, 51, 59,
    4, 12, 20, 28, 36, 44, 52, 60,
    5, 13, 21, 29, 37, 45, 53, 61,
    6, 14, 22, 30, 38, 46, 54, 62,
    7, 15, 23, 31, 39, 47, 55, 63);

  //итерационные константы C1 - C12
  C : CTable = (
       ($07, $45, $a6, $f2, $59, $65, $80, $dd,
        $23, $4d, $74, $cc, $36, $74, $76, $05,
        $15, $d3, $60, $a4, $08, $2a, $42, $a2,
        $01, $69, $67, $92, $91, $e0, $7c, $4b,
        $fc, $c4, $85, $75, $8d, $b8, $4e, $71,
        $16, $d0, $45, $2e, $43, $76, $6a, $2f,
        $1f, $7c, $65, $c0, $81, $2f, $cb, $eb,
        $e9, $da, $ca, $1e, $da, $5b, $08, $b1),

       ($b7, $9b, $b1, $21, $70, $04, $79, $e6,
        $56, $cd, $cb, $d7, $1b, $a2, $dd, $55,
        $ca, $a7, $0a, $db, $c2, $61, $b5, $5c,
        $58, $99, $d6, $12, $6b, $17, $b5, $9a,
        $31, $01, $b5, $16, $0f, $5e, $d5, $61,
        $98, $2b, $23, $0a, $72, $ea, $fe, $f3,
        $d7, $b5, $70, $0f, $46, $9d, $e3, $4f,
        $1a, $2f, $9d, $a9, $8a, $b5, $a3, $6f),

       ($b2, $0a, $ba, $0a, $f5, $96, $1e, $99,
        $31, $db, $7a, $86, $43, $f4, $b6, $c2,
        $09, $db, $62, $60, $37, $3a, $c9, $c1,
        $b1, $9e, $35, $90, $e4, $0f, $e2, $d3,
        $7b, $7b, $29, $b1, $14, $75, $ea, $f2,
        $8b, $1f, $9c, $52, $5f, $5e, $f1, $06,
        $35, $84, $3d, $6a, $28, $fc, $39, $0a,
        $c7, $2f, $ce, $2b, $ac, $dc, $74, $f5),

       ($2e, $d1, $e3, $84, $bc, $be, $0c, $22,
        $f1, $37, $e8, $93, $a1, $ea, $53, $34,
        $be, $03, $52, $93, $33, $13, $b7, $d8,
        $75, $d6, $03, $ed, $82, $2c, $d7, $a9,
        $3f, $35, $5e, $68, $ad, $1c, $72, $9d,
        $7d, $3c, $5c, $33, $7e, $85, $8e, $48,
        $dd, $e4, $71, $5d, $a0, $e1, $48, $f9,
        $d2, $66, $15, $e8, $b3, $df, $1f, $ef),

       ($57, $fe, $6c, $7c, $fd, $58, $17, $60,
        $f5, $63, $ea, $a9, $7e, $a2, $56, $7a,
        $16, $1a, $27, $23, $b7, $00, $ff, $df,
        $a3, $f5, $3a, $25, $47, $17, $cd, $bf,
        $bd, $ff, $0f, $80, $d7, $35, $9e, $35,
        $4a, $10, $86, $16, $1f, $1c, $15, $7f,
        $63, $23, $a9, $6c, $0c, $41, $3f, $9a,
        $99, $47, $47, $ad, $ac, $6b, $ea, $4b),

       ($6e, $7d, $64, $46, $7a, $40, $68, $fa,
        $35, $4f, $90, $36, $72, $c5, $71, $bf,
        $b6, $c6, $be, $c2, $66, $1f, $f2, $0a,
        $b4, $b7, $9a, $1c, $b7, $a6, $fa, $cf,
        $c6, $8e, $f0, $9a, $b4, $9a, $7f, $18,
        $6c, $a4, $42, $51, $f9, $c4, $66, $2d,
        $c0, $39, $30, $7a, $3b, $c3, $a4, $6f,
        $d9, $d3, $3a, $1d, $ae, $ae, $4f, $ae),

       ($93, $d4, $14, $3a, $4d, $56, $86, $88,
        $f3, $4a, $3c, $a2, $4c, $45, $17, $35,
        $04, $05, $4a, $28, $83, $69, $47, $06,
        $37, $2c, $82, $2d, $c5, $ab, $92, $09,
        $c9, $93, $7a, $19, $33, $3e, $47, $d3,
        $c9, $87, $bf, $e6, $c7, $c6, $9e, $39,
        $54, $09, $24, $bf, $fe, $86, $ac, $51,
        $ec, $c5, $aa, $ee, $16, $0e, $c7, $f4),

       ($1e, $e7, $02, $bf, $d4, $0d, $7f, $a4,
        $d9, $a8, $51, $59, $35, $c2, $ac, $36,
        $2f, $c4, $a5, $d1, $2b, $8d, $d1, $69,
        $90, $06, $9b, $92, $cb, $2b, $89, $f4,
        $9a, $c4, $db, $4d, $3b, $44, $b4, $89,
        $1e, $de, $36, $9c, $71, $f8, $b7, $4e,
        $41, $41, $6e, $0c, $02, $aa, $e7, $03,
        $a7, $c9, $93, $4d, $42, $5b, $1f, $9b),

       ($db, $5a, $23, $83, $51, $44, $61, $72,
        $60, $2a, $1f, $cb, $92, $dc, $38, $0e,
        $54, $9c, $07, $a6, $9a, $8a, $2b, $7b,
        $b1, $ce, $b2, $db, $0b, $44, $0a, $80,
        $84, $09, $0d, $e0, $b7, $55, $d9, $3c,
        $24, $42, $89, $25, $1b, $3a, $7d, $3a,
        $de, $5f, $16, $ec, $d8, $9a, $4c, $94,
        $9b, $22, $31, $16, $54, $5a, $8f, $37),

       ($ed, $9c, $45, $98, $fb, $c7, $b4, $74,
        $c3, $b6, $3b, $15, $d1, $fa, $98, $36,
        $f4, $52, $76, $3b, $30, $6c, $1e, $7a,
        $4b, $33, $69, $af, $02, $67, $e7, $9f,
        $03, $61, $33, $1b, $8a, $e1, $ff, $1f,
        $db, $78, $8a, $ff, $1c, $e7, $41, $89,
        $f3, $f3, $e4, $b2, $48, $e5, $2a, $38,
        $52, $6f, $05, $80, $a6, $de, $be, $ab),

       ($1b, $2d, $f3, $81, $cd, $a4, $ca, $6b,
        $5d, $d8, $6f, $c0, $4a, $59, $a2, $de,
        $98, $6e, $47, $7d, $1d, $cd, $ba, $ef,
        $ca, $b9, $48, $ea, $ef, $71, $1d, $8a,
        $79, $66, $84, $14, $21, $80, $01, $20,
        $61, $07, $ab, $eb, $bb, $6b, $fa, $d8,
        $94, $fe, $5a, $63, $cd, $c6, $02, $30,
        $fb, $89, $c8, $ef, $d0, $9e, $cd, $7b),

       ($20, $d7, $1b, $f1, $4a, $92, $bc, $48,
        $99, $1b, $b2, $d9, $d5, $17, $f4, $fa,
        $52, $28, $e1, $88, $aa, $a4, $1d, $e7,
        $86, $cc, $91, $18, $9d, $ef, $80, $5d,
        $9b, $9f, $21, $30, $d4, $12, $20, $f8,
        $77, $1d, $df, $bc, $32, $3c, $a4, $cd,
        $7a, $b1, $49, $04, $b0, $80, $13, $d2,
        $ba, $31, $16, $f1, $67, $e7, $8e, $37)
    );

function GOST2012_HashToString(h : array of byte;
                        hashSize : integer) : string;
var
  i : byte;
begin
  if hashSize = 512 then
    for i:= 0 to 63 do
      result := result + inttohex(h[i],2)
  else
    for i:= 32 to 63 do
      result := result + inttohex(h[i],2);
end;

procedure GOST2012_Add512(const a : array of byte;
                          const b : array of byte;
                            var c : array of byte);
var
  i, sum : integer;
begin
  sum := 0;
  for i := 0 to 63 do
  begin
    sum := a[i] + b[i] + (sum shr 8);
    c[i] := sum and $ff;
  end;
end;

procedure GOST2012_X(const a : array of byte;
                       const b : array of byte;
                         var c : array of byte);
var
  i : byte;
begin
  for i := 0 to 63 do
    c[i] := a[i] xor b[i];
end;

procedure GOST2012_P(var vect : array of byte);
var
  i : byte;
  t : array [0..63] of byte;
begin
  for i := 63 downto 0 do
    t[i] := vect[Tau[i]];
  Move(t, vect, 64);
end;

procedure GOST2012_S(var vect : array of byte);
var
  i : byte;
begin
  for i := 63 downto 0 do
    vect[i] := Pi[vect[i]];
end;

procedure GOST2012_L(var vect : array of byte);
var
  i, j : byte;
     v_in : array [0..7] of int64;
     v_out : array [0..7] of int64;
     p : PByte;
begin
  p := @vect;
  v_in[0] := uint64(Pointer(Cardinal(p))^);
  v_in[1] := uint64(Pointer(Cardinal(p) + 8)^);
  v_in[2] := uint64(Pointer(Cardinal(p) + 16)^);
  v_in[3] := uint64(Pointer(Cardinal(p) + 24)^);
  v_in[4] := uint64(Pointer(Cardinal(p) + 32)^);
  v_in[5] := uint64(Pointer(Cardinal(p) + 40)^);
  v_in[6] := uint64(Pointer(Cardinal(p) + 48)^);
  v_in[7] := uint64(Pointer(Cardinal(p) + 56)^);
  FillChar(v_out, 64, 0);
  for i := 7 downto 0 do
    for j := 63 downto 0 do
      if ((v_in[i] shr j) and 1) = 1 then
        v_out[i] := v_out[i] xor A[63 - j];
  Move(v_out, vect, 64);

end;

procedure GOST2012_GetKey(var K : array of byte;
                              i : byte);
begin
  GOST2012_X(K, C[i], K);
  GOST2012_S(K);
  GOST2012_P(K);
  GOST2012_L(K);
end;

procedure GOST2012_E(K : array of byte;
               const m : array of byte;
              var vect : array of byte);
var
  i : byte;
begin
  Move(K, K, 64);
  GOST2012_X(K, m, vect);
  for i := 0 to 11 do
    begin
      GOST2012_S(vect);
      GOST2012_P(vect);
      GOST2012_L(vect);
      GOST2012_GetKey(K, i);
      GOST2012_X(vect, K, vect);
    end;
end;

procedure GOST2012_g(var h : array of byte;
                   const N : array of byte;
                   const m : array of byte);
var
  t, K : array [0..63] of byte;
begin
  GOST2012_X(N, h, K);
  GOST2012_S(K);
  GOST2012_P(K);
  GOST2012_L(K);
  GOST2012_E(K, m, t);
  GOST2012_X(t, h, t);
  GOST2012_X(t, m, h);
end;

procedure GOST2012_Init(var CTX : TGOST2012_Context;
                      hash_size : integer);
begin
  FillChar(CTX, sizeof(CTX), 0);
  if hash_size = 256 then
    FillChar(CTX.h, 64, 1)
  else
    FillChar(CTX.h, 64, 0);
  CTX.hash_size := hash_size;
  CTX.v_512[1] := 2;
end;

procedure GOST2012_Padding(var CTX : TGOST2012_Context);
var
  v : array [0..63] of byte;
begin
  if (CTX.buf_size < 64) then
  begin
    FillChar(v, 64, 0);
    Move(CTX.buffer, v, 64);
    v[CTX.buf_size] := 1;
    Move(v, CTX.buffer, 64);
  end;
end;

procedure GOST2012_Stage2(var CTX : TGOST2012_Context;
                       const data : array of byte);
begin
  GOST2012_G(CTX.h, CTX.N, data);
  GOST2012_Add512(CTX.N, CTX.v_512, CTX.N);
  GOST2012_Add512(CTX.Sigma, data, CTX.Sigma);
end;

procedure GOST2012_Stage3(var CTX : TGOST2012_Context);
var
  v : array [0..63] of byte;
begin
  FillChar(v, 64, 0);
  v[1] := ((CTX.buf_size * 8) shr 8) and $ff;
  v[0] := (CTX.buf_size * 8) and $ff;
  GOST2012_Padding(CTX);

  GOST2012_G(CTX.h, CTX.N, CTX.buffer);

  GOST2012_Add512(CTX.N, v, CTX.N);

  GOST2012_Add512(CTX.Sigma, CTX.buffer, CTX.Sigma);

  GOST2012_G(CTX.h, CTX.v_0, CTX.N);

  GOST2012_G(CTX.h, CTX.v_0, CTX.Sigma);
  Move(CTX.h, CTX.hash, 64);
end;

procedure GOST2012_Update(var CTX : TGOST2012_Context;
                             data : array of byte;
                              len : cardinal);
var
  chk_size : cardinal;
  v : array [0..63] of byte;
  start : cardinal;
begin
  start := 0;
  while ((len > 63) and (CTX.buf_size = 0)) do
  begin
    Move(data[start], v, 64);
    GOST2012_Stage2(CTX, v);
    start := start + 64;
    len := len - 64;
  end;
  while (len <> 0) do
  begin
    chk_size := 64 - CTX.buf_size;
    if (chk_size > len) then
      chk_size := len;
    Move(data[start], v, 64);
    Move(v, CTX.buffer[CTX.buf_size], chk_size);
    CTX.buf_size := CTX.buf_size + chk_size;
    len := len - chk_size;
    start := start - chk_size;
    if (CTX.buf_size = 64) then
    begin
      GOST2012_Stage2(CTX, CTX.buffer);
      CTX.buf_size := 0;
    end;
  end;
end;

procedure GOST2012_Final(var CTX : TGOST2012_Context);
begin
  GOST2012_Stage3(CTX);
  CTX.buf_size := 0;
end;

function GOST2012_HashFileToString(const FileName: string;
                                        hashSize : integer) : string;
var
         CTX : TGOST2012_Context;
           F : file;
         buf : array [0..4096] of byte;
   ReadBytes : cardinal;
begin

  GOST2012_Init(CTX, hashSize);
  try
    AssignFile(F, FileName);
    Reset(F, 1);
    repeat
      BlockRead(F, buf,4096, ReadBytes);
      GOST2012_Update(CTX, buf, ReadBytes);
    until(ReadBytes = 0);
  finally

  end;
  GOST2012_Final(CTX);
  finalize(buf);
  CloseFile(F);
  result := GOST2012_HashToString(CTX.hash, hashSize);
end;

end.

