{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE DeriveGeneric #-}

module Queue (queue) where

import GHC.Base.Brisk
import Control.Distributed.Process
import Control.Distributed.BriskStatic
import Control.Distributed.Process.Closure
import Control.Distributed.Process.SymmetricProcess
import Control.Monad (forM)

import Utils
import Mapper  

remotable [ 'mapper ]

queue :: ([NodeId], ProcessId) -> Process ()
queue (nodes, master) =
  do self <- getSelfPid

     -- -- get the workset
     -- WorkSet ns <- expect

     -- create the workers
     mapperPids <- spawnSymmetric nodes $ $(mkBriskClosure 'mapper) self

     -- for k times ...
     myFoldM go () [1::Int .. workCount]
  

     -- for each mapper ...
     forM mapperPids (\x -> do -- wait for its next request
                                  (Request pid) <- expectFrom x :: Process Request
                                  -- send the termination message
                                  send x Term)

     return ()
  where
    go _ i = do (Request mapperId) <- expect :: Process Request
                send mapperId (Work master i)
