{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE DeriveGeneric #-}

module Mapper (mapper) where

import Control.Distributed.Process
import Control.Distributed.BriskStatic
import Control.Distributed.Process.Closure
import Control.Distributed.Process.SymmetricProcess

import Utils  

mapper :: ProcessId -> Process ()
mapper queue =
  do self <- getSelfPid
     -- request a work from the work queue
     send queue (Request self)
     -- block until receive the work
     work <- expect
     case work of
       -- if got a work, send the processed
       -- result to the master process
       Work master i -> do send master (Result i)
                           mapper queue
       -- otherwise, there must be no more work
       -- mapper is shutdown
       Term   -> return ()
