# Fix for "Could not find the 'photos' column of 'clients' in the schema cache"

## Problem Description
The application is trying to use a `photos` column (plural) in the `clients` table, but the database schema only has a `photo` column (singular). This causes the error: "Could not find the 'photos' column of 'clients' in the schema cache".

## Root Cause
- **Database Schema**: Has `photo` column (singular) for single photo storage
- **Application Code**: Expects `photos` column (plural) for multiple photo storage  
- **Missing Migration**: No database migration was run to add the `photos` column

## Solution

### Step 1: Run the Migration Script
Execute the migration script `add-photos-column-migration.sql` in your Supabase SQL Editor:

1. Go to your Supabase Dashboard
2. Navigate to SQL Editor
3. Copy and paste the contents of `add-photos-column-migration.sql`
4. Click "Run" to execute the migration

### Step 2: Verify the Fix
After running the migration, the `clients` table will have both columns:
- `photo` - Legacy single photo column (kept for backward compatibility)
- `photos` - New multiple photos column (JSON array format)

### What the Migration Does
1. **Adds the `photos` column** to the `clients` table
2. **Migrates existing data** from `photo` to `photos` (converts single URLs to JSON arrays)
3. **Maintains backward compatibility** by keeping the original `photo` column
4. **Adds proper documentation** with column comments

### Application Behavior After Fix
- The app will use the `photos` column for storing multiple photo URLs as JSON
- Existing single photos will be automatically converted to the new format
- The application handles both old (`photo`) and new (`photos`) formats gracefully

## Files Modified
1. `add-photos-column-migration.sql` - New migration script
2. `database-setup.sql` - Updated to include `photos` column for new installations
3. `FIX-PHOTOS-COLUMN.md` - This documentation

## Testing
After applying the migration:
1. Try adding a new client with photos - should work without errors
2. Edit existing clients - photos should display correctly
3. Check that no "schema cache" errors appear in the browser console

## Prevention
For new installations, the updated `database-setup.sql` now includes the `photos` column, preventing this issue from occurring again.