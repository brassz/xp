-- =====================================================
-- FIX RLS POLICIES FOR CURRENT EXPENSES TABLE
-- =====================================================
-- This script fixes RLS policies for the actual expenses table structure
-- which only has: id, user_id, description, category, amount, date, notes, signature, created_at, updated_at

-- Disable RLS temporarily to avoid issues during policy changes
ALTER TABLE expenses DISABLE ROW LEVEL SECURITY;

-- Drop any existing policies to start fresh
DROP POLICY IF EXISTS "Users can view own expenses" ON expenses;
DROP POLICY IF EXISTS "Users can insert own expenses" ON expenses;
DROP POLICY IF EXISTS "Users can update own expenses" ON expenses;
DROP POLICY IF EXISTS "Users can delete own expenses" ON expenses;

-- Re-enable RLS
ALTER TABLE expenses ENABLE ROW LEVEL SECURITY;

-- Create simple policies that work with the current table structure
-- Since the app uses custom auth and not Supabase Auth, we can't use auth.uid()
-- Instead, we'll create permissive policies and rely on the application logic

-- Allow users to view expenses (application filters by user_id)
CREATE POLICY "Allow users to view expenses" ON expenses
    FOR SELECT USING (true);

-- Allow users to insert expenses (application sets user_id)
CREATE POLICY "Allow users to insert expenses" ON expenses
    FOR INSERT WITH CHECK (user_id IS NOT NULL);

-- Allow users to update expenses (application manages authorization)
CREATE POLICY "Allow users to update expenses" ON expenses
    FOR UPDATE USING (user_id IS NOT NULL);

-- Allow users to delete expenses (application manages authorization)
CREATE POLICY "Allow users to delete expenses" ON expenses
    FOR DELETE USING (user_id IS NOT NULL);

-- Verify the policies were created
SELECT schemaname, tablename, policyname, cmd 
FROM pg_policies 
WHERE tablename = 'expenses'
ORDER BY policyname;