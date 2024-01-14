{-# LANGUAGE OverloadedStrings #-}
module InsertSample where

import Database.Beam
import Database.Beam.Backend.SQL.BeamExtensions
import Database.Beam.Postgres
import Data.UUID.V4
import Data.Text
import Data.Time.LocalTime
import Schema

sample25 :: Connection -> IO ()
sample25 c = do
  u1 <- nextRandom
  u2 <- nextRandom
  tz  <- getZonedTime
  let l = zonedTimeToLocalTime tz
  runBeamPostgresDebug putStrLn c $ runInsert $ insert (categories blogDatabase) $ do
    insertValues [ Category u1 "Linux" "linux" l l
                 , Category u2 "News" "news" l l
                 ]

sample26 :: Connection -> IO ()
sample26 c = do
  runBeamPostgresDebug putStrLn c $ runInsert $ insert (tags blogDatabase) $ do
    insertExpressions [ Tag default_ (val_ "Rails") (val_ "rails") default_ default_
                      , Tag default_ (val_ "Erlang") (val_ "erlang") default_ default_
                      , Tag default_ (val_ "LISP") (val_ "lisp") currentTimestamp_ currentTimestamp_
                      ]

sample27 :: Connection -> IO ()
sample27 c =
  runBeamPostgresDebug putStrLn c $ do
    li <- runInsertReturningList $ insert (users blogDatabase) $ do
      insertExpressions [ User default_ (val_ "mike@example.com") (val_ "Mike") default_ default_
                        ]
    let usr = Prelude.head li 
    runInsert $ insert (profiles blogDatabase) $ do
      insertExpressions [ Profile default_ (val_ $ primaryKey usr) (val_ $ Just "Nagoya") (val_ $ Just "Hello, world") ]

sample28 :: Connection -> IO ()
sample28 c = do
  runBeamPostgresDebug putStrLn c $ do
    Just u <- getUser "Tora"
    Just ca <- getCategory "web"
    li <- runInsertReturningList $ insert (posts blogDatabase) $ do
      insertExpressions [ Post { postId = default_
                               , postSlug = val_ "sample-post-04"
                               , postTitle = val_ "Sample Post Title 04"
                               , postMarkdown = val_ "## Sample"
                               , postCategory = val_ (primaryKey ca)
                               , postUser = val_ (primaryKey u)
                               , postCreatedAt = default_
                               , postUpdatedAt = default_
                               }
                        ]
    Just t <- runSelectReturningOne $ select $ filter_ (\t -> tagSlug t ==. "haskell") $ all_ (tags blogDatabase)
    runInsert $ insert (posts_tags blogDatabase) $ do
      insertExpressions [ PostTag default_ (val_ $ primaryKey (Prelude.head li)) (val_ $ primaryKey t) ]
  where
    getUser :: Text -> Pg (Maybe User)
    getUser s = runSelectReturningOne $ select $
      filter_ (\u -> userName u ==. val_ s) $ all_ (users blogDatabase)

    getCategory :: Text -> Pg (Maybe Category)
    getCategory s = runSelectReturningOne $ select $
      filter_ (\ca -> categorySlug ca ==. val_ s) $ all_ (categories blogDatabase)

