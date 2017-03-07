{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE DeriveGeneric #-}

module Master (master) where

import GHC.Base.Brisk
import Control.Distributed.Process
import Control.Distributed.BriskStatic
import Control.Distributed.Process.Closure
import Control.Distributed.Process.SymmetricProcess

import Utils
import Queue

remotable [ 'queue ]

master :: (NodeId, [NodeId]) -> Process ()
master (node, nodes) =
  do self <- getSelfPid
     queuePid <- spawn node $ $(mkBriskClosure 'queue) (nodes, self)

     -- -- Send the work list
     -- send queuePid (WorkSet [1..workCount])

     -- for k times ...
     forN workCount (\_ -> do -- wait for a work result
                              (Result n) <- expect :: Process Result
                              return ()
                    )

