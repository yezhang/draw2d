	uniform sampler2D uAtlasSampler;
    uniform vec2 uTexelSize;
	uniform vec2 uPositionMul;
	uniform vec2 uPositionAdd;
	uniform vec2 uCanvasSize;

	attribute vec2 aPosition;
	attribute vec2 aCurvesMin;
	attribute vec4 aColor;

	varying vec2 vCurvesMin;
	varying vec2 vGridMin;
	varying vec2 vGridSize;
	varying vec2 vNormCoord;
	varying vec4 vColor;
	
	#define kGlyphExpandFactor 0.1

	// Get non-normalised number in range 0-65535 from two channels of a texel
	float ushortFromVec2(vec2 v) {
		// v.x holds most significant bits, v.y holds least significant bits
		return 65280.0 * v.x + 255.0 * v.y;
	}

	vec2 fetchVec2(vec2 coord) {
		vec2 ret;
		vec4 tex = texture2D(uAtlasSampler, (coord + 0.5) * uTexelSize);

		ret.x = ushortFromVec2(tex.rg);
		ret.y = ushortFromVec2(tex.ba);
		return ret;
	}

	void decodeUnsignedShortWithFlag(vec2 f, out vec2 x, out vec2 flag) {
		x = floor(f * 0.5);
		flag = mod(f, 2.0);
	}

	void main() {

		vColor = aColor;

		decodeUnsignedShortWithFlag(aCurvesMin, vCurvesMin, vNormCoord);
		vGridMin = fetchVec2(vCurvesMin);
		vGridSize = fetchVec2(vec2(vCurvesMin.x + 1.0, vCurvesMin.y));

		// Adjust vNormCoord to compensate for expanded glyph bounding boxes
		vNormCoord = vNormCoord * (1.0 + 2.0 * kGlyphExpandFactor) - kGlyphExpandFactor;

		// Transform position
		vec2 pos = aPosition;
		pos.y = 1.0 - pos.y;
		pos = pos * uPositionMul + uPositionAdd;

		gl_Position = vec4(pos, 0.0, 1.0);
		gl_Position.x *= uCanvasSize.y / uCanvasSize.x;

	}
		