#Codigo:
def baconian_cipher(string)
    diccionario={"a"=>"AAAAA","b"=>"AAAAB","c"=>"AAABA","d"=>"AAABB","e"=>"AABAA",
            "f"=>"AABAB","g"=>"AABBA","h"=>"AABBB","i"=>"ABAAA","k"=>"ABAAB",
            "l"=>"ABABA","m"=>"ABABB","n"=>"ABBAA","o"=>"ABBAB","p"=>"ABBBA",
            "q"=>"ABBBB","r"=>"BAAAA","s"=>"BAAAB","t"=>"BAABA","v"=>"BAABB",
            "w"=>"BABAA","x"=>"BABAB","y"=>"BABBA","z"=>"BABBB"}
    answer = ""
    string.scan(/...../).each { |a| answer += diccionario.key(a) }
    answer
end
p baconian_cipher("BAABAAABAAAABAABAAABABBBAAABAABAAAAABBABAAAAAABABAAAAAABAAABAAABAABAAAABBAAAAABAABBAB") == "teesperoalascinco"
p baconian_cipher("ABABAAAAAAAAABAABABAAAAAABAABBAABAAAABAABAAABAAABBABBABBAAABBAABABAAAAAABAABAAAB") == "laclaveesdostres"