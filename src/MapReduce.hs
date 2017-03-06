{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE DeriveGeneric #-}

module MapReduce (main) where

import GHC.Base.Brisk
import Control.Distributed.Process
import Control.Distributed.BriskStatic
import Control.Distributed.Process.Closure
import Control.Distributed.Process.SymmetricProcess

import Utils
import Master

remotable [ 'master ]

main :: NodeId -> Process ()
main node =  do spawn node $ $(mkBriskClosure 'master) ()
                return ()
