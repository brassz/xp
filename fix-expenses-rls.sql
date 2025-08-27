-- =====================================================
-- FIX RLS POLICIES FOR EXPENSES TABLE
-- =====================================================
-- This script fixes the RLS policy violations for the expenses table

-- First, drop existing policies to avoid conflicts
DROP POLICY IF EXISTS "Users can view own expenses" ON expenses;
DROP POLICY IF EXISTS "Users can insert own expenses" ON expenses;
DROP POLICY IF EXISTS "Users can update own expenses" ON expenses;
DROP POLICY IF EXISTS "Users can delete own expenses" ON expenses;
DROP POLICY IF EXISTS "Users can update own expenses or admins can update all" ON expenses;
DROP POLICY IF EXISTS "Users can delete own expenses or admins can delete all" ON expenses;

-- Recreate policies with proper auth.uid() usage (without ::text conversion)
-- These policies are simpler and more reliable with Supabase

-- Policy for viewing expenses
CREATE POLICY "Users can view own expenses" ON expenses
    FOR SELECT USING (
        user_id = auth.uid() OR
        created_by = auth.uid() OR
        EXISTS (
            SELECT 1 FROM users 
            WHERE id = auth.uid() 
            AND role IN ('admin', 'manager')
        )
    );

-- Policy for inserting expenses
CREATE POLICY "Users can insert own expenses" ON expenses
    FOR INSERT WITH CHECK (
        user_id = auth.uid() AND
        created_by = auth.uid()
    );

-- Policy for updating expenses
CREATE POLICY "Users can update own expenses" ON expenses
    FOR UPDATE USING (
        user_id = auth.uid() OR
        created_by = auth.uid() OR
        EXISTS (
            SELECT 1 FROM users 
            WHERE id = auth.uid() 
            AND role IN ('admin', 'manager')
        )
    );

-- Policy for deleting expenses
CREATE POLICY "Users can delete own expenses" ON expenses
    FOR DELETE USING (
        user_id = auth.uid() OR
        created_by = auth.uid() OR
        EXISTS (
            SELECT 1 FROM users 
            WHERE id = auth.uid() 
            AND role = 'admin'
        )
    );

-- Make sure RLS is enabled
ALTER TABLE expenses ENABLE ROW LEVEL SECURITY;

-- Verify the policies were created
SELECT schemaname, tablename, policyname, permissive, roles, cmd 
FROM pg_policies 
WHERE tablename = 'expenses'
ORDER BY policyname;