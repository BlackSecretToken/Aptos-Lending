address Quantum {

module SafeMathU64 {
    use std::error;
    use Quantum::MathU64;

    const EXP_SCALE_9: u64 = 1000000000;// e9
    const EXP_SCALE_10: u64 = 10000000000;// e10
    const EXP_SCALE_18: u64 = 1000000000000000000;// e18
    const U64_MAX:u64 = 18446744073709551615;  //length(U64_MAX)==20
    const U128_MAX:u128 = 340282366920938463463374607431768211455;  //length(U128_MAX)==39

    const EQUAL: u8 = 0;
    const LESS_THAN: u8 = 1;
    const GREATER_THAN: u8 = 2;

    const OVER_FLOW: u64 = 1001;
    const DIVIDE_BY_ZERO: u64 = 1002;

    /// support 18-bit precision token
    /// if token is limited release, the total capacity around e10 (almost ten billions)
    /// can avoid x*y/z overflow, and at the same time avoid loss presicion
    public fun safe_mul_div(x: u64, y: u64, z: u64): u64 {
        if ( z == 0) {
            abort error::invalid_argument(DIVIDE_BY_ZERO)
        };
        if (x <= EXP_SCALE_18 && y <= EXP_SCALE_18) {
            return x * y / z
        };
        if (x >= z || y >= z) {
            return MathU64::mul_div(x, y, z)
        };

        if (x >= y) {
            x = x * EXP_SCALE_10;
        } else {
            y = y * EXP_SCALE_10;
        };
        let r = MathU64::mul_div(x, y, z);
        r / EXP_SCALE_10
    }

    /// support 18-bit precision token
    /// if token is limited release, the total capacity around e10 (almost ten billions)
    /// can avoid x1*y1 compare x2*y2 overflow, and at the same time avoid loss presicion
    public fun safe_compare(x1: u64, y1: u64, x2: u64, y2: u64): u8 {
        let (r1, r2);
        if (x1 <= EXP_SCALE_18 && y1 <= EXP_SCALE_18 && x2 <= EXP_SCALE_18 && y2 <= EXP_SCALE_18) {
            r1 = x1 * y1;
            r2 = x2 * y2;
        } else {
            r1 = safe_mul_div(x1, y1, EXP_SCALE_18);
            r2 = safe_mul_div(x2, y2, EXP_SCALE_18);
            if (r1 == 0 && r2 == 0 ){
                r1 = x1 * y1;
                r2 = x2 * y2;
            };
        };

        if (r1 == r2) EQUAL
        else if (r1 < r2) LESS_THAN
        else GREATER_THAN
    }

    public fun safe_more_than_or_equal(x1: u64, y1: u64, x2: u64, y2: u64): bool {
        let r_order = safe_compare(x1, y1, x2, y2);
        EQUAL == r_order || GREATER_THAN == r_order
    }

    /// support 18-bit precision token
    /// if token is limited release, the total capacity around e10 (almost ten billions)
    /// can avoid  sqrt(x*y) overflow, and at the same time avoid loss presicion
    public fun safe_mul_sqrt(x: u64, y: u64): u64 {
        if (x <= EXP_SCALE_18 && y <= EXP_SCALE_18) {
            (MathU64::sqrt(x * y) as u64)
        }else {
            // sqrt(x*y) == sqrt(x) * sqrt(y)
            let r = safe_mul_div(x, y ,EXP_SCALE_18);
            (MathU64::sqrt(r) as u64) * EXP_SCALE_9
        }
    }
}
}
