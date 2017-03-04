{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE DeriveGeneric #-}

module MapReduce where

import GHC.Base.Brisk
import Control.Distributed.Process
import Control.Distributed.BriskStatic
import Control.Distributed.Process.Closure
import Control.Distributed.Process.SymmetricProcess

import Utils
import Master

remotable [ 'master ]

mapreduce :: Process ()
mapreduce =  do let node = undefined
                spawn node $ $(mkBriskClosure 'master) ()
                return ()
