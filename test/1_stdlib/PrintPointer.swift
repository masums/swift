// RUN: %target-run-simple-swift
// REQUIRES: executable_test

import StdlibUnittest


let PrintTests = TestSuite("PrintPointer")
PrintTests.test("Printable") {
  let nullUP: UnsafeMutablePointer<Float> = nil
  let fourByteUP = UnsafeMutablePointer<Float>(bitPattern: 0xabcd1234 as UInt)
  
#if !(arch(i386) || arch(arm))
  let eightByteAddr: UInt = 0xabcddcba12344321
  let eightByteUP = UnsafeMutablePointer<Float>(bitPattern: eightByteAddr)
#endif
  
#if arch(i386) || arch(arm)
  let expectedNull = "0x00000000"
  expectPrinted("0xabcd1234", fourByteUP)
#else
  let expectedNull = "0x0000000000000000"
  expectPrinted("0x00000000abcd1234", fourByteUP)
  expectPrinted("0xabcddcba12344321", eightByteUP)
#endif
  
  expectPrinted(expectedNull, nullUP)
  
  expectPrinted("UnsafeBufferPointer(start: \(expectedNull), count: 0)",
    UnsafeBufferPointer(start: nullUP, count: 0))
  expectPrinted("UnsafeMutableBufferPointer(start: \(expectedNull), count: 0)",
    UnsafeMutableBufferPointer(start: nullUP, count: 0))
  
  let nullOpaque: OpaquePointer = nil
  expectPrinted(expectedNull, nullOpaque)
  expectPrinted(expectedNull, CVaListPointer(_fromUnsafeMutablePointer: nullUP))
#if _runtime(_ObjC)
  let nullAutoUP: AutoreleasingUnsafeMutablePointer<Int> = nil
  expectPrinted(expectedNull, nullAutoUP)
#endif
}

runAllTests()
