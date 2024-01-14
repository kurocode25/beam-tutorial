{-# LANGUAGE OverloadedStrings #-}
module DeleteSample where

import Database.Beam
import Database.Beam.Postgres
import Schema
import Data.Text

sample31 :: Connection -> IO ()
sample31 c = do
  let targetSlug = "misc" :: Text
  runBeamPostgresDebug putStrLn c $ runDelete $ do
    delete (categories blogDatabase) (\ca -> categorySlug ca ==. val_ targetSlug)
