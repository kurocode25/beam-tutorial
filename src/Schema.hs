{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE StandaloneDeriving #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}

module Schema where

import Database.Beam
import Data.Text
import Data.UUID
import Data.Time

data UserT f = User
  { userId        :: C f UUID
  , userEmail     :: C f Text
  , userName      :: C f Text
  , userCreatedAt :: C f LocalTime
  , userUpdatedAt :: C f LocalTime
  } deriving Generic

type User = UserT Identity
type UserId = PrimaryKey UserT Identity

deriving instance Show User

instance Beamable UserT
instance Table UserT where
  data PrimaryKey UserT f = UserId (Columnar f UUID) deriving (Generic, Beamable)
  primaryKey = UserId . userId

data PostT f = Post
  { postId            :: C f UUID
  , postSlug          :: C f Text
  , postTitle         :: C f Text
  , postMarkdown      :: C f Text
  , postUser          :: PrimaryKey UserT f
  , postCategory      :: PrimaryKey CategoryT f
  , postCreatedAt    :: C f LocalTime
  , postUpdatedAt    :: C f LocalTime
  } deriving (Generic)

type Post = PostT Identity
type PostId = PrimaryKey PostT Identity

deriving instance Show (PrimaryKey CategoryT Identity)
deriving instance Show (PrimaryKey UserT Identity)
deriving instance Show Post
instance Beamable PostT
instance Table PostT where
  data PrimaryKey PostT f = PostId (Columnar f UUID) deriving (Generic, Beamable)
  primaryKey = PostId . postId

data CategoryT f = Category
  { categoryId        :: C f UUID
  , categoryName      :: C f Text 
  , categorySlug      :: C f Text
  , categoryCreatedAt :: C f LocalTime
  , categoryUpdatedAt :: C f LocalTime
  } deriving Generic

type Category = CategoryT Identity

deriving instance Show Category

instance Beamable CategoryT
instance Table CategoryT where
  data PrimaryKey CategoryT f = CategoryId (Columnar f UUID) deriving (Generic, Beamable)
  primaryKey = CategoryId . categoryId

type CategoryId = PrimaryKey CategoryT Identity

data TagT f = Tag
  { tagId        :: C f UUID
  , tagName      :: C f Text
  , tagSlug      :: C f Text
  , tagCreatedAt :: C f LocalTime
  , tagUpdatedAt :: C f LocalTime
  } deriving (Generic)

type Tag = TagT Identity
type TagId = PrimaryKey TagT Identity

deriving instance Show Tag

instance Beamable TagT
instance Table TagT where
  data PrimaryKey TagT f = TagId (Columnar f UUID) deriving (Generic, Beamable)  
  primaryKey = TagId . tagId

data PostTagT f = PostTag
  { posttagId      :: Columnar f UUID
  , posttagPost :: PrimaryKey PostT f
  , posttagTag  :: PrimaryKey TagT f
  } deriving Generic

type PostTag = PostTagT Identity
deriving instance Show PostTag
deriving instance Show (PrimaryKey PostT Identity)
deriving instance Show (PrimaryKey TagT Identity)

instance Beamable PostTagT
instance Table PostTagT where
  data PrimaryKey PostTagT f = PostTagId (Columnar f UUID) deriving (Generic, Beamable)
  primaryKey = PostTagId . posttagId

data ProfileT f
  = Profile
    { profileId        :: C f UUID
    , profileUser      :: PrimaryKey UserT f
    , profileLocation   :: C f (Maybe Text)
    , profileMessage   :: C f (Maybe Text)
    } deriving Generic

type Profile = ProfileT Identity
type ProfileId = PrimaryKey ProfileT Identity

deriving instance Show Profile

instance Beamable ProfileT
instance Table ProfileT where
  data PrimaryKey ProfileT f = ProfileId (Columnar f UUID) deriving (Generic, Beamable)
  primaryKey = ProfileId . profileId
data BlogDatabase f = BlogDatabase
  { users      :: f (TableEntity UserT)
  , profiles   :: f (TableEntity ProfileT)
  , categories :: f (TableEntity CategoryT)
  , posts   :: f (TableEntity PostT)
  , tags   :: f (TableEntity TagT)
  , posts_tags :: f (TableEntity PostTagT)
  } deriving (Generic, Database be)

blogDatabase :: DatabaseSettings be BlogDatabase
blogDatabase = defaultDbSettings
