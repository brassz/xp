-- =====================================================
-- FIX RLS POLICIES FOR EXPENSES TABLE (NO SUPABASE AUTH)
-- =====================================================
-- This script fixes RLS policies to work with custom authentication
-- since the app doesn't use Supabase Auth (auth.uid() returns null)

-- Disable RLS temporarily to avoid issues
ALTER TABLE expenses DISABLE ROW LEVEL SECURITY;

-- Option 1: Completely disable RLS (Quick fix - less secure)
-- This allows the application to work immediately but with no row-level security
-- Uncomment the line below if you want to disable RLS completely:
-- ALTER TABLE expenses DISABLE ROW LEVEL SECURITY;

-- Option 2: Keep RLS but make policies that work with custom auth
-- Re-enable RLS
ALTER TABLE expenses ENABLE ROW LEVEL SECURITY;

-- Drop existing policies
DROP POLICY IF EXISTS "Users can view own expenses" ON expenses;
DROP POLICY IF EXISTS "Users can insert own expenses" ON expenses;
DROP POLICY IF EXISTS "Users can update own expenses" ON expenses;
DROP POLICY IF EXISTS "Users can delete own expenses" ON expenses;
DROP POLICY IF EXISTS "Users can update own expenses or admins can update all" ON expenses;
DROP POLICY IF EXISTS "Users can delete own expenses or admins can delete all" ON expenses;

-- Create new policies that allow authenticated users to manage their own data
-- Since we can't use auth.uid(), we'll rely on the application logic to set user_id correctly

-- Allow users to view expenses (will be filtered by application)
CREATE POLICY "Allow authenticated users to view expenses" ON expenses
    FOR SELECT USING (true);

-- Allow users to insert expenses (application must set correct user_id)
CREATE POLICY "Allow authenticated users to insert expenses" ON expenses
    FOR INSERT WITH CHECK (
        user_id IS NOT NULL AND 
        created_by IS NOT NULL
    );

-- Allow users to update expenses (application manages authorization)
CREATE POLICY "Allow authenticated users to update expenses" ON expenses
    FOR UPDATE USING (
        user_id IS NOT NULL
    );

-- Allow users to delete expenses (application manages authorization)
CREATE POLICY "Allow authenticated users to delete expenses" ON expenses
    FOR DELETE USING (
        user_id IS NOT NULL
    );

-- Verify the policies were created
SELECT schemaname, tablename, policyname, cmd 
FROM pg_policies 
WHERE tablename = 'expenses'
ORDER BY policyname;