module VectorBuilder.Private.Builder
where

import VectorBuilder.Private.Prelude
import qualified VectorBuilder.Private.UpdateWithOffset as A
import qualified Data.Vector.Generic as B


-- |
-- An abstraction over the size of a vector for the process of its construction.
-- 
-- It postpones the actual construction of a vector until the execution of the builder.
newtype Builder element =
  Builder (A.UpdateWithOffset element)

-- |
-- Provides support for /O(1)/ concatenation.
instance Monoid (Builder element) where
  {-# INLINE mempty #-}
  mempty =
    VectorBuilder.Private.Builder.empty
  {-# INLINE mappend #-}
  mappend =
    prepend

-- |
-- Provides support for /O(1)/ concatenation.
instance Semigroup (Builder element) where
  {-# INLINE (<>) #-}
  (<>) =
    prepend


-- * Initialisation

-- |
-- Empty builder.
{-# INLINE empty #-}
empty :: Builder element
empty =
  Builder (mempty)

-- |
-- Builder of a single element.
{-# INLINE singleton #-}
singleton :: element -> Builder element
singleton element =
  Builder (A.snoc element)

-- |
-- Builder from an immutable vector of elements.
-- 
-- Supports all kinds of vectors: boxed, unboxed, primitive, storable.
{-# INLINE vector #-}
vector :: B.Vector vector element => vector element -> Builder element
vector vector =
  Builder (A.append vector)


-- * Updates

{-# INLINE snoc #-}
snoc :: element -> Builder element -> Builder element
snoc element (Builder action) =
  Builder (action <> A.snoc element)

{-# INLINE cons #-}
cons :: element -> Builder element -> Builder element
cons element (Builder action) =
  Builder (A.snoc element <> action)

{-# INLINE prepend #-}
prepend :: Builder element -> Builder element -> Builder element
prepend (Builder action1) (Builder action2) =
  Builder (action1 <> action2)

{-# INLINE append #-}
append :: Builder element -> Builder element -> Builder element
append (Builder action1) (Builder action2) =
  Builder (action2 <> action1)
