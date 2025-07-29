# Database Migrations

This directory contains Supabase database migrations for the Security Dashboard project.

## Getting Started

1. **Install Supabase CLI** (if not already installed):
   ```bash
   npm install -g supabase
   ```

2. **Initialize Supabase locally**:
   ```bash
   supabase start
   ```

3. **Create a new migration**:
   ```bash
   supabase migration new migration_name
   ```

4. **Apply migrations**:
   ```bash
   supabase db reset
   ```

5. **Generate TypeScript types**:
   ```bash
   npm run supabase:generate-types
   ```

## Migration Guidelines

- Always test migrations locally before applying to production
- Use descriptive migration names with timestamps
- Include rollback instructions in migration comments
- Document schema changes in the changelog

## Example Migration Structure

```sql
-- Migration: 20240729000001_create_users_table.sql
-- Description: Create users table for authentication and user management

-- Create users table
CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email TEXT UNIQUE NOT NULL,
    role TEXT NOT NULL DEFAULT 'user',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Add RLS policies
ALTER TABLE users ENABLE ROW LEVEL SECURITY;

-- Create policies (example)
CREATE POLICY "Users can read own data" ON users
    FOR SELECT USING (auth.uid() = id);

-- Add indexes
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_role ON users(role);

-- Add updated_at trigger
CREATE TRIGGER set_updated_at
    BEFORE UPDATE ON users
    FOR EACH ROW
    EXECUTE FUNCTION trigger_set_updated_at();
```

## Available Scripts

- `npm run supabase:start` - Start local Supabase instance
- `npm run supabase:stop` - Stop local Supabase instance  
- `npm run supabase:reset` - Reset database and apply all migrations
- `npm run supabase:generate-types` - Generate TypeScript types from schema