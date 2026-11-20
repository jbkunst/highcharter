// Shinylive 0.10.12
// Copyright 2026 Posit, PBC
var __typeError = (msg) => {
  throw TypeError(msg);
};
var __accessCheck = (obj, member, msg) => member.has(obj) || __typeError("Cannot " + msg);
var __privateGet = (obj, member, getter) => (__accessCheck(obj, member, "read from private field"), getter ? getter.call(obj) : member.get(obj));
var __privateAdd = (obj, member, value) => member.has(obj) ? __typeError("Cannot add the same private member more than once") : member instanceof WeakSet ? member.add(obj) : member.set(obj, value);
var __privateMethod = (obj, member, method) => (__accessCheck(obj, member, "access private method"), method);

// src/assets/shinylive-inject-socket.txt
var shinylive_inject_socket_default = '// src/messageportwebsocket.ts\nvar MessagePortWebSocket = class extends EventTarget {\n  constructor(port) {\n    super();\n    this.readyState = 0;\n    this.addEventListener("open", (e) => {\n      if (this.onopen) {\n        this.onopen(e);\n      }\n    });\n    this.addEventListener("message", (e) => {\n      if (this.onmessage) {\n        this.onmessage(e);\n      }\n    });\n    this.addEventListener("error", (e) => {\n      if (this.onerror) {\n        this.onerror(e);\n      }\n    });\n    this.addEventListener("close", (e) => {\n      if (this.onclose) {\n        this.onclose(e);\n      }\n    });\n    this._port = port;\n    port.addEventListener("message", this._onMessage.bind(this));\n    port.start();\n  }\n  // Call on the server side of the connection, to tell the client that\n  // the connection has been established.\n  accept() {\n    if (this.readyState !== 0) {\n      return;\n    }\n    this.readyState = 1;\n    this._port.postMessage({ type: "open" });\n  }\n  send(data) {\n    if (this.readyState === 0) {\n      throw new DOMException(\n        "Can\'t send messages while WebSocket is in CONNECTING state",\n        "InvalidStateError"\n      );\n    }\n    if (this.readyState > 1) {\n      return;\n    }\n    this._port.postMessage({ type: "message", value: { data } });\n  }\n  close(code, reason) {\n    if (this.readyState > 1) {\n      return;\n    }\n    this.readyState = 2;\n    this._port.postMessage({ type: "close", value: { code, reason } });\n    this.readyState = 3;\n    this.dispatchEvent(new CloseEvent("close", { code, reason }));\n  }\n  _onMessage(e) {\n    const event = e.data;\n    switch (event.type) {\n      case "open":\n        if (this.readyState === 0) {\n          this.readyState = 1;\n          this.dispatchEvent(new Event("open"));\n          return;\n        }\n        break;\n      case "message":\n        if (this.readyState === 1) {\n          this.dispatchEvent(new MessageEvent("message", { ...event.value }));\n          return;\n        }\n        break;\n      case "close":\n        if (this.readyState < 3) {\n          this.readyState = 3;\n          this.dispatchEvent(new CloseEvent("close", { ...event.value }));\n          return;\n        }\n        break;\n    }\n    this._reportError(\n      `Unexpected event \'${event.type}\' while in readyState ${this.readyState}`,\n      1002\n    );\n  }\n  _reportError(message, code) {\n    this.dispatchEvent(new ErrorEvent("error", { message }));\n    if (typeof code === "number") {\n      this.close(code, message);\n    }\n  }\n};\n\n// src/shinylive-inject-socket.ts\nwindow.Shiny.createSocket = function() {\n  const channel = new MessageChannel();\n  window.parent.postMessage(\n    {\n      type: "openChannel",\n      // Infer app name from path: "/foo/app_abc123/"" => "app_abc123"\n      appName: window.location.pathname.replace(\n        new RegExp(".*/([^/]+)/$"),\n        "$1"\n      ),\n      path: "/websocket/"\n    },\n    "*",\n    [channel.port2]\n  );\n  return new MessagePortWebSocket(channel.port1);\n};\n';

