// Shinylive 0.10.12
// Copyright 2026 Posit, PBC
var __create = Object.create;
var __defProp = Object.defineProperty;
var __getOwnPropDesc = Object.getOwnPropertyDescriptor;
var __getOwnPropNames = Object.getOwnPropertyNames;
var __getProtoOf = Object.getPrototypeOf;
var __hasOwnProp = Object.prototype.hasOwnProperty;
var __typeError = (msg) => {
  throw TypeError(msg);
};
var __require = /* @__PURE__ */ ((x3) => typeof require !== "undefined" ? require : typeof Proxy !== "undefined" ? new Proxy(x3, {
  get: (a, b3) => (typeof require !== "undefined" ? require : a)[b3]
}) : x3)(function(x3) {
  if (typeof require !== "undefined") return require.apply(this, arguments);
  throw Error('Dynamic require of "' + x3 + '" is not supported');
});
var __commonJS = (cb, mod) => function __require2() {
  return mod || (0, cb[__getOwnPropNames(cb)[0]])((mod = { exports: {} }).exports, mod), mod.exports;
};
var __copyProps = (to, from, except, desc) => {
  if (from && typeof from === "object" || typeof from === "function") {
    for (let key of __getOwnPropNames(from))
      if (!__hasOwnProp.call(to, key) && key !== except)
        __defProp(to, key, { get: () => from[key], enumerable: !(desc = __getOwnPropDesc(from, key)) || desc.enumerable });
  }
  return to;
};
var __toESM = (mod, isNodeMode, target) => (target = mod != null ? __create(__getProtoOf(mod)) : {}, __copyProps(
  // If the importer is in node compatibility mode or this is not an ESM
  // file that has been converted to a CommonJS file using a Babel-
  // compatible transform (i.e. "__esModule" has not been set), then set
  // "default" to the CommonJS "module.exports" for node compatibility.
  isNodeMode || !mod || !mod.__esModule ? __defProp(target, "default", { value: mod, enumerable: true }) : target,
  mod
));
var __accessCheck = (obj, member, msg) => member.has(obj) || __typeError("Cannot " + msg);
var __privateGet = (obj, member, getter) => (__accessCheck(obj, member, "read from private field"), getter ? getter.call(obj) : member.get(obj));
var __privateAdd = (obj, member, value) => member.has(obj) ? __typeError("Cannot add the same private member more than once") : member instanceof WeakSet ? member.add(obj) : member.set(obj, value);
var __privateMethod = (obj, member, method) => (__accessCheck(obj, member, "access private method"), method);

// node_modules/ws/browser.js
var require_browser = __commonJS({
  "node_modules/ws/browser.js"(exports, module2) {
    "use strict";
    module2.exports = function() {
      throw new Error(
        "ws does not work in the browser. Browser clients must use the native WebSocket object"
      );
    };
  }
});

// src/awaitable-queue.ts
var AwaitableQueue = class {
  constructor() {
    this._buffer = [];
    this._resolve = null;
    this._promise = null;
    this._notifyAll();
  }
  async _wait() {
    await this._promise;
  }
  _notifyAll() {
    if (this._resolve) {
      this._resolve();
    }
    this._promise = new Promise((resolve) => this._resolve = resolve);
  }
  async dequeue() {
    while (this._buffer.length === 0) {
      await this._wait();
    }
    return this._buffer.shift();
  }
  enqueue(x3) {
    this._buffer.push(x3);
    this._notifyAll();
  }
};

// src/utils.ts
function uint8ArrayToString(buf) {
  let result = "";
  for (let i = 0; i < buf.length; i++) {
    result += String.fromCharCode(buf[i]);
  }
  return result;
}

