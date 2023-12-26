{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeApplications #-}
module SelectSample where

import Schema
import Database.Beam
import Database.Beam.Postgres
import Data.Text
import Data.Int

sample01 :: Connection -> IO ()
sample01 c = do
  li <- runBeamPostgresDebug putStrLn c $ runSelectReturningList $ select $ do
    all_ (users blogDatabase)
  print li
  
sample02 :: Connection -> IO ()
sample02 c = do
  li <- runBeamPostgresDebug putStrLn c $ runSelectReturningList $ select $ do
    ca <- all_ (categories blogDatabase)
    return (categorySlug ca, categoryName ca)
  print li

sample03 :: Connection -> IO ()
sample03 c = do
  li <- runBeamPostgresDebug putStrLn c $ runSelectReturningList $ select $ do 
    filter_ (\u -> userName u ==. "Kuro") $ all_ (users blogDatabase)
  print li

sample04 :: Connection -> IO ()
sample04 c = do
  li <- runBeamPostgresDebug putStrLn c $ runSelectReturningList $ select $ do
    u <- all_ (users blogDatabase)
    guard_ (userName u ==. "Kuro")
    return u
  print li

sample05 :: Connection -> IO ()
sample05 c = do
  let limitNum = 3 :: Integer
  let offsetNum = 1 :: Integer
  li <- runBeamPostgres c $ runSelectReturningList $ select $ do
    limit_ limitNum $ offset_ offsetNum $ all_ (categories blogDatabase)
  print li

sample06 :: Connection -> IO ()
sample06 c = do
  let limitNum = 3 :: Integer
  let offsetNum = 1 :: Integer
  li <- runBeamPostgres c $ runSelectReturningList $ select $ do
    limit_ limitNum $ offset_ offsetNum $
      orderBy_ (desc_ . categoryName) $ all_ (categories blogDatabase)
  print li

sample07 :: Connection -> IO ()
sample07 c = do
  let limitNum = 3 :: Integer
  let offsetNum = 1 :: Integer
  li <- runBeamPostgres c $ runSelectReturningList $ select $ do
    limit_ limitNum $ offset_ offsetNum $
      orderBy_ (\ca -> (asc_ (categoryName ca) , desc_ (categorySlug ca))) $ all_ (categories blogDatabase)
  print li

-- Distinct support
sample08 :: Connection -> IO ()
sample08 c = do
  li <- runBeamPostgresDebug putStrLn c $ runSelectReturningList $ select $ do
    nub_ $ all_ (posts_tags blogDatabase)
  print li

sample09 :: Connection -> IO ()
sample09 c = do
  li <- runBeamPostgresDebug putStrLn c $ runSelectReturningList $ select $ do
    l1 <- all_ (posts blogDatabase)
    l2 <- all_ (categories blogDatabase)
    return (l1, l2)
  print li

sample10 :: Connection -> IO ()
sample10 c = do
  li <- runBeamPostgresDebug putStrLn c $ runSelectReturningList $ select $ do
    l1 <- all_ (posts blogDatabase)
    l2 <- all_ (categories blogDatabase)
    guard_ (categorySlug l2 ==. "web")
    return (l1, l2)
  print li

-- one to one
sample11 :: Connection -> IO ()
sample11 c = do
  li <- runBeamPostgresDebug putStrLn c $ runSelectReturningList $ select $ do
    prof <- all_ (profiles blogDatabase)
    usr <- related_ (users blogDatabase) (profileUser prof)
    return (usr, prof)
  print li

-- one to one
sample12 :: Connection -> IO ()
sample12 c = do
  li <- runBeamPostgresDebug putStrLn c $ runSelectReturningList $ select $ do
    usr <- all_ (users blogDatabase)
    prof <- oneToOne_ (profiles blogDatabase) profileUser usr
    return (usr, prof)
  print li

-- one to meny
sample13 :: Connection -> IO ()
sample13 c = do
  li <- runBeamPostgresDebug putStrLn c $ runSelectReturningList $ select $ do
    po <- all_ (posts blogDatabase)
    ca <- related_ (categories blogDatabase) (postCategory po)
    return (ca, po)
  print li

sample14 :: Connection -> IO ()
sample14 c = do
  li <- runBeamPostgresDebug putStrLn c $ runSelectReturningList $ select $ do
    ca <- all_ (categories blogDatabase)
    po <- oneToMany_ (posts blogDatabase) postCategory ca
    return (ca, po)
  print li

sample15 :: Connection -> IO ()
sample15 c = do
  let s = "haskell" :: Text
  li <- runBeamPostgresDebug putStrLn c $ do
    runSelectReturningList $ select $ do
      manyToMany_ (posts_tags blogDatabase)
                  posttagPost
                  posttagTag
                  (all_ (posts blogDatabase))
                  (filter_ (\t -> tagSlug t ==. val_ s) $ all_ (tags blogDatabase))
  print li

-- JOIN
sample16 :: Connection -> IO ()
sample16 c = do
  li <- runBeamPostgresDebug putStrLn c $ runSelectReturningList $ select $ do
    ca <- all_ (categories blogDatabase)
    join_ (posts blogDatabase) (\p -> postCategory p ==. primaryKey ca)
  print li


-- LEFT JOIN
sample17 :: Connection -> IO ()
sample17 c = do
  li <- runBeamPostgresDebug putStrLn c $ runSelectReturningList $ select $ do
    tg <- all_ (tags blogDatabase)
    pt <- leftJoin_ (all_ (posts_tags blogDatabase)) (\p -> posttagTag p ==.  primaryKey tg)
    return (tg, pt)
  print li


-- Subquery
sample18 :: Connection -> IO ()
sample18 c = do
  li <- runBeamPostgresDebug putStrLn c $ runSelectReturningList $ select $ do
    sub <- subquery
    pt <- leftJoin_ (all_ (posts_tags blogDatabase)) (\p -> posttagTag p ==.  primaryKey sub)
    return (sub, pt)
  print li
  where
    target = "haskell" :: Text
    subquery = subselect_ $ filter_ (\t -> tagSlug t ==. val_ target) $ all_ (tags blogDatabase)
  

-- filter, limit, offset
sample19 :: Connection -> IO ()
sample19 c = do
  li <- runBeamPostgresDebug putStrLn c $ runSelectReturningList $ select $ do
    limit_ 10 $ orderBy_ (\(u, _) -> asc_ (userName u)) $ do 
      filter_ (\(u, _) -> userName u ==. "Chatora") $ do
        usr <- all_ (users blogDatabase)
        prof <- oneToOne_ (profiles blogDatabase) profileUser usr
        return (usr, prof)
  print li

-- GROUP BY
sample20 :: Connection -> IO ()
sample20 c = do
  li <- runBeamPostgresDebug putStrLn c $ runSelectReturningList $ select $ do
    aggregate_ (\pt -> group_ $ posttagPost pt) $ all_ (posts_tags blogDatabase)
  print li

-- COUNT
sample21 :: Connection -> IO ()
sample21 c = do
  li <- runBeamPostgresDebug putStrLn c $ runSelectReturningList $ select $ do
    aggregate_ (\pt -> (as_ @Int32 $ count_ $ posttagId pt)) $ all_ (posts_tags blogDatabase)
  print li

sample22 :: Connection -> IO ()
sample22 c = do
  li <- runBeamPostgresDebug putStrLn c $ runSelectReturningList $ select $ do
    aggregate_ (\pt -> (group_ $ posttagPost pt, as_ @Int32 $ countAll_)) $ all_ (posts_tags blogDatabase)
  print li

sample23 :: Connection -> IO ()
sample23 c = do
  li <- runBeamPostgresDebug putStrLn c $ runSelectReturningList $ select $ do
    aggregate_ (\(p, t) -> (group_ $ postSlug p, as_ @Int32 $ countAll_)) $ do
      manyToMany_ (posts_tags blogDatabase)
                  posttagPost
                  posttagTag
                  (all_ (posts blogDatabase))
                  (all_ (tags blogDatabase))
  print li

sample24 :: Connection -> IO ()
sample24 c = do
  li <- runBeamPostgresDebug putStrLn c $ runSelectReturningList $ select $ do
    filter_ (\(ca, cnt) -> categorySlug ca `like_` "we%" &&. cnt ==. 2) $ do
      aggregate_ (\(_, ca) -> (group_ ca, as_ @Int32 $ countAll_)) $ do
        po <- all_ (posts blogDatabase)
        ca <- related_ (categories blogDatabase) (postCategory po)
        pure (po, ca)

  print li

      
-- one to many
-- sample15
getPostsWithCategory :: Connection -> IO ()
getPostsWithCategory c = do
  let targetSlug = "web" :: Text
  li <- runBeamPostgresDebug putStrLn c $ runSelectReturningList $ select $ do
    ca <- filter_ (\ca -> categorySlug ca ==. val_ targetSlug) $ all_ (categories blogDatabase)
    oneToMany_ (posts blogDatabase) postCategory ca
  print li



-- many to many
-- sample16
getPostsByTag :: Connection -> IO ()
getPostsByTag c = do
  let s = "haskell" :: Text
  li <- runBeamPostgresDebug putStrLn c $ do
    runSelectReturningList $ select $ do
      manyToMany_ (posts_tags blogDatabase)
                  posttagPost
                  posttagTag
                  (all_ (posts blogDatabase))
                  (filter_ (\t -> tagSlug t ==. val_ s) $ all_ (tags blogDatabase))
  print li

-- many to many
-- sample17

-- join
-- sample17
getPostsWithCategory' :: Connection -> IO ()
getPostsWithCategory' c = do
  let targetSlug = "web" :: Text
  li <- runBeamPostgresDebug putStrLn c $ runSelectReturningList $ select $ do
    ca <- filter_ (\ca -> categorySlug ca ==. val_ targetSlug) $ all_ (categories blogDatabase)
    join_ (posts blogDatabase) (\p -> postCategory p ==. primaryKey ca)
  print li

-- join別の例
getPostWithUserCategory :: Connection -> IO ()
getPostWithUserCategory c = do
  let targetSlug = "web" :: Text
  li <- runBeamPostgresDebug putStrLn c $ runSelectReturningList $ select $ do
    ca <- filter_ (\ca -> categorySlug ca ==. val_ targetSlug) $ all_ (categories blogDatabase)
    us <- filter_ (\u -> userName u ==. "Chatora") $ all_ (users blogDatabase)
    ta <- join_ (posts blogDatabase) (\p -> postCategory p ==. primaryKey ca)
    join_ (posts blogDatabase) (\p -> postUser p ==. primaryKey us)
  print li

-- left join
-- sample19
getPostsWithTag :: Connection -> IO ()
getPostsWithTag c = do
  li <- runBeamPostgresDebug putStrLn c $ runSelectReturningList $ select $ do
    po <- all_ (posts blogDatabase)
    ca <- related_ (categories blogDatabase) (postCategory po)
    us <- related_ (users blogDatabase) (postUser po)
    guard_ (categorySlug ca ==. "web")
    return (po, ca, us)
  print li

getPosts :: Connection -> IO [Post]
getPosts c = do
  runBeamPostgres c $ runSelectReturningList $ select query
    where
      query = all_ (posts blogDatabase)

getPostsByUser :: Connection -> Text -> IO [(User, Post)]
getPostsByUser c s = do
  runBeamPostgresDebug putStrLn c $ runSelectReturningList $ select $ do
    filter_ (\(u, _) -> userName u ==. val_ s) $ do
      usr <- all_ (users blogDatabase)
      pos <- oneToMany_ (posts blogDatabase) postUser usr
      return (usr, pos)

