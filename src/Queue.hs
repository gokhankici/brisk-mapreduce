{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE DeriveGeneric #-}

module Queue (queue) where

import GHC.Base.Brisk
import Control.Distributed.Process
import Control.Distributed.BriskStatic
import Control.Distributed.Process.Closure
import Control.Distributed.Process.SymmetricProcess

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
     let k = length nodes

     -- for k times ...
     forN k (\i -> do (Request mapperId) <- expect :: Process Request
                      send mapperId (Work master i))

     -- for each mapper ...
     forEach mapperPids (\x -> do -- wait for its next request
                                  (Request pid) <- expect :: Process Request
                                  -- send the termination message
                                  send x Term)
