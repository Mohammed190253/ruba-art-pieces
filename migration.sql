-- Run this SQL query in your Supabase SQL Editor to update the database schema
-- so it supports secondary showcase images for each artwork.

ALTER TABLE artworks 
ADD COLUMN IF NOT EXISTS secondary_images jsonb DEFAULT '[]'::jsonb,
ADD COLUMN IF NOT EXISTS status text DEFAULT 'Available Upon Inquiry',
ADD COLUMN IF NOT EXISTS description text DEFAULT '';

-- ────────────────────────────────────────────────────────
-- ROW LEVEL SECURITY (RLS) POLICIES FOR RUBA ART STUDIO
-- ────────────────────────────────────────────────────────

-- 1. Enable Row Level Security (RLS)
ALTER TABLE artworks ENABLE ROW LEVEL SECURITY;
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;

-- 2. Artworks Table Policies
-- Allow anyone (public anonymous users) to view artworks
CREATE POLICY "Allow public read access to artworks" 
ON artworks FOR SELECT 
TO public 
USING (true);

-- Restrict write actions (INSERT, UPDATE, DELETE) to authenticated admin requests
CREATE POLICY "Allow insert access to authenticated users only" 
ON artworks FOR INSERT 
TO authenticated 
WITH CHECK (true);

CREATE POLICY "Allow update access to authenticated users only" 
ON artworks FOR UPDATE 
TO authenticated 
USING (true)
WITH CHECK (true);

CREATE POLICY "Allow delete access to authenticated users only" 
ON artworks FOR DELETE 
TO authenticated 
USING (true);


-- 3. Categories Table Policies
-- Allow anyone to view categories
CREATE POLICY "Allow public read access to categories" 
ON categories FOR SELECT 
TO public 
USING (true);

-- Restrict category management to authenticated admin requests
CREATE POLICY "Allow insert access to authenticated users only" 
ON categories FOR INSERT 
TO authenticated 
WITH CHECK (true);

CREATE POLICY "Allow delete access to authenticated users only" 
ON categories FOR DELETE 
TO authenticated 
USING (true);


-- 4. Studio Moments Table (Optional dedicated table for Behind-the-Scenes / Instagram Grid)
CREATE TABLE IF NOT EXISTS studio_moments (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    title text,
    caption text,
    image_url text NOT NULL,
    created_at timestamptz DEFAULT now()
);

ALTER TABLE studio_moments ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow public read access to studio_moments" 
ON studio_moments FOR SELECT 
TO public 
USING (true);

CREATE POLICY "Allow insert access to authenticated users only" 
ON studio_moments FOR INSERT 
TO authenticated 
WITH CHECK (true);

CREATE POLICY "Allow update access to authenticated users only" 
ON studio_moments FOR UPDATE 
TO authenticated 
USING (true)
WITH CHECK (true);

CREATE POLICY "Allow delete access to authenticated users only" 
ON studio_moments FOR DELETE 
TO authenticated 
USING (true);

-- 5. Site Settings Table (For Hero Feature Showcase, Subtitles, Headings & Global Config)
CREATE TABLE IF NOT EXISTS site_settings (
    key text PRIMARY KEY,
    value jsonb NOT NULL,
    updated_at timestamptz DEFAULT now()
);

ALTER TABLE site_settings ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow public read access to site_settings" 
ON site_settings FOR SELECT 
TO public 
USING (true);

CREATE POLICY "Allow write access to authenticated users only on site_settings" 
ON site_settings FOR ALL 
TO authenticated 
USING (true)
WITH CHECK (true);

-- 6. Inquiries & Leads Table (For Commission Requests, Dimensions, WhatsApp Leads & Inquiries)
CREATE TABLE IF NOT EXISTS inquiries (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    name text NOT NULL,
    email text NOT NULL,
    country text,
    details text,
    image_url text,
    status text DEFAULT 'New Lead',
    source text DEFAULT 'Commission Form',
    created_at timestamptz DEFAULT now()
);

ALTER TABLE inquiries ENABLE ROW LEVEL SECURITY;

-- Allow public anonymous visitors to insert commission requests
CREATE POLICY "Allow public insert to inquiries" 
ON inquiries FOR INSERT 
TO public 
WITH CHECK (true);

-- Allow authenticated admins to view, update status, and manage inquiries
CREATE POLICY "Allow authenticated read/manage on inquiries" 
ON inquiries FOR ALL 
TO authenticated 
USING (true)
WITH CHECK (true);

-- 7. Studio Stories / Moments (High-End Artist Stories Feature)
CREATE TABLE IF NOT EXISTS public.studio_stories (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    title TEXT NOT NULL,
    media_url TEXT NOT NULL,
    link_url TEXT,
    expires_at TIMESTAMP WITH TIME ZONE
);

ALTER TABLE public.studio_stories ENABLE ROW LEVEL SECURITY;

-- Allow public read access to active stories
CREATE POLICY "Allow public read access to studio_stories" 
ON public.studio_stories FOR SELECT 
TO public 
USING (true);

-- Allow authenticated admins to insert new stories
CREATE POLICY "Allow insert access to authenticated users on studio_stories" 
ON public.studio_stories FOR INSERT 
TO authenticated 
WITH CHECK (true);

-- Allow authenticated admins to update stories
CREATE POLICY "Allow update access to authenticated users on studio_stories" 
ON public.studio_stories FOR UPDATE 
TO authenticated 
USING (true)
WITH CHECK (true);

-- Allow authenticated admins to delete stories
CREATE POLICY "Allow delete access to authenticated users on studio_stories" 
ON public.studio_stories FOR DELETE 
TO authenticated 
USING (true);

