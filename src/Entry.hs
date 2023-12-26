module Entry where

import Config
import Database.Beam.Postgres
import System.Environment
import SelectSample
import InsertSample
import UpdateSample
import DeleteSample

entry :: IO ()
entry = do
  args <- getArgs
  c <- conn
  parse args c
  where
    parse :: [String] -> Connection -> IO ()
    parse ["sample01"] c = sample01 c
    parse ["sample02"] c = sample02 c
    parse ["sample03"] c = sample03 c
    parse ["sample04"] c = sample04 c
    parse ["sample05"] c = sample05 c
    parse ["sample06"] c = sample06 c
    parse ["sample07"] c = sample07 c
    parse ["sample08"] c = sample08 c
    parse ["sample09"] c = sample09 c
    parse ["sample10"] c = sample10 c
    parse ["sample11"] c = sample11 c
    parse ["sample12"] c = sample12 c
    parse ["sample13"] c = sample13 c
    parse ["sample14"] c = sample14 c
    parse ["sample15"] c = sample15 c
    parse ["sample16"] c = sample16 c
    parse ["sample17"] c = sample17 c
    parse ["sample18"] c = sample18 c
    parse ["sample19"] c = sample19 c
    parse ["sample20"] c = sample20 c
    parse ["sample21"] c = sample21 c
    parse ["sample22"] c = sample22 c
    parse ["sample23"] c = sample23 c
    parse ["sample24"] c = sample24 c
    parse ["sample25"] c = sample25 c
    parse ["sample26"] c = sample26 c
    parse ["sample27"] c = sample27 c
    parse ["sample28"] c = sample28 c
    parse ["sample29"] c = sample29 c
    parse ["sample30"] c = sample30 c
    parse ["sample31"] c = sample31 c
    parse _ _ = putStrLn "usage:\n\n    beam-tutorial sampleXX"
    
