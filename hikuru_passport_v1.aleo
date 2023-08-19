program hikuru_passport_v1.aleo;

struct TokenId:
    data1 as u128;
    data2 as u128;

struct BaseURI:
    data0 as u128;
    data1 as u128;
    data2 as u128;
    data3 as u128;

struct UserName:
    data0 as u128;
    data1 as u128;
    data2 as u128;
    data3 as u128;

struct SymbolBits:
    data as u128;

struct PassPort:
    passport_owner as address;
    username as UserName;
    time as u64;
    scores as u32;
    status as u32;

record NFT:
    owner as address.private;
    data as TokenId.private;
    edition as scalar.private;
    passport as PassPort.private;


mapping toggle_settings:
	key left as u8.public;
	value right as u32.public;


mapping general_settings:
	key left as u8.public;
	value right as u128.public;


mapping identity:
	key left as address.public;
	value right as PassPort.public;


mapping identity_via_username:
	key left as UserName.public;
	value right as PassPort.public;

closure get_status:
    input r0 as u32;
    lte r0 20u32 into r1;
    lt r0 80u32 into r2;
    not r1 into r3;
    and r3 r2 into r4;
    ternary r4 1u32 2u32 into r5;
    ternary r1 0u32 r5 into r6;
    output r6 as u32;


function initialize_collection:
    input r0 as u128.public;
    input r1 as u128.public;
    input r2 as BaseURI.public;
    assert.eq self.caller aleo1geqft8epz9kurdv7fqfrwe4l75dw240jvhmt9x7ennftz9gt2q8q86hzjl;

    finalize r0 r1 r2;

finalize initialize_collection:
    input r0 as u128.public;
    input r1 as u128.public;
    input r2 as BaseURI.public;
    get.or_use toggle_settings[0u8] 0u32 into r3;
    assert.eq r3 0u32;
    set 0u128 into general_settings[0u8];
    set r0 into general_settings[1u8];
    set r1 into general_settings[2u8];
    set r2.data0 into general_settings[3u8];
    set r2.data1 into general_settings[4u8];
    set r2.data2 into general_settings[5u8];
    set r2.data3 into general_settings[6u8];
    set 5u32 into toggle_settings[0u8];
    set 0u32 into toggle_settings[1u8];


function update_base_uri:
    input r0 as BaseURI.public;
    assert.eq self.caller aleo1geqft8epz9kurdv7fqfrwe4l75dw240jvhmt9x7ennftz9gt2q8q86hzjl;

    finalize r0;

finalize update_base_uri:
    input r0 as BaseURI.public;
    get.or_use toggle_settings[0u8] 1u32 into r1;
    assert.eq r1 1u32;
    set r0.data0 into general_settings[3u8];
    set r0.data1 into general_settings[4u8];
    set r0.data2 into general_settings[5u8];
    set r0.data3 into general_settings[6u8];


function mint:
    input r0 as UserName.public;
    input r1 as TokenId.public;
    input r2 as scalar.public;
    input r3 as u64.public;
    input r4 as u32.public;
    call get_status r4 into r5;
    cast self.caller r0 r3 r4 r5 into r6 as PassPort;
    cast self.caller r1 r2 r6 into r7 as NFT.record;
    output r7 as NFT.record;

    finalize self.caller r0 r6;

finalize mint:
    input r0 as address.public;
    input r1 as UserName.public;
    input r2 as PassPort.public;
    get identity[r0] into r3;
    or r3.time 0u64 into r4;
    get identity_via_username[r1] into r5;
    or r5.time 0u64 into r6;
    assert.eq r4 0u64;
    assert.eq r6 0u64;
    get.or_use toggle_settings[0u8] 0u32 into r7;
    assert.neq r7 0u32;
    set r2 into identity[r0];
    set r2 into identity_via_username[r1];


function update_passport:
    input r0 as address.private;
    input r1 as UserName.private;
    input r2 as scalar.private;
    input r3 as u64.private;
    input r4 as u32.private;
    assert.eq r0 self.caller;
    call get_status r4 into r5;

    finalize r0 r1 r2 r4 r5;

finalize update_passport:
    input r0 as address.public;
    input r1 as UserName.public;
    input r2 as scalar.public;
    input r3 as u32.public;
    input r4 as u32.public;
    get identity[r0] into r5;
    or r5.time 0u64 into r6;
    get identity_via_username[r1] into r7;
    or r7.time 0u64 into r8;
    assert.eq r6 0u64;
    assert.eq r8 0u64;
    get identity[r0] into r9;
    cast r9.passport_owner r1 r9.time r3 r4 into r10 as PassPort;
    get.or_use toggle_settings[0u8] 0u32 into r11;
    assert.neq r11 0u32;
    set r10 into identity[r0];
    set r10 into identity_via_username[r1];
