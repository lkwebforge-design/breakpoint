-- Breakpoint Billiards: Supabase starter schema
-- Apply in Supabase SQL Editor only after creating your project.
-- IMPORTANT: do not expose the service_role key in browser code.
create extension if not exists pgcrypto;

create table if not exists public.tables (
  id uuid primary key default gen_random_uuid(),
  code text not null unique,
  display_name text not null,
  active boolean not null default true,
  created_at timestamptz not null default now()
);

insert into public.tables (code, display_name)
values ('board-01', 'Billiard Board 01')
on conflict (code) do nothing;

create table if not exists public.bookings (
  id uuid primary key default gen_random_uuid(),
  booking_reference text not null unique default upper(substr(encode(gen_random_bytes(8), 'hex'), 1, 8)),
  table_id uuid not null references public.tables(id),
  customer_name text not null check (char_length(customer_name) between 1 and 80),
  customer_phone text not null check (char_length(customer_phone) between 5 and 24),
  starts_at timestamptz not null,
  ends_at timestamptz not null,
  notes text check (notes is null or char_length(notes) <= 240),
  status text not null default 'confirmed'
    check (status in ('confirmed','cancelled','arrived','completed','no_show')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint booking_time_positive check (ends_at > starts_at)
);

create index if not exists bookings_table_starts_idx
  on public.bookings (table_id, starts_at);
create index if not exists bookings_status_starts_idx
  on public.bookings (status, starts_at);

-- The overlap guard is enforced by PostgreSQL, not only by the UI.
-- It prevents two active bookings for the same table from overlapping.
create extension if not exists btree_gist;
alter table public.bookings
  add constraint bookings_no_overlapping_active
  exclude using gist (
    table_id with =,
    tstzrange(starts_at, ends_at, '[)') with &&
  )
  where (status in ('confirmed','arrived'));

-- Keep this table private to authenticated staff. Add owner accounts in Supabase Auth
-- and create an owner/staff role policy before shipping the dashboard.
alter table public.tables enable row level security;
alter table public.bookings enable row level security;

-- Public visitors must not be allowed to read customer details directly.
-- Production booking creation should happen through a server-side Edge Function
-- that validates opening hours/duration, checks conflicts, inserts the booking,
-- and then sends WhatsApp notification. Do not add anon INSERT policy to bookings.
create policy "Public can read active table inventory"
  on public.tables for select
  to anon, authenticated
  using (active = true);

-- No public bookings policies are intentionally provided here.
-- Add narrowly scoped staff policies after configuring authenticated owner users.
