component name="mxFirst-mxUnit-Target" hint="test file for my first mxunit test" extends="mxunit.framework.TestCase"{

    public void function test_DecToBin_firstEight(){
        local.converter = createObject('component', 'BinaryDecimalConverter').init();

        assertEquals('00000000', local.converter.decimalToBinary(0,8), "Converting decimal 0 Failed.");   
        assertEquals('00000001', local.converter.decimalToBinary(1,8), "Converting decimal 1 Failed.");   
        assertEquals('00000010', local.converter.decimalToBinary(2,8), "Converting decimal 2 Failed.");   
        assertEquals('00000011', local.converter.decimalToBinary(3,8), "Converting decimal 3 Failed.");   
        assertEquals('00000100', local.converter.decimalToBinary(4,8), "Converting decimal 4 Failed.");   
        assertEquals('00000101', local.converter.decimalToBinary(5,8), "Converting decimal 5 Failed.");   
        assertEquals('00000110', local.converter.decimalToBinary(6,8), "Converting decimal 6 Failed.");   
        assertEquals('00000111', local.converter.decimalToBinary(7,8), "Converting decimal 7 Failed.");   
    }

    public void function test_BinToDec_firstEight(){
        local.converter = createObject('component', 'BinaryDecimalConverter').init();

        assertEquals(0, local.converter.binaryToDecimal('00000000'), "Converting binary 00000000 Failed.");
        assertEquals(1, local.converter.binaryToDecimal('00000001'), "Converting binary 00000001 Failed.");
        assertEquals(2, local.converter.binaryToDecimal('00000010'), "Converting binary 00000010 Failed.");
        assertEquals(3, local.converter.binaryToDecimal('00000011'), "Converting binary 00000011 Failed.");
        assertEquals(4, local.converter.binaryToDecimal('00000100'), "Converting binary 00000100 Failed.");
        assertEquals(5, local.converter.binaryToDecimal('00000101'), "Converting binary 00000101 Failed.");
        assertEquals(6, local.converter.binaryToDecimal('00000110'), "Converting binary 00000110 Failed.");
        assertEquals(7, local.converter.binaryToDecimal('00000111'), "Converting binary 00000111 Failed.");
    }
}

<!---
    Reference: https://www.bennadel.com/blog/2394-writing-my-first-unit-tests-with-mxunit-and-coldfusion.htm
--->