// node_modules/webr/dist/webr.js
var gr = Object.create;
var Et = Object.defineProperty;
var br = Object.getOwnPropertyDescriptor;
var wr = Object.getOwnPropertyNames;
var xr = Object.getPrototypeOf;
var Er = Object.prototype.hasOwnProperty;
var g = (r5, e) => () => (e || r5((e = { exports: {} }).exports, e), e.exports);
var vr = (r5, e, t, s2) => {
  if (e && typeof e == "object" || typeof e == "function") for (let n of wr(e)) !Er.call(r5, n) && n !== t && Et(r5, n, { get: () => e[n], enumerable: !(s2 = br(e, n)) || s2.enumerable });
  return r5;
};
var vt = (r5, e, t) => (t = r5 != null ? gr(xr(r5)) : {}, vr(e || !r5 || !r5.__esModule ? Et(t, "default", { value: r5, enumerable: true }) : t, r5));
var Pt = g((As, Pr) => {
  Pr.exports = { _makeLong: "", basename: "", default: "", delimiter: "", dirname: "", extname: "", format: "", isAbsolute: "", join: "", matchesGlob: "", normalize: "", parse: "", posix: "", relative: "", resolve: "", sep: "", toNamespacedPath: "", win32: "" };
});
var fe = g((_2) => {
  "use strict";
  Object.defineProperty(_2, "__esModule", { value: true });
  _2.getUint64 = _2.getInt64 = _2.setInt64 = _2.setUint64 = _2.UINT32_MAX = void 0;
  _2.UINT32_MAX = 4294967295;
  function Wr(r5, e, t) {
    let s2 = t / 4294967296, n = t;
    r5.setUint32(e, s2), r5.setUint32(e + 4, n);
  }
  _2.setUint64 = Wr;
  function Ar(r5, e, t) {
    let s2 = Math.floor(t / 4294967296), n = t;
    r5.setUint32(e, s2), r5.setUint32(e + 4, n);
  }
  _2.setInt64 = Ar;
  function Dr(r5, e) {
    let t = r5.getInt32(e), s2 = r5.getUint32(e + 4);
    return t * 4294967296 + s2;
  }
  _2.getInt64 = Dr;
  function Or(r5, e) {
    let t = r5.getUint32(e), s2 = r5.getUint32(e + 4);
    return t * 4294967296 + s2;
  }
  _2.getUint64 = Or;
});
var _e = g((E2) => {
  "use strict";
  var Qe, Ye, Ze;
  Object.defineProperty(E2, "__esModule", { value: true });
  E2.utf8DecodeTD = E2.TEXT_DECODER_THRESHOLD = E2.utf8DecodeJs = E2.utf8EncodeTE = E2.TEXT_ENCODER_THRESHOLD = E2.utf8EncodeJs = E2.utf8Count = void 0;
  var Nt = fe(), ke = (typeof process > "u" || ((Qe = process == null ? void 0 : process.env) === null || Qe === void 0 ? void 0 : Qe.TEXT_ENCODING) !== "never") && typeof TextEncoder < "u" && typeof TextDecoder < "u";
  function Cr(r5) {
    let e = r5.length, t = 0, s2 = 0;
    for (; s2 < e; ) {
      let n = r5.charCodeAt(s2++);
      if ((n & 4294967168) === 0) {
        t++;
        continue;
      } else if ((n & 4294965248) === 0) t += 2;
      else {
        if (n >= 55296 && n <= 56319 && s2 < e) {
          let o = r5.charCodeAt(s2);
          (o & 64512) === 56320 && (++s2, n = ((n & 1023) << 10) + (o & 1023) + 65536);
        }
        (n & 4294901760) === 0 ? t += 3 : t += 4;
      }
    }
    return t;
  }
  E2.utf8Count = Cr;
  function Ir(r5, e, t) {
    let s2 = r5.length, n = t, o = 0;
    for (; o < s2; ) {
      let a = r5.charCodeAt(o++);
      if ((a & 4294967168) === 0) {
        e[n++] = a;
        continue;
      } else if ((a & 4294965248) === 0) e[n++] = a >> 6 & 31 | 192;
      else {
        if (a >= 55296 && a <= 56319 && o < s2) {
          let i = r5.charCodeAt(o);
          (i & 64512) === 56320 && (++o, a = ((a & 1023) << 10) + (i & 1023) + 65536);
        }
        (a & 4294901760) === 0 ? (e[n++] = a >> 12 & 15 | 224, e[n++] = a >> 6 & 63 | 128) : (e[n++] = a >> 18 & 7 | 240, e[n++] = a >> 12 & 63 | 128, e[n++] = a >> 6 & 63 | 128);
      }
      e[n++] = a & 63 | 128;
    }
  }
  E2.utf8EncodeJs = Ir;
  var me2 = ke ? new TextEncoder() : void 0;
  E2.TEXT_ENCODER_THRESHOLD = ke ? typeof process < "u" && ((Ye = process == null ? void 0 : process.env) === null || Ye === void 0 ? void 0 : Ye.TEXT_ENCODING) !== "force" ? 200 : 0 : Nt.UINT32_MAX;
  function Ur(r5, e, t) {
    e.set(me2.encode(r5), t);
  }
  function Nr(r5, e, t) {
    me2.encodeInto(r5, e.subarray(t));
  }
  E2.utf8EncodeTE = me2?.encodeInto ? Nr : Ur;
  var Br = 4096;
  function jr(r5, e, t) {
    let s2 = e, n = s2 + t, o = [], a = "";
    for (; s2 < n; ) {
      let i = r5[s2++];
      if ((i & 128) === 0) o.push(i);
      else if ((i & 224) === 192) {
        let c = r5[s2++] & 63;
        o.push((i & 31) << 6 | c);
      } else if ((i & 240) === 224) {
        let c = r5[s2++] & 63, R2 = r5[s2++] & 63;
        o.push((i & 31) << 12 | c << 6 | R2);
      } else if ((i & 248) === 240) {
        let c = r5[s2++] & 63, R2 = r5[s2++] & 63, d = r5[s2++] & 63, M2 = (i & 7) << 18 | c << 12 | R2 << 6 | d;
        M2 > 65535 && (M2 -= 65536, o.push(M2 >>> 10 & 1023 | 55296), M2 = 56320 | M2 & 1023), o.push(M2);
      } else o.push(i);
      o.length >= Br && (a += String.fromCharCode(...o), o.length = 0);
    }
    return o.length > 0 && (a += String.fromCharCode(...o)), a;
  }
  E2.utf8DecodeJs = jr;
  var Lr = ke ? new TextDecoder() : null;
  E2.TEXT_DECODER_THRESHOLD = ke ? typeof process < "u" && ((Ze = process == null ? void 0 : process.env) === null || Ze === void 0 ? void 0 : Ze.TEXT_DECODER) !== "force" ? 200 : 0 : Nt.UINT32_MAX;
  function Fr(r5, e, t) {
    let s2 = r5.subarray(e, e + t);
    return Lr.decode(s2);
  }
  E2.utf8DecodeTD = Fr;
});
var tt = g((Me) => {
  "use strict";
  Object.defineProperty(Me, "__esModule", { value: true });
  Me.ExtData = void 0;
  var et = class {
    constructor(e, t) {
      this.type = e, this.data = t;
    }
  };
  Me.ExtData = et;
});
var Ae = g((We) => {
  "use strict";
  Object.defineProperty(We, "__esModule", { value: true });
  We.DecodeError = void 0;
  var rt = class r5 extends Error {
    constructor(e) {
      super(e);
      let t = Object.create(r5.prototype);
      Object.setPrototypeOf(this, t), Object.defineProperty(this, "name", { configurable: true, enumerable: false, value: r5.name });
    }
  };
  We.DecodeError = rt;
});
var st = g((w2) => {
  "use strict";
  Object.defineProperty(w2, "__esModule", { value: true });
  w2.timestampExtension = w2.decodeTimestampExtension = w2.decodeTimestampToTimeSpec = w2.encodeTimestampExtension = w2.encodeDateToTimeSpec = w2.encodeTimeSpecToTimestamp = w2.EXT_TIMESTAMP = void 0;
  var Vr = Ae(), Bt = fe();
  w2.EXT_TIMESTAMP = -1;
  var qr = 4294967296 - 1, Jr = 17179869184 - 1;
  function jt({ sec: r5, nsec: e }) {
    if (r5 >= 0 && e >= 0 && r5 <= Jr) if (e === 0 && r5 <= qr) {
      let t = new Uint8Array(4);
      return new DataView(t.buffer).setUint32(0, r5), t;
    } else {
      let t = r5 / 4294967296, s2 = r5 & 4294967295, n = new Uint8Array(8), o = new DataView(n.buffer);
      return o.setUint32(0, e << 2 | t & 3), o.setUint32(4, s2), n;
    }
    else {
      let t = new Uint8Array(12), s2 = new DataView(t.buffer);
      return s2.setUint32(0, e), (0, Bt.setInt64)(s2, 4, r5), t;
    }
  }
  w2.encodeTimeSpecToTimestamp = jt;
  function Lt(r5) {
    let e = r5.getTime(), t = Math.floor(e / 1e3), s2 = (e - t * 1e3) * 1e6, n = Math.floor(s2 / 1e9);
    return { sec: t + n, nsec: s2 - n * 1e9 };
  }
  w2.encodeDateToTimeSpec = Lt;
  function Ft(r5) {
    if (r5 instanceof Date) {
      let e = Lt(r5);
      return jt(e);
    } else return null;
  }
  w2.encodeTimestampExtension = Ft;
  function Vt(r5) {
    let e = new DataView(r5.buffer, r5.byteOffset, r5.byteLength);
    switch (r5.byteLength) {
      case 4:
        return { sec: e.getUint32(0), nsec: 0 };
      case 8: {
        let t = e.getUint32(0), s2 = e.getUint32(4), n = (t & 3) * 4294967296 + s2, o = t >>> 2;
        return { sec: n, nsec: o };
      }
      case 12: {
        let t = (0, Bt.getInt64)(e, 4), s2 = e.getUint32(0);
        return { sec: t, nsec: s2 };
      }
      default:
        throw new Vr.DecodeError(`Unrecognized data size for timestamp (expected 4, 8, or 12): ${r5.length}`);
    }
  }
  w2.decodeTimestampToTimeSpec = Vt;
  function qt(r5) {
    let e = Vt(r5);
    return new Date(e.sec * 1e3 + e.nsec / 1e6);
  }
  w2.decodeTimestampExtension = qt;
  w2.timestampExtension = { type: w2.EXT_TIMESTAMP, encode: Ft, decode: qt };
});
var Ce = g((Oe) => {
  "use strict";
  Object.defineProperty(Oe, "__esModule", { value: true });
  Oe.ExtensionCodec = void 0;
  var De = tt(), Hr = st(), Re = class {
    constructor() {
      this.builtInEncoders = [], this.builtInDecoders = [], this.encoders = [], this.decoders = [], this.register(Hr.timestampExtension);
    }
    register({ type: e, encode: t, decode: s2 }) {
      if (e >= 0) this.encoders[e] = t, this.decoders[e] = s2;
      else {
        let n = 1 + e;
        this.builtInEncoders[n] = t, this.builtInDecoders[n] = s2;
      }
    }
    tryToEncode(e, t) {
      for (let s2 = 0; s2 < this.builtInEncoders.length; s2++) {
        let n = this.builtInEncoders[s2];
        if (n != null) {
          let o = n(e, t);
          if (o != null) {
            let a = -1 - s2;
            return new De.ExtData(a, o);
          }
        }
      }
      for (let s2 = 0; s2 < this.encoders.length; s2++) {
        let n = this.encoders[s2];
        if (n != null) {
          let o = n(e, t);
          if (o != null) {
            let a = s2;
            return new De.ExtData(a, o);
          }
        }
      }
      return e instanceof De.ExtData ? e : null;
    }
    decode(e, t, s2) {
      let n = t < 0 ? this.builtInDecoders[-1 - t] : this.decoders[t];
      return n ? n(e, t, s2) : new De.ExtData(t, e);
    }
  };
  Oe.ExtensionCodec = Re;
  Re.defaultCodec = new Re();
});
var nt = g((te2) => {
  "use strict";
  Object.defineProperty(te2, "__esModule", { value: true });
  te2.createDataView = te2.ensureUint8Array = void 0;
  function Jt(r5) {
    return r5 instanceof Uint8Array ? r5 : ArrayBuffer.isView(r5) ? new Uint8Array(r5.buffer, r5.byteOffset, r5.byteLength) : r5 instanceof ArrayBuffer ? new Uint8Array(r5) : Uint8Array.from(r5);
  }
  te2.ensureUint8Array = Jt;
  function zr(r5) {
    if (r5 instanceof ArrayBuffer) return new DataView(r5);
    let e = Jt(r5);
    return new DataView(e.buffer, e.byteOffset, e.byteLength);
  }
  te2.createDataView = zr;
});
var at = g((O2) => {
  "use strict";
  Object.defineProperty(O2, "__esModule", { value: true });
  O2.Encoder = O2.DEFAULT_INITIAL_BUFFER_SIZE = O2.DEFAULT_MAX_DEPTH = void 0;
  var ge2 = _e(), Gr = Ce(), Ht = fe(), $r = nt();
  O2.DEFAULT_MAX_DEPTH = 100;
  O2.DEFAULT_INITIAL_BUFFER_SIZE = 2048;
  var ot = class {
    constructor(e = Gr.ExtensionCodec.defaultCodec, t = void 0, s2 = O2.DEFAULT_MAX_DEPTH, n = O2.DEFAULT_INITIAL_BUFFER_SIZE, o = false, a = false, i = false, c = false) {
      this.extensionCodec = e, this.context = t, this.maxDepth = s2, this.initialBufferSize = n, this.sortKeys = o, this.forceFloat32 = a, this.ignoreUndefined = i, this.forceIntegerToFloat = c, this.pos = 0, this.view = new DataView(new ArrayBuffer(this.initialBufferSize)), this.bytes = new Uint8Array(this.view.buffer);
    }
    reinitializeState() {
      this.pos = 0;
    }
    encodeSharedRef(e) {
      return this.reinitializeState(), this.doEncode(e, 1), this.bytes.subarray(0, this.pos);
    }
    encode(e) {
      return this.reinitializeState(), this.doEncode(e, 1), this.bytes.slice(0, this.pos);
    }
    doEncode(e, t) {
      if (t > this.maxDepth) throw new Error(`Too deep objects in depth ${t}`);
      e == null ? this.encodeNil() : typeof e == "boolean" ? this.encodeBoolean(e) : typeof e == "number" ? this.encodeNumber(e) : typeof e == "string" ? this.encodeString(e) : this.encodeObject(e, t);
    }
    ensureBufferSizeToWrite(e) {
      let t = this.pos + e;
      this.view.byteLength < t && this.resizeBuffer(t * 2);
    }
    resizeBuffer(e) {
      let t = new ArrayBuffer(e), s2 = new Uint8Array(t), n = new DataView(t);
      s2.set(this.bytes), this.view = n, this.bytes = s2;
    }
    encodeNil() {
      this.writeU8(192);
    }
    encodeBoolean(e) {
      e === false ? this.writeU8(194) : this.writeU8(195);
    }
    encodeNumber(e) {
      Number.isSafeInteger(e) && !this.forceIntegerToFloat ? e >= 0 ? e < 128 ? this.writeU8(e) : e < 256 ? (this.writeU8(204), this.writeU8(e)) : e < 65536 ? (this.writeU8(205), this.writeU16(e)) : e < 4294967296 ? (this.writeU8(206), this.writeU32(e)) : (this.writeU8(207), this.writeU64(e)) : e >= -32 ? this.writeU8(224 | e + 32) : e >= -128 ? (this.writeU8(208), this.writeI8(e)) : e >= -32768 ? (this.writeU8(209), this.writeI16(e)) : e >= -2147483648 ? (this.writeU8(210), this.writeI32(e)) : (this.writeU8(211), this.writeI64(e)) : this.forceFloat32 ? (this.writeU8(202), this.writeF32(e)) : (this.writeU8(203), this.writeF64(e));
    }
    writeStringHeader(e) {
      if (e < 32) this.writeU8(160 + e);
      else if (e < 256) this.writeU8(217), this.writeU8(e);
      else if (e < 65536) this.writeU8(218), this.writeU16(e);
      else if (e < 4294967296) this.writeU8(219), this.writeU32(e);
      else throw new Error(`Too long string: ${e} bytes in UTF-8`);
    }
    encodeString(e) {
      if (e.length > ge2.TEXT_ENCODER_THRESHOLD) {
        let n = (0, ge2.utf8Count)(e);
        this.ensureBufferSizeToWrite(5 + n), this.writeStringHeader(n), (0, ge2.utf8EncodeTE)(e, this.bytes, this.pos), this.pos += n;
      } else {
        let n = (0, ge2.utf8Count)(e);
        this.ensureBufferSizeToWrite(5 + n), this.writeStringHeader(n), (0, ge2.utf8EncodeJs)(e, this.bytes, this.pos), this.pos += n;
      }
    }
    encodeObject(e, t) {
      let s2 = this.extensionCodec.tryToEncode(e, this.context);
      if (s2 != null) this.encodeExtension(s2);
      else if (Array.isArray(e)) this.encodeArray(e, t);
      else if (ArrayBuffer.isView(e)) this.encodeBinary(e);
      else if (typeof e == "object") this.encodeMap(e, t);
      else throw new Error(`Unrecognized object: ${Object.prototype.toString.apply(e)}`);
    }
    encodeBinary(e) {
      let t = e.byteLength;
      if (t < 256) this.writeU8(196), this.writeU8(t);
      else if (t < 65536) this.writeU8(197), this.writeU16(t);
      else if (t < 4294967296) this.writeU8(198), this.writeU32(t);
      else throw new Error(`Too large binary: ${t}`);
      let s2 = (0, $r.ensureUint8Array)(e);
      this.writeU8a(s2);
    }
    encodeArray(e, t) {
      let s2 = e.length;
      if (s2 < 16) this.writeU8(144 + s2);
      else if (s2 < 65536) this.writeU8(220), this.writeU16(s2);
      else if (s2 < 4294967296) this.writeU8(221), this.writeU32(s2);
      else throw new Error(`Too large array: ${s2}`);
      for (let n of e) this.doEncode(n, t + 1);
    }
    countWithoutUndefined(e, t) {
      let s2 = 0;
      for (let n of t) e[n] !== void 0 && s2++;
      return s2;
    }
    encodeMap(e, t) {
      let s2 = Object.keys(e);
      this.sortKeys && s2.sort();
      let n = this.ignoreUndefined ? this.countWithoutUndefined(e, s2) : s2.length;
      if (n < 16) this.writeU8(128 + n);
      else if (n < 65536) this.writeU8(222), this.writeU16(n);
      else if (n < 4294967296) this.writeU8(223), this.writeU32(n);
      else throw new Error(`Too large map object: ${n}`);
      for (let o of s2) {
        let a = e[o];
        this.ignoreUndefined && a === void 0 || (this.encodeString(o), this.doEncode(a, t + 1));
      }
    }
    encodeExtension(e) {
      let t = e.data.length;
      if (t === 1) this.writeU8(212);
      else if (t === 2) this.writeU8(213);
      else if (t === 4) this.writeU8(214);
      else if (t === 8) this.writeU8(215);
      else if (t === 16) this.writeU8(216);
      else if (t < 256) this.writeU8(199), this.writeU8(t);
      else if (t < 65536) this.writeU8(200), this.writeU16(t);
      else if (t < 4294967296) this.writeU8(201), this.writeU32(t);
      else throw new Error(`Too large extension object: ${t}`);
      this.writeI8(e.type), this.writeU8a(e.data);
    }
    writeU8(e) {
      this.ensureBufferSizeToWrite(1), this.view.setUint8(this.pos, e), this.pos++;
    }
    writeU8a(e) {
      let t = e.length;
      this.ensureBufferSizeToWrite(t), this.bytes.set(e, this.pos), this.pos += t;
    }
    writeI8(e) {
      this.ensureBufferSizeToWrite(1), this.view.setInt8(this.pos, e), this.pos++;
    }
    writeU16(e) {
      this.ensureBufferSizeToWrite(2), this.view.setUint16(this.pos, e), this.pos += 2;
    }
    writeI16(e) {
      this.ensureBufferSizeToWrite(2), this.view.setInt16(this.pos, e), this.pos += 2;
    }
    writeU32(e) {
      this.ensureBufferSizeToWrite(4), this.view.setUint32(this.pos, e), this.pos += 4;
    }
    writeI32(e) {
      this.ensureBufferSizeToWrite(4), this.view.setInt32(this.pos, e), this.pos += 4;
    }
    writeF32(e) {
      this.ensureBufferSizeToWrite(4), this.view.setFloat32(this.pos, e), this.pos += 4;
    }
    writeF64(e) {
      this.ensureBufferSizeToWrite(8), this.view.setFloat64(this.pos, e), this.pos += 8;
    }
    writeU64(e) {
      this.ensureBufferSizeToWrite(8), (0, Ht.setUint64)(this.view, this.pos, e), this.pos += 8;
    }
    writeI64(e) {
      this.ensureBufferSizeToWrite(8), (0, Ht.setInt64)(this.view, this.pos, e), this.pos += 8;
    }
  };
  O2.Encoder = ot;
});
var zt = g((Ie) => {
  "use strict";
  Object.defineProperty(Ie, "__esModule", { value: true });
  Ie.encode = void 0;
  var Xr = at(), Kr = {};
  function Qr(r5, e = Kr) {
    return new Xr.Encoder(e.extensionCodec, e.context, e.maxDepth, e.initialBufferSize, e.sortKeys, e.forceFloat32, e.ignoreUndefined, e.forceIntegerToFloat).encodeSharedRef(r5);
  }
  Ie.encode = Qr;
});
var Gt = g((Ue) => {
  "use strict";
  Object.defineProperty(Ue, "__esModule", { value: true });
  Ue.prettyByte = void 0;
  function Yr(r5) {
    return `${r5 < 0 ? "-" : ""}0x${Math.abs(r5).toString(16).padStart(2, "0")}`;
  }
  Ue.prettyByte = Yr;
});
var $t = g((Ne2) => {
  "use strict";
  Object.defineProperty(Ne2, "__esModule", { value: true });
  Ne2.CachedKeyDecoder = void 0;
  var Zr = _e(), es = 16, ts = 16, it = class {
    constructor(e = es, t = ts) {
      this.maxKeyLength = e, this.maxLengthPerKey = t, this.hit = 0, this.miss = 0, this.caches = [];
      for (let s2 = 0; s2 < this.maxKeyLength; s2++) this.caches.push([]);
    }
    canBeCached(e) {
      return e > 0 && e <= this.maxKeyLength;
    }
    find(e, t, s2) {
      let n = this.caches[s2 - 1];
      e: for (let o of n) {
        let a = o.bytes;
        for (let i = 0; i < s2; i++) if (a[i] !== e[t + i]) continue e;
        return o.str;
      }
      return null;
    }
    store(e, t) {
      let s2 = this.caches[e.length - 1], n = { bytes: e, str: t };
      s2.length >= this.maxLengthPerKey ? s2[Math.random() * s2.length | 0] = n : s2.push(n);
    }
    decode(e, t, s2) {
      let n = this.find(e, t, s2);
      if (n != null) return this.hit++, n;
      this.miss++;
      let o = (0, Zr.utf8DecodeJs)(e, t, s2), a = Uint8Array.prototype.slice.call(e, t, t + s2);
      return this.store(a, o), o;
    }
  };
  Ne2.CachedKeyDecoder = it;
});
var Be = g((j2) => {
  "use strict";
  Object.defineProperty(j2, "__esModule", { value: true });
  j2.Decoder = j2.DataViewIndexOutOfBoundsError = void 0;
  var lt = Gt(), rs = Ce(), X = fe(), ct = _e(), ut = nt(), ss = $t(), B2 = Ae(), ns = (r5) => {
    let e = typeof r5;
    return e === "string" || e === "number";
  }, be = -1, dt = new DataView(new ArrayBuffer(0)), os = new Uint8Array(dt.buffer);
  j2.DataViewIndexOutOfBoundsError = (() => {
    try {
      dt.getInt8(0);
    } catch (r5) {
      return r5.constructor;
    }
    throw new Error("never reached");
  })();
  var Xt = new j2.DataViewIndexOutOfBoundsError("Insufficient data"), as = new ss.CachedKeyDecoder(), pt = class {
    constructor(e = rs.ExtensionCodec.defaultCodec, t = void 0, s2 = X.UINT32_MAX, n = X.UINT32_MAX, o = X.UINT32_MAX, a = X.UINT32_MAX, i = X.UINT32_MAX, c = as) {
      this.extensionCodec = e, this.context = t, this.maxStrLength = s2, this.maxBinLength = n, this.maxArrayLength = o, this.maxMapLength = a, this.maxExtLength = i, this.keyDecoder = c, this.totalPos = 0, this.pos = 0, this.view = dt, this.bytes = os, this.headByte = be, this.stack = [];
    }
    reinitializeState() {
      this.totalPos = 0, this.headByte = be, this.stack.length = 0;
    }
    setBuffer(e) {
      this.bytes = (0, ut.ensureUint8Array)(e), this.view = (0, ut.createDataView)(this.bytes), this.pos = 0;
    }
    appendBuffer(e) {
      if (this.headByte === be && !this.hasRemaining(1)) this.setBuffer(e);
      else {
        let t = this.bytes.subarray(this.pos), s2 = (0, ut.ensureUint8Array)(e), n = new Uint8Array(t.length + s2.length);
        n.set(t), n.set(s2, t.length), this.setBuffer(n);
      }
    }
    hasRemaining(e) {
      return this.view.byteLength - this.pos >= e;
    }
    createExtraByteError(e) {
      let { view: t, pos: s2 } = this;
      return new RangeError(`Extra ${t.byteLength - s2} of ${t.byteLength} byte(s) found at buffer[${e}]`);
    }
    decode(e) {
      this.reinitializeState(), this.setBuffer(e);
      let t = this.doDecodeSync();
      if (this.hasRemaining(1)) throw this.createExtraByteError(this.pos);
      return t;
    }
    *decodeMulti(e) {
      for (this.reinitializeState(), this.setBuffer(e); this.hasRemaining(1); ) yield this.doDecodeSync();
    }
    async decodeAsync(e) {
      let t = false, s2;
      for await (let i of e) {
        if (t) throw this.createExtraByteError(this.totalPos);
        this.appendBuffer(i);
        try {
          s2 = this.doDecodeSync(), t = true;
        } catch (c) {
          if (!(c instanceof j2.DataViewIndexOutOfBoundsError)) throw c;
        }
        this.totalPos += this.pos;
      }
      if (t) {
        if (this.hasRemaining(1)) throw this.createExtraByteError(this.totalPos);
        return s2;
      }
      let { headByte: n, pos: o, totalPos: a } = this;
      throw new RangeError(`Insufficient data in parsing ${(0, lt.prettyByte)(n)} at ${a} (${o} in the current buffer)`);
    }
    decodeArrayStream(e) {
      return this.decodeMultiAsync(e, true);
    }
    decodeStream(e) {
      return this.decodeMultiAsync(e, false);
    }
    async *decodeMultiAsync(e, t) {
      let s2 = t, n = -1;
      for await (let o of e) {
        if (t && n === 0) throw this.createExtraByteError(this.totalPos);
        this.appendBuffer(o), s2 && (n = this.readArraySize(), s2 = false, this.complete());
        try {
          for (; yield this.doDecodeSync(), --n !== 0; ) ;
        } catch (a) {
          if (!(a instanceof j2.DataViewIndexOutOfBoundsError)) throw a;
        }
        this.totalPos += this.pos;
      }
    }
    doDecodeSync() {
      e: for (; ; ) {
        let e = this.readHeadByte(), t;
        if (e >= 224) t = e - 256;
        else if (e < 192) if (e < 128) t = e;
        else if (e < 144) {
          let n = e - 128;
          if (n !== 0) {
            this.pushMapState(n), this.complete();
            continue e;
          } else t = {};
        } else if (e < 160) {
          let n = e - 144;
          if (n !== 0) {
            this.pushArrayState(n), this.complete();
            continue e;
          } else t = [];
        } else {
          let n = e - 160;
          t = this.decodeUtf8String(n, 0);
        }
        else if (e === 192) t = null;
        else if (e === 194) t = false;
        else if (e === 195) t = true;
        else if (e === 202) t = this.readF32();
        else if (e === 203) t = this.readF64();
        else if (e === 204) t = this.readU8();
        else if (e === 205) t = this.readU16();
        else if (e === 206) t = this.readU32();
        else if (e === 207) t = this.readU64();
        else if (e === 208) t = this.readI8();
        else if (e === 209) t = this.readI16();
        else if (e === 210) t = this.readI32();
        else if (e === 211) t = this.readI64();
        else if (e === 217) {
          let n = this.lookU8();
          t = this.decodeUtf8String(n, 1);
        } else if (e === 218) {
          let n = this.lookU16();
          t = this.decodeUtf8String(n, 2);
        } else if (e === 219) {
          let n = this.lookU32();
          t = this.decodeUtf8String(n, 4);
        } else if (e === 220) {
          let n = this.readU16();
          if (n !== 0) {
            this.pushArrayState(n), this.complete();
            continue e;
          } else t = [];
        } else if (e === 221) {
          let n = this.readU32();
          if (n !== 0) {
            this.pushArrayState(n), this.complete();
            continue e;
          } else t = [];
        } else if (e === 222) {
          let n = this.readU16();
          if (n !== 0) {
            this.pushMapState(n), this.complete();
            continue e;
          } else t = {};
        } else if (e === 223) {
          let n = this.readU32();
          if (n !== 0) {
            this.pushMapState(n), this.complete();
            continue e;
          } else t = {};
        } else if (e === 196) {
          let n = this.lookU8();
          t = this.decodeBinary(n, 1);
        } else if (e === 197) {
          let n = this.lookU16();
          t = this.decodeBinary(n, 2);
        } else if (e === 198) {
          let n = this.lookU32();
          t = this.decodeBinary(n, 4);
        } else if (e === 212) t = this.decodeExtension(1, 0);
        else if (e === 213) t = this.decodeExtension(2, 0);
        else if (e === 214) t = this.decodeExtension(4, 0);
        else if (e === 215) t = this.decodeExtension(8, 0);
        else if (e === 216) t = this.decodeExtension(16, 0);
        else if (e === 199) {
          let n = this.lookU8();
          t = this.decodeExtension(n, 1);
        } else if (e === 200) {
          let n = this.lookU16();
          t = this.decodeExtension(n, 2);
        } else if (e === 201) {
          let n = this.lookU32();
          t = this.decodeExtension(n, 4);
        } else throw new B2.DecodeError(`Unrecognized type byte: ${(0, lt.prettyByte)(e)}`);
        this.complete();
        let s2 = this.stack;
        for (; s2.length > 0; ) {
          let n = s2[s2.length - 1];
          if (n.type === 0) if (n.array[n.position] = t, n.position++, n.position === n.size) s2.pop(), t = n.array;
          else continue e;
          else if (n.type === 1) {
            if (!ns(t)) throw new B2.DecodeError("The type of key must be string or number but " + typeof t);
            if (t === "__proto__") throw new B2.DecodeError("The key __proto__ is not allowed");
            n.key = t, n.type = 2;
            continue e;
          } else if (n.map[n.key] = t, n.readCount++, n.readCount === n.size) s2.pop(), t = n.map;
          else {
            n.key = null, n.type = 1;
            continue e;
          }
        }
        return t;
      }
    }
    readHeadByte() {
      return this.headByte === be && (this.headByte = this.readU8()), this.headByte;
    }
    complete() {
      this.headByte = be;
    }
    readArraySize() {
      let e = this.readHeadByte();
      switch (e) {
        case 220:
          return this.readU16();
        case 221:
          return this.readU32();
        default: {
          if (e < 160) return e - 144;
          throw new B2.DecodeError(`Unrecognized array type byte: ${(0, lt.prettyByte)(e)}`);
        }
      }
    }
    pushMapState(e) {
      if (e > this.maxMapLength) throw new B2.DecodeError(`Max length exceeded: map length (${e}) > maxMapLengthLength (${this.maxMapLength})`);
      this.stack.push({ type: 1, size: e, key: null, readCount: 0, map: {} });
    }
    pushArrayState(e) {
      if (e > this.maxArrayLength) throw new B2.DecodeError(`Max length exceeded: array length (${e}) > maxArrayLength (${this.maxArrayLength})`);
      this.stack.push({ type: 0, size: e, array: new Array(e), position: 0 });
    }
    decodeUtf8String(e, t) {
      var s2;
      if (e > this.maxStrLength) throw new B2.DecodeError(`Max length exceeded: UTF-8 byte length (${e}) > maxStrLength (${this.maxStrLength})`);
      if (this.bytes.byteLength < this.pos + t + e) throw Xt;
      let n = this.pos + t, o;
      return this.stateIsMapKey() && (!((s2 = this.keyDecoder) === null || s2 === void 0) && s2.canBeCached(e)) ? o = this.keyDecoder.decode(this.bytes, n, e) : e > ct.TEXT_DECODER_THRESHOLD ? o = (0, ct.utf8DecodeTD)(this.bytes, n, e) : o = (0, ct.utf8DecodeJs)(this.bytes, n, e), this.pos += t + e, o;
    }
    stateIsMapKey() {
      return this.stack.length > 0 ? this.stack[this.stack.length - 1].type === 1 : false;
    }
    decodeBinary(e, t) {
      if (e > this.maxBinLength) throw new B2.DecodeError(`Max length exceeded: bin length (${e}) > maxBinLength (${this.maxBinLength})`);
      if (!this.hasRemaining(e + t)) throw Xt;
      let s2 = this.pos + t, n = this.bytes.subarray(s2, s2 + e);
      return this.pos += t + e, n;
    }
    decodeExtension(e, t) {
      if (e > this.maxExtLength) throw new B2.DecodeError(`Max length exceeded: ext length (${e}) > maxExtLength (${this.maxExtLength})`);
      let s2 = this.view.getInt8(this.pos + t), n = this.decodeBinary(e, t + 1);
      return this.extensionCodec.decode(n, s2, this.context);
    }
    lookU8() {
      return this.view.getUint8(this.pos);
    }
    lookU16() {
      return this.view.getUint16(this.pos);
    }
    lookU32() {
      return this.view.getUint32(this.pos);
    }
    readU8() {
      let e = this.view.getUint8(this.pos);
      return this.pos++, e;
    }
    readI8() {
      let e = this.view.getInt8(this.pos);
      return this.pos++, e;
    }
    readU16() {
      let e = this.view.getUint16(this.pos);
      return this.pos += 2, e;
    }
    readI16() {
      let e = this.view.getInt16(this.pos);
      return this.pos += 2, e;
    }
    readU32() {
      let e = this.view.getUint32(this.pos);
      return this.pos += 4, e;
    }
    readI32() {
      let e = this.view.getInt32(this.pos);
      return this.pos += 4, e;
    }
    readU64() {
      let e = (0, X.getUint64)(this.view, this.pos);
      return this.pos += 8, e;
    }
    readI64() {
      let e = (0, X.getInt64)(this.view, this.pos);
      return this.pos += 8, e;
    }
    readF32() {
      let e = this.view.getFloat32(this.pos);
      return this.pos += 4, e;
    }
    readF64() {
      let e = this.view.getFloat64(this.pos);
      return this.pos += 8, e;
    }
  };
  j2.Decoder = pt;
});
var ht = g((C2) => {
  "use strict";
  Object.defineProperty(C2, "__esModule", { value: true });
  C2.decodeMulti = C2.decode = C2.defaultDecodeOptions = void 0;
  var Kt = Be();
  C2.defaultDecodeOptions = {};
  function is(r5, e = C2.defaultDecodeOptions) {
    return new Kt.Decoder(e.extensionCodec, e.context, e.maxStrLength, e.maxBinLength, e.maxArrayLength, e.maxMapLength, e.maxExtLength).decode(r5);
  }
  C2.decode = is;
  function ls(r5, e = C2.defaultDecodeOptions) {
    return new Kt.Decoder(e.extensionCodec, e.context, e.maxStrLength, e.maxBinLength, e.maxArrayLength, e.maxMapLength, e.maxExtLength).decodeMulti(r5);
  }
  C2.decodeMulti = ls;
});
var Zt = g((q2) => {
  "use strict";
  Object.defineProperty(q2, "__esModule", { value: true });
  q2.ensureAsyncIterable = q2.asyncIterableFromStream = q2.isAsyncIterable = void 0;
  function Qt(r5) {
    return r5[Symbol.asyncIterator] != null;
  }
  q2.isAsyncIterable = Qt;
  function cs(r5) {
    if (r5 == null) throw new Error("Assertion Failure: value must not be null nor undefined");
  }
  async function* Yt(r5) {
    let e = r5.getReader();
    try {
      for (; ; ) {
        let { done: t, value: s2 } = await e.read();
        if (t) return;
        cs(s2), yield s2;
      }
    } finally {
      e.releaseLock();
    }
  }
  q2.asyncIterableFromStream = Yt;
  function us(r5) {
    return Qt(r5) ? r5 : Yt(r5);
  }
  q2.ensureAsyncIterable = us;
});
var tr = g((I2) => {
  "use strict";
  Object.defineProperty(I2, "__esModule", { value: true });
  I2.decodeStream = I2.decodeMultiStream = I2.decodeArrayStream = I2.decodeAsync = void 0;
  var yt = Be(), ft = Zt(), je = ht();
  async function ps(r5, e = je.defaultDecodeOptions) {
    let t = (0, ft.ensureAsyncIterable)(r5);
    return new yt.Decoder(e.extensionCodec, e.context, e.maxStrLength, e.maxBinLength, e.maxArrayLength, e.maxMapLength, e.maxExtLength).decodeAsync(t);
  }
  I2.decodeAsync = ps;
  function ds(r5, e = je.defaultDecodeOptions) {
    let t = (0, ft.ensureAsyncIterable)(r5);
    return new yt.Decoder(e.extensionCodec, e.context, e.maxStrLength, e.maxBinLength, e.maxArrayLength, e.maxMapLength, e.maxExtLength).decodeArrayStream(t);
  }
  I2.decodeArrayStream = ds;
  function er(r5, e = je.defaultDecodeOptions) {
    let t = (0, ft.ensureAsyncIterable)(r5);
    return new yt.Decoder(e.extensionCodec, e.context, e.maxStrLength, e.maxBinLength, e.maxArrayLength, e.maxMapLength, e.maxExtLength).decodeStream(t);
  }
  I2.decodeMultiStream = er;
  function hs(r5, e = je.defaultDecodeOptions) {
    return er(r5, e);
  }
  I2.decodeStream = hs;
});
var nr = g((u) => {
  "use strict";
  Object.defineProperty(u, "__esModule", { value: true });
  u.decodeTimestampExtension = u.encodeTimestampExtension = u.decodeTimestampToTimeSpec = u.encodeTimeSpecToTimestamp = u.encodeDateToTimeSpec = u.EXT_TIMESTAMP = u.ExtData = u.ExtensionCodec = u.Encoder = u.DataViewIndexOutOfBoundsError = u.DecodeError = u.Decoder = u.decodeStream = u.decodeMultiStream = u.decodeArrayStream = u.decodeAsync = u.decodeMulti = u.decode = u.encode = void 0;
  var ys = zt();
  Object.defineProperty(u, "encode", { enumerable: true, get: function() {
    return ys.encode;
  } });
  var rr = ht();
  Object.defineProperty(u, "decode", { enumerable: true, get: function() {
    return rr.decode;
  } });
  Object.defineProperty(u, "decodeMulti", { enumerable: true, get: function() {
    return rr.decodeMulti;
  } });
  var Le = tr();
  Object.defineProperty(u, "decodeAsync", { enumerable: true, get: function() {
    return Le.decodeAsync;
  } });
  Object.defineProperty(u, "decodeArrayStream", { enumerable: true, get: function() {
    return Le.decodeArrayStream;
  } });
  Object.defineProperty(u, "decodeMultiStream", { enumerable: true, get: function() {
    return Le.decodeMultiStream;
  } });
  Object.defineProperty(u, "decodeStream", { enumerable: true, get: function() {
    return Le.decodeStream;
  } });
  var sr = Be();
  Object.defineProperty(u, "Decoder", { enumerable: true, get: function() {
    return sr.Decoder;
  } });
  Object.defineProperty(u, "DataViewIndexOutOfBoundsError", { enumerable: true, get: function() {
    return sr.DataViewIndexOutOfBoundsError;
  } });
  var fs = Ae();
  Object.defineProperty(u, "DecodeError", { enumerable: true, get: function() {
    return fs.DecodeError;
  } });
  var ms = at();
  Object.defineProperty(u, "Encoder", { enumerable: true, get: function() {
    return ms.Encoder;
  } });
  var Rs = Ce();
  Object.defineProperty(u, "ExtensionCodec", { enumerable: true, get: function() {
    return Rs.ExtensionCodec;
  } });
  var gs = tt();
  Object.defineProperty(u, "ExtData", { enumerable: true, get: function() {
    return gs.ExtData;
  } });
  var re2 = st();
  Object.defineProperty(u, "EXT_TIMESTAMP", { enumerable: true, get: function() {
    return re2.EXT_TIMESTAMP;
  } });
  Object.defineProperty(u, "encodeDateToTimeSpec", { enumerable: true, get: function() {
    return re2.encodeDateToTimeSpec;
  } });
  Object.defineProperty(u, "encodeTimeSpecToTimestamp", { enumerable: true, get: function() {
    return re2.encodeTimeSpecToTimestamp;
  } });
  Object.defineProperty(u, "decodeTimestampToTimeSpec", { enumerable: true, get: function() {
    return re2.decodeTimestampToTimeSpec;
  } });
  Object.defineProperty(u, "encodeTimestampExtension", { enumerable: true, get: function() {
    return re2.encodeTimestampExtension;
  } });
  Object.defineProperty(u, "decodeTimestampExtension", { enumerable: true, get: function() {
    return re2.decodeTimestampExtension;
  } });
});
var pr = g((Ro, Es) => {
  Es.exports = { Receiver: "", Sender: "", WebSocket: "", WebSocketServer: "", createWebSocketStream: "", default: "" };
});
var gt = g((So, vs) => {
  vs.exports = { BroadcastChannel: "", MessageChannel: "", MessagePort: "", SHARE_ENV: "", Worker: "", default: "", getEnvironmentData: "", isMainThread: "", markAsUntransferable: "", moveMessagePortToContext: "", parentPort: "", postMessageToThread: "", receiveMessageOnPort: "", resourceLimits: "", setEnvironmentData: "", threadId: "", workerData: "" };
});
var P = class extends Error {
  constructor(e) {
    super(e), this.name = this.constructor.name, Object.setPrototypeOf(this, new.target.prototype);
  }
};
var h = typeof process < "u" && process.release && process.release.name === "node";
var ze;
if (globalThis.document) ze = (r5) => new Promise((e, t) => {
  let s2 = document.createElement("script");
  s2.src = r5, s2.onload = () => e(), s2.onerror = t, document.head.appendChild(s2);
});
else if (globalThis.importScripts) ze = async (r5) => {
  try {
    globalThis.importScripts(r5);
  } catch (e) {
    if (e instanceof TypeError) await import(r5);
    else throw e;
  }
};
else if (h) ze = async (r5) => {
  await import((await Promise.resolve().then(() => vt(Pt()))).default.resolve(r5));
};
else throw new P("Cannot determine runtime environment");
var W = { null: 0, symbol: 1, pairlist: 2, closure: 3, environment: 4, promise: 5, call: 6, special: 7, builtin: 8, string: 9, logical: 10, integer: 13, double: 14, complex: 15, character: 16, dots: 17, any: 18, list: 19, expression: 20, bytecode: 21, pointer: 22, weakref: 23, raw: 24, s4: 25, new: 30, free: 31, function: 99 };
function oe(r5) {
  return !!r5 && typeof r5 == "object" && Object.keys(W).includes(r5.type);
}
function H(r5) {
  return !!r5 && typeof r5 == "object" && "re" in r5 && "im" in r5;
}
var l = {};
function Tt(r5) {
  Object.keys(r5).forEach((e) => l._free(r5[e]));
}
function ae(r5) {
  return l._Rf_protect(A(r5)), r5;
}
function y(r5, e) {
  return l._Rf_protect(A(r5)), ++e.n, r5;
}
function St(r5) {
  let e = l._malloc(4);
  return l._R_ProtectWithIndex(A(r5), e), { loc: l.getValue(e, "i32"), ptr: e };
}
function kt(r5) {
  l._Rf_unprotect(1), l._free(r5.ptr);
}
function _t(r5, e) {
  return l._R_Reprotect(A(r5), e.loc), r5;
}
function b(r5) {
  l._Rf_unprotect(r5);
}
function Ge(r5, e, t) {
  l._Rf_defineVar(A(e), A(t), A(r5));
}
function $e(r5, e) {
  let t = {}, s2 = { n: 0 };
  try {
    let n = new le(e);
    y(n, s2), t.code = l.allocateUTF8(r5);
    let o = l._R_ParseEvalString(t.code, n.ptr);
    return p.wrap(o);
  } finally {
    Tt(t), b(s2.n);
  }
}
function ie(r5, e) {
  return l.getWasmTableEntry(l.GOT.ffi_safe_eval.value)(A(r5), A(e));
}
function A(r5) {
  return Te(r5) ? r5.ptr : r5;
}
function G(r5, e) {
  if (l._TYPEOF(r5.ptr) !== W[e]) throw new Error(`Unexpected object type "${r5.type()}" when expecting type "${e}"`);
}
function At(r5) {
  if (oe(r5)) return new (Dt(r5.type))(r5);
  if (typeof r5 > "u") return new ce();
  if (r5 && typeof r5 == "object" && "type" in r5 && r5.type === "null") return new ce();
  if (r5 === null) return new z({ type: "logical", names: null, values: [null] });
  if (typeof r5 == "boolean") return new z(r5);
  if (typeof r5 == "number") return new ye(r5);
  if (typeof r5 == "string") return new N(r5);
  if (H(r5)) return new ve(r5);
  if (ArrayBuffer.isView(r5) || r5 instanceof ArrayBuffer) return new Pe(r5);
  if (Array.isArray(r5)) return kr(r5);
  if (typeof r5 == "object") return de.fromObject(r5);
  throw new Error("R object construction for this JS object is not yet supported.");
}
function kr(r5) {
  let e = { n: 0 };
  if (r5.every((s2) => s2 && typeof s2 == "object" && !Te(s2) && !H(s2))) {
    let s2 = r5, n = s2.every((a) => Object.keys(a).filter((i) => !Object.keys(s2[0]).includes(i)).length === 0 && Object.keys(s2[0]).filter((i) => !Object.keys(a).includes(i)).length === 0), o = s2.every((a) => Object.values(a).every((i) => Ct(i) || Ot(i)));
    if (n && o) return de.fromD3(s2);
  }
  if (r5.every((s2) => typeof s2 == "boolean" || s2 === null)) return new z(r5);
  if (r5.every((s2) => typeof s2 == "number" || s2 === null)) return new ye(r5);
  if (r5.every((s2) => typeof s2 == "string" || s2 === null)) return new N(r5);
  try {
    let s2 = new F([new k("c"), ...r5]);
    return y(s2, e), s2.eval();
  } finally {
    b(e.n);
  }
}
var f = class {
  constructor(e) {
    this.ptr = e;
  }
  type() {
    let e = l._TYPEOF(this.ptr);
    return Object.keys(W).find((s2) => W[s2] === e);
  }
};
var _r_instances, e_fn, _a;
var p = (_a = class extends f {
  constructor(e) {
    if (!(e instanceof f)) return At(e);
    super(e.ptr);
    __privateAdd(this, _r_instances);
  }
  static wrap(e) {
    let t = l._TYPEOF(e), s2 = Object.keys(W)[Object.values(W).indexOf(t)];
    return new (Dt(s2))(new f(e));
  }
  get [Symbol.toStringTag]() {
    return `RObject:${this.type()}`;
  }
  static getPersistentObject(e) {
    return x[e];
  }
  getPropertyValue(e) {
    return this[e];
  }
  inspect() {
    $e(".Internal(inspect(x))", { x: this });
  }
  isNull() {
    return l._TYPEOF(this.ptr) === W.null;
  }
  isNa() {
    try {
      let e = $e("is.na(x)", { x: this });
      return ae(e), e.toBoolean();
    } finally {
      b(1);
    }
  }
  isUnbound() {
    return this.ptr === x.unboundValue.ptr;
  }
  attrs() {
    return ue.wrap(l._ATTRIB(this.ptr));
  }
  class() {
    let e = { n: 0 }, t = new F([new k("class"), this]);
    y(t, e);
    try {
      return t.eval();
    } finally {
      b(e.n);
    }
  }
  setNames(e) {
    let t;
    if (e === null) t = x.null;
    else if (Array.isArray(e) && e.every((s2) => typeof s2 == "string" || s2 === null)) t = new N(e);
    else throw new Error("Argument to setNames must be null or an Array of strings or null");
    return l._Rf_setAttrib(this.ptr, x.namesSymbol.ptr, t.ptr), this;
  }
  names() {
    let e = N.wrap(l._Rf_getAttrib(this.ptr, x.namesSymbol.ptr));
    return e.isNull() ? null : e.toArray();
  }
  includes(e) {
    let t = this.names();
    return t && t.includes(e);
  }
  toJs(e = { depth: 0 }, t = 1) {
    throw new Error("This R object cannot be converted to JS");
  }
  subset(e) {
    return __privateMethod(this, _r_instances, e_fn).call(this, e, x.bracketSymbol.ptr);
  }
  get(e) {
    return __privateMethod(this, _r_instances, e_fn).call(this, e, x.bracket2Symbol.ptr);
  }
  getDollar(e) {
    return __privateMethod(this, _r_instances, e_fn).call(this, e, x.dollarSymbol.ptr);
  }
  pluck(...e) {
    let t = St(x.null);
    try {
      let s2 = (o, a) => {
        let i = o.get(a);
        return _t(i, t);
      }, n = e.reduce(s2, this);
      return n.isNull() ? void 0 : n;
    } finally {
      kt(t);
    }
  }
  set(e, t) {
    let s2 = { n: 0 };
    try {
      let n = new _a(e);
      y(n, s2);
      let o = new _a(t);
      y(o, s2);
      let a = new k("[[<-"), i = l._Rf_lang4(a.ptr, this.ptr, n.ptr, o.ptr);
      return y(i, s2), _a.wrap(ie(i, x.baseEnv));
    } finally {
      b(s2.n);
    }
  }
  static getMethods(e) {
    let t = /* @__PURE__ */ new Set(), s2 = e;
    do
      Object.getOwnPropertyNames(s2).map((n) => t.add(n));
    while (s2 = Object.getPrototypeOf(s2));
    return [...t.keys()].filter((n) => typeof e[n] == "function");
  }
}, _r_instances = new WeakSet(), e_fn = function(e, t) {
  let s2 = { n: 0 };
  try {
    let n = new _a(e);
    y(n, s2);
    let o = l._Rf_lang3(t, this.ptr, n.ptr);
    return y(o, s2), _a.wrap(ie(o, x.baseEnv));
  } finally {
    b(s2.n);
  }
}, _a);
var ce = class extends p {
  constructor() {
    return super(new f(l.getValue(l._R_NilValue, "*"))), this;
  }
  toJs() {
    return { type: "null" };
  }
};
var k = class extends p {
  constructor(e) {
    if (e instanceof f) {
      G(e, "symbol"), super(e);
      return;
    }
    let t = l.allocateUTF8(e);
    try {
      super(new f(l._Rf_install(t)));
    } finally {
      l._free(t);
    }
  }
  toJs() {
    let e = this.toObject();
    return { type: "symbol", printname: e.printname, symvalue: e.symvalue, internal: e.internal };
  }
  toObject() {
    return { printname: this.printname().isUnbound() ? null : this.printname().toString(), symvalue: this.symvalue().isUnbound() ? null : this.symvalue().ptr, internal: this.internal().isNull() ? null : this.internal().ptr };
  }
  toString() {
    return this.printname().toString();
  }
  printname() {
    return he.wrap(l._PRINTNAME(this.ptr));
  }
  symvalue() {
    return p.wrap(l._SYMVALUE(this.ptr));
  }
  internal() {
    return p.wrap(l._INTERNAL(this.ptr));
  }
};
var ue = class r extends p {
  constructor(e) {
    if (e instanceof f) return G(e, "pairlist"), super(e), this;
    let t = { n: 0 };
    try {
      let { names: s2, values: n } = Z(e), o = r.wrap(l._Rf_allocList(n.length));
      y(o, t);
      for (let [a, i] = [0, o]; !i.isNull(); [a, i] = [a + 1, i.cdr()]) i.setcar(new p(n[a]));
      o.setNames(s2), super(o);
    } finally {
      b(t.n);
    }
  }
  get length() {
    return this.toArray().length;
  }
  toArray(e = { depth: 1 }) {
    return this.toJs(e).values;
  }
  toObject({ allowDuplicateKey: e = true, allowEmptyKey: t = false, depth: s2 = -1 } = {}) {
    let n = this.entries({ depth: s2 }), o = n.map(([a]) => a);
    if (!e && new Set(o).size !== o.length) throw new Error("Duplicate key when converting pairlist without allowDuplicateKey enabled");
    if (!t && o.some((a) => !a)) throw new Error("Empty or null key when converting pairlist without allowEmptyKey enabled");
    return Object.fromEntries(n.filter((a, i) => n.findIndex((c) => c[0] === a[0]) === i));
  }
  entries(e = { depth: 1 }) {
    let t = this.toJs(e);
    return t.values.map((s2, n) => [t.names ? t.names[n] : null, s2]);
  }
  toJs(e = { depth: 0 }, t = 1) {
    let s2 = [], n = false, o = [];
    for (let i = this; !i.isNull(); i = i.cdr()) {
      let c = i.tag();
      c.isNull() ? s2.push("") : (n = true, s2.push(c.toString())), e.depth && t >= e.depth ? o.push(i.car()) : o.push(i.car().toJs(e, t + 1));
    }
    return { type: "pairlist", names: n ? s2 : null, values: o };
  }
  includes(e) {
    return e in this.toObject();
  }
  setcar(e) {
    l._SETCAR(this.ptr, e.ptr);
  }
  car() {
    return p.wrap(l._CAR(this.ptr));
  }
  cdr() {
    return p.wrap(l._CDR(this.ptr));
  }
  tag() {
    return p.wrap(l._TAG(this.ptr));
  }
};
var F = class r2 extends p {
  constructor(e) {
    if (e instanceof f) return G(e, "call"), super(e), this;
    let t = { n: 0 };
    try {
      let { values: s2 } = Z(e), n = s2.map((a) => y(new p(a), t)), o = r2.wrap(l._Rf_allocVector(W.call, s2.length));
      y(o, t);
      for (let [a, i] = [0, o]; !i.isNull(); [a, i] = [a + 1, i.cdr()]) i.setcar(n[a]);
      super(o);
    } finally {
      b(t.n);
    }
  }
  setcar(e) {
    l._SETCAR(this.ptr, e.ptr);
  }
  car() {
    return p.wrap(l._CAR(this.ptr));
  }
  cdr() {
    return p.wrap(l._CDR(this.ptr));
  }
  eval() {
    return l.webr.evalR(this, { env: x.baseEnv });
  }
  capture(e = {}) {
    return l.webr.captureR(this, e);
  }
  deparse() {
    let e = { n: 0 };
    try {
      let t = l._Rf_lang2(new k("deparse1").ptr, l._Rf_lang2(new k("quote").ptr, this.ptr));
      y(t, e);
      let s2 = N.wrap(ie(t, x.baseEnv));
      return y(s2, e), s2.toString();
    } finally {
      b(e.n);
    }
  }
};
var pe = class r3 extends p {
  constructor(e, t = null) {
    if (e instanceof f) {
      if (G(e, "list"), super(e), t) {
        if (t.length !== this.length) throw new Error("Can't construct named `RList`. Supplied `names` must be the same length as the list.");
        this.setNames(t);
      }
      return this;
    }
    let s2 = { n: 0 };
    try {
      let n = Z(e), o = l._Rf_allocVector(W.list, n.values.length);
      y(o, s2), n.values.forEach((i, c) => {
        It(i) ? l._SET_VECTOR_ELT(o, c, new r3(i).ptr) : l._SET_VECTOR_ELT(o, c, new p(i).ptr);
      });
      let a = t || n.names;
      if (a && a.length !== n.values.length) throw new Error("Can't construct named `RList`. Supplied `names` must be the same length as the list.");
      p.wrap(o).setNames(a), super(new f(o));
    } finally {
      b(s2.n);
    }
  }
  get length() {
    return l._LENGTH(this.ptr);
  }
  isDataFrame() {
    let e = ue.wrap(l._ATTRIB(this.ptr)).get("class");
    return !e.isNull() && e.toArray().includes("data.frame");
  }
  toArray(e = { depth: 1 }) {
    return this.toJs(e).values;
  }
  toObject({ allowDuplicateKey: e = true, allowEmptyKey: t = false, depth: s2 = -1 } = {}) {
    let n = this.entries({ depth: s2 }), o = n.map(([a]) => a);
    if (!e && new Set(o).size !== o.length) throw new Error("Duplicate key when converting list without allowDuplicateKey enabled");
    if (!t && o.some((a) => !a)) throw new Error("Empty or null key when converting list without allowEmptyKey enabled");
    return Object.fromEntries(n.filter((a, i) => n.findIndex((c) => c[0] === a[0]) === i));
  }
  toD3() {
    if (!this.isDataFrame()) throw new Error("Can't convert R list object to D3 format. Object must be of class 'data.frame'.");
    return this.entries().reduce((t, s2) => (s2[1].forEach((n, o) => t[o] = Object.assign(t[o] || {}, { [s2[0]]: n })), t), []);
  }
  entries(e = { depth: -1 }) {
    let t = this.toJs(e);
    return this.isDataFrame() && e.depth < 0 && (t.values = t.values.map((s2) => s2.toArray())), t.values.map((s2, n) => [t.names ? t.names[n] : null, s2]);
  }
  toJs(e = { depth: 0 }, t = 1) {
    return { type: "list", names: this.names(), values: [...Array(this.length).keys()].map((s2) => e.depth && t >= e.depth ? this.get(s2 + 1) : this.get(s2 + 1).toJs(e, t + 1)) };
  }
};
var de = class r4 extends pe {
  constructor(e) {
    if (e instanceof f) {
      if (super(e), !this.isDataFrame()) throw new Error("Can't construct `RDataFrame`. Supplied R object is not a `data.frame`.");
      return this;
    }
    return r4.fromObject(e);
  }
  static fromObject(e) {
    let { names: t, values: s2 } = Z(e), n = { n: 0 };
    try {
      let o = !!t && t.length > 0 && t.every((i) => i), a = s2.length > 0 && s2.every((i) => Array.isArray(i) || ArrayBuffer.isView(i) || i instanceof ArrayBuffer);
      if (o && a) {
        let i = s2, c = i.every((d) => d.length === i[0].length), R2 = i.every((d) => Ct(d[0]) || Ot(d[0]));
        if (c && R2) {
          let d = new pe({ type: "list", names: t, values: i.map((Ee) => At(Ee)) });
          y(d, n);
          let M2 = new F([new k("as.data.frame"), d]);
          return y(M2, n), new r4(M2.eval());
        }
      }
    } finally {
      b(n.n);
    }
    throw new Error("Can't construct `data.frame`. Source object is not eligible.");
  }
  static fromD3(e) {
    return this.fromObject(Object.fromEntries(Object.keys(e[0]).map((t) => [t, e.map((s2) => s2[t])])));
  }
};
var Y = class extends p {
  exec(...e) {
    let t = { n: 0 };
    try {
      let s2 = new F([this, ...e]);
      return y(s2, t), s2.eval();
    } finally {
      b(t.n);
    }
  }
  capture(e = {}, ...t) {
    let s2 = { n: 0 };
    try {
      let n = new F([this, ...t]);
      return y(n, s2), n.capture(e);
    } finally {
      b(s2.n);
    }
  }
};
var _a2;
var he = (_a2 = class extends p {
  constructor(e) {
    if (e instanceof f) {
      G(e, "string"), super(e);
      return;
    }
    let t = l.allocateUTF8(e);
    try {
      super(new f(l._Rf_mkCharCE(t, _a2.CEType.CE_UTF8)));
    } finally {
      l._free(t);
    }
  }
  toString() {
    let e = l._vmaxget();
    try {
      return l.UTF8ToString(l._Rf_translateCharUTF8(this.ptr));
    } finally {
      l._vmaxset(e);
    }
  }
  toJs() {
    return { type: "string", value: this.toString() };
  }
}, _a2.CEType = { CE_NATIVE: 0, CE_UTF8: 1, CE_LATIN1: 2, CE_BYTES: 3, CE_SYMBOL: 5, CE_ANY: 99 }, _a2);
var le = class extends p {
  constructor(e = {}) {
    if (e instanceof f) return G(e, "environment"), super(e), this;
    let t = 0;
    try {
      let { names: s2, values: n } = Z(e), o = ae(l._R_NewEnv(x.globalEnv.ptr, 0, 0));
      ++t, n.forEach((a, i) => {
        let c = s2 ? s2[i] : null;
        if (!c) throw new Error("Can't create object in new environment with empty symbol name");
        let R2 = new k(c), d = ae(new p(a));
        try {
          Ge(o, R2, d);
        } finally {
          b(1);
        }
      }), super(new f(o));
    } finally {
      b(t);
    }
  }
  ls(e = false, t = true) {
    return N.wrap(l._R_lsInternal3(this.ptr, Number(e), Number(t))).toArray();
  }
  bind(e, t) {
    let s2 = new k(e), n = ae(new p(t));
    try {
      Ge(this, s2, n);
    } finally {
      b(1);
    }
  }
  names() {
    return this.ls(true, true);
  }
  frame() {
    return p.wrap(l._FRAME(this.ptr));
  }
  subset(e) {
    if (typeof e == "number") throw new Error("Object of type environment is not subsettable");
    return this.getDollar(e);
  }
  toObject({ depth: e = -1 } = {}) {
    let t = this.names();
    return Object.fromEntries([...Array(t.length).keys()].map((s2) => {
      let n = this.getDollar(t[s2]);
      return [t[s2], e < 0 ? n : n.toJs({ depth: e })];
    }));
  }
  toJs(e = { depth: 0 }, t = 1) {
    let s2 = this.names(), n = [...Array(s2.length).keys()].map((o) => e.depth && t >= e.depth ? this.getDollar(s2[o]) : this.getDollar(s2[o]).toJs(e, t + 1));
    return { type: "environment", names: s2, values: n };
  }
};
var V = class extends p {
  constructor(e, t, s2) {
    if (e instanceof f) return G(e, t), super(e), this;
    let n = { n: 0 };
    try {
      let { names: o, values: a } = Z(e), i = l._Rf_allocVector(W[t], a.length);
      y(i, n), a.forEach(s2(i)), p.wrap(i).setNames(o), super(new f(i));
    } finally {
      b(n.n);
    }
  }
  get length() {
    return l._LENGTH(this.ptr);
  }
  get(e) {
    return super.get(e);
  }
  subset(e) {
    return super.subset(e);
  }
  getDollar() {
    throw new Error("$ operator is invalid for atomic vectors");
  }
  detectMissing() {
    let e = { n: 0 };
    try {
      let t = l._Rf_lang2(new k("is.na").ptr, this.ptr);
      y(t, e);
      let s2 = z.wrap(ie(t, x.baseEnv));
      y(s2, e);
      let n = s2.toTypedArray();
      return Array.from(n).map((o) => !!o);
    } finally {
      b(e.n);
    }
  }
  toArray() {
    let e = this.toTypedArray();
    return this.detectMissing().map((t, s2) => t ? null : e[s2]);
  }
  toObject({ allowDuplicateKey: e = true, allowEmptyKey: t = false } = {}) {
    let s2 = this.entries(), n = s2.map(([o]) => o);
    if (!e && new Set(n).size !== n.length) throw new Error("Duplicate key when converting atomic vector without allowDuplicateKey enabled");
    if (!t && n.some((o) => !o)) throw new Error("Empty or null key when converting atomic vector without allowEmptyKey enabled");
    return Object.fromEntries(s2.filter((o, a) => s2.findIndex((i) => i[0] === o[0]) === a));
  }
  entries() {
    let e = this.toArray(), t = this.names();
    return e.map((s2, n) => [t ? t[n] : null, s2]);
  }
  toJs() {
    return { type: this.type(), names: this.names(), values: this.toArray() };
  }
};
var _a3, _e2;
var z = (_a3 = class extends V {
  constructor(e) {
    super(e, "logical", __privateGet(_a3, _e2));
  }
  getBoolean(e) {
    return this.get(e).toArray()[0];
  }
  toBoolean() {
    if (this.length !== 1) throw new Error("Can't convert atomic vector of length > 1 to a scalar JS value");
    let e = this.getBoolean(1);
    if (e === null) throw new Error("Can't convert missing value `NA` to a JS boolean");
    return e;
  }
  toTypedArray() {
    return new Int32Array(l.HEAP32.subarray(l._LOGICAL(this.ptr) / 4, l._LOGICAL(this.ptr) / 4 + this.length));
  }
  toArray() {
    let e = this.toTypedArray();
    return this.detectMissing().map((t, s2) => t ? null : !!e[s2]);
  }
}, _e2 = new WeakMap(), __privateAdd(_a3, _e2, (e) => {
  let t = l._LOGICAL(e), s2 = l.getValue(l._R_NaInt, "i32");
  return (n, o) => {
    l.setValue(t + 4 * o, n === null ? s2 : Number(n), "i32");
  };
}), _a3);
var _a4, _e3;
var Ke = (_a4 = class extends V {
  constructor(e) {
    super(e, "integer", __privateGet(_a4, _e3));
  }
  getNumber(e) {
    return this.get(e).toArray()[0];
  }
  toNumber() {
    if (this.length !== 1) throw new Error("Can't convert atomic vector of length > 1 to a scalar JS value");
    let e = this.getNumber(1);
    if (e === null) throw new Error("Can't convert missing value `NA` to a JS number");
    return e;
  }
  toTypedArray() {
    return new Int32Array(l.HEAP32.subarray(l._INTEGER(this.ptr) / 4, l._INTEGER(this.ptr) / 4 + this.length));
  }
}, _e3 = new WeakMap(), __privateAdd(_a4, _e3, (e) => {
  let t = l._INTEGER(e), s2 = l.getValue(l._R_NaInt, "i32");
  return (n, o) => {
    l.setValue(t + 4 * o, n === null ? s2 : Math.round(Number(n)), "i32");
  };
}), _a4);
var _a5, _e4;
var ye = (_a5 = class extends V {
  constructor(e) {
    super(e, "double", __privateGet(_a5, _e4));
  }
  getNumber(e) {
    return this.get(e).toArray()[0];
  }
  toNumber() {
    if (this.length !== 1) throw new Error("Can't convert atomic vector of length > 1 to a scalar JS value");
    let e = this.getNumber(1);
    if (e === null) throw new Error("Can't convert missing value `NA` to a JS number");
    return e;
  }
  toTypedArray() {
    return new Float64Array(l.HEAPF64.subarray(l._REAL(this.ptr) / 8, l._REAL(this.ptr) / 8 + this.length));
  }
}, _e4 = new WeakMap(), __privateAdd(_a5, _e4, (e) => {
  let t = l._REAL(e), s2 = l.getValue(l._R_NaReal, "double");
  return (n, o) => {
    l.setValue(t + 8 * o, n === null ? s2 : n, "double");
  };
}), _a5);
var _a6, _e5;
var ve = (_a6 = class extends V {
  constructor(e) {
    super(e, "complex", __privateGet(_a6, _e5));
  }
  getComplex(e) {
    return this.get(e).toArray()[0];
  }
  toComplex() {
    if (this.length !== 1) throw new Error("Can't convert atomic vector of length > 1 to a scalar JS value");
    let e = this.getComplex(1);
    if (e === null) throw new Error("Can't convert missing value `NA` to a JS object");
    return e;
  }
  toTypedArray() {
    return new Float64Array(l.HEAPF64.subarray(l._COMPLEX(this.ptr) / 8, l._COMPLEX(this.ptr) / 8 + 2 * this.length));
  }
  toArray() {
    let e = this.toTypedArray();
    return this.detectMissing().map((t, s2) => t ? null : { re: e[2 * s2], im: e[2 * s2 + 1] });
  }
}, _e5 = new WeakMap(), __privateAdd(_a6, _e5, (e) => {
  let t = l._COMPLEX(e), s2 = l.getValue(l._R_NaReal, "double");
  return (n, o) => {
    l.setValue(t + 8 * (2 * o), n === null ? s2 : n.re, "double"), l.setValue(t + 8 * (2 * o + 1), n === null ? s2 : n.im, "double");
  };
}), _a6);
var _a7, _e6;
var N = (_a7 = class extends V {
  constructor(e) {
    super(e, "character", __privateGet(_a7, _e6));
  }
  getString(e) {
    return this.get(e).toArray()[0];
  }
  toString() {
    if (this.length !== 1) throw new Error("Can't convert atomic vector of length > 1 to a scalar JS value");
    let e = this.getString(1);
    if (e === null) throw new Error("Can't convert missing value `NA` to a JS string");
    return e;
  }
  toTypedArray() {
    return new Uint32Array(l.HEAPU32.subarray(l._STRING_PTR(this.ptr) / 4, l._STRING_PTR(this.ptr) / 4 + this.length));
  }
  toArray() {
    let e = l._vmaxget();
    try {
      return this.detectMissing().map((t, s2) => t ? null : l.UTF8ToString(l._Rf_translateCharUTF8(l._STRING_ELT(this.ptr, s2))));
    } finally {
      l._vmaxset(e);
    }
  }
}, _e6 = new WeakMap(), __privateAdd(_a7, _e6, (e) => (t, s2) => {
  t === null ? l._SET_STRING_ELT(e, s2, x.naString.ptr) : l._SET_STRING_ELT(e, s2, new he(t).ptr);
}), _a7);
var _a8, _e7;
var Pe = (_a8 = class extends V {
  constructor(e) {
    e instanceof ArrayBuffer && (e = new Uint8Array(e)), super(e, "raw", __privateGet(_a8, _e7));
  }
  getNumber(e) {
    return this.get(e).toArray()[0];
  }
  toNumber() {
    if (this.length !== 1) throw new Error("Can't convert atomic vector of length > 1 to a scalar JS value");
    let e = this.getNumber(1);
    if (e === null) throw new Error("Can't convert missing value `NA` to a JS number");
    return e;
  }
  toTypedArray() {
    return new Uint8Array(l.HEAPU8.subarray(l._RAW(this.ptr), l._RAW(this.ptr) + this.length));
  }
}, _e7 = new WeakMap(), __privateAdd(_a8, _e7, (e) => {
  let t = l._RAW(e);
  return (s2, n) => {
    l.setValue(t + n, Number(s2), "i8");
  };
}), _a8);
function Z(r5) {
  return oe(r5) ? r5 : Array.isArray(r5) || ArrayBuffer.isView(r5) ? { names: null, values: r5 } : r5 && typeof r5 == "object" && !H(r5) ? { names: Object.keys(r5), values: Object.values(r5) } : { names: null, values: [r5] };
}
function Dt(r5) {
  let e = { object: p, null: ce, symbol: k, pairlist: ue, closure: Y, environment: le, call: F, special: Y, builtin: Y, string: he, logical: z, integer: Ke, double: ye, complex: ve, character: N, list: pe, raw: Pe, function: Y, dataframe: de };
  return r5 in e ? e[r5] : p;
}
function Te(r5) {
  return r5 instanceof p;
}
function Ot(r5) {
  let e = ["logical", "integer", "double", "complex", "character"];
  return Te(r5) && e.includes(r5.type()) || Te(r5) && r5.isNa();
}
function Ct(r5) {
  return r5 === null || typeof r5 == "number" || typeof r5 == "boolean" || typeof r5 == "string" || H(r5);
}
var x;
function It(r5) {
  return typeof r5 == "object" && r5 !== null && !Array.isArray(r5) && !ArrayBuffer.isView(r5) && !H(r5) && !oe(r5) && !(r5 instanceof Date) && !(r5 instanceof RegExp) && !(r5 instanceof Error) && !(r5 instanceof f) && Object.getPrototypeOf(r5) === Object.prototype;
}
var ir = vt(nr());
var bs = new TextEncoder();
var yo = new TextDecoder("utf-8");
var fo = new Int32Array(new ArrayBuffer(4));
h && (globalThis.CloseEvent = class extends Event {
  constructor(e, t = {}) {
    super(e, t), this.wasClean = t.wasClean || false, this.code = t.code || 0, this.reason = t.reason || "";
  }
});
h && (globalThis.Worker = gt().Worker);
h && (globalThis.Worker = gt().Worker);
var U = { Automatic: 0, SharedArrayBuffer: 1, PostMessage: 3 };
var hr = h ? __dirname + "/" : "https://webr.r-wasm.org/v0.6.0/";
var yr = "https://repo.r-wasm.org";
var bt = "0.6.0";
var wt = "4.6.0";
var ks = { FONTCONFIG_PATH: "/etc/fonts", R_HOME: "/usr/lib/R", R_ENABLE_JIT: "0", ALL_PROXY: "socks5h://localhost:8580", WEBR: "1", WEBR_VERSION: bt, R_VERSION: wt };
var Rr = { RArgs: [], REnv: ks, baseUrl: hr, serviceWorkerUrl: "", repoUrl: yr, homedir: "/home/web_user", interactive: true, channelType: U.Automatic, createLazyFilesystem: true };

