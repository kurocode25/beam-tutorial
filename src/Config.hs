module Config where


import Database.Beam.Postgres

-- | Settings of database connection
conn :: IO Connection
conn = connect defaultConnectInfo
  { connectUser     = "username"   -- database user name
  , connectDatabase = "beam"       -- database name
  , connectPassword = "password"   -- database password
  , connectHost     = "localhost"  -- database host
  }

