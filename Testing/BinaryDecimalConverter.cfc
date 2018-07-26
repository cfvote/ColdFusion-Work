component name="Binary Decimal Converter" hint="Convert decimal to/from binary"{

    public any function init(){
        return this;
    }

    public string function decimalToBinary(required string decimal, required int bit){
        var binary = arrayNew(1);
        var num = decimal;
        while(num > 0){
            binary.append(num % 2);
            num /= 2;
        }
        var str = "";
        for(var i = arrayLen(binary); i > 0; i--){
            str = str & binary[i];
        }
        return numberFormat(str, repeatString('0', bit));
    }

    public string function binaryToDecimal(required string binary){
        var decimal = 0;
        var base = 1;
        for(var i = len(binary); i > 0; i--){
            if(mid(binary, i, 1) == "1"){
                decimal += (base);
            }
            base *= 2;
        }
        return decimal;
    }

}