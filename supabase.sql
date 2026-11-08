-- Jalankan di Supabase: menu SQL Editor > New query > tempel semua > Run

create table if not exists public.products (
  id uuid primary key,
  code text default '',
  name text not null,
  price numeric not null default 0,
  stock integer,                         -- NULL = stok tidak dihitung
  deleted boolean not null default false,
  updated_at timestamptz not null default now(),
  synced_at timestamptz not null default now()
);

create table if not exists public.sales (
  id uuid primary key,
  created_at timestamptz not null,
  total numeric not null,
  paid numeric not null,
  change_amount numeric not null,
  items jsonb not null,
  synced_at timestamptz not null default now()
);

-- synced_at diisi otomatis oleh server setiap ada data masuk/berubah
create or replace function public.set_synced_at() returns trigger as $$
begin
  new.synced_at = now();
  return new;
end;
$$ language plpgsql;

drop trigger if exists trg_products_synced on public.products;
create trigger trg_products_synced before insert or update on public.products
  for each row execute function public.set_synced_at();

drop trigger if exists trg_sales_synced on public.sales;
create trigger trg_sales_synced before insert or update on public.sales
  for each row execute function public.set_synced_at();

create index if not exists products_synced_idx on public.products (synced_at);
create index if not exists sales_synced_idx on public.sales (synced_at);

-- KEAMANAN: hanya pengguna yang sudah login yang boleh membaca/menulis
alter table public.products enable row level security;
alter table public.sales enable row level security;

drop policy if exists "login_products" on public.products;
create policy "login_products" on public.products
  for all to authenticated using (true) with check (true);

drop policy if exists "login_sales" on public.sales;
create policy "login_sales" on public.sales
  for all to authenticated using (true) with check (true);