// src/messageporthttp.ts
async function makeRequest(scope, appName, clientPort, pyodide2) {
  const asgiFunc = pyodide2.runPython(
    `_shiny_app_registry["${appName}"].app.call_pyodide`
  );
  await connect(scope, clientPort, asgiFunc);
}
async function connect(scope, clientPort, asgiFunc) {
  const fromClientQueue = new AwaitableQueue();
  clientPort.addEventListener("message", (event) => {
    if (event.data.type === "http.request") {
      fromClientQueue.enqueue({
        type: "http.request",
        body: event.data.body,
        more_body: event.data.more_body
      });
    }
  });
  clientPort.start();
  async function fromClient() {
    return fromClientQueue.dequeue();
  }
  async function toClient(event) {
    event = Object.fromEntries(event.toJs());
    if (event.type === "http.response.start") {
      clientPort.postMessage({
        type: event.type,
        status: event.status,
        headers: asgiHeadersToRecord(event.headers)
      });
    } else if (event.type === "http.response.body") {
      clientPort.postMessage({
        type: event.type,
        body: asgiBodyToArray(event.body),
        more_body: event.more_body
      });
    } else {
      throw new Error(`Unhandled ASGI event: ${event.type}`);
    }
  }
  await asgiFunc(scope, fromClient, toClient);
}
function asgiHeadersToRecord(headers) {
  headers = headers.map(([key, val]) => {
    return [uint8ArrayToString(key), uint8ArrayToString(val)];
  });
  return Object.assign(
    {
      "cross-origin-embedder-policy": "credentialless",
      "cross-origin-resource-policy": "cross-origin"
    },
    Object.fromEntries(headers)
  );
}
function asgiBodyToArray(body) {
  return body;
}

