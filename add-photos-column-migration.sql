-- =====================================================
-- MIGRATION: Add photos column to clients table
-- =====================================================
-- This script adds the missing 'photos' column that the application expects
-- The photos column will store JSON data for multiple photo URLs

BEGIN;

-- Add the photos column to support multiple photos (JSON format)
DO $$
BEGIN
    -- Check if the photos column doesn't exist and add it
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'clients' AND column_name = 'photos'
    ) THEN
        ALTER TABLE clients ADD COLUMN photos TEXT;
        
        -- Add comment for the new column
        COMMENT ON COLUMN clients.photos IS 'JSON array of photo URLs (Uploadcare) - supports multiple photos';
        
        RAISE NOTICE '✓ Added photos column to clients table';
    ELSE
        RAISE NOTICE '✓ Photos column already exists in clients table';
    END IF;
END
$$;

-- Optional: Migrate existing single photo data to the new photos column
-- This will convert single photo URLs to JSON arrays for consistency
DO $$
DECLARE
    client_record RECORD;
    photo_array TEXT;
BEGIN
    -- Only migrate if there are clients with photo but no photos
    FOR client_record IN 
        SELECT id, photo 
        FROM clients 
        WHERE photo IS NOT NULL 
        AND photo != ''
        AND (photos IS NULL OR photos = '')
    LOOP
        -- Convert single photo URL to JSON array format
        photo_array := '["' || replace(client_record.photo, '"', '\"') || '"]';
        
        -- Update the photos column with the JSON array
        UPDATE clients 
        SET photos = photo_array 
        WHERE id = client_record.id;
        
        RAISE NOTICE '✓ Migrated photo to photos for client ID: %', client_record.id;
    END LOOP;
    
    RAISE NOTICE '✓ Migration of existing photo data completed';
END
$$;

COMMIT;

-- Verify the migration
SELECT 
    column_name, 
    data_type, 
    is_nullable,
    column_default
FROM information_schema.columns 
WHERE table_name = 'clients' 
AND column_name IN ('photo', 'photos')
ORDER BY column_name;

RAISE NOTICE '✓ Photos column migration completed successfully';