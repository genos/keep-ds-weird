-- https://www.schoolofhaskell.com/school/starting-with-haskell/libraries-and-frameworks/text-manipulation/attoparsec
-- https://two-wrongs.com/parser-combinators-parsing-for-haskell-beginners
module Main where

import Data.Char                    (isDigit)
import Data.Word                    (Word8)
import Text.ParserCombinators.ReadP

-- data types

data Date = Date { _year :: Int, _month :: Int, _day :: Int } deriving Show

data IPAddress = IPv4 { _a :: Word8
                      , _b :: Word8
                      , _c :: Word8
                      , _d :: Word8
                      } deriving Show

data Action = GET | POST | PUT deriving Show

data Entry = Entry { _date   :: Date
                   , _ip     :: IPAddress
                   , _action :: Action
                   } deriving Show

-- parsing

digit :: ReadP Char
digit = satisfy isDigit

word8 :: ReadP Word8
word8 = fmap read (many1 digit)

word8' :: ReadP Word8
word8' = read <$> many1 digit

fourDigit :: ReadP Int
fourDigit = read <$> count 4 digit

twoDigit :: ReadP Int
twoDigit = read <$> count 2 digit

date :: ReadP Date
date = do
  y <- fourDigit
  _ <- char '-'
  m <- twoDigit
  _ <- char '-'
  d <- twoDigit
  return Date {_year = y, _month = m, _day = d}

date' :: ReadP Date
date' = do
  y <- fourDigit
  m <- char '-' *> twoDigit
  d <- char '-' *> twoDigit
  return Date {_year = y, _month = m, _day = d}

date'' :: ReadP Date
date'' =
  Date <$> fourDigit <*> (char '-' *> twoDigit) <*> (char '-' *> twoDigit)

ipAddress :: ReadP IPAddress
ipAddress = do
  a <- word8
  b <- char '.' *> word8
  c <- char '.' *> word8
  d <- char '.' *> word8
  return IPv4 {_a = a, _b = b, _c = c, _d = d}

action :: ReadP Action
action = choice
  [ string "GET" >> return GET
  , string "POST" >> return POST
  , string "PUT" >> return PUT
  ]

entry :: ReadP Entry
entry = do
  d <- date
  i <- skipSpaces *> ipAddress
  a <- skipSpaces *> action
  return Entry {_date = d, _ip = i, _action = a}

logFile :: ReadP [Entry]
logFile = entry `sepBy` char '\n' <* (optional (char '\n') <* eof)

-- main event

main :: IO ()
main = do
  rawLog <- readFile "input.log"
  let entries = head $ fst <$> readP_to_S logFile rawLog
  mapM_ print entries