// src/messageportwebsocket.ts
var MessagePortWebSocket = class extends EventTarget {
  constructor(port) {
    super();
    this.readyState = 0;
    this.addEventListener("open", (e) => {
      if (this.onopen) {
        this.onopen(e);
      }
    });
    this.addEventListener("message", (e) => {
      if (this.onmessage) {
        this.onmessage(e);
      }
    });
    this.addEventListener("error", (e) => {
      if (this.onerror) {
        this.onerror(e);
      }
    });
    this.addEventListener("close", (e) => {
      if (this.onclose) {
        this.onclose(e);
      }
    });
    this._port = port;
    port.addEventListener("message", this._onMessage.bind(this));
    port.start();
  }
  // Call on the server side of the connection, to tell the client that
  // the connection has been established.
  accept() {
    if (this.readyState !== 0) {
      return;
    }
    this.readyState = 1;
    this._port.postMessage({ type: "open" });
  }
  send(data) {
    if (this.readyState === 0) {
      throw new DOMException(
        "Can't send messages while WebSocket is in CONNECTING state",
        "InvalidStateError"
      );
    }
    if (this.readyState > 1) {
      return;
    }
    this._port.postMessage({ type: "message", value: { data } });
  }
  close(code, reason) {
    if (this.readyState > 1) {
      return;
    }
    this.readyState = 2;
    this._port.postMessage({ type: "close", value: { code, reason } });
    this.readyState = 3;
    this.dispatchEvent(new CloseEvent("close", { code, reason }));
  }
  _onMessage(e) {
    const event = e.data;
    switch (event.type) {
      case "open":
        if (this.readyState === 0) {
          this.readyState = 1;
          this.dispatchEvent(new Event("open"));
          return;
        }
        break;
      case "message":
        if (this.readyState === 1) {
          this.dispatchEvent(new MessageEvent("message", { ...event.value }));
          return;
        }
        break;
      case "close":
        if (this.readyState < 3) {
          this.readyState = 3;
          this.dispatchEvent(new CloseEvent("close", { ...event.value }));
          return;
        }
        break;
    }
    this._reportError(
      `Unexpected event '${event.type}' while in readyState ${this.readyState}`,
      1002
    );
  }
  _reportError(message, code) {
    this.dispatchEvent(new ErrorEvent("error", { message }));
    if (typeof code === "number") {
      this.close(code, message);
    }
  }
};

