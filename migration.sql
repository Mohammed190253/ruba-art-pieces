create table if not exists public.studio_stories (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  media_url text not null,
  link_url text,
  expires_at timestamptz,
  created_at timestamptz default now()
);
alter table public.studio_stories enable row level security;
create policy "Public can read stories" on public.studio_stories for select to anon, authenticated using (true);
create policy "Admin can insert stories" on public.studio_stories for insert to authenticated with check (true);
create policy "Admin can delete stories" on public.studio_stories for delete to authenticated using (true);