// src/utils.ts
function sleep(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}
function dirname(path) {
  if (path === "/" || path === "") {
    return "";
  }
  return path.replace(/[/]?[^/]+[/]?$/, "");
}
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
var vr = (r5, e, t, s) => {
  if (e && typeof e == "object" || typeof e == "function") for (let n of wr(e)) !Er.call(r5, n) && n !== t && Et(r5, n, { get: () => e[n], enumerable: !(s = br(e, n)) || s.enumerable });
  return r5;
};
var vt = (r5, e, t) => (t = r5 != null ? gr(xr(r5)) : {}, vr(e || !r5 || !r5.__esModule ? Et(t, "default", { value: r5, enumerable: true }) : t, r5));
var Pt = g((As, Pr) => {
  Pr.exports = { _makeLong: "", basename: "", default: "", delimiter: "", dirname: "", extname: "", format: "", isAbsolute: "", join: "", matchesGlob: "", normalize: "", parse: "", posix: "", relative: "", resolve: "", sep: "", toNamespacedPath: "", win32: "" };
});
var fe = g((_) => {
  "use strict";
  Object.defineProperty(_, "__esModule", { value: true });
  _.getUint64 = _.getInt64 = _.setInt64 = _.setUint64 = _.UINT32_MAX = void 0;
  _.UINT32_MAX = 4294967295;
  function Wr(r5, e, t) {
    let s = t / 4294967296, n = t;
    r5.setUint32(e, s), r5.setUint32(e + 4, n);
  }
  _.setUint64 = Wr;
  function Ar(r5, e, t) {
    let s = Math.floor(t / 4294967296), n = t;
    r5.setUint32(e, s), r5.setUint32(e + 4, n);
  }
  _.setInt64 = Ar;
  function Dr(r5, e) {
    let t = r5.getInt32(e), s = r5.getUint32(e + 4);
    return t * 4294967296 + s;
  }
  _.getInt64 = Dr;
  function Or(r5, e) {
    let t = r5.getUint32(e), s = r5.getUint32(e + 4);
    return t * 4294967296 + s;
  }
  _.getUint64 = Or;
});
var _e = g((E) => {
  "use strict";
  var Qe, Ye, Ze;
  Object.defineProperty(E, "__esModule", { value: true });
  E.utf8DecodeTD = E.TEXT_DECODER_THRESHOLD = E.utf8DecodeJs = E.utf8EncodeTE = E.TEXT_ENCODER_THRESHOLD = E.utf8EncodeJs = E.utf8Count = void 0;
  var Nt = fe(), ke = (typeof process > "u" || ((Qe = process == null ? void 0 : process.env) === null || Qe === void 0 ? void 0 : Qe.TEXT_ENCODING) !== "never") && typeof TextEncoder < "u" && typeof TextDecoder < "u";
  function Cr(r5) {
    let e = r5.length, t = 0, s = 0;
    for (; s < e; ) {
      let n = r5.charCodeAt(s++);
      if ((n & 4294967168) === 0) {
        t++;
        continue;
      } else if ((n & 4294965248) === 0) t += 2;
      else {
        if (n >= 55296 && n <= 56319 && s < e) {
          let o = r5.charCodeAt(s);
          (o & 64512) === 56320 && (++s, n = ((n & 1023) << 10) + (o & 1023) + 65536);
        }
        (n & 4294901760) === 0 ? t += 3 : t += 4;
      }
    }
    return t;
  }
  E.utf8Count = Cr;
  function Ir(r5, e, t) {
    let s = r5.length, n = t, o = 0;
    for (; o < s; ) {
      let a = r5.charCodeAt(o++);
      if ((a & 4294967168) === 0) {
        e[n++] = a;
        continue;
      } else if ((a & 4294965248) === 0) e[n++] = a >> 6 & 31 | 192;
      else {
        if (a >= 55296 && a <= 56319 && o < s) {
          let i = r5.charCodeAt(o);
          (i & 64512) === 56320 && (++o, a = ((a & 1023) << 10) + (i & 1023) + 65536);
        }
        (a & 4294901760) === 0 ? (e[n++] = a >> 12 & 15 | 224, e[n++] = a >> 6 & 63 | 128) : (e[n++] = a >> 18 & 7 | 240, e[n++] = a >> 12 & 63 | 128, e[n++] = a >> 6 & 63 | 128);
      }
      e[n++] = a & 63 | 128;
    }
  }
  E.utf8EncodeJs = Ir;
  var me = ke ? new TextEncoder() : void 0;
  E.TEXT_ENCODER_THRESHOLD = ke ? typeof process < "u" && ((Ye = process == null ? void 0 : process.env) === null || Ye === void 0 ? void 0 : Ye.TEXT_ENCODING) !== "force" ? 200 : 0 : Nt.UINT32_MAX;
  function Ur(r5, e, t) {
    e.set(me.encode(r5), t);
  }
  function Nr(r5, e, t) {
    me.encodeInto(r5, e.subarray(t));
  }
  E.utf8EncodeTE = me?.encodeInto ? Nr : Ur;
  var Br = 4096;
  function jr(r5, e, t) {
    let s = e, n = s + t, o = [], a = "";
    for (; s < n; ) {
      let i = r5[s++];
      if ((i & 128) === 0) o.push(i);
      else if ((i & 224) === 192) {
        let c = r5[s++] & 63;
        o.push((i & 31) << 6 | c);
      } else if ((i & 240) === 224) {
        let c = r5[s++] & 63, R = r5[s++] & 63;
        o.push((i & 31) << 12 | c << 6 | R);
      } else if ((i & 248) === 240) {
        let c = r5[s++] & 63, R = r5[s++] & 63, d = r5[s++] & 63, M = (i & 7) << 18 | c << 12 | R << 6 | d;
        M > 65535 && (M -= 65536, o.push(M >>> 10 & 1023 | 55296), M = 56320 | M & 1023), o.push(M);
      } else o.push(i);
      o.length >= Br && (a += String.fromCharCode(...o), o.length = 0);
    }
    return o.length > 0 && (a += String.fromCharCode(...o)), a;
  }
  E.utf8DecodeJs = jr;
  var Lr = ke ? new TextDecoder() : null;
  E.TEXT_DECODER_THRESHOLD = ke ? typeof process < "u" && ((Ze = process == null ? void 0 : process.env) === null || Ze === void 0 ? void 0 : Ze.TEXT_DECODER) !== "force" ? 200 : 0 : Nt.UINT32_MAX;
  function Fr(r5, e, t) {
    let s = r5.subarray(e, e + t);
    return Lr.decode(s);
  }
  E.utf8DecodeTD = Fr;
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
var st = g((w) => {
  "use strict";
  Object.defineProperty(w, "__esModule", { value: true });
  w.timestampExtension = w.decodeTimestampExtension = w.decodeTimestampToTimeSpec = w.encodeTimestampExtension = w.encodeDateToTimeSpec = w.encodeTimeSpecToTimestamp = w.EXT_TIMESTAMP = void 0;
  var Vr = Ae(), Bt = fe();
  w.EXT_TIMESTAMP = -1;
  var qr = 4294967296 - 1, Jr = 17179869184 - 1;
  function jt({ sec: r5, nsec: e }) {
    if (r5 >= 0 && e >= 0 && r5 <= Jr) if (e === 0 && r5 <= qr) {
      let t = new Uint8Array(4);
      return new DataView(t.buffer).setUint32(0, r5), t;
    } else {
      let t = r5 / 4294967296, s = r5 & 4294967295, n = new Uint8Array(8), o = new DataView(n.buffer);
      return o.setUint32(0, e << 2 | t & 3), o.setUint32(4, s), n;
    }
    else {
      let t = new Uint8Array(12), s = new DataView(t.buffer);
      return s.setUint32(0, e), (0, Bt.setInt64)(s, 4, r5), t;
    }
  }
  w.encodeTimeSpecToTimestamp = jt;
  function Lt(r5) {
    let e = r5.getTime(), t = Math.floor(e / 1e3), s = (e - t * 1e3) * 1e6, n = Math.floor(s / 1e9);
    return { sec: t + n, nsec: s - n * 1e9 };
  }
  w.encodeDateToTimeSpec = Lt;
  function Ft(r5) {
    if (r5 instanceof Date) {
      let e = Lt(r5);
      return jt(e);
    } else return null;
  }
  w.encodeTimestampExtension = Ft;
  function Vt(r5) {
    let e = new DataView(r5.buffer, r5.byteOffset, r5.byteLength);
    switch (r5.byteLength) {
      case 4:
        return { sec: e.getUint32(0), nsec: 0 };
      case 8: {
        let t = e.getUint32(0), s = e.getUint32(4), n = (t & 3) * 4294967296 + s, o = t >>> 2;
        return { sec: n, nsec: o };
      }
      case 12: {
        let t = (0, Bt.getInt64)(e, 4), s = e.getUint32(0);
        return { sec: t, nsec: s };
      }
      default:
        throw new Vr.DecodeError(`Unrecognized data size for timestamp (expected 4, 8, or 12): ${r5.length}`);
    }
  }
  w.decodeTimestampToTimeSpec = Vt;
  function qt(r5) {
    let e = Vt(r5);
    return new Date(e.sec * 1e3 + e.nsec / 1e6);
  }
  w.decodeTimestampExtension = qt;
  w.timestampExtension = { type: w.EXT_TIMESTAMP, encode: Ft, decode: qt };
});
var Ce = g((Oe) => {
  "use strict";
  Object.defineProperty(Oe, "__esModule", { value: true });
  Oe.ExtensionCodec = void 0;
  var De = tt(), Hr = st(), Re = class {
    constructor() {
      this.builtInEncoders = [], this.builtInDecoders = [], this.encoders = [], this.decoders = [], this.register(Hr.timestampExtension);
    }
    register({ type: e, encode: t, decode: s }) {
      if (e >= 0) this.encoders[e] = t, this.decoders[e] = s;
      else {
        let n = 1 + e;
        this.builtInEncoders[n] = t, this.builtInDecoders[n] = s;
      }
    }
    tryToEncode(e, t) {
      for (let s = 0; s < this.builtInEncoders.length; s++) {
        let n = this.builtInEncoders[s];
        if (n != null) {
          let o = n(e, t);
          if (o != null) {
            let a = -1 - s;
            return new De.ExtData(a, o);
          }
        }
      }
      for (let s = 0; s < this.encoders.length; s++) {
        let n = this.encoders[s];
        if (n != null) {
          let o = n(e, t);
          if (o != null) {
            let a = s;
            return new De.ExtData(a, o);
          }
        }
      }
      return e instanceof De.ExtData ? e : null;
    }
    decode(e, t, s) {
      let n = t < 0 ? this.builtInDecoders[-1 - t] : this.decoders[t];
      return n ? n(e, t, s) : new De.ExtData(t, e);
    }
  };
  Oe.ExtensionCodec = Re;
  Re.defaultCodec = new Re();
});
var nt = g((te) => {
  "use strict";
  Object.defineProperty(te, "__esModule", { value: true });
  te.createDataView = te.ensureUint8Array = void 0;
  function Jt(r5) {
    return r5 instanceof Uint8Array ? r5 : ArrayBuffer.isView(r5) ? new Uint8Array(r5.buffer, r5.byteOffset, r5.byteLength) : r5 instanceof ArrayBuffer ? new Uint8Array(r5) : Uint8Array.from(r5);
  }
  te.ensureUint8Array = Jt;
  function zr(r5) {
    if (r5 instanceof ArrayBuffer) return new DataView(r5);
    let e = Jt(r5);
    return new DataView(e.buffer, e.byteOffset, e.byteLength);
  }
  te.createDataView = zr;
});
var at = g((O) => {
  "use strict";
  Object.defineProperty(O, "__esModule", { value: true });
  O.Encoder = O.DEFAULT_INITIAL_BUFFER_SIZE = O.DEFAULT_MAX_DEPTH = void 0;
  var ge = _e(), Gr = Ce(), Ht = fe(), $r = nt();
  O.DEFAULT_MAX_DEPTH = 100;
  O.DEFAULT_INITIAL_BUFFER_SIZE = 2048;
  var ot = class {
    constructor(e = Gr.ExtensionCodec.defaultCodec, t = void 0, s = O.DEFAULT_MAX_DEPTH, n = O.DEFAULT_INITIAL_BUFFER_SIZE, o = false, a = false, i = false, c = false) {
      this.extensionCodec = e, this.context = t, this.maxDepth = s, this.initialBufferSize = n, this.sortKeys = o, this.forceFloat32 = a, this.ignoreUndefined = i, this.forceIntegerToFloat = c, this.pos = 0, this.view = new DataView(new ArrayBuffer(this.initialBufferSize)), this.bytes = new Uint8Array(this.view.buffer);
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
      let t = new ArrayBuffer(e), s = new Uint8Array(t), n = new DataView(t);
      s.set(this.bytes), this.view = n, this.bytes = s;
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
      if (e.length > ge.TEXT_ENCODER_THRESHOLD) {
        let n = (0, ge.utf8Count)(e);
        this.ensureBufferSizeToWrite(5 + n), this.writeStringHeader(n), (0, ge.utf8EncodeTE)(e, this.bytes, this.pos), this.pos += n;
      } else {
        let n = (0, ge.utf8Count)(e);
        this.ensureBufferSizeToWrite(5 + n), this.writeStringHeader(n), (0, ge.utf8EncodeJs)(e, this.bytes, this.pos), this.pos += n;
      }
    }
    encodeObject(e, t) {
      let s = this.extensionCodec.tryToEncode(e, this.context);
      if (s != null) this.encodeExtension(s);
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
      let s = (0, $r.ensureUint8Array)(e);
      this.writeU8a(s);
    }
    encodeArray(e, t) {
      let s = e.length;
      if (s < 16) this.writeU8(144 + s);
      else if (s < 65536) this.writeU8(220), this.writeU16(s);
      else if (s < 4294967296) this.writeU8(221), this.writeU32(s);
      else throw new Error(`Too large array: ${s}`);
      for (let n of e) this.doEncode(n, t + 1);
    }
    countWithoutUndefined(e, t) {
      let s = 0;
      for (let n of t) e[n] !== void 0 && s++;
      return s;
    }
    encodeMap(e, t) {
      let s = Object.keys(e);
      this.sortKeys && s.sort();
      let n = this.ignoreUndefined ? this.countWithoutUndefined(e, s) : s.length;
      if (n < 16) this.writeU8(128 + n);
      else if (n < 65536) this.writeU8(222), this.writeU16(n);
      else if (n < 4294967296) this.writeU8(223), this.writeU32(n);
      else throw new Error(`Too large map object: ${n}`);
      for (let o of s) {
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
  O.Encoder = ot;
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
var $t = g((Ne) => {
  "use strict";
  Object.defineProperty(Ne, "__esModule", { value: true });
  Ne.CachedKeyDecoder = void 0;
  var Zr = _e(), es = 16, ts = 16, it = class {
    constructor(e = es, t = ts) {
      this.maxKeyLength = e, this.maxLengthPerKey = t, this.hit = 0, this.miss = 0, this.caches = [];
      for (let s = 0; s < this.maxKeyLength; s++) this.caches.push([]);
    }
    canBeCached(e) {
      return e > 0 && e <= this.maxKeyLength;
    }
    find(e, t, s) {
      let n = this.caches[s - 1];
      e: for (let o of n) {
        let a = o.bytes;
        for (let i = 0; i < s; i++) if (a[i] !== e[t + i]) continue e;
        return o.str;
      }
      return null;
    }
    store(e, t) {
      let s = this.caches[e.length - 1], n = { bytes: e, str: t };
      s.length >= this.maxLengthPerKey ? s[Math.random() * s.length | 0] = n : s.push(n);
    }
    decode(e, t, s) {
      let n = this.find(e, t, s);
      if (n != null) return this.hit++, n;
      this.miss++;
      let o = (0, Zr.utf8DecodeJs)(e, t, s), a = Uint8Array.prototype.slice.call(e, t, t + s);
      return this.store(a, o), o;
    }
  };
  Ne.CachedKeyDecoder = it;
});
var Be = g((j) => {
  "use strict";
  Object.defineProperty(j, "__esModule", { value: true });
  j.Decoder = j.DataViewIndexOutOfBoundsError = void 0;
  var lt = Gt(), rs = Ce(), X = fe(), ct = _e(), ut = nt(), ss = $t(), B = Ae(), ns = (r5) => {
    let e = typeof r5;
    return e === "string" || e === "number";
  }, be = -1, dt = new DataView(new ArrayBuffer(0)), os = new Uint8Array(dt.buffer);
  j.DataViewIndexOutOfBoundsError = (() => {
    try {
      dt.getInt8(0);
    } catch (r5) {
      return r5.constructor;
    }
    throw new Error("never reached");
  })();
  var Xt = new j.DataViewIndexOutOfBoundsError("Insufficient data"), as = new ss.CachedKeyDecoder(), pt = class {
    constructor(e = rs.ExtensionCodec.defaultCodec, t = void 0, s = X.UINT32_MAX, n = X.UINT32_MAX, o = X.UINT32_MAX, a = X.UINT32_MAX, i = X.UINT32_MAX, c = as) {
      this.extensionCodec = e, this.context = t, this.maxStrLength = s, this.maxBinLength = n, this.maxArrayLength = o, this.maxMapLength = a, this.maxExtLength = i, this.keyDecoder = c, this.totalPos = 0, this.pos = 0, this.view = dt, this.bytes = os, this.headByte = be, this.stack = [];
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
        let t = this.bytes.subarray(this.pos), s = (0, ut.ensureUint8Array)(e), n = new Uint8Array(t.length + s.length);
        n.set(t), n.set(s, t.length), this.setBuffer(n);
      }
    }
    hasRemaining(e) {
      return this.view.byteLength - this.pos >= e;
    }
    createExtraByteError(e) {
      let { view: t, pos: s } = this;
      return new RangeError(`Extra ${t.byteLength - s} of ${t.byteLength} byte(s) found at buffer[${e}]`);
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
      let t = false, s;
      for await (let i of e) {
        if (t) throw this.createExtraByteError(this.totalPos);
        this.appendBuffer(i);
        try {
          s = this.doDecodeSync(), t = true;
        } catch (c) {
          if (!(c instanceof j.DataViewIndexOutOfBoundsError)) throw c;
        }
        this.totalPos += this.pos;
      }
      if (t) {
        if (this.hasRemaining(1)) throw this.createExtraByteError(this.totalPos);
        return s;
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
      let s = t, n = -1;
      for await (let o of e) {
        if (t && n === 0) throw this.createExtraByteError(this.totalPos);
        this.appendBuffer(o), s && (n = this.readArraySize(), s = false, this.complete());
        try {
          for (; yield this.doDecodeSync(), --n !== 0; ) ;
        } catch (a) {
          if (!(a instanceof j.DataViewIndexOutOfBoundsError)) throw a;
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
        } else throw new B.DecodeError(`Unrecognized type byte: ${(0, lt.prettyByte)(e)}`);
        this.complete();
        let s = this.stack;
        for (; s.length > 0; ) {
          let n = s[s.length - 1];
          if (n.type === 0) if (n.array[n.position] = t, n.position++, n.position === n.size) s.pop(), t = n.array;
          else continue e;
          else if (n.type === 1) {
            if (!ns(t)) throw new B.DecodeError("The type of key must be string or number but " + typeof t);
            if (t === "__proto__") throw new B.DecodeError("The key __proto__ is not allowed");
            n.key = t, n.type = 2;
            continue e;
          } else if (n.map[n.key] = t, n.readCount++, n.readCount === n.size) s.pop(), t = n.map;
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
          throw new B.DecodeError(`Unrecognized array type byte: ${(0, lt.prettyByte)(e)}`);
        }
      }
    }
    pushMapState(e) {
      if (e > this.maxMapLength) throw new B.DecodeError(`Max length exceeded: map length (${e}) > maxMapLengthLength (${this.maxMapLength})`);
      this.stack.push({ type: 1, size: e, key: null, readCount: 0, map: {} });
    }
    pushArrayState(e) {
      if (e > this.maxArrayLength) throw new B.DecodeError(`Max length exceeded: array length (${e}) > maxArrayLength (${this.maxArrayLength})`);
      this.stack.push({ type: 0, size: e, array: new Array(e), position: 0 });
    }
    decodeUtf8String(e, t) {
      var s;
      if (e > this.maxStrLength) throw new B.DecodeError(`Max length exceeded: UTF-8 byte length (${e}) > maxStrLength (${this.maxStrLength})`);
      if (this.bytes.byteLength < this.pos + t + e) throw Xt;
      let n = this.pos + t, o;
      return this.stateIsMapKey() && (!((s = this.keyDecoder) === null || s === void 0) && s.canBeCached(e)) ? o = this.keyDecoder.decode(this.bytes, n, e) : e > ct.TEXT_DECODER_THRESHOLD ? o = (0, ct.utf8DecodeTD)(this.bytes, n, e) : o = (0, ct.utf8DecodeJs)(this.bytes, n, e), this.pos += t + e, o;
    }
    stateIsMapKey() {
      return this.stack.length > 0 ? this.stack[this.stack.length - 1].type === 1 : false;
    }
    decodeBinary(e, t) {
      if (e > this.maxBinLength) throw new B.DecodeError(`Max length exceeded: bin length (${e}) > maxBinLength (${this.maxBinLength})`);
      if (!this.hasRemaining(e + t)) throw Xt;
      let s = this.pos + t, n = this.bytes.subarray(s, s + e);
      return this.pos += t + e, n;
    }
    decodeExtension(e, t) {
      if (e > this.maxExtLength) throw new B.DecodeError(`Max length exceeded: ext length (${e}) > maxExtLength (${this.maxExtLength})`);
      let s = this.view.getInt8(this.pos + t), n = this.decodeBinary(e, t + 1);
      return this.extensionCodec.decode(n, s, this.context);
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
  j.Decoder = pt;
});
var ht = g((C) => {
  "use strict";
  Object.defineProperty(C, "__esModule", { value: true });
  C.decodeMulti = C.decode = C.defaultDecodeOptions = void 0;
  var Kt = Be();
  C.defaultDecodeOptions = {};
  function is(r5, e = C.defaultDecodeOptions) {
    return new Kt.Decoder(e.extensionCodec, e.context, e.maxStrLength, e.maxBinLength, e.maxArrayLength, e.maxMapLength, e.maxExtLength).decode(r5);
  }
  C.decode = is;
  function ls(r5, e = C.defaultDecodeOptions) {
    return new Kt.Decoder(e.extensionCodec, e.context, e.maxStrLength, e.maxBinLength, e.maxArrayLength, e.maxMapLength, e.maxExtLength).decodeMulti(r5);
  }
  C.decodeMulti = ls;
});
var Zt = g((q) => {
  "use strict";
  Object.defineProperty(q, "__esModule", { value: true });
  q.ensureAsyncIterable = q.asyncIterableFromStream = q.isAsyncIterable = void 0;
  function Qt(r5) {
    return r5[Symbol.asyncIterator] != null;
  }
  q.isAsyncIterable = Qt;
  function cs(r5) {
    if (r5 == null) throw new Error("Assertion Failure: value must not be null nor undefined");
  }
  async function* Yt(r5) {
    let e = r5.getReader();
    try {
      for (; ; ) {
        let { done: t, value: s } = await e.read();
        if (t) return;
        cs(s), yield s;
      }
    } finally {
      e.releaseLock();
    }
  }
  q.asyncIterableFromStream = Yt;
  function us(r5) {
    return Qt(r5) ? r5 : Yt(r5);
  }
  q.ensureAsyncIterable = us;
});
var tr = g((I) => {
  "use strict";
  Object.defineProperty(I, "__esModule", { value: true });
  I.decodeStream = I.decodeMultiStream = I.decodeArrayStream = I.decodeAsync = void 0;
  var yt = Be(), ft = Zt(), je = ht();
  async function ps(r5, e = je.defaultDecodeOptions) {
    let t = (0, ft.ensureAsyncIterable)(r5);
    return new yt.Decoder(e.extensionCodec, e.context, e.maxStrLength, e.maxBinLength, e.maxArrayLength, e.maxMapLength, e.maxExtLength).decodeAsync(t);
  }
  I.decodeAsync = ps;
  function ds(r5, e = je.defaultDecodeOptions) {
    let t = (0, ft.ensureAsyncIterable)(r5);
    return new yt.Decoder(e.extensionCodec, e.context, e.maxStrLength, e.maxBinLength, e.maxArrayLength, e.maxMapLength, e.maxExtLength).decodeArrayStream(t);
  }
  I.decodeArrayStream = ds;
  function er(r5, e = je.defaultDecodeOptions) {
    let t = (0, ft.ensureAsyncIterable)(r5);
    return new yt.Decoder(e.extensionCodec, e.context, e.maxStrLength, e.maxBinLength, e.maxArrayLength, e.maxMapLength, e.maxExtLength).decodeStream(t);
  }
  I.decodeMultiStream = er;
  function hs(r5, e = je.defaultDecodeOptions) {
    return er(r5, e);
  }
  I.decodeStream = hs;
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
  var re = st();
  Object.defineProperty(u, "EXT_TIMESTAMP", { enumerable: true, get: function() {
    return re.EXT_TIMESTAMP;
  } });
  Object.defineProperty(u, "encodeDateToTimeSpec", { enumerable: true, get: function() {
    return re.encodeDateToTimeSpec;
  } });
  Object.defineProperty(u, "encodeTimeSpecToTimestamp", { enumerable: true, get: function() {
    return re.encodeTimeSpecToTimestamp;
  } });
  Object.defineProperty(u, "decodeTimestampToTimeSpec", { enumerable: true, get: function() {
    return re.decodeTimestampToTimeSpec;
  } });
  Object.defineProperty(u, "encodeTimestampExtension", { enumerable: true, get: function() {
    return re.encodeTimestampExtension;
  } });
  Object.defineProperty(u, "decodeTimestampExtension", { enumerable: true, get: function() {
    return re.decodeTimestampExtension;
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
  let s = document.createElement("script");
  s.src = r5, s.onload = () => e(), s.onerror = t, document.head.appendChild(s);
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
  let t = {}, s = { n: 0 };
  try {
    let n = new le(e);
    y(n, s), t.code = l.allocateUTF8(r5);
    let o = l._R_ParseEvalString(t.code, n.ptr);
    return p.wrap(o);
  } finally {
    Tt(t), b(s.n);
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
  if (r5.every((s) => s && typeof s == "object" && !Te(s) && !H(s))) {
    let s = r5, n = s.every((a) => Object.keys(a).filter((i) => !Object.keys(s[0]).includes(i)).length === 0 && Object.keys(s[0]).filter((i) => !Object.keys(a).includes(i)).length === 0), o = s.every((a) => Object.values(a).every((i) => Ct(i) || Ot(i)));
    if (n && o) return de.fromD3(s);
  }
  if (r5.every((s) => typeof s == "boolean" || s === null)) return new z(r5);
  if (r5.every((s) => typeof s == "number" || s === null)) return new ye(r5);
  if (r5.every((s) => typeof s == "string" || s === null)) return new N(r5);
  try {
    let s = new F([new k("c"), ...r5]);
    return y(s, e), s.eval();
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
    return Object.keys(W).find((s) => W[s] === e);
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
    let t = l._TYPEOF(e), s = Object.keys(W)[Object.values(W).indexOf(t)];
    return new (Dt(s))(new f(e));
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
    else if (Array.isArray(e) && e.every((s) => typeof s == "string" || s === null)) t = new N(e);
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
      let s = (o, a) => {
        let i = o.get(a);
        return _t(i, t);
      }, n = e.reduce(s, this);
      return n.isNull() ? void 0 : n;
    } finally {
      kt(t);
    }
  }
  set(e, t) {
    let s = { n: 0 };
    try {
      let n = new _a(e);
      y(n, s);
      let o = new _a(t);
      y(o, s);
      let a = new k("[[<-"), i = l._Rf_lang4(a.ptr, this.ptr, n.ptr, o.ptr);
      return y(i, s), _a.wrap(ie(i, x.baseEnv));
    } finally {
      b(s.n);
    }
  }
  static getMethods(e) {
    let t = /* @__PURE__ */ new Set(), s = e;
    do
      Object.getOwnPropertyNames(s).map((n) => t.add(n));
    while (s = Object.getPrototypeOf(s));
    return [...t.keys()].filter((n) => typeof e[n] == "function");
  }
}, _r_instances = new WeakSet(), e_fn = function(e, t) {
  let s = { n: 0 };
  try {
    let n = new _a(e);
    y(n, s);
    let o = l._Rf_lang3(t, this.ptr, n.ptr);
    return y(o, s), _a.wrap(ie(o, x.baseEnv));
  } finally {
    b(s.n);
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
      let { names: s, values: n } = Z(e), o = r.wrap(l._Rf_allocList(n.length));
      y(o, t);
      for (let [a, i] = [0, o]; !i.isNull(); [a, i] = [a + 1, i.cdr()]) i.setcar(new p(n[a]));
      o.setNames(s), super(o);
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
  toObject({ allowDuplicateKey: e = true, allowEmptyKey: t = false, depth: s = -1 } = {}) {
    let n = this.entries({ depth: s }), o = n.map(([a]) => a);
    if (!e && new Set(o).size !== o.length) throw new Error("Duplicate key when converting pairlist without allowDuplicateKey enabled");
    if (!t && o.some((a) => !a)) throw new Error("Empty or null key when converting pairlist without allowEmptyKey enabled");
    return Object.fromEntries(n.filter((a, i) => n.findIndex((c) => c[0] === a[0]) === i));
  }
  entries(e = { depth: 1 }) {
    let t = this.toJs(e);
    return t.values.map((s, n) => [t.names ? t.names[n] : null, s]);
  }
  toJs(e = { depth: 0 }, t = 1) {
    let s = [], n = false, o = [];
    for (let i = this; !i.isNull(); i = i.cdr()) {
      let c = i.tag();
      c.isNull() ? s.push("") : (n = true, s.push(c.toString())), e.depth && t >= e.depth ? o.push(i.car()) : o.push(i.car().toJs(e, t + 1));
    }
    return { type: "pairlist", names: n ? s : null, values: o };
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
      let { values: s } = Z(e), n = s.map((a) => y(new p(a), t)), o = r2.wrap(l._Rf_allocVector(W.call, s.length));
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
      let s = N.wrap(ie(t, x.baseEnv));
      return y(s, e), s.toString();
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
    let s = { n: 0 };
    try {
      let n = Z(e), o = l._Rf_allocVector(W.list, n.values.length);
      y(o, s), n.values.forEach((i, c) => {
        It(i) ? l._SET_VECTOR_ELT(o, c, new r3(i).ptr) : l._SET_VECTOR_ELT(o, c, new p(i).ptr);
      });
      let a = t || n.names;
      if (a && a.length !== n.values.length) throw new Error("Can't construct named `RList`. Supplied `names` must be the same length as the list.");
      p.wrap(o).setNames(a), super(new f(o));
    } finally {
      b(s.n);
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
  toObject({ allowDuplicateKey: e = true, allowEmptyKey: t = false, depth: s = -1 } = {}) {
    let n = this.entries({ depth: s }), o = n.map(([a]) => a);
    if (!e && new Set(o).size !== o.length) throw new Error("Duplicate key when converting list without allowDuplicateKey enabled");
    if (!t && o.some((a) => !a)) throw new Error("Empty or null key when converting list without allowEmptyKey enabled");
    return Object.fromEntries(n.filter((a, i) => n.findIndex((c) => c[0] === a[0]) === i));
  }
  toD3() {
    if (!this.isDataFrame()) throw new Error("Can't convert R list object to D3 format. Object must be of class 'data.frame'.");
    return this.entries().reduce((t, s) => (s[1].forEach((n, o) => t[o] = Object.assign(t[o] || {}, { [s[0]]: n })), t), []);
  }
  entries(e = { depth: -1 }) {
    let t = this.toJs(e);
    return this.isDataFrame() && e.depth < 0 && (t.values = t.values.map((s) => s.toArray())), t.values.map((s, n) => [t.names ? t.names[n] : null, s]);
  }
  toJs(e = { depth: 0 }, t = 1) {
    return { type: "list", names: this.names(), values: [...Array(this.length).keys()].map((s) => e.depth && t >= e.depth ? this.get(s + 1) : this.get(s + 1).toJs(e, t + 1)) };
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
    let { names: t, values: s } = Z(e), n = { n: 0 };
    try {
      let o = !!t && t.length > 0 && t.every((i) => i), a = s.length > 0 && s.every((i) => Array.isArray(i) || ArrayBuffer.isView(i) || i instanceof ArrayBuffer);
      if (o && a) {
        let i = s, c = i.every((d) => d.length === i[0].length), R = i.every((d) => Ct(d[0]) || Ot(d[0]));
        if (c && R) {
          let d = new pe({ type: "list", names: t, values: i.map((Ee) => At(Ee)) });
          y(d, n);
          let M = new F([new k("as.data.frame"), d]);
          return y(M, n), new r4(M.eval());
        }
      }
    } finally {
      b(n.n);
    }
    throw new Error("Can't construct `data.frame`. Source object is not eligible.");
  }
  static fromD3(e) {
    return this.fromObject(Object.fromEntries(Object.keys(e[0]).map((t) => [t, e.map((s) => s[t])])));
  }
};
var Y = class extends p {
  exec(...e) {
    let t = { n: 0 };
    try {
      let s = new F([this, ...e]);
      return y(s, t), s.eval();
    } finally {
      b(t.n);
    }
  }
  capture(e = {}, ...t) {
    let s = { n: 0 };
    try {
      let n = new F([this, ...t]);
      return y(n, s), n.capture(e);
    } finally {
      b(s.n);
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
      let { names: s, values: n } = Z(e), o = ae(l._R_NewEnv(x.globalEnv.ptr, 0, 0));
      ++t, n.forEach((a, i) => {
        let c = s ? s[i] : null;
        if (!c) throw new Error("Can't create object in new environment with empty symbol name");
        let R = new k(c), d = ae(new p(a));
        try {
          Ge(o, R, d);
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
    let s = new k(e), n = ae(new p(t));
    try {
      Ge(this, s, n);
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
    return Object.fromEntries([...Array(t.length).keys()].map((s) => {
      let n = this.getDollar(t[s]);
      return [t[s], e < 0 ? n : n.toJs({ depth: e })];
    }));
  }
  toJs(e = { depth: 0 }, t = 1) {
    let s = this.names(), n = [...Array(s.length).keys()].map((o) => e.depth && t >= e.depth ? this.getDollar(s[o]) : this.getDollar(s[o]).toJs(e, t + 1));
    return { type: "environment", names: s, values: n };
  }
};
var V = class extends p {
  constructor(e, t, s) {
    if (e instanceof f) return G(e, t), super(e), this;
    let n = { n: 0 };
    try {
      let { names: o, values: a } = Z(e), i = l._Rf_allocVector(W[t], a.length);
      y(i, n), a.forEach(s(i)), p.wrap(i).setNames(o), super(new f(i));
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
      let s = z.wrap(ie(t, x.baseEnv));
      y(s, e);
      let n = s.toTypedArray();
      return Array.from(n).map((o) => !!o);
    } finally {
      b(e.n);
    }
  }
  toArray() {
    let e = this.toTypedArray();
    return this.detectMissing().map((t, s) => t ? null : e[s]);
  }
  toObject({ allowDuplicateKey: e = true, allowEmptyKey: t = false } = {}) {
    let s = this.entries(), n = s.map(([o]) => o);
    if (!e && new Set(n).size !== n.length) throw new Error("Duplicate key when converting atomic vector without allowDuplicateKey enabled");
    if (!t && n.some((o) => !o)) throw new Error("Empty or null key when converting atomic vector without allowEmptyKey enabled");
    return Object.fromEntries(s.filter((o, a) => s.findIndex((i) => i[0] === o[0]) === a));
  }
  entries() {
    let e = this.toArray(), t = this.names();
    return e.map((s, n) => [t ? t[n] : null, s]);
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
    return this.detectMissing().map((t, s) => t ? null : !!e[s]);
  }
}, _e2 = new WeakMap(), __privateAdd(_a3, _e2, (e) => {
  let t = l._LOGICAL(e), s = l.getValue(l._R_NaInt, "i32");
  return (n, o) => {
    l.setValue(t + 4 * o, n === null ? s : Number(n), "i32");
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
  let t = l._INTEGER(e), s = l.getValue(l._R_NaInt, "i32");
  return (n, o) => {
    l.setValue(t + 4 * o, n === null ? s : Math.round(Number(n)), "i32");
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
  let t = l._REAL(e), s = l.getValue(l._R_NaReal, "double");
  return (n, o) => {
    l.setValue(t + 8 * o, n === null ? s : n, "double");
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
    return this.detectMissing().map((t, s) => t ? null : { re: e[2 * s], im: e[2 * s + 1] });
  }
}, _e5 = new WeakMap(), __privateAdd(_a6, _e5, (e) => {
  let t = l._COMPLEX(e), s = l.getValue(l._R_NaReal, "double");
  return (n, o) => {
    l.setValue(t + 8 * (2 * o), n === null ? s : n.re, "double"), l.setValue(t + 8 * (2 * o + 1), n === null ? s : n.im, "double");
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
      return this.detectMissing().map((t, s) => t ? null : l.UTF8ToString(l._Rf_translateCharUTF8(l._STRING_ELT(this.ptr, s))));
    } finally {
      l._vmaxset(e);
    }
  }
}, _e6 = new WeakMap(), __privateAdd(_a7, _e6, (e) => (t, s) => {
  t === null ? l._SET_STRING_ELT(e, s, x.naString.ptr) : l._SET_STRING_ELT(e, s, new he(t).ptr);
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
  return (s, n) => {
    l.setValue(t + n, Number(s), "i8");
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
async function fetchASGI(client, resource, init, filter = (bodyChunk) => bodyChunk) {
  if (typeof resource === "string" || typeof init !== "undefined") {
    resource = new Request(resource, init);
  }
  const channel = new MessageChannel();
  const clientPort = channel.port1;
  client.postMessage(
    {
      type: "makeRequest",
      scope: reqToASGI(resource)
    },
    [channel.port2]
  );
  const blob = await resource.blob();
  if (!blob.size) {
    clientPort.postMessage({
      type: "http.request",
      more_body: false
    });
  } else {
    const reader = blob.stream().getReader();
    try {
      while (true) {
        const { value: theChunk, done } = await reader.read();
        clientPort.postMessage({
          type: "http.request",
          body: theChunk,
          more_body: !done
        });
        if (done) {
          break;
        }
      }
    } finally {
      reader.releaseLock();
    }
  }
  return new Promise((resolve) => {
    let streamController;
    const readableStream = new ReadableStream({
      start(controller) {
        streamController = controller;
      },
      cancel(reason) {
      }
    });
    let response;
    clientPort.addEventListener("message", (event) => {
      const msg = event.data;
      if (msg.type === "http.response.start") {
        response = asgiToRes(msg, readableStream);
        resolve(response);
      } else if (msg.type === "http.response.body") {
        if (msg.body) {
          streamController.enqueue(filter(msg.body, response));
        }
        if (!msg.more_body) {
          streamController.close();
          clientPort.close();
        }
      } else {
        throw new Error("Unexpected event type from clientPort: " + msg.type);
      }
    });
    clientPort.start();
  });
}
function headersToASGI(headers) {
  const result = [];
  for (const [key, value] of headers.entries()) {
    result.push([key, value]);
  }
  return result;
}
function reqToASGI(req) {
  const url = new URL(req.url);
  return {
    type: "http",
    asgi: {
      version: "3.0",
      spec_version: "2.1"
    },
    http_version: "1.1",
    method: req.method,
    scheme: url.protocol.replace(/:$/, ""),
    path: url.pathname,
    query_string: url.search.replace(/^\?/, ""),
    root_path: "",
    headers: headersToASGI(req.headers)
  };
}
function asgiToRes(res, body) {
  return new Response(body, {
    headers: res.headers,
    status: res.status
  });
}

// src/shinylive-sw.ts
var useCaching = false;
var cacheName = "::shinyliveServiceworker";
var version = "v10";
function addCoiHeaders(resp) {
  const headers = new Headers(resp.headers);
  headers.set("Cross-Origin-Embedder-Policy", "require-corp");
  headers.set("Cross-Origin-Resource-Policy", "cross-origin");
  headers.set("Cross-Origin-Opener-Policy", "same-origin");
  return new Response(resp.body, {
    status: resp.status,
    statusText: resp.statusText,
    headers
  });
}
function addCorpHeader(resp) {
  const headers = new Headers(resp.headers);
  headers.set("Cross-Origin-Resource-Policy", "cross-origin");
  return new Response(resp.body, {
    status: resp.status,
    statusText: resp.statusText,
    headers
  });
}
self.addEventListener("install", (event) => {
  event.waitUntil(
    Promise.all([self.skipWaiting(), caches.open(version + cacheName)])
  );
});
self.addEventListener("activate", function(event) {
  event.waitUntil(
    (async () => {
      await self.clients.claim();
      const keys = await caches.keys();
      return Promise.all(
        keys.filter(function(key) {
          return key.indexOf(version + cacheName) !== 0;
        }).map(function(key) {
          return caches.delete(key);
        })
      );
    })()
  );
});
self.addEventListener("fetch", function(event) {
  const request = event.request;
  const url = new URL(request.url);
  if (self.location.origin !== url.origin) return;
  if (url.pathname == "/esbuild") return;
  const base_path = dirname(self.location.pathname);
  if (url.pathname == `${base_path}/shinylive-inject-socket.js`) {
    event.respondWith(
      new Response(shinylive_inject_socket_default, {
        headers: { "Content-Type": "text/javascript" },
        status: 200
      })
    );
    return;
  }
  const coiRequested = url.searchParams.get("coi") === "1" || request.referrer.includes("coi=1");
  const appPathRegex = /.*\/(app_[^/]+\/)/;
  const m_appPath = appPathRegex.exec(url.pathname);
  if (m_appPath) {
    event.respondWith(
      (async () => {
        let pollCount = 5;
        while (!apps[m_appPath[1]]) {
          if (pollCount == 0) {
            return new Response(
              `Couldn't find parent page for ${url}. This may be because the Service Worker has updated. Try reloading the page.`,
              {
                status: 404
              }
            );
          }
          console.log("App URL not registered. Waiting 50ms.");
          await sleep(50);
          pollCount--;
        }
        url.pathname = url.pathname.replace(appPathRegex, "/");
        const isAppRoot = url.pathname === "/";
        const filter = isAppRoot ? injectSocketFilter : identityFilter;
        const blob = await request.blob();
        const resp = await fetchASGI(
          apps[m_appPath[1]],
          new Request(url.toString(), {
            method: request.method,
            headers: request.headers,
            body: request.method === "GET" || request.method === "HEAD" ? void 0 : blob,
            credentials: request.credentials,
            cache: request.cache,
            redirect: request.redirect,
            referrer: request.referrer
          }),
          void 0,
          filter
        );
        if (coiRequested) {
          return addCorpHeader(resp);
        } else {
          return resp;
        }
      })()
    );
    return;
  }
  if (request.method !== "GET") {
    return;
  }
  if (useCaching) {
    event.respondWith(
      (async () => {
        const cachedResponse = await caches.match(request);
        if (cachedResponse) {
          return cachedResponse;
        }
        try {
          const networkResponse = addCoiHeaders(await fetch(request));
          const baseUrl = self.location.origin + dirname(self.location.pathname);
          if (request.url.startsWith(baseUrl + "/shinylive/") || request.url === baseUrl + "/favicon.ico") {
            const cache = await caches.open(version + cacheName);
            await cache.put(request, networkResponse.clone());
          }
          return networkResponse;
        } catch {
          return new Response("Failed to find in cache, or fetch.", {
            status: 404
          });
        }
      })()
    );
    return;
  }
  if (coiRequested) {
    event.respondWith(
      (async () => {
        const resp = await fetch(request);
        return addCoiHeaders(resp);
      })()
    );
  }
});
var apps = {};
(async () => {
  const allClients = await self.clients.matchAll();
  for (const client of allClients) {
    client.postMessage({
      type: "serviceworkerStart"
    });
  }
})();
self.addEventListener("message", (event) => {
  const msg = event.data;
  if (msg.type === "configureProxyPath") {
    const path = msg.path;
    const port = event.ports[0];
    apps[path] = port;
  }
});
function identityFilter(bodyChunk, response) {
  return bodyChunk;
}
function injectSocketFilter(bodyChunk, response) {
  const contentType = response.headers.get("content-type");
  if (contentType && /^text\/html(;|$)/.test(contentType)) {
    const bodyChunkStr = uint8ArrayToString(bodyChunk);
    const base_path = dirname(self.location.pathname);
    const newStr = bodyChunkStr.replace(
      /<\/head>/,
      `<script src="${base_path}/shinylive-inject-socket.js" type="module"><\/script>
</head>`
    );
    const newChunk = Uint8Array.from(
      newStr.split("").map((s) => s.charCodeAt(0))
    );
    return newChunk;
  }
  return bodyChunk;
}