// src/messageportwebsocket-channel.ts
async function openChannel(path, appName, clientPort, pyodide2) {
  const conn = new MessagePortWebSocket(clientPort);
  const asgiFunc = pyodide2.runPython(
    `_shiny_app_registry["${appName}"].app.call_pyodide`
  );
  await connect2(path, conn, asgiFunc);
}
async function connect2(path, conn, asgiFunc) {
  const scope = {
    type: "websocket",
    asgi: {
      version: "3.0",
      spec_version: "2.1"
    },
    path,
    headers: []
  };
  const fromClientQueue = new AwaitableQueue();
  fromClientQueue.enqueue({ type: "websocket.connect" });
  async function fromClient() {
    return await fromClientQueue.dequeue();
  }
  async function toClient(event) {
    event = Object.fromEntries(event.toJs());
    if (event.type === "websocket.accept") {
      conn.accept();
    } else if (event.type === "websocket.send") {
      conn.send(event.text ?? event.bytes);
    } else if (event.type === "websocket.close") {
      conn.close(event.code, event.reason);
      fromClientQueue.enqueue({ type: "websocket.disconnect" });
    } else {
      conn.close(1002, "ASGI protocol error");
      throw new Error(`Unhandled ASGI event: ${event.type}`);
    }
  }
  conn.addEventListener("message", (e) => {
    const me2 = e;
    const event = { type: "websocket.receive" };
    if (typeof me2.data === "string") {
      event.text = me2.data;
    } else {
      event.bytes = me2.data;
    }
    fromClientQueue.enqueue(event);
  });
  conn.addEventListener("close", (e) => {
    const ce3 = e;
    fromClientQueue.enqueue({ type: "websocket.disconnect", code: ce3.code });
  });
  conn.addEventListener("error", (e) => {
    console.error(e);
  });
  await asgiFunc(scope, fromClient, toClient);
}

