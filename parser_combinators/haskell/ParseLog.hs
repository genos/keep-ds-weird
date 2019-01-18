{-# LANGUAGE NamedFieldPuns #-}
module Main where

import Data.Char                    (isDigit)
import Data.Foldable                (for_)
import Numeric.Natural              (Natural)
import Text.ParserCombinators.ReadP
-- https://two-wrongs.com/parser-combinators-parsing-for-haskell-beginners
-- stick with what's available in std lib

{- data types and human readable output -}

data Entry = Entry { _sensorID :: SensorID
                   , _date     :: Date
                   , _time     :: Maybe Time
                   , _temp     :: Fahrenheit
                   , _humidity :: Percentage
                   , _wind     :: Maybe Wind
                   } deriving Show

data SensorID = A | B | C deriving Show

data Date = Date { _year :: Natural, _month :: Natural, _day :: Natural }

instance Show Date where
  show (Date y m d) = show y ++ "-" ++ f m ++ "-" ++ f d where
    f x = let s = show x in if 1 == length s then "0" ++ s else s

data Time = Time { _hour :: Natural, _minute :: Natural, _second :: Natural }

instance Show Time where
  show (Time h m s) = f h ++ ":" ++ f m ++ ":" ++ f s where
    f x = let s = show x in if 1 == length s then "0" ++ s else s

newtype Fahrenheit = Fahrenheit Double

instance Show Fahrenheit where
  show (Fahrenheit f) = show f ++ "°F"

newtype Percentage = Percentage Double

instance Show Percentage where
  show (Percentage p) = p' ++ "%" where
    p' = takeWhile (/= '.') (show p)

data Wind = Wind { _direction :: Direction, _speed :: MilesPerHour }

instance Show Wind where
  show (Wind d s) = show d ++ "@" ++ show s

data Direction = N | S | E | W deriving Show

newtype MilesPerHour = MilesPerHour Natural

instance Show MilesPerHour where
  show (MilesPerHour m) = show m ++ "mph"

{- parsing -}

-- helpers

digits :: (Num a, Read a) => Int -> ReadP a
digits n = read <$> count n (satisfy isDigit)

number :: (Num a, Read a) => ReadP a
number = read <$> many (satisfy isDigit)

-- parse pieces

sensorID :: ReadP SensorID
sensorID = choice [char 'A' >> pure A, char 'B' >> pure B, char 'C' >> pure C]

date :: ReadP Date
date = do
  _year  <- digits 4
  _      <- char '-'
  _month <- digits 2
  _      <- char '-'
  _day   <- digits 2
  return Date { _year, _month, _day }

date' :: ReadP Date
date' = do
  _year  <- digits 4
  _month <- char '-' *> digits 2
  _day   <- char '-' *> digits 2
  return Date { _year, _month, _day}

date'' :: ReadP Date
date'' =
  Date <$> digits 4 <*> (char '-' *> digits 2) <*> (char '-' *> digits 2)

time :: ReadP Time
time = do
  _hour   <- digits 2
  _minute <- char ':' *> digits 2
  _second <- char ':' *> digits 2
  return Time { _hour, _minute, _second }

fahrenheit :: ReadP Fahrenheit
fahrenheit = do
  x <- number
  y <- char '.' *> number
  let f = x + y / 10
  return (Fahrenheit f)

humidity :: ReadP Percentage
humidity = do
  p <- number <* char '%'
  return (Percentage p)

direction :: ReadP Direction
direction = choice
  [ char 'N' >> pure N
  , char 'S' >> pure S
  , char 'E' >> pure E
  , char 'W' >> pure W
  ]

speed :: ReadP MilesPerHour
speed = do
  s <- digits 2 <++ digits 1
  return (MilesPerHour s)

speed' :: ReadP MilesPerHour
speed' = MilesPerHour <$> (digits 2 <++ digits 1)

wind :: ReadP Wind
wind = do
  _direction <- direction
  _speed     <- skipSpaces *> speed
  return Wind { _direction, _speed }

wind' :: ReadP Wind
wind' = Wind <$> direction <*> (skipSpaces *> speed')

-- parse a full entry

entry :: ReadP Entry
entry = do
  _sensorID <- sensorID
  _date     <- skipSpaces *> date
  _time     <- skipSpaces *> (Just <$> time) <++ pure Nothing
  _temp     <- skipSpaces *> fahrenheit
  _humidity <- skipSpaces *> humidity
  _wind     <- skipSpaces *> (Just <$> wind) <++ pure Nothing
  return Entry { _sensorID, _date, _time, _temp, _humidity, _wind }

-- run our parser
parseEntry :: String -> Entry
parseEntry = fst . head . readP_to_S entry

{- main event -}

main :: IO ()
main = do
  rawData <- readFile "../data.log"
  for_ (lines rawData) $ \line -> print $ parseEntry line
