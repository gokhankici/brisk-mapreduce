{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE DeriveGeneric #-}

module Queue (queue) where

import Control.Distributed.Process
import Control.Distributed.BriskStatic
import Control.Distributed.Process.Closure
import Control.Distributed.Process.SymmetricProcess

import Utils
import Mapper  

remotable [ 'mapper ]

queue :: ProcessId -> Process ()
queue master =
  do self <- getSelfPid
     -- get the workset
     WorkSet ns <- expect
     let k = length ns
     -- create the workers
     let nodes = undefined
     mapperPids <- spawnSymmetric nodes $ $(mkBriskClosure 'mapper) self
     -- for k times ...
     forN k (\i -> do -- wait for a work request
                   (Request mapperId) <- expect
                   -- send the work to the mapper
                   send mapperId (Work master i))
     -- for each mapper ...
     forEach mapperPids (\x -> do -- wait for its next request
                               (Request pid) <- expect
                               -- send the termination message
                               send x Term)
