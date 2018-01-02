{-# LANGUAGE RecordWildCards #-}
-- https://two-wrongs.com/parser-combinators-parsing-for-haskell-beginners
module Main where

import Control.Monad                (forM_)
import Data.Char                    (isDigit)
import Numeric.Natural              (Natural)
import Text.ParserCombinators.ReadP

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

data Wind = Wind { _direction :: Direction, _mph :: MilesPerHour }

instance Show Wind where
  show (Wind d m) = show d ++ "@" ++ show m

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

parseSensorID :: ReadP SensorID
parseSensorID =
  choice [char 'A' >> pure A, char 'B' >> pure B, char 'C' >> pure C]

parseDate :: ReadP Date
parseDate = do
  _year  <- digits 4
  _      <- char '-'
  _month <- digits 2
  _      <- char '-'
  _day   <- digits 2
  return Date {..}

parseDate' :: ReadP Date
parseDate' = do
  _year  <- digits 4
  _month <- char '-' *> digits 2
  _day   <- char '-' *> digits 2
  return Date {..}

parseDate'' :: ReadP Date
parseDate'' =
  Date <$> digits 4 <*> (char '-' *> digits 2) <*> (char '-' *> digits 2)

parseTime :: ReadP Time
parseTime = do
  _hour   <- digits 2
  _minute <- char ':' *> digits 2
  _second <- char ':' *> digits 2
  return Time {..}

parseFahrenheit :: ReadP Fahrenheit
parseFahrenheit = do
  x <- number
  y <- char '.' *> number
  let f = x + y / 10
  return (Fahrenheit f)

parsePercentage :: ReadP Percentage
parsePercentage = do
  p <- number <* char '%'
  return (Percentage p)

parseDirection :: ReadP Direction
parseDirection = choice
  [ char 'N' >> pure N
  , char 'S' >> pure S
  , char 'E' >> pure E
  , char 'W' >> pure W
  ]

parseMPH :: ReadP MilesPerHour
parseMPH = do
  mph <- choice [digits 2, digits 1]
  return (MilesPerHour mph)

parseWind :: ReadP Wind
parseWind = do
  _direction <- parseDirection
  _mph <- skipSpaces *> parseMPH
  return Wind {..}

parseWind' :: ReadP (Direction, MilesPerHour)
parseWind' = (,) <$> parseDirection <*> (skipSpaces *> parseMPH)

-- parse a full entry

parseEntry :: ReadP Entry
parseEntry = do
  _sensorID <- parseSensorID
  _date     <- skipSpaces *> parseDate
  _time     <- skipSpaces *> (Just <$> parseTime) <++ pure Nothing
  _temp     <- skipSpaces *> parseFahrenheit
  _humidity <- skipSpaces *> parsePercentage
  _wind     <- skipSpaces *> (Just <$> parseWind) <++ pure Nothing
  return Entry {..}

{- main event -}

main :: IO ()
main = do
  rawData <- readFile "../data.log"
  forM_ (lines rawData) $ \line -> do
    let entry = head (fst <$> readP_to_S parseEntry line)
    print entry
