/**
 * Created by wildlife on 7/24/14.
 */
package {
    public class FFT {
        var _n:int = 0;          // order
        var _bitrev:Vector.<uint> = null;  // bit reversal table
        var _cstb:Vector.<Number> = null;    // sin/cos table
        var _tre:Vector.<Number>, _tim:Vector.<Number>;


        public function FFT() {
        }


        function init(n:int) {
            if (n !== 0 && (n & (n - 1)) === 0) {
                _n = n;
                _setVariables();
                _makeBitReversal();
                _makeCosSinTable();
            } else {
                throw new Error("init: radix-2 required");
            }
        }

        // 1D-FFT
        function fft1d(re:Vector.<Number>, im:Vector.<Number>) {
            fft(re, im, 1);
        }

        // 1D-IFFT
        function ifft1d(re:Vector.<Number>, im:Vector.<Number>) {
            var n:Number = 1 / _n;
            fft(re, im, -1);
            for (var i:int = 0; i < _n; i++) {
                re[i] *= n;
                im[i] *= n;
            }
        }

        // 2D-FFT
        function fft2d(re:Array, im:Array) {
            var i = 0;
            // x-axis
            for (var y = 0; y < _n; y++) {
                i = y * _n;
                for (var x1 = 0; x1 < _n; x1++) {
                    _tre[x1] = re[x1 + i];
                    _tim[x1] = im[x1 + i];
                }
                this.fft1d(_tre, _tim);
                for (var x2 = 0; x2 < _n; x2++) {
                    re[x2 + i] = _tre[x2];
                    im[x2 + i] = _tim[x2];
                }
            }
            // y-axis
            for (var x = 0; x < _n; x++) {
                for (var y1 = 0; y1 < _n; y1++) {
                    i = x + y1 * _n;
                    _tre[y1] = re[i];
                    _tim[y1] = im[i];
                }
                this.fft1d(_tre, _tim);
                for (var y2 = 0; y2 < _n; y2++) {
                    i = x + y2 * _n;
                    re[i] = _tre[y2];
                    im[i] = _tim[y2];
                }
            }
        }

        // 2D-IFFT
        function ifft2d(re:Array, im:Array) {
            var i:uint = 0;
            // x-axis
            for (var y:int = 0; y < _n; y++) {
                i = y * _n;
                for (var x1:int = 0; x1 < _n; x1++) {
                    _tre[x1] = re[x1 + i];
                    _tim[x1] = im[x1 + i];
                }
                this.ifft1d(_tre, _tim);
                for (var x2:int = 0; x2 < _n; x2++) {
                    re[x2 + i] = _tre[x2];
                    im[x2 + i] = _tim[x2];
                }
            }
            // y-axis
            for (var x = 0; x < _n; x++) {
                for (var y1 = 0; y1 < _n; y1++) {
                    i = x + y1 * _n;
                    _tre[y1] = re[i];
                    _tim[y1] = im[i];
                }
                this.ifft1d(_tre, _tim);
                for (var y2 = 0; y2 < _n; y2++) {
                    i = x + y2 * _n;
                    re[i] = _tre[y2];
                    im[i] = _tim[y2];
                }
            }
        }

        // core operation of FFT
        function fft(re:Vector.<Number>, im:Vector.<Number>, inv:Number) {
            var d:uint, h:uint, ik:uint, m:uint, tmp:Number, wr:Number, wi:Number, xr:Number, xi:Number,
                    n4:uint = _n >> 2;
            // bit reversal
            for (var l:int = 0; l < _n; l++) {
                m = _bitrev[l];
                if (l < m) {
                    tmp = re[l];
                    re[l] = re[m];
                    re[m] = tmp;
                    tmp = im[l];
                    im[l] = im[m];
                    im[m] = tmp;
                }
            }
            // butterfly operation
            for (var k:int = 1; k < _n; k <<= 1) {
                h = 0;
                d = _n / (k << 1);
                for (var j:int = 0; j < k; j++) {
                    wr = _cstb[h + n4];
                    wi = inv * _cstb[h];
                    for (var i:int = j; i < _n; i += (k << 1)) {
                        ik = i + k;
                        xr = wr * re[ik] + wi * im[ik];
                        xi = wr * im[ik] - wi * re[ik];
                        re[ik] = re[i] - xr;
                        re[i] += xr;
                        im[ik] = im[i] - xi;
                        im[i] += xi;
                    }
                    h += d;
                }
            }
        }

        // set variables
        function _setVariables() {
            _bitrev = new Vector.<uint>(_n);
            _cstb = new Vector.<Number>(_n * 1.25);
            _tre = new Vector.<Number>(_n * _n);
            _tim = new Vector.<Number>(_n * _n);
        }

        // make bit reversal table
        function _makeBitReversal() {
            var i:uint = 0,
                    j:uint = 0,
                    k:uint = 0;
            _bitrev[0] = 0;
            while (++i < _n) {
                k = _n >> 1;
                while (k <= j) {
                    j -= k;
                    k >>= 1;
                }
                j += k;
                _bitrev[i] = j;
            }
        }

        // make trigonometric function table
        function _makeCosSinTable() {
            var n2 = _n >> 1,
                    n4:uint = _n >> 2,
                    n8:uint = _n >> 3,
                    n2p4:uint = n2 + n4,
                    t:Number = Math.sin(Math.PI / _n),
                    dc:Number = 2 * t * t,
                    ds:Number = Math.sqrt(dc * (2 - dc)),
                    c:Number = _cstb[n4] = 1,
                    s:Number = _cstb[0] = 0;
            t = 2 * dc;
            for (var i:int = 1; i < n8; i++) {
                c -= dc;
                dc += t * c;
                s += ds;
                ds -= t * s;
                _cstb[i] = s;
                _cstb[n4 - i] = c;
            }
            if (n8 !== 0) {
                _cstb[n8] = Math.sqrt(0.5);
            }
            for (var j:int = 0; j < n4; j++) {
                _cstb[n2 - j] = _cstb[j];
            }
            for (var k:int = 0; k < n2p4; k++) {
                _cstb[k + n2] = -_cstb[k];
            }
        }
    }
}
