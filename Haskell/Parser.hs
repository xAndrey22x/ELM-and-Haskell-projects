module Bencode.Parser where

import Bencode.Value
import qualified Data.List as L
import Parsec (Parser, andThen, orElse, pMap, pThen)
import qualified Parsec as P
import Result

-- | Parse a bencode value
--
-- >>> P.runParser value "i10e"
-- Success (BencodeInt 10, "")
--
-- >>> P.runParser value "3:abc"
-- Success (BencodeString "abc", "")
--
-- >>> P.runParser value "l3:abc4:abcde"
-- Success (BencodeList [BencodeString "abc",BencodeString "abcd"], "")
--
-- >>> P.runParser value "d3:abci10ee"
-- Success (BencodeDict [("abc",BencodeInt 10)], "")
value :: Parser BencodeValue
value =
  (pMap BencodeString string)
    `orElse` (pMap BencodeInt int)
    `orElse` (pMap BencodeList list)
    `orElse` (pMap BencodeDict dict)

-- | Parse a bencode integer
--
-- >>> P.runParser int "i10e"
-- Success (10, "")
int :: Parser Int
int = P.between (P.char 'i') (P.char 'e') P.number

-- | Parse a bencode string
--
-- >>> P.runParser string "3:abc"
-- Success ("abc", "")
string :: Parser String
string = 
  let
    colonParser = P.char ':'
  in
    P.with P.number (\ch -> P.pThen colonParser (P.take ch))

-- | Parse a bencode list
--
-- >>> P.runParser list "li1ei2ee"
-- Success ([BencodeInt 1,BencodeInt 2], "")
--
-- >>> P.runParser list "l1:a1:be"
-- Success ([BencodeString "a",BencodeString "b"], "")
list :: Parser [BencodeValue]
list = P.between (P.char 'l') (P.char 'e') (P.many value)

-- | Parse a bencode dict
--
-- >>> P.runParser dict "d1:ai1e1:bi2ee"
-- Success ([(BencodeString "a", BencodeInt 1),(BencodeString "b",BencodeInt 2)], "")
dict :: Parser [BencodeKW]
dict = 
  let
    pair = P.with string (\k -> P.with value (\v -> P.succeed (k, v)))
  in
    P.between (P.char 'd') (P.char 'e') (P.many pair)

-- | Convenience wrapper for `value`
--
-- >>> parse "i10e"
-- Success (BencodeInt 10)
parse :: String -> Result P.ParseError BencodeValue
parse input = fst <$> P.runParser value input
