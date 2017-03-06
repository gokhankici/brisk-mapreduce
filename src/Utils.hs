{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE DeriveGeneric #-}

module Utils where

import Control.Distributed.Process
import Control.Distributed.Process.SymmetricProcess

import Control.Monad (foldM)
import Data.Binary
import Data.Typeable
import GHC.Generics (Generic)

data WorkSet = WorkSet [Int]             deriving (Generic, Typeable)
data Request = Request ProcessId         deriving (Generic, Typeable)
data Work    = Work ProcessId Int | Term deriving (Generic, Typeable)
data Result  = Result Int                deriving (Generic, Typeable)

instance Binary WorkSet
instance Binary Request
instance Binary Work
instance Binary Result

workCount :: Int
workCount =  15

forN :: Int -> (Int -> Process a) -> Process ()
forN n f = foldM (\ _  i -> f i >> return ()) () [1..n]

forEach :: SymSet ProcessId -> (ProcessId -> Process a) -> Process ()
forEach s f = foldM (\ _ pid -> f pid >> return ()) () s

getNodes :: Int -> Process [NodeId]
getNodes n = do node <- getSelfNode
                return $ replicate n node

