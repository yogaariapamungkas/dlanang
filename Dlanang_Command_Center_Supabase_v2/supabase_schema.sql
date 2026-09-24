-- D’Lanang Command Center - Supabase schema
-- Jalankan seluruh script ini di Supabase > SQL Editor.
-- Gunakan hanya Publishable/Anon Key di frontend. JANGAN taruh service_role key di index.html.

create extension if not exists pgcrypto;

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  name text not null default 'Admin D’Lanang',
  role text not null default 'admin',
  created_at timestamptz not null default now()
);

create table if not exists public.events (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  route text,
  start_date date,
  end_date date,
  target numeric(14,2) not null default 0,
  note text,
  created_at timestamptz not null default now()
);

create table if not exists public.members (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  motor text,
  plate text,
  target numeric(14,2) not null default 0,
  created_at timestamptz not null default now()
);

create table if not exists public.deposits (
  id uuid primary key default gen_random_uuid(),
  member_id uuid not null references public.members(id) on delete cascade,
  date date not null default current_date,
  amount numeric(14,2) not null default 0,
  method text not null default 'Cash',
  status text not null default 'Terverifikasi',
  note text,
  created_at timestamptz not null default now()
);

create table if not exists public.expenses (
  id uuid primary key default gen_random_uuid(),
  date date not null default current_date,
  category text not null,
  description text not null,
  person text,
  amount numeric(14,2) not null default 0,
  created_at timestamptz not null default now()
);

create table if not exists public.budgets (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  amount numeric(14,2) not null default 0,
  created_at timestamptz not null default now()
);

create table if not exists public.payment_settings (
  id integer primary key default 1,
  holder text,
  bank text,
  number text,
  qris text,
  instruction text,
  updated_at timestamptz not null default now()
);

create table if not exists public.app_settings (
  id integer primary key default 1,
  logo_url text,
  updated_at timestamptz not null default now()
);

alter table public.profiles enable row level security;
alter table public.events enable row level security;
alter table public.members enable row level security;
alter table public.deposits enable row level security;
alter table public.expenses enable row level security;
alter table public.budgets enable row level security;
alter table public.payment_settings enable row level security;
alter table public.app_settings enable row level security;

-- Untuk aplikasi admin sederhana: semua user yang berhasil login dapat membaca/mengubah data.
-- Jika nanti ada role berbeda, kebijakan ini dapat diperketat.
do $$ begin
  create policy "authenticated full access profiles" on public.profiles for all to authenticated using (true) with check (true);
exception when duplicate_object then null; end $$;
do $$ begin
  create policy "authenticated full access events" on public.events for all to authenticated using (true) with check (true);
exception when duplicate_object then null; end $$;
do $$ begin
  create policy "authenticated full access members" on public.members for all to authenticated using (true) with check (true);
exception when duplicate_object then null; end $$;
do $$ begin
  create policy "authenticated full access deposits" on public.deposits for all to authenticated using (true) with check (true);
exception when duplicate_object then null; end $$;
do $$ begin
  create policy "authenticated full access expenses" on public.expenses for all to authenticated using (true) with check (true);
exception when duplicate_object then null; end $$;
do $$ begin
  create policy "authenticated full access budgets" on public.budgets for all to authenticated using (true) with check (true);
exception when duplicate_object then null; end $$;
do $$ begin
  create policy "authenticated full access payment" on public.payment_settings for all to authenticated using (true) with check (true);
exception when duplicate_object then null; end $$;
do $$ begin
  create policy "authenticated full access settings" on public.app_settings for all to authenticated using (true) with check (true);
exception when duplicate_object then null; end $$;

insert into public.payment_settings(id,holder,bank,number,instruction)
values(1,'D’Lanang Touring','BCA','1234567890','Transfer sesuai nominal dan tulis nama anggota.')
on conflict(id) do nothing;

insert into public.app_settings(id,logo_url)
values(1,'')
on conflict(id) do nothing;

-- Setelah membuat akun admin di Authentication > Users, profil dapat dibuat otomatis:
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  insert into public.profiles (id, name, role)
  values (new.id, coalesce(new.raw_user_meta_data->>'name','Admin D’Lanang'), 'admin')
  on conflict (id) do nothing;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
after insert on auth.users
for each row execute procedure public.handle_new_user();
