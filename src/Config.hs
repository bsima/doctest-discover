{-# LANGUAGE OverloadedStrings #-}

module Config where

import Data.Aeson ((.:), (.:?), decode, FromJSON(..), Value(..))
import Control.Applicative
import qualified Data.ByteString.Lazy.Char8 as B

data Config = Config {
    ignore :: Maybe [String],
    sourceFolders :: Maybe [String],
    doctestOptions :: Maybe [String]
} deriving (Show)

instance FromJSON Config where
    parseJSON (Object v) = 
        Config <$> 
        (v .:? "ignore") <*>
        (v .:? "sourceFolders") <*>
        (v .:? "doctestOptions")

-- | Parses config json as string to the Config type
--
-- >>> config "{\"ignore\": [] }"
-- Just (Config {ignore = Just [], sourceFolders = Nothing, doctestOptions = Nothing})
--
-- >>> config "{\"ignore\": [\"Foo.hs\"] }"
-- Just (Config {ignore = Just ["Foo.hs"], sourceFolders = Nothing, doctestOptions = Nothing})
--
-- >>> config "{\"ignore\": [1,2,3] }"
-- Nothing
--
-- >>> config "{\"sourceFolders\": [1,2,3] }"
-- Nothing
--
-- >>> config "{\"sourceFolders\": [\"src\"] }"
-- Just (Config {ignore = Nothing, sourceFolders = Just ["src"], doctestOptions = Nothing})
--
-- >>> config "{\"doctestOptions\": [\"--some-option\"] }"
-- Just (Config {ignore = Nothing, sourceFolders = Nothing, doctestOptions = Just ["--some-option"]})
--
config :: String -> Maybe Config
config json = decode (B.pack json) :: Maybe Config
