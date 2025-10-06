# Fix: Missing Secret for NEXT_PUBLIC_SUPABASE_URL

## Problem
Environment Variable "NEXT_PUBLIC_SUPABASE_URL" references Secret "next_public_supabase_url", which does not exist.

## Root Cause
The project uses company-specific environment variables (EMPRESA1, EMPRESA2, EMPRESA3) for different companies, but some deployment configuration was expecting a generic `NEXT_PUBLIC_SUPABASE_URL` variable.

## Solution
Added a fallback `NEXT_PUBLIC_SUPABASE_URL` environment variable that points to the main company (EMPRESA 1 - NEXUS) URL.

## Changes Made

### 1. Updated `.env.example`
- Added `NEXT_PUBLIC_SUPABASE_URL=https://mhtxyxizfnxupwmilith.supabase.co` as a fallback configuration
- This points to EMPRESA 1 (NEXUS - Principal) Supabase instance

### 2. Updated `VERCEL-DEPLOY-INSTRUCTIONS.md`
- Added instructions to configure the generic `NEXT_PUBLIC_SUPABASE_URL` variable in Vercel
- Updated CLI commands section to include the fallback variable

### 3. Updated `README-MULTI-EMPRESAS.md`
- Added the fallback variable to the environment variables documentation

### 4. Created `.env.local.example`
- Example configuration file for local development
- Includes all necessary environment variables including the fallback

## Deployment Instructions

### For Vercel:
1. Go to your project Settings > Environment Variables
2. Add the following variable:
   - **Name**: `NEXT_PUBLIC_SUPABASE_URL`
   - **Value**: `https://mhtxyxizfnxupwmilith.supabase.co`
   - **Environments**: Production, Preview, Development

### Using Vercel CLI:
```bash
vercel env add NEXT_PUBLIC_SUPABASE_URL
```
When prompted, enter the value: `https://mhtxyxizfnxupwmilith.supabase.co`

## Why This Fix Works
- The generic `NEXT_PUBLIC_SUPABASE_URL` now exists and points to a valid Supabase instance
- It serves as a fallback for any code that might reference the generic variable
- The company-specific variables (EMPRESA1, EMPRESA2, EMPRESA3) continue to work as before
- This maintains backward compatibility while fixing the missing secret error

## Verification
After deploying with the new environment variable:
1. The deployment should complete without the missing secret error
2. The application should continue to work with company-specific configurations
3. Any code referencing the generic `NEXT_PUBLIC_SUPABASE_URL` will now have a valid value