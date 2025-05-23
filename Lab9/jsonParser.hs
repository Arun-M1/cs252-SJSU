import Text.ParserCombinators.Parsec
import System.Environment
import Data.Text.Lazy.Read (double)
import Language.Haskell.TH.PprLib (colon)

data JValue = JString String
            | JNumber Double
            | JBool Bool
            | JNull
            | JObject [(String, JValue)]
            | JArray [JValue]
  deriving (Eq, Ord, Show)


jsonFile :: GenParser Char st JValue
jsonFile = do
  result <- jsonArr <|> jsonObject
  spaces
  eof
  return result

jsonElem :: GenParser Char st JValue
jsonElem = do
  spaces
  result <- jsonElem'
  spaces
  return result

jsonElem' = jsonArr
        <|> jsonString
        <|> jsonBool
        <|> jsonNull
        <|> jsonNumber
        <|> jsonObject
        <?> "json element"

jsonString :: GenParser Char st JValue
jsonString = jsonStringDQ <|> jsonStringSQ

jsonStringDQ = do
  char '"'
  s <- many $ noneOf "\"" -- crude.  does not allow double quotes within strings
  char '"'
  return $ JString s

jsonStringSQ = do
  char '\''
  s <- many $ noneOf "'" -- crude, same as above
  char '\''
  return $ JString s

jsonBool = do
  bStr <- string "true" <|> string "false"
  return $ case bStr of
    "true" -> JBool True
    "false" -> JBool False

jsonNull = do
  string "null"
  return JNull

jsonNumber = do
  num <- many1 digit
  return $ JNumber (read num)

jsonObject = do
  char '{'
  spaces
  pairs <- jsonPair `sepBy` (char ',')
  spaces
  char '}'
  return $ JObject pairs

jsonPair = do
  key <- many1 $ noneOf ":"
  spaces
  char ':'
  value <- jsonElem
  return $ (key, value)


jsonArr = do
  char '['
  arr <- jsonElem `sepBy` (char ',')
  char ']'
  return $ JArray arr


parseJSON :: String -> Either ParseError JValue
parseJSON input = parse jsonFile "(unknown)" input

main = do
  args <- getArgs
  p <- parseFromFile jsonFile (head args)
  case p of
    Left err  -> print err
    Right json -> print json


