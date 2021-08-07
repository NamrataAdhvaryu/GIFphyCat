

import Foundation


public func gcd(a: Int, b: Int) -> Int
{
    if b > a
    {
        return gcd(a: b, b: a)
    }
    
    if b == 0
    {
        return a
    }
    
    let remainder = abs(a) % abs(b)
    
    return gcd(a: abs(b), b: abs(remainder))
}