// src/postable-error.ts
function errorToPostableErrorObject(e) {
  const errObj = {
    message: "An unknown error occured",
    name: e.name
  };
  if (!(e instanceof Error)) {
    return errObj;
  }
  errObj.message = e.message;
  if (e.stack) {
    errObj.stack = e.stack;
  }
  return errObj;
}

// src/pyodide/pyodide.js
var Q = Object.defineProperty;
var s = (e, t) => Q(e, "name", { value: t, configurable: true });
var R = ((e) => typeof __require < "u" ? __require : typeof Proxy < "u" ? new Proxy(e, { get: (t, o) => (typeof __require < "u" ? __require : t)[o] }) : e)(function(e) {
  if (typeof __require < "u") return __require.apply(this, arguments);
  throw new Error('Dynamic require of "' + e + '" is not supported');
});
function Z2(e) {
  return !isNaN(parseFloat(e)) && isFinite(e);
}
s(Z2, "_isNumber");
function E(e) {
  return e.charAt(0).toUpperCase() + e.substring(1);
}
s(E, "_capitalize");
function O(e) {
  return function() {
    return this[e];
  };
}
s(O, "_getter");
var w = ["isConstructor", "isEval", "isNative", "isToplevel"];
var N2 = ["columnNumber", "lineNumber"];
var _ = ["fileName", "functionName", "source"];
var ee = ["args"];
var te = ["evalOrigin"];
var P2 = w.concat(N2, _, ee, te);
function p2(e) {
  if (e) for (var t = 0; t < P2.length; t++) e[P2[t]] !== void 0 && this["set" + E(P2[t])](e[P2[t]]);
}
s(p2, "StackFrame");
p2.prototype = { getArgs: function() {
  return this.args;
}, setArgs: function(e) {
  if (Object.prototype.toString.call(e) !== "[object Array]") throw new TypeError("Args must be an Array");
  this.args = e;
}, getEvalOrigin: function() {
  return this.evalOrigin;
}, setEvalOrigin: function(e) {
  if (e instanceof p2) this.evalOrigin = e;
  else if (e instanceof Object) this.evalOrigin = new p2(e);
  else throw new TypeError("Eval Origin must be an Object or StackFrame");
}, toString: function() {
  var e = this.getFileName() || "", t = this.getLineNumber() || "", o = this.getColumnNumber() || "", r5 = this.getFunctionName() || "";
  return this.getIsEval() ? e ? "[eval] (" + e + ":" + t + ":" + o + ")" : "[eval]:" + t + ":" + o : r5 ? r5 + " (" + e + ":" + t + ":" + o + ")" : e + ":" + t + ":" + o;
} };
p2.fromString = s(function(t) {
  var o = t.indexOf("("), r5 = t.lastIndexOf(")"), a = t.substring(0, o), n = t.substring(o + 1, r5).split(","), i = t.substring(r5 + 1);
  if (i.indexOf("@") === 0) var c = /@(.+?)(?::(\d+))?(?::(\d+))?$/.exec(i, ""), l2 = c[1], d = c[2], u = c[3];
  return new p2({ functionName: a, args: n || void 0, fileName: l2, lineNumber: d || void 0, columnNumber: u || void 0 });
}, "StackFrame$$fromString");
for (b2 = 0; b2 < w.length; b2++) p2.prototype["get" + E(w[b2])] = O(w[b2]), p2.prototype["set" + E(w[b2])] = /* @__PURE__ */ function(e) {
  return function(t) {
    this[e] = !!t;
  };
}(w[b2]);
var b2;
for (v = 0; v < N2.length; v++) p2.prototype["get" + E(N2[v])] = O(N2[v]), p2.prototype["set" + E(N2[v])] = /* @__PURE__ */ function(e) {
  return function(t) {
    if (!Z2(t)) throw new TypeError(e + " must be a Number");
    this[e] = Number(t);
  };
}(N2[v]);
var v;
for (h2 = 0; h2 < _.length; h2++) p2.prototype["get" + E(_[h2])] = O(_[h2]), p2.prototype["set" + E(_[h2])] = /* @__PURE__ */ function(e) {
  return function(t) {
    this[e] = String(t);
  };
}(_[h2]);
var h2;
var k2 = p2;
function ne() {
  var e = /^\s*at .*(\S+:\d+|\(native\))/m, t = /^(eval@)?(\[native code])?$/;
  return { parse: s(function(r5) {
    if (r5.stack && r5.stack.match(e)) return this.parseV8OrIE(r5);
    if (r5.stack) return this.parseFFOrSafari(r5);
    throw new Error("Cannot parse given Error object");
  }, "ErrorStackParser$$parse"), extractLocation: s(function(r5) {
    if (r5.indexOf(":") === -1) return [r5];
    var a = /(.+?)(?::(\d+))?(?::(\d+))?$/, n = a.exec(r5.replace(/[()]/g, ""));
    return [n[1], n[2] || void 0, n[3] || void 0];
  }, "ErrorStackParser$$extractLocation"), parseV8OrIE: s(function(r5) {
    var a = r5.stack.split(`
`).filter(function(n) {
      return !!n.match(e);
    }, this);
    return a.map(function(n) {
      n.indexOf("(eval ") > -1 && (n = n.replace(/eval code/g, "eval").replace(/(\(eval at [^()]*)|(,.*$)/g, ""));
      var i = n.replace(/^\s+/, "").replace(/\(eval code/g, "(").replace(/^.*?\s+/, ""), c = i.match(/ (\(.+\)$)/);
      i = c ? i.replace(c[0], "") : i;
      var l2 = this.extractLocation(c ? c[1] : i), d = c && i || void 0, u = ["eval", "<anonymous>"].indexOf(l2[0]) > -1 ? void 0 : l2[0];
      return new k2({ functionName: d, fileName: u, lineNumber: l2[1], columnNumber: l2[2], source: n });
    }, this);
  }, "ErrorStackParser$$parseV8OrIE"), parseFFOrSafari: s(function(r5) {
    var a = r5.stack.split(`
`).filter(function(n) {
      return !n.match(t);
    }, this);
    return a.map(function(n) {
      if (n.indexOf(" > eval") > -1 && (n = n.replace(/ line (\d+)(?: > eval line \d+)* > eval:\d+:\d+/g, ":$1")), n.indexOf("@") === -1 && n.indexOf(":") === -1) return new k2({ functionName: n });
      var i = /((.*".+"[^@]*)?[^@]*)(?:@)/, c = n.match(i), l2 = c && c[1] ? c[1] : void 0, d = this.extractLocation(n.replace(i, ""));
      return new k2({ functionName: l2, fileName: d[0], lineNumber: d[1], columnNumber: d[2], source: n });
    }, this);
  }, "ErrorStackParser$$parseFFOrSafari") };
}
s(ne, "ErrorStackParser");
var re = new ne();
var M = re;
var g2 = typeof process == "object" && typeof process.versions == "object" && typeof process.versions.node == "string" && !process.browser;
var A2 = g2 && typeof module < "u" && typeof module.exports < "u" && typeof R < "u" && typeof __dirname < "u";
var W2 = g2 && !A2;
var Ne = typeof globalThis.Bun < "u";
var ie2 = typeof Deno < "u";
var B = !g2 && !ie2;
var $ = B && typeof window == "object" && typeof document == "object" && typeof document.createElement == "function" && "sessionStorage" in window && typeof importScripts != "function";
var j = B && typeof importScripts == "function" && typeof self == "object";
var _e8 = typeof navigator == "object" && typeof navigator.userAgent == "string" && navigator.userAgent.indexOf("Chrome") == -1 && navigator.userAgent.indexOf("Safari") > -1;
var z2;
var D;
var V2;
var H2;
var L;
async function T() {
  if (!g2 || (z2 = (await import("node:url")).default, H2 = await import("node:fs"), L = await import("node:fs/promises"), V2 = (await import("node:vm")).default, D = await import("node:path"), U2 = D.sep, typeof R < "u")) return;
  let e = H2, t = await import("node:crypto"), o = await Promise.resolve().then(() => __toESM(require_browser())), r5 = await import("node:child_process"), a = { fs: e, crypto: t, ws: o, child_process: r5 };
  globalThis.require = function(n) {
    return a[n];
  };
}
s(T, "initNodeModules");
function oe2(e, t) {
  return D.resolve(t || ".", e);
}
s(oe2, "node_resolvePath");
function ae2(e, t) {
  return t === void 0 && (t = location), new URL(e, t).toString();
}
s(ae2, "browser_resolvePath");
var x2;
g2 ? x2 = oe2 : x2 = ae2;
var U2;
g2 || (U2 = "/");
function se(e, t) {
  return e.startsWith("file://") && (e = e.slice(7)), e.includes("://") ? { response: fetch(e) } : { binary: L.readFile(e).then((o) => new Uint8Array(o.buffer, o.byteOffset, o.byteLength)) };
}
s(se, "node_getBinaryResponse");
function ce2(e, t) {
  let o = new URL(e, location);
  return { response: fetch(o, t ? { integrity: t } : {}) };
}
s(ce2, "browser_getBinaryResponse");
var F2;
g2 ? F2 = se : F2 = ce2;
async function q(e, t) {
  let { response: o, binary: r5 } = F2(e, t);
  if (r5) return r5;
  let a = await o;
  if (!a.ok) throw new Error(`Failed to load '${e}': request failed.`);
  return new Uint8Array(await a.arrayBuffer());
}
s(q, "loadBinaryFile");
var I;
if ($) I = s(async (e) => await import(e), "loadScript");
else if (j) I = s(async (e) => {
  try {
    globalThis.importScripts(e);
  } catch (t) {
    if (t instanceof TypeError) await import(e);
    else throw t;
  }
}, "loadScript");
else if (g2) I = le2;
else throw new Error("Cannot determine runtime environment");
async function le2(e) {
  e.startsWith("file://") && (e = e.slice(7)), e.includes("://") ? V2.runInThisContext(await (await fetch(e)).text()) : await import(z2.pathToFileURL(e).href);
}
s(le2, "nodeLoadScript");
async function J(e) {
  if (g2) {
    await T();
    let t = await L.readFile(e, { encoding: "utf8" });
    return JSON.parse(t);
  } else return await (await fetch(e)).json();
}
s(J, "loadLockFile");
async function K() {
  if (A2) return __dirname;
  let e;
  try {
    throw new Error();
  } catch (r5) {
    e = r5;
  }
  let t = M.parse(e)[0].fileName;
  if (g2 && !t.startsWith("file://") && (t = `file://${t}`), W2) {
    let r5 = await import("node:path");
    return (await import("node:url")).fileURLToPath(r5.dirname(t));
  }
  let o = t.lastIndexOf(U2);
  if (o === -1) throw new Error("Could not extract indexURL path from pyodide module location");
  return t.slice(0, o);
}
s(K, "calculateDirname");
function Y2(e) {
  let t = e.FS, o = e.FS.filesystems.MEMFS, r5 = e.PATH, a = { DIR_MODE: 16895, FILE_MODE: 33279, mount: function(n) {
    if (!n.opts.fileSystemHandle) throw new Error("opts.fileSystemHandle is required");
    return o.mount.apply(null, arguments);
  }, syncfs: async (n, i, c) => {
    try {
      let l2 = a.getLocalSet(n), d = await a.getRemoteSet(n), u = i ? d : l2, m = i ? l2 : d;
      await a.reconcile(n, u, m), c(null);
    } catch (l2) {
      c(l2);
    }
  }, getLocalSet: (n) => {
    let i = /* @__PURE__ */ Object.create(null);
    function c(u) {
      return u !== "." && u !== "..";
    }
    s(c, "isRealDir");
    function l2(u) {
      return (m) => r5.join2(u, m);
    }
    s(l2, "toAbsolute");
    let d = t.readdir(n.mountpoint).filter(c).map(l2(n.mountpoint));
    for (; d.length; ) {
      let u = d.pop(), m = t.stat(u);
      t.isDir(m.mode) && d.push.apply(d, t.readdir(u).filter(c).map(l2(u))), i[u] = { timestamp: m.mtime, mode: m.mode };
    }
    return { type: "local", entries: i };
  }, getRemoteSet: async (n) => {
    let i = /* @__PURE__ */ Object.create(null), c = await de2(n.opts.fileSystemHandle);
    for (let [l2, d] of c) l2 !== "." && (i[r5.join2(n.mountpoint, l2)] = { timestamp: d.kind === "file" ? new Date((await d.getFile()).lastModified) : /* @__PURE__ */ new Date(), mode: d.kind === "file" ? a.FILE_MODE : a.DIR_MODE });
    return { type: "remote", entries: i, handles: c };
  }, loadLocalEntry: (n) => {
    let c = t.lookupPath(n).node, l2 = t.stat(n);
    if (t.isDir(l2.mode)) return { timestamp: l2.mtime, mode: l2.mode };
    if (t.isFile(l2.mode)) return c.contents = o.getFileDataAsTypedArray(c), { timestamp: l2.mtime, mode: l2.mode, contents: c.contents };
    throw new Error("node type not supported");
  }, storeLocalEntry: (n, i) => {
    if (t.isDir(i.mode)) t.mkdirTree(n, i.mode);
    else if (t.isFile(i.mode)) t.writeFile(n, i.contents, { canOwn: true });
    else throw new Error("node type not supported");
    t.chmod(n, i.mode), t.utime(n, i.timestamp, i.timestamp);
  }, removeLocalEntry: (n) => {
    var i = t.stat(n);
    t.isDir(i.mode) ? t.rmdir(n) : t.isFile(i.mode) && t.unlink(n);
  }, loadRemoteEntry: async (n) => {
    if (n.kind === "file") {
      let i = await n.getFile();
      return { contents: new Uint8Array(await i.arrayBuffer()), mode: a.FILE_MODE, timestamp: new Date(i.lastModified) };
    } else {
      if (n.kind === "directory") return { mode: a.DIR_MODE, timestamp: /* @__PURE__ */ new Date() };
      throw new Error("unknown kind: " + n.kind);
    }
  }, storeRemoteEntry: async (n, i, c) => {
    let l2 = n.get(r5.dirname(i)), d = t.isFile(c.mode) ? await l2.getFileHandle(r5.basename(i), { create: true }) : await l2.getDirectoryHandle(r5.basename(i), { create: true });
    if (d.kind === "file") {
      let u = await d.createWritable();
      await u.write(c.contents), await u.close();
    }
    n.set(i, d);
  }, removeRemoteEntry: async (n, i) => {
    await n.get(r5.dirname(i)).removeEntry(r5.basename(i)), n.delete(i);
  }, reconcile: async (n, i, c) => {
    let l2 = 0, d = [];
    Object.keys(i.entries).forEach(function(f2) {
      let y2 = i.entries[f2], S = c.entries[f2];
      (!S || t.isFile(y2.mode) && y2.timestamp.getTime() > S.timestamp.getTime()) && (d.push(f2), l2++);
    }), d.sort();
    let u = [];
    if (Object.keys(c.entries).forEach(function(f2) {
      i.entries[f2] || (u.push(f2), l2++);
    }), u.sort().reverse(), !l2) return;
    let m = i.type === "remote" ? i.handles : c.handles;
    for (let f2 of d) {
      let y2 = r5.normalize(f2.replace(n.mountpoint, "/")).substring(1);
      if (c.type === "local") {
        let S = m.get(y2), X = await a.loadRemoteEntry(S);
        a.storeLocalEntry(f2, X);
      } else {
        let S = a.loadLocalEntry(f2);
        await a.storeRemoteEntry(m, y2, S);
      }
    }
    for (let f2 of u) if (c.type === "local") a.removeLocalEntry(f2);
    else {
      let y2 = r5.normalize(f2.replace(n.mountpoint, "/")).substring(1);
      await a.removeRemoteEntry(m, y2);
    }
  } };
  e.FS.filesystems.NATIVEFS_ASYNC = a;
}
s(Y2, "initializeNativeFS");
var de2 = s(async (e) => {
  let t = [];
  async function o(a) {
    for await (let n of a.values()) t.push(n), n.kind === "directory" && await o(n);
  }
  s(o, "collect"), await o(e);
  let r5 = /* @__PURE__ */ new Map();
  r5.set(".", e);
  for (let a of t) {
    let n = (await e.resolve(a)).join("/");
    r5.set(n, a);
  }
  return r5;
}, "getFsHandles");
function G2(e) {
  let t = { noImageDecoding: true, noAudioDecoding: true, noWasmDecoding: false, preRun: ge(e), quit(o, r5) {
    throw t.exited = { status: o, toThrow: r5 }, r5;
  }, print: e.stdout, printErr: e.stderr, thisProgram: e._sysExecutable, arguments: e.args, API: { config: e }, locateFile: (o) => e.indexURL + o, instantiateWasm: ye2(e.indexURL) };
  return t;
}
s(G2, "createSettings");
function ue2(e) {
  return function(t) {
    let o = "/";
    try {
      t.FS.mkdirTree(e);
    } catch (r5) {
      console.error(`Error occurred while making a home directory '${e}':`), console.error(r5), console.error(`Using '${o}' for a home directory instead`), e = o;
    }
    t.FS.chdir(e);
  };
}
s(ue2, "createHomeDirectory");
function fe2(e) {
  return function(t) {
    Object.assign(t.ENV, e);
  };
}
s(fe2, "setEnvironment");
function me(e) {
  return e ? [async (t) => {
    t.addRunDependency("fsInitHook");
    try {
      await e(t.FS, { sitePackages: t.API.sitePackages });
    } finally {
      t.removeRunDependency("fsInitHook");
    }
  }] : [];
}
s(me, "callFsInitHook");
function pe2(e) {
  let t = q(e);
  return async (o) => {
    let r5 = o._py_version_major(), a = o._py_version_minor();
    o.FS.mkdirTree("/lib"), o.API.sitePackages = `/lib/python${r5}.${a}/site-packages`, o.FS.mkdirTree(o.API.sitePackages), o.addRunDependency("install-stdlib");
    try {
      let n = await t;
      o.FS.writeFile(`/lib/python${r5}${a}.zip`, n);
    } catch (n) {
      console.error("Error occurred while installing the standard library:"), console.error(n);
    } finally {
      o.removeRunDependency("install-stdlib");
    }
  };
}
s(pe2, "installStdlib");
function ge(e) {
  let t;
  return e.stdLibURL != null ? t = e.stdLibURL : t = e.indexURL + "python_stdlib.zip", [...me(e.fsInit), pe2(t), ue2(e.env.HOME), fe2(e.env), Y2];
}
s(ge, "getFileSystemInitializationFuncs");
function ye2(e) {
  if (typeof WasmOffsetConverter < "u") return;
  let { binary: t, response: o } = F2(e + "pyodide.asm.wasm");
  return function(r5, a) {
    return async function() {
      try {
        let n;
        o ? n = await WebAssembly.instantiateStreaming(o, r5) : n = await WebAssembly.instantiate(await t, r5);
        let { instance: i, module: c } = n;
        a(i, c);
      } catch (n) {
        console.warn("wasm instantiation failed!"), console.warn(n);
      }
    }(), {};
  };
}
s(ye2, "getInstantiateWasmFunc");
var C = "0.27.7";
async function $e2(e = {}) {
  var u, m;
  await T();
  let t = e.indexURL || await K();
  t = x2(t), t.endsWith("/") || (t += "/"), e.indexURL = t;
  let o = { fullStdLib: false, jsglobals: globalThis, stdin: globalThis.prompt ? globalThis.prompt : void 0, lockFileURL: t + "pyodide-lock.json", args: [], env: {}, packageCacheDir: t, packages: [], enableRunUntilComplete: true, checkAPIVersion: true, BUILD_ID: "e94377f5ce7dcf67e0417b69a0016733c2cfb6b4622ee8c490a6f17eb58e863b" }, r5 = Object.assign(o, e);
  (u = r5.env).HOME ?? (u.HOME = "/home/pyodide"), (m = r5.env).PYTHONINSPECT ?? (m.PYTHONINSPECT = "1");
  let a = G2(r5), n = a.API;
  if (n.lockFilePromise = J(r5.lockFileURL), typeof _createPyodideModule != "function") {
    let f2 = `${r5.indexURL}pyodide.asm.js`;
    await I(f2);
  }
  let i;
  if (e._loadSnapshot) {
    let f2 = await e._loadSnapshot;
    ArrayBuffer.isView(f2) ? i = f2 : i = new Uint8Array(f2), a.noInitialRun = true, a.INITIAL_MEMORY = i.length;
  }
  let c = await _createPyodideModule(a);
  if (a.exited) throw a.exited.toThrow;
  if (e.pyproxyToStringRepr && n.setPyProxyToStringMethod(true), n.version !== C && r5.checkAPIVersion) throw new Error(`Pyodide version does not match: '${C}' <==> '${n.version}'. If you updated the Pyodide version, make sure you also updated the 'indexURL' parameter passed to loadPyodide.`);
  c.locateFile = (f2) => {
    throw new Error("Didn't expect to load any more file_packager files!");
  };
  let l2;
  i && (l2 = n.restoreSnapshot(i));
  let d = n.finalizeBootstrap(l2, e._snapshotDeserializer);
  return n.sys.path.insert(0, ""), d.version.includes("dev") || n.setCdnUrl(`https://cdn.jsdelivr.net/pyodide/v${d.version}/full/`), n._pyodide.set_excepthook(), await n.packageIndexReady, n.initializeStreams(r5.stdin, r5.stdout, r5.stderr), d;
}
s($e2, "loadPyodide");

// src/pyodide-proxy.ts
async function setupPythonEnv(pyodide2, callJS2) {
  const repr = pyodide2.globals.get("repr");
  pyodide2.globals.set("js_pyodide", pyodide2);
  const pyconsole = await pyodide2.runPythonAsync(`
  import pyodide.console
  import __main__
  pyodide.console.PyodideConsole(__main__.__dict__)
  `);
  const tabComplete = pyconsole.complete.copy();
  pyconsole.destroy();
  if (callJS2) {
    pyodide2.globals.set("callJS", callJS2);
  }
  const shortFormatLastTraceback = await pyodide2.runPythonAsync(`
  def _short_format_last_traceback() -> str:
      import sys
      import traceback
      e = sys.last_value
      found_marker = False
      nframes = 0
      for (frame, _) in traceback.walk_tb(e.__traceback__):
          if frame.f_code.co_filename in ("<console>", "<exec>"):
              found_marker = True
          if found_marker:
              nframes += 1
      return "".join(traceback.format_exception(type(e), e, e.__traceback__, -nframes))

  _short_format_last_traceback
  `);
  await pyodide2.runPythonAsync(`del _short_format_last_traceback`);
  return {
    repr,
    tabComplete,
    shortFormatLastTraceback
  };
}
function processReturnValue(value, returnResult = "none", pyodide2, repr) {
  const possibleReturnValues = {
    get value() {
      if (value instanceof pyodide2.ffi.PyProxy) {
        return value.toJs();
      } else {
        return value;
      }
    },
    get printed_value() {
      return repr(value);
    },
    get to_html() {
      let toHtml;
      try {
        toHtml = pyodide2.globals.get("_to_html");
      } catch (e) {
        console.error("Couldn't find _to_html function: ", e);
        toHtml = (x3) => ({
          type: "text",
          value: "Couldn't finding _to_html function."
        });
      }
      const val = toHtml(value).toJs({
        dict_converter: Object.fromEntries
      });
      return val;
    },
    get none() {
      return void 0;
    }
  };
  return possibleReturnValues[returnResult];
}

// src/pyodide-worker.ts
var pyodideStatus = "none";
var pyodide;
self.stdout_callback = function(s2) {
  self.postMessage({ type: "nonreply", subtype: "output", stdout: s2 });
};
self.stderr_callback = function(s2) {
  self.postMessage({ type: "nonreply", subtype: "output", stderr: s2 });
};
async function callJS(fnName, args) {
  self.postMessage({
    type: "nonreply",
    subtype: "callJS",
    fnName: fnName.toJs(),
    args: args.toJs()
  });
}
var pyUtils;
self.onmessage = async function(e) {
  const msg = e.data;
  if (msg.type === "openChannel") {
    const clientPort = e.ports[0];
    await openChannel(msg.path, msg.appName, clientPort, pyodide);
    return;
  } else if (msg.type === "makeRequest") {
    const clientPort = e.ports[0];
    await makeRequest(msg.scope, msg.appName, clientPort, pyodide);
    return;
  }
  const messagePort = e.ports[0];
  try {
    if (msg.type === "init") {
      if (pyodideStatus === "none") {
        pyodideStatus = "loading";
        pyodide = await $e2({
          ...msg.config,
          stdout: self.stdout_callback,
          stderr: self.stderr_callback
        });
        pyUtils = await setupPythonEnv(pyodide, callJS);
        pyodideStatus = "loaded";
      }
      messagePort.postMessage({ type: "reply", subtype: "done" });
    } else if (msg.type === "loadPackagesFromImports") {
      const result = await pyodide.loadPackagesFromImports(msg.code);
      messagePort.postMessage({
        type: "reply",
        subtype: "done",
        value: result
      });
    } else if (msg.type === "runPythonAsync") {
      await pyodide.loadPackagesFromImports(msg.code);
      const result = await pyodide.runPythonAsync(msg.code);
      if (msg.printResult && result !== void 0) {
        self.stdout_callback(pyUtils.repr(result));
      }
      try {
        const processedResult = processReturnValue(
          result,
          msg.returnResult,
          pyodide,
          pyUtils.repr
        );
        messagePort.postMessage({
          type: "reply",
          subtype: "done",
          value: processedResult
        });
      } finally {
        if (result instanceof pyodide.ffi.PyProxy) {
          result.destroy();
        }
      }
    } else if (msg.type === "tabComplete") {
      const completions = pyUtils.tabComplete(msg.code).toJs()[0];
      messagePort.postMessage({
        type: "reply",
        subtype: "tabCompletions",
        completions
      });
    } else if (msg.type === "callPyAsync") {
      const { fnName, args, kwargs } = msg;
      let fn = pyodide.globals.get(fnName[0]);
      for (const el of fnName.slice(1)) {
        fn = fn[el];
      }
      const resultMaybePromise = fn.callKwargs(...args, kwargs);
      const result = await Promise.resolve(resultMaybePromise);
      if (msg.printResult && result !== void 0) {
        self.stdout_callback(pyUtils.repr(result));
      }
      try {
        const processedResult = processReturnValue(
          result,
          msg.returnResult,
          pyodide,
          pyUtils.repr
        );
        messagePort.postMessage({
          type: "reply",
          subtype: "done",
          value: processedResult
        });
      } finally {
        if (result instanceof pyodide.ffi.PyProxy) {
          result.destroy();
        }
      }
    } else {
      messagePort.postMessage({
        type: "reply",
        subtype: "done",
        error: new Error(`Unknown message type: ${msg.toString()}`)
      });
    }
  } catch (e2) {
    if (e2 instanceof pyodide.ffi.PythonError) {
      e2.message = pyUtils.shortFormatLastTraceback();
    }
    messagePort.postMessage({
      type: "reply",
      subtype: "done",
      error: errorToPostableErrorObject(e2)
    });
  }
};
