{-# LANGUAGE OverloadedStrings #-}
module UpdateSample where

import Database.Beam
import Database.Beam.Postgres
import Schema

sample29 :: Connection -> IO ()
sample29 c =
  runBeamPostgres c $ do
    Just profile <- runSelectReturningOne $ select $ filter_ (\u -> userName u ==. "Tora") $ all_ (users blogDatabase)
    runUpdate $ save (users blogDatabase) (profile {userEmail = "kijitora@example.com", userName="Kijitora"})

sample30 :: Connection -> IO ()
sample30 c = do
  runBeamPostgres c $ do
    runUpdate $ update (categories blogDatabase)
                       (\ca -> categoryName ca <-. "Web Tech")
                       (\ca -> categorySlug ca ==. "web")